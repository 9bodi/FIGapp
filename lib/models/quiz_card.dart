enum CardKind { trueFalse, multipleChoice, estimation }

class QuizCardData {
  final CardKind kind;
  final String category;
  final String question;
  final List<String>? options;
  final int? correctIndex;
  final double? min;
  final double? max;
  final double? correctValue;
  final String answerLabel;
  final String revealTitle;
  final String revealText;

  const QuizCardData({
    required this.kind,
    required this.category,
    required this.question,
    required this.answerLabel,
    required this.revealTitle,
    required this.revealText,
    this.options,
    this.correctIndex,
    this.min,
    this.max,
    this.correctValue,
  });
}
