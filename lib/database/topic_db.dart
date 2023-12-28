import 'package:sqflite/sqflite.dart';
import 'package:cyber_secure_child/database/database_service.dart';
import 'package:cyber_secure_child/model/topic.dart';
import 'package:cyber_secure_child/model/topic_body.dart';
import 'package:cyber_secure_child/model/topic_advice.dart';

class TopicDB {
  final topicTableName = "topic";
  final topicBodyTableName = "topic_body";
  final topicAdviceTableName = "topic_advice";

  Future<List<Topic>> fetchAllTopics() async {
    final database = await DatabaseService().database;
    final topics = await database.rawQuery(
      """SELECT * FROM $topicTableName WHERE id <> 0;"""
    );
    return topics.map((topic) => Topic.fromSqfliteDatabase(topic)).toList();
  }

  Future<Topic> fetchTopicById(int id) async {
    final database = await DatabaseService().database;
    final topics = await database.rawQuery(
      """SELECT * FROM $topicTableName WHERE id = ?;""",
      [id]
    );
    return Topic.fromSqfliteDatabase(topics.first);
  }

  Future<List<TopicBody>> fetchTopicBodiesByTopicId(int id) async {
    final database = await DatabaseService().database;
    final topicBodies = await database.rawQuery(
      """SELECT * FROM $topicBodyTableName WHERE topic_id = ?;""",
      [id]
    );
    return topicBodies.map((topicBody) => TopicBody.fromSqfliteDatabase(topicBody)).toList();
  }

  Future<TopicAdvice> fetchTopicAdviceByTopicId(int id) async {
    final database = await DatabaseService().database;
    final topicAdvices = await database.rawQuery(
      """SELECT * FROM $topicAdviceTableName WHERE topic_id = ? ORDER BY RANDOM();""",
      [id]
    );
    return TopicAdvice.fromSqfliteDatabase(topicAdvices.first);
  }

}