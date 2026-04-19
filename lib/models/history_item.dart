class HistoryItem {
  final String expression;
  final String result;

  HistoryItem({required this.expression, required this.result});

  Map<String, dynamic> toJson() => {
        'expression': expression,
        'result': result,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      expression: json['expression'],
      result: json['result'],
    );
  }
}
