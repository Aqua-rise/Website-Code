import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:questure/Pages/add_cards_screen.dart';

class CardListScreen extends StatelessWidget {
  final String folderId;
  final String folderName;

  const CardListScreen({
    Key? key,
    required this.folderId,
    required this.folderName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 224, 224),
      appBar: AppBar(
        title: Text(folderName,
            style: const TextStyle(
              color: Color.fromRGBO(14, 60, 83, 1),
              fontSize: 24,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to AddCardsScreen when the user wants to add new sets
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddCardsScreen(folderId: folderId),
              ));
            },
          ),
        ],
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('folders')
            .doc(folderId)
            .collection('cards')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No cards found in this folder'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Card(
                    child: ListTile(
                      title: Text(data['question']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List.generate(data['answers'].length, (index) {
                          var answer = data['answers'][index];
                          return Row(
                            children: [
                              Expanded(child: Text(answer['answer'])),
                              data['answers'].length > 1
                                  ? Icon(
                                      answer['isCorrect']
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: answer['isCorrect']
                                          ? Colors.green
                                          : Colors.red,
                                    )
                                  : Container(),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
