class TopicBody {

  final int id;
  final int topicId;
  final String textBody;
  final String imageFilepath;

  TopicBody({
    required this.id,
    required this.topicId,
    required this.textBody,
    required this.imageFilepath,
  });

  factory TopicBody.fromSqfliteDatabase(Map<String, dynamic> map) => TopicBody(
    id: map["id"]?.toInt() ?? 0,
    topicId: map["topic_id"]?.toInt() ?? 0,
    textBody: map["text_body"] ?? "",
    imageFilepath: map["image_filepath"] ?? ""
  );

}