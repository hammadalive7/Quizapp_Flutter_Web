class QuestionModel {
  String? question;
  Map<String, bool>? answers;
  QuestionModel(this.question, this.answers);

  factory QuestionModel.fromFirestore(Map<String, dynamic> data) {
    return QuestionModel(
      data['question'] as String?,
      (data['answers'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as bool),
      ),
    );
  }

}
