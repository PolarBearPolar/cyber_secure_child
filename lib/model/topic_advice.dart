class TopicAdvice {

  final int id;
  final int topicId;
  final String advice;

  TopicAdvice({
    required this.id,
    required this.topicId,
    required this.advice,
  });

  factory TopicAdvice.fromSqfliteDatabase(Map<String, dynamic> map) => TopicAdvice(
    id: map["id"]?.toInt() ?? 0,
    topicId: map["topic_id"]?.toInt() ?? 0,
    advice: map["advice"] ?? "",
  );

}