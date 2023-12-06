//Ideally how the content appears on the cards

class Sets {
  int? id;
  final String question;
  final String answer;

  Sets(
      {required this.question,
      required this.answer,});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  factory Sets.fromMap({required Map<String, dynamic> map}) {
    return Sets(
        question: map['question'],
        answer: map['answer']);
  }
}
