import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCardsScreen extends StatefulWidget {
  final String folderId;

  const AddCardsScreen({Key? key, required this.folderId}) : super(key: key);

  @override
  _AddCardsScreenState createState() => _AddCardsScreenState();
}

class _AddCardsScreenState extends State<AddCardsScreen> {
  final List<TextEditingController> _questionControllers = [];
  final List<List<TextEditingController>> _answerControllers = [];
  final List<List<bool>> _answerCorrectness =
      []; // Stored "true" or "false" Booleans
  final List<String> _cardDocIDs = []; // To store Firestore document IDs
  bool _navigateBackAfterSave = true;

  @override
  void initState() {
    super.initState();
    _loadUserPreference();
    _fetchAndPopulateData();
  }

  void _loadUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _navigateBackAfterSave = prefs.getBool('navigateBackAfterSave') ?? true;
    });
  }

  void _saveUserPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('navigateBackAfterSave', value);
  }

  void _fetchAndPopulateData() async {
    // Fetch data from Firestore
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

    setState(() {});
  }

  void _addCardPair() {
    _questionControllers.add(TextEditingController());
    _answerControllers.add([TextEditingController()]);
    _answerCorrectness.add([true]); // The first answer is true by default
  }

  void _addAnswer(int questionIndex) {
    setState(() {
      _answerControllers[questionIndex].add(TextEditingController());
      _answerCorrectness[questionIndex]
          .add(false); // New answers are false by default
    });
  }

  void _removeAnswer(int questionIndex, int answerIndex) {
    setState(() {
      _answerControllers[questionIndex][answerIndex].dispose();
      _answerControllers[questionIndex].removeAt(answerIndex);
      _answerCorrectness[questionIndex].removeAt(answerIndex);
    });
  }

  void _toggleCorrectness(int questionIndex, int answerIndex) {
    setState(() {
      _answerCorrectness[questionIndex][answerIndex] =
          !_answerCorrectness[questionIndex][answerIndex];
    });
  }

  void _deleteCardSet(int answerIndex) async {
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
                _saveUserPreference(!_navigateBackAfterSave);
                _navigateBackAfterSave = !_navigateBackAfterSave;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      _navigateBackAfterSave
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: _navigateBackAfterSave ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Navigate Back After Save'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCardData, // Call the save method here
          ),
        ],
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children:
                List.generate(_questionControllers.length, (questionIndex) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 775),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _buildTextField(_questionControllers[questionIndex],
                              'Question ${questionIndex + 1}'),
                          TextButton(
                            child: const Text(
                              'Delete card set',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () => _deleteCardSet(questionIndex),
                          ),
                          Column(
                            children: List.generate(
                                _answerControllers[questionIndex].length,
                                (answerIndex) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
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
                                          onPressed: () => _toggleCorrectness(
                                              questionIndex, answerIndex),
                                        )
                                      : Container(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    onPressed: () => _removeAnswer(
                                        questionIndex, answerIndex),
                                  ),
                                ],
                              );
                            }),
                          ),
                          TextButton(
                            child: const Text('Add another answer'),
                            onPressed: () => _addAnswer(questionIndex),
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
          setState(_addCardPair);
        },
        backgroundColor: const Color.fromRGBO(148, 204, 202, 1),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
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
  Future<void> _saveCardData() async {
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

    if (_navigateBackAfterSave) {
      Navigator.pop(context);
    }
  }

  void _removeCard(int cardIndex) async {
    if (cardIndex < _cardDocIDs.length) {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(widget.folderId)
          .collection('cards')
          .doc(_cardDocIDs[cardIndex])
          .delete();

      // Remove from local state
      _cardDocIDs.removeAt(cardIndex);
      _questionControllers.removeAt(cardIndex);
      _answerControllers.removeAt(cardIndex);
      _answerCorrectness.removeAt(cardIndex);
    }

    setState(() {});
  }

  @override
  void dispose() {
    _questionControllers.forEach((controller) => controller.dispose());
    for (var answerList in _answerControllers) {
      answerList.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }
}
