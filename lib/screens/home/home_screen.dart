import 'package:flutter/material.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/screens/home/tab_content/account_content.dart';
import 'package:hackerinus/screens/home/tab_content/competition_content.dart';
import 'package:hackerinus/screens/home/tab_content/course_content.dart';
import 'package:hackerinus/screens/home/tab_content/tools_content.dart';
import 'package:hackerinus/screens/placeholder_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  List<Widget> _children = [
    ToolsContent(),
    CoursesContent(),
    CompetitionContent(),
    AccountContent()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // decoration: BoxDecoration(
          //     gradient: RadialGradient(
          //       colors: [Colors.brown, Colors.black],
          //     ),
          // ),
          color: Colors.black,
          child: Center(child:_children.elementAt(_currentIndex))
      ),
      bottomNavigationBar: SizedBox(
        height: 85,
        child: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.outbox,color: Colors.black,size: 45.0,),
              label: 'Tools',
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined,color: Colors.black,size: 45.0),
              label: 'Courses',
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.run_circle,color: Colors.black,size: 45.0),
                label: 'Competition'
            ),
            new BottomNavigationBarItem(
              // icon: Icon(Icons.person,color: Colors.deepOrange),
              icon: Icon(Icons.person,color: Colors.black,size: 45.0),
              label: 'Account'
            )
        ],
      ),
      ),
      floatingActionButton: _currentIndex != 3 ? FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        tooltip: 'Increment',
        onPressed: () {
          switch(_currentIndex){
            case 0:
              Navigator.pushNamed(context, RouteConstant.formTools);
              break;
            case 1:
              Navigator.pushNamed(context, RouteConstant.formCourse);
              break;
            case 2:
              Navigator.pushNamed(context, RouteConstant.formCompetition);
              break;
          }
        },
        child: _currentIndex == 3 ? Icon(Icons.edit) : Icon(Icons.add),
      ): null,
    );
  }
}
