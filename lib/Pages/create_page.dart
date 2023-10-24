import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  List<TextEditingController> _questionControllers = [TextEditingController()];
  List<TextEditingController> _answerControllers = [TextEditingController()];
  List<Map<String, String>> _qaPairs = [
    {'question': '', 'answer': ''}
  ];
  bool _isQuestionAnswerClicked = false;
  bool _isMultipleChoiceClicked = false;

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _correctAnswerController =
      TextEditingController();
  final List<TextEditingController> _falseAnswerControllers = [
    TextEditingController()
  ];
  String _question = '';
  String _correctAnswer = '';
  final List<String> _falseAnswers = [''];

  void _onQuestionAnswerClicked() {
    setState(() {
      _isQuestionAnswerClicked = true;
      _isMultipleChoiceClicked = false;
    });
  }

  void _onMultipleChoiceClicked() {
    setState(() {
      _isQuestionAnswerClicked = false;
      _isMultipleChoiceClicked = true;
    });
  }

  void _onBackPressed() {
    setState(() {
      _isQuestionAnswerClicked = false;
      _isMultipleChoiceClicked = false;
      _qaPairs = [
        {'question': '', 'answer': ''}
      ];
      _questionControllers = [TextEditingController()];
      _answerControllers = [TextEditingController()];
    });
  }

  void _addFalseAnswer() {
    setState(() {
      _falseAnswerControllers.add(TextEditingController());
      _falseAnswers.add('');
    });
  }

  void _removeFalseAnswer(int index) {
    setState(() {
      _falseAnswerControllers[index].dispose();
      _falseAnswerControllers.removeAt(index);
      _falseAnswers.removeAt(index);
    });
  }

  void _addQAPair() {
    setState(() {
      _questionControllers.add(TextEditingController());
      _answerControllers.add(TextEditingController());
      _qaPairs.add({'question': '', 'answer': ''});
    });
  }

  void _removeQAPair(int index) {
    setState(() {
      _questionControllers[index].dispose();
      _answerControllers[index].dispose();
      _questionControllers.removeAt(index);
      _answerControllers.removeAt(index);
      _qaPairs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Questure',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isQuestionAnswerClicked
              ? _buildQuestionAnswerFields()
              : _isMultipleChoiceClicked
                  ? _buildMultipleChoiceFields() // Implement as needed
                  : _buildButtons(),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _onQuestionAnswerClicked,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Question-Answer Set'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _onMultipleChoiceClicked,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Multiple Choice Set'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.all(16),
          ), // Implement functionality as needed
          child: const Text('Multiple Answer Set'),
        ),
      ],
    );
  }

  Widget _buildQuestionAnswerFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _onBackPressed,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Back'),
          ),
        ),
        for (int i = 0; i < _questionControllers.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: _questionControllers[i],
                      decoration:
                          InputDecoration(hintText: 'Enter question ${i + 1}'),
                      onChanged: (text) {
                        setState(() {
                          _qaPairs[i]['question'] = text;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _answerControllers[i],
                      decoration:
                          InputDecoration(hintText: 'Enter answer ${i + 1}'),
                      onChanged: (text) {
                        setState(() {
                          _qaPairs[i]['answer'] = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_questionControllers.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeQAPair(i),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        ElevatedButton(
          onPressed: _addQAPair,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Add Q/A Pair'),
        ),
        const SizedBox(height: 16),
        for (var qaPair in _qaPairs)
          Text(
            'Q: ${qaPair['question']}, A: ${qaPair['answer']}',
            style: const TextStyle(fontSize: 18),
          ),
      ],
    );
  }

  Widget _buildMultipleChoiceFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            onPressed: _onBackPressed,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Back'),
          ),
        ),
        TextField(
          controller: _questionController,
          decoration: const InputDecoration(hintText: 'Enter your question'),
          onChanged: (text) {
            setState(() {
              _question = text;
            });
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _correctAnswerController,
          decoration:
              const InputDecoration(hintText: 'Enter the correct answer'),
          onChanged: (text) {
            setState(() {
              _correctAnswer = text;
            });
          },
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < _falseAnswerControllers.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _falseAnswerControllers[i],
                  decoration:
                      InputDecoration(hintText: 'Enter false answer ${i + 1}'),
                  onChanged: (text) {
                    setState(() {
                      _falseAnswers[i] = text;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              if (_falseAnswerControllers.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeFalseAnswer(i),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        ElevatedButton(
          onPressed: _addFalseAnswer,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.all(16),
          ),
          child: const Text('Add False Answer'),
        ),
        const SizedBox(height: 16),
        Text(
          'Question: $_question',
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          'Correct Answer: $_correctAnswer',
          style: const TextStyle(fontSize: 18),
        ),
        for (String falseAnswer in _falseAnswers)
          Text(
            'False Answer: $falseAnswer',
            style: const TextStyle(fontSize: 18),
          ),
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
