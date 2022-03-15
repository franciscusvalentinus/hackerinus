import 'package:flutter/material.dart';
import 'package:hackerinus/constant/RouteConstant.dart';
import 'package:hackerinus/services/auth_services.dart';
import 'package:hackerinus/utils/activity_util.dart';
import 'package:hackerinus/utils/sharedprefs_util.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _email = "";
  String _password = "";

  bool isLoading = false;

  AuthService authService = AuthService.instance;

  @override
  void initState() {
    super.initState();
  }

   onTapLogin() async {
    setState(() {
      isLoading = true;
    });
    bool shouldNavigate = await authService.signIn(_email, _password);
    if (shouldNavigate) {
      print("authorized");
      SharedPrefsUtil.setIsLogin(true);
      SharedPrefsUtil.setEmail(_email);
      Navigator.pushNamed(context, RouteConstant.home);
    } else{
      print("unauthorized");
    }
    setState(() {
      isLoading = false;
    });
  }

  formLogin(){
    return Container(
      child: Column(children: [
        Container(
          margin: EdgeInsets.all(10.0),
          color: Colors.white,
          child: TextField(
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
        ElevatedButton(
          onPressed: onTapLogin,
          style:  ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: const Text('Login'),
        ),
        ElevatedButton(
          onPressed:(){
            Navigator.pushNamed(context, RouteConstant.registration);
          },
          style:  ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          child: const Text('Register'),
        ),
      ],),
    );
  }

  @override
  Widget build(BuildContext context) {
  Size media = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading == false ? Container(
          color: Colors.black,
          height: media.height,
          width: media.width,
          child: Padding(
            padding: EdgeInsets.all(media.height * 0.05),
            child: Column(children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(70.0),
                  child: Center(
                    child: Image.asset('assets/images/hackerinus.png'),
                  ),
                ),
              ),
              formLogin()
            ],),
          ),
        ) : ActivityUtils.loadings()
    );
  }
}
