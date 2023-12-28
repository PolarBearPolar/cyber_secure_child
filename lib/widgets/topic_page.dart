import 'package:flutter/material.dart';
import 'package:cyber_secure_child/database/topic_db.dart';
import 'package:cyber_secure_child/model/topic.dart';
import 'package:cyber_secure_child/model/topic_body.dart';
import 'package:cyber_secure_child/widgets/swimming_fish_row.dart';

class TopicPage extends StatelessWidget {

  final int topicId;
  final TopicDB topicDB = TopicDB();

  TopicPage({
    required this.topicId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.white,
                    size: 50.0,
                    shadows: [
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ]
                  ),
                  leading: null,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: FutureBuilder(
                    future: topicDB.fetchTopicById(topicId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                        return CircularProgressIndicator();
                      } else {
                        Topic data = snapshot.data as Topic;
                        return ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.white, Colors.lightBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: Text(
                            data.title,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ]
                            ),
                          ),
                        );
                      }
                    }
                  ),
                ),
                Container(
                  height: 550.0,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0), 
                  child: FutureBuilder(
                    future: topicDB.fetchTopicBodiesByTopicId(topicId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                        return CircularProgressIndicator();
                      } else {
                        List<TopicBody> data = snapshot.data as List<TopicBody>;
                        return Scrollbar(
                          thickness: 15,
                          child: ListView.builder(
                            itemBuilder: (context, index) => Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                                  child: Text(
                                    data[index].textBody,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 2, 37, 66),
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1.0,
                                          color: Colors.white,
                                          offset: Offset(2.0, 2.0),
                                        ),
                                        Shadow(
                                          blurRadius: 1.0,
                                          color: Colors.white,
                                          offset: Offset(-2.0, 2.0),
                                        ),
                                        Shadow(
                                          blurRadius: 1.0,
                                          color: Colors.white,
                                          offset: Offset(-2.0, -2.0),
                                        ),
                                        Shadow(
                                          blurRadius: 1.0,
                                          color: Colors.white,
                                          offset: Offset(2.0, -2.0),
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                                _getImage(data[index].imageFilepath)
                              ]
                            ),
                            itemCount: data.length,
                            scrollDirection: Axis.vertical,
                          ),
                        );
                      }
                    }
                  ),
                ),
                SizedBox(
                  height: 10
                ),
                _getSwimmingFishRow(topicId),
                SizedBox(
                  height: 10
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}

Widget _getSwimmingFishRow(int topicId) {
  return SwimmingFishRow(topicId: topicId);
}

Widget _getImage(String imageFilepath) {
  if (imageFilepath == null || imageFilepath.isEmpty) {
    return Container();
  } else {
    return Image.asset(
      imageFilepath,
      width: 300,
      height: 300,
    );
  }
}