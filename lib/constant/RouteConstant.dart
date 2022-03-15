import 'package:flutter/cupertino.dart';
import 'package:hackerinus/screens/form_competition/form_competition_screen.dart';
import 'package:hackerinus/screens/form_course/form_course_screen.dart';
import 'package:hackerinus/screens/form_tools/form_tools_create_screen.dart';
import 'package:hackerinus/screens/form_tools/form_tools_edit_screen.dart';
import 'package:hackerinus/screens/home/home_screen.dart';
import 'package:hackerinus/screens/login/login_screen.dart';
import 'package:hackerinus/screens/registration/registration_screen.dart';

class RouteConstant {
  static const String root = "/";
  static const String home = "/home";
  static const String login = "/login";
  static const String registration = "/registration";
  static const String formTools = "/form_tools";
  static const String formUpdate = "/form_tools_update";
  static const String formCourse = "/form_course";
  static const String formCompetition = "/form_competition";

  Map<String,Widget Function(BuildContext)> routeList = {
    root: (context) => LoginScreen(),
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    registration: (context) => RegistrationScreen(),
    formTools: (context) => FormToolScreen(),
    formUpdate: (context) => FormToolEditScreen(),
    formCourse: (context) => FormCourseScreen(),
    formCompetition: (context) => FormCompetitionScreen(),
  };
}