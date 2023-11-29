import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCardsScreen extends StatefulWidget {
  final String folderId;

  const AddCardsScreen({
    Key? key,
    required this.folderId,
  }) : super(key: key);

  @override
  AddCardsScreenState createState() => AddCardsScreenState();
}

class AddCardsScreenState extends State<AddCardsScreen> {
  final List<TextEditingController> _questionControllers = [];
  final List<List<TextEditingController>> _answerControllers = [];
  final List<List<bool>> _answerCorrectness =
      []; // To store "true" or "false" Booleans
  final List<String> _cardDocIDs = []; // To store Firestore document IDs
  bool navigateBackAfterSave = true;

  @override
  void initState() {
    super.initState();
    loadUserPreference();
    fetchAndPopulateData();
  }

  void loadUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      navigateBackAfterSave = prefs.getBool('navigateBackAfterSave') ?? true;
    });
  }

  void saveUserPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('navigateBackAfterSave', value);
  }

  void fetchAndPopulateData() async {
    // Fetch any existing set data from Firestore
    var cardSetSnapshot = await FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.folderId)
        .collection('cards')
        .get();

    for (var doc in cardSetSnapshot.docs) {
      var data = doc.data();
      var questionController = TextEditingController(text: data['question']);
      _questionControllers.add(questionController);

      List<TextEditingController> answerControllers = [];
      List<bool> correctnessList = [];

      for (var answer in data['answers']) {
        answerControllers.add(TextEditingController(text: answer['answer']));
        correctnessList.add(answer['isCorrect']);
      }

      _answerControllers.add(answerControllers);
      _answerCorrectness.add(correctnessList);

      _cardDocIDs.add(doc.id); // Store the document ID
    }

    if (cardSetSnapshot.docs.isEmpty) {
      // No sets present, create a default set
      addCardPair();
    }

    setState(() {});
  }

  void addCardPair() {
    _questionControllers.add(TextEditingController());
    _answerControllers.add([TextEditingController()]);
    _answerCorrectness.add([true]);
    // The first answer is true by default
  }

  void addAnswer(int questionIndex) {
    setState(() {
      _answerControllers[questionIndex].add(TextEditingController());
      _answerCorrectness[questionIndex]
          .add(false); // New answers are false by default
    });
  }

  void removeAnswer(int questionIndex, int answerIndex) {
    setState(() {
      _answerControllers[questionIndex][answerIndex].dispose();
      _answerControllers[questionIndex].removeAt(answerIndex);
      _answerCorrectness[questionIndex].removeAt(answerIndex);
    });
  }

  void toggleCorrectness(int questionIndex, int answerIndex) {
    setState(() {
      _answerCorrectness[questionIndex][answerIndex] =
          !_answerCorrectness[questionIndex][answerIndex];
    });
  }

  void deleteCardSet(int answerIndex) async {
    if (answerIndex < _cardDocIDs.length) {
      // Delete from Firestore if it's an existing card
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(widget.folderId)
          .collection('cards')
          .doc(_cardDocIDs[answerIndex])
          .delete();
    }

    // Remove from local state
    _questionControllers.removeAt(answerIndex);
    _answerControllers.removeAt(answerIndex);
    _answerCorrectness.removeAt(answerIndex);
    if (answerIndex < _cardDocIDs.length) {
      _cardDocIDs.removeAt(answerIndex);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 224, 224),
      appBar: AppBar(
        title: const Text('Add Cards',
            style: TextStyle(
              color: Color.fromRGBO(14, 60, 83, 1),
              fontSize: 24,
            )),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 1) {
                // Toggle navigate back preference
                saveUserPreference(!navigateBackAfterSave);
                navigateBackAfterSave = !navigateBackAfterSave;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      navigateBackAfterSave
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: navigateBackAfterSave ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Navigate Back After Save'),
                  ],
                ),
              ),
            ],
          ),
          //Save button logic here

          IconButton(icon: const Icon(Icons.save), onPressed: saveCardData)
        ],
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children:
                List.generate(_questionControllers.length, (questionIndex) {
              return SizedBox(
                width: 775,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          buildTextField(_questionControllers[questionIndex],
                              'Question ${questionIndex + 1}'),
                          TextButton(
                            child: const Text(
                              'Delete card set',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => deleteCardSet(questionIndex),
                          ),
                          Column(
                            children: List.generate(
                                _answerControllers[questionIndex].length,
                                (answerIndex) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: buildTextField(
                                        _answerControllers[questionIndex]
                                            [answerIndex],
                                        'Answer ${answerIndex + 1}'),
                                  ),
                                  _answerControllers[questionIndex].length > 1
                                      ? IconButton(
                                          icon: Icon(
                                            _answerCorrectness[questionIndex]
                                                    [answerIndex]
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: _answerCorrectness[
                                                    questionIndex][answerIndex]
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                          onPressed: () => toggleCorrectness(
                                              questionIndex, answerIndex),
                                        )
                                      : Container(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () => removeAnswer(
                                        questionIndex, answerIndex),
                                  ),
                                ],
                              );
                            }),
                          ),
                          TextButton(
                            child: const Text('Add another answer'),
                            onPressed: () => addAnswer(questionIndex),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(addCardPair);
        },
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }

  //Method for saving sets to Firestore
  Future<void> saveCardData() async {
    var collectionRef = FirebaseFirestore.instance
        .collection('folders')
        .doc(widget.folderId)
        .collection('cards');

    for (int i = 0; i < _questionControllers.length; i++) {
      Map<String, dynamic> cardData = {
        'question': _questionControllers[i].text,
        'answers': List.generate(_answerControllers[i].length, (j) {
          return {
            'answer': _answerControllers[i][j].text,
            'isCorrect': _answerControllers[i].length > 1
                ? _answerCorrectness[i][j]
                : true,
          };
        }),
      };

      if (i < _cardDocIDs.length) {
        // Update existing card
        await collectionRef.doc(_cardDocIDs[i]).update(cardData);
      } else {
        // Add new card
        var addedDoc = await collectionRef.add(cardData);
        _cardDocIDs.add(addedDoc.id); // Store new document ID
      }
    }

    if (navigateBackAfterSave) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    for (var answerList in _answerControllers) {
      for (var controller in answerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
