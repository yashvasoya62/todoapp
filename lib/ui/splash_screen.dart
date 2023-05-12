import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todoapp/ui/home_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  bool notification = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:Color(0xff3D3542),
      body: Center(
        child:Text("ToDo Task",style:  TextStyle(color:Colors.white,fontSize: 40,fontWeight: FontWeight.bold )),
      ),
    );
  }
  void startTimer(){
    Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));

      }
    );
  }
  void startNotification() {
      Timer(const Duration(seconds: 5), () async {
        if (await Permission.notification.request().isGranted) {
        }
      }
      );
  }
}
