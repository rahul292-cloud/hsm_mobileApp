import 'package:flutter/material.dart';
import 'package:housing_society_management/app/pages/home_page.dart';
import 'package:housing_society_management/app/pages/login_page.dart';
import 'package:housing_society_management/setting/setting.dart';

class AuthFlow extends StatelessWidget {
  static const MaterialColor color = const MaterialColor(
  0xff417698, // 0xFFFFFFFF  #417698  // #39687e
  const <int, Color>{
    50: const Color(0xff417698),
    100: const Color(0xff417698),
    200: const Color(0xff417698),
    300: const Color(0xff417698),
    400: const Color(0xff417698),
    500: const Color(0xff417698),
    600: const Color(0xff417698),
    700: const Color(0xff417698),
    800: const Color(0xff417698),
    900: const Color(0xff417698),
  },
);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
	    title: 'Authentication Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: color,
        ),
      home: new LoginPage(),
	    routes: {//<String, WidgetBuilder>
      	HomePage.routeName: (BuildContext context) => new HomePage(),
        //SettingView.routeName:(BuildContext context)=>new SettingView(), //Setting(),
	    },
      
    );
  }
}