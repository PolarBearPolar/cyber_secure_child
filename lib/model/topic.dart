class Topic {

  final int id;
  final String title;
  final String imageFilepath;

  Topic({
    required this.id,
    required this.title,
    required this.imageFilepath,
  });

  factory Topic.fromSqfliteDatabase(Map<String, dynamic> map) => Topic(
    id: map["id"]?.toInt() ?? 0,
    title: map["title"] ?? "",
    imageFilepath: map["image_filepath"] ?? ""
  );

}