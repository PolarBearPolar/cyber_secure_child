import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cyber_secure_child/database/topic_db.dart';
import 'package:cyber_secure_child/model/topic.dart';
import 'package:cyber_secure_child/widgets/topic_page.dart';
import 'package:cyber_secure_child/widgets/swimming_fish_row.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
        // Define default text styles
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: "Kids Zone",
          ),
          bodyText2: TextStyle(
            fontFamily: "Kids Zone",
            fontSize: 20.0,
            color: Color.fromARGB(255, 2, 37, 66)
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final TopicDB topicDB = TopicDB();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.white, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Cyber Secure Child',
                    style: TextStyle(
                      fontSize: 40.0,
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
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome to Ilia Filippov\'s application!\nRead the fun stories and learn cyber security the fun way.\n Let the adventure begin!',
                    style: TextStyle(
                      fontSize: 25,
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
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 300.0,
                child: FutureBuilder(
                  future: topicDB.fetchAllTopics(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                      return CircularProgressIndicator();
                    } else {
                      List<Topic> data = snapshot.data as List<Topic>;
                      return ListView.builder(
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => _getTopicPage(data[index].id)),
                              );
                            },
                            child: Container(
                            margin: EdgeInsets.all(8),
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 26, 25, 25).withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 3),
                                ),
                              ]
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  data[index].imageFilepath,
                                  width: 110,
                                  height: 110,
                                ),
                                Text(
                                    data[index].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                              ]
                            ),
                          ),
                        ),
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                      );
                    }
                  }
                ),
              ),
              _getSwimmingFishRow(0),
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

Widget _getTopicPage(int topicId) {
  return TopicPage(topicId: topicId);
}

Widget _getSwimmingFishRow(int topicId) {
  return SwimmingFishRow(topicId: topicId);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}