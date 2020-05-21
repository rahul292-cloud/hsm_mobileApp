import 'package:flutter/material.dart';
import 'package:housing_society_management/app/auth_flow.dart';
import 'package:device_info/device_info.dart';
import 'package:housing_society_management/globals.dart' as globals;
import 'package:housing_society_management/constants.dart';

 main(){
   runApp(AuthFlow());//MyApp()
   //getDeviceInfo();
  //  DatabaseHelper();
   //read();
  
}
// getDeviceInfo() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     globals.androidVersion = androidInfo.version.codename;
//     globals.deviceId = androidInfo.id;
//     //print("this is global variable information: ${globals.androidVersion}");   
//   }



// class MyApp extends StatefulWidget{
//   @override 
//   State<StatefulWidget> createState() {
//     return MyAppState();
//   }
// }

// class MyAppState extends State<MyApp>{

//   var token1;
//   bool wait = false;
//   static const MaterialColor white1 = const MaterialColor(
//   0xff417698, // 0xFFFFFFFF  #417698  // #39687e
//   const <int, Color>{
//     50: const Color(0xff417698),
//     100: const Color(0xff417698),
//     200: const Color(0xff417698),
//     300: const Color(0xff417698),
//     400: const Color(0xff417698),
//     500: const Color(0xff417698),
//     600: const Color(0xff417698),
//     700: const Color(0xff417698),
//     800: const Color(0xff417698),
//     900: const Color(0xff417698),
//   },
// );
// @override
//   void initState() {
//     super.initState();
//     setState(() {
//       wait=false;
//     });
//     read();
//     //getDeviceInfo();
//   }
//   read() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'token';
//     final value = prefs.get(key ) ?? 0;
//     token1=value;
//     print("this is app token1 $token1");
//     setState(() {
//       wait=true;
//     });
//   }
  

//   @override 
//   Widget build(BuildContext context) {
    
//      return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HSM',
//       theme: ThemeData(
//         primarySwatch: white1,
//         //primaryColor: Colors.white,
//        ),
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: globals.token!='0'?Home():wait?Login(token1):Center(child:CircularProgressIndicator()),
//       )
//       // home:Scaffold(backgroundColor: Colors.white,
//       //   body: login?Login(token):Center(child:CircularProgressIndicator()),
//       // )

//       // login?Login(token):Center(child:CircularProgressIndicator()),  //  LoginPage(),  
//     );
//   }
// }
