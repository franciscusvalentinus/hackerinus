import 'package:flutter/material.dart';
import 'package:hackerinus/services/auth_services.dart';
import 'package:hackerinus/utils/activity_util.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  String _email = "";
  String _password = "";
  String _phoneNumber = "";
  String _fullName = "";
  String _confirmPassword = "";
  bool isLoading = false;
  
  AuthService _authService = AuthService.instance;

  registrationAction() async{
    setState(() {
      isLoading = true;
    });
    if(_confirmPassword != _password){
      ActivityUtils.showToast("Password not same", Colors.redAccent);
      return;
    }
    await _authService.register(_email, _password,_fullName,_phoneNumber);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Registration'),
      ),
      body: isLoading == false ? Container(
        color: Colors.black,
        child: Column(children: [
          Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Full Name",
              ),
              onChanged: (String name){
                setState(() {
                  _fullName = name;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Phone Number",
              ),
              onChanged: (String phone){
                setState(() {
                  _phoneNumber = phone;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Email",
              ),
              onChanged: (String email){
                setState(() {
                  _email = email;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Password",
              ),
              onChanged: (String password){
                setState(() {
                  _password = password;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: "Confirm Password",
              ),
              onChanged: (String password){
                setState(() {
                  _confirmPassword = password;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed:registrationAction,
            style:  ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: const Text('Register'),
          ),
        ],),
      ) : ActivityUtils.loadings(),
    );
  }
}
