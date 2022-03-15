import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/services/auth_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:hackerinus/utils/sharedprefs_util.dart';

class AccountContent extends StatefulWidget {
  @override
  _AccountContentState createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  bool _isloading = false;

  String _email = "";
  String _name = "";
  String _phone = "";
  String _joinedDate = "";

  AuthService _authService = AuthService.instance;

  getPrefs() async{
    await SharedPrefsUtil.getEmail().then((value) {
      setState(() {
        _email = value;
      });
    });

    await SharedPrefsUtil.getName().then((value) {
      setState(() {
        _name = value;
      });
    });

    await SharedPrefsUtil.getPhone().then((value) {
      setState(() {
        _phone = value;
      });
    });

    await SharedPrefsUtil.getJoinedDate().then((value) {
      setState(() {
        _joinedDate = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(children: [
        Container(
            child: Text("My Account",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.yellow,fontSize: 40),),
            margin:EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0)
        ),
        Expanded(
          child: ListView(
            children: [
              Card(
                color: HexColor("#363636"),
                child: ListTile(
                  title :   Text ("Your Email",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                  subtitle :  Text (_email,style: TextStyle(color: Colors.white),),
                  // trailing :  Text (student.address),
                ),
              ),
              Card(
                color: HexColor("#363636"),
                child: ListTile(
                  title :   Text ("Your Name",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                  subtitle :  Text (_name,style: TextStyle(color: Colors.white),),
                  // trailing :  Text (student.address),
                ),
              ),
              Card(
                color: HexColor("#363636"),
                child: ListTile(
                  title :   Text ("Phone Number",style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                  subtitle :  Text (_phone,style: TextStyle(color: Colors.white),),
                  // trailing :  Text (student.address),
                ),
              ),
              // Card(
              //   color: Colors.white,
              //   child: ListTile(
              //     title :   Text ("Joined At",style: TextStyle(color: Colors.deepOrange),),
              //     subtitle :  Text (_joinedDate,style: TextStyle(color: Colors.black),),
              //     // trailing :  Text (student.address),
              //   ),
              // )
            ],
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                _isloading = true;
              });
              await _authService.signOut().then((value) {
                if (value == true) {
                  setState(() {
                    _isloading = false;
                  });
                  ActivityUtils.showToast("Logout Success", Colors.green);
                  Navigator.pushReplacementNamed(context, RouteConstant.login);
                } else {
                  setState(() {
                    _isloading = false;
                  });
                  ActivityUtils.showToast("Logout Failed", Colors.green);
                }
              });
            },
            icon: Icon(Icons.login_rounded),
            label: Text("Logout"),
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange[400],
              elevation: 0,
            ),
          ),
        ),
        _isloading == true ? ActivityUtils.loadings() : Container()
      ],),
    );;
  }
}
