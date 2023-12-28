import 'package:flutter/material.dart';
import 'package:cyber_secure_child/database/topic_db.dart';
import 'package:cyber_secure_child/model/topic_advice.dart';
import 'dart:async';
import 'dart:math';

class SwimmingFishRow extends StatefulWidget {
  final int topicId;

  SwimmingFishRow({
    required this.topicId
  });

  @override
  _SwimmingFishRowState createState() => _SwimmingFishRowState(topicId: topicId);
}

class _SwimmingFishRowState extends State<SwimmingFishRow> with TickerProviderStateMixin {
  late AnimationController _fishController;
  late AnimationController _notificationController;
  late final Animation<double> _notificationAnimation = CurvedAnimation(
    parent: _notificationController,
    curve: Curves.elasticOut
  );
  late String _notificationText = "Hi there! Sending positive vibes your way";
  late bool _isNotificationDisplayed;
  final int topicId;
  final TopicDB topicDB = TopicDB();

  _SwimmingFishRowState({
    required this.topicId
  });

  @override
  void initState() {
    super.initState();
    _fishController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _notificationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _isNotificationDisplayed = false;
  }

  void showNotification() {
    getAdviceFromDatabase();
    setState(() {
      _isNotificationDisplayed=true;
    });
    _notificationController.forward();
    Future.delayed(Duration(seconds: 5), () {
      _notificationController.reverse();
    });
    setState(() {
      _isNotificationDisplayed=false;
    });
  }

  Future<void> getAdviceFromDatabase() async {
    final TopicAdvice topic = await topicDB.fetchTopicAdviceByTopicId(topicId);
    setState(() {
      _notificationText = topic.advice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 110,
          height: 110,
          child: GestureDetector(
            onTap: () {
              if (!_isNotificationDisplayed) {
                showNotification();
              }
            },
            child: AnimatedBuilder(
              animation: _fishController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, sin(_fishController.value * 2 * pi) * 20),
                  child: Image.asset(
                    'assets/fish_friend_transparent.png',
                    width: 100,
                    height: 100,
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: ScaleTransition(
            scale: _notificationAnimation,
            child: Container(
              margin: EdgeInsets.all(8),
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 26, 25, 25).withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(5.0),
              child: Text(
                _notificationText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fishController.dispose();
    _notificationController.dispose();
    super.dispose();
  }
}