import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/models/Tools.dart';
import 'package:hackerinus/screens/form_tools/form_tools_edit_screen.dart';
import 'package:hackerinus/services/tools_services.dart';

class ToolsContent extends StatefulWidget {
  @override
  _ToolsContentState createState() => _ToolsContentState();
}

class _ToolsContentState extends State<ToolsContent> {

  ToolServices _toolServices = ToolServices.instance;
  final ctrlSearch = TextEditingController();
  String _searchText = "";

  Widget cardTool(BuildContext context, Tools tools){
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
                      builder: (context)=> FormToolEditScreen(),
                      settings: RouteSettings(
                        arguments: tools
                      )
                  ),

              );
            },
            leading:  CircleAvatar(
              backgroundImage: NetworkImage(tools.imageUrl),),
            title :   Text (tools.title,style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
            subtitle :  Text (tools.description,style: TextStyle(color: Colors.white),),
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
      child: Container(
          child: Column(
            children: [
              Text("Tools",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.yellow,fontSize: 40),),
              StreamBuilder(stream: _toolServices.toolsRepository.collectionReference.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasData){
                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs.map((e) =>
                            cardTool(context,Tools(e.id,e['title'], e['imageUrl'],e['description'], e['createdBy'],e['createdDate'],e['updatedDate']))
                        ).toList(),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                },
              )
            ],
          ),
          margin:EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0)
      ),
    );
  }
}
