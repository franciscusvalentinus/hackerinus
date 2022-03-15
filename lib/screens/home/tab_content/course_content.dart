import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:hackerinus/models/Course.dart';
import 'package:hackerinus/screens/form_course/form_course_edit_screen.dart';
import 'package:hackerinus/services/course_services.dart';

class CoursesContent extends StatefulWidget {
  @override
  _CoursesContentState createState() => _CoursesContentState();
}

class _CoursesContentState extends State<CoursesContent> {

  CourseService _courseServices = CourseService.instance;

  Widget cardTool(BuildContext context, Course course){
    return Card(
      margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      elevation: 20.0,
      color: HexColor("#363636"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=> FormCourseEditScreen(),
                    settings: RouteSettings(
                        arguments: course
                    )
                ),

              );
            },
            leading:  CircleAvatar(
              backgroundImage: NetworkImage(course.imageUrl),),
            title :   Text (course.title,style: TextStyle(color: Colors.deepOrange),),
            subtitle :  Text (course.description,style: TextStyle(color: Colors.white),),
            // trailing :  Text (student.address),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(children: [
        Container(
            child: Text("Courses",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.yellow,fontSize: 40),),
            margin:EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0)
        ),
        StreamBuilder(stream: _courseServices.courseRepository.collectionReference.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((e) =>
                      cardTool(context,Course(e.id,e['title'], e['imageUrl'],e['description'], e['createdBy'],e['createdDate'],e['updatedDate']))
                  ).toList(),
                ),
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },

        )
      ],),
    );;
  }
}

