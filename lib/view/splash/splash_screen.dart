import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_wallpaper/view/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? pref;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  late String deviceId;

  Future<void> getAndroidDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = "${androidInfo.device}" + "${androidInfo.id}";
      print('Android Device ID: $deviceId');
    } catch (e) {
      print('Failed to get Android device ID: $e');
      deviceId = '';
    }
  }
  @override
  void initState() {
    getAndroidDeviceId();
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(seconds: 2), () {
        screenNav();
      });
    });

    super.initState();
  }

  // Future<void> screenNav() async {
  //   if (await MySharedPreference.getOnBoarding()) {
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => onboardingScreen(),
  //     ));
  //
  //   } else {
  //
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     if(preferences.getString('email')==null){
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (context) => LoginScreen(),));
  //     }else{
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => MainScreen(),
  //       ));
  //     }
  //
  //   }
  // }
  Future<void> screenNav() async {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));

  }

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:const [
            Center(
                child: CircularProgressIndicator()),

          ],
        ),
      ),
    );
  }
}