import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:hackerinus/models/Competition.dart';
import 'package:hackerinus/screens/form_competition/form_competition_edit_screen.dart';
import 'package:hackerinus/services/competition_services.dart';

class CompetitionContent extends StatefulWidget {
  @override
  _CompetitionContentState createState() => _CompetitionContentState();
}

class _CompetitionContentState extends State<CompetitionContent> {
  CompetitionService _courseServices = CompetitionService.instance;

  Widget cardTool(BuildContext context, Competition competition){
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
                    builder: (context)=> FormCompetitionEditScreen(),
                    settings: RouteSettings(
                        arguments: competition
                    )
                ),

              );
            },
            leading:  CircleAvatar(
              backgroundImage: NetworkImage(competition.imageUrl),),
            title :   Text (competition.title,style: TextStyle(color: Colors.deepOrange),),
            subtitle :  Text (competition.description,style: TextStyle(color: Colors.white),),
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
            child: Text("Competition",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.yellow,fontSize: 40),),
            margin:EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0)
        ),
        StreamBuilder(stream: _courseServices.competitionRepository.collectionReference.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((e) =>
                      cardTool(context,Competition(e.id,e['title'], e['imageUrl'],e['description'], e['createdBy'],e['createdDate'],e['updatedDate']))
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
