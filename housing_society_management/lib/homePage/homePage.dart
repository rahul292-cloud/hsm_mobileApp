// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:housing_society_management/accounting/accounting.dart';
// import 'package:housing_society_management/controller/databasehelper.dart';
// import 'package:housing_society_management/flats/flats.dart';
// import 'package:housing_society_management/helpDesk/helpDesk.dart';
// import 'package:housing_society_management/homePage/homePageContent.dart';
// import 'package:housing_society_management/loginSystem/login.dart';
// import 'package:housing_society_management/loginSystem/userProfile.dart';
// import 'package:housing_society_management/maintenance/maintenance.dart';
// import 'package:housing_society_management/members/members.dart';
// import 'package:housing_society_management/notice/notice.dart';
// import 'package:housing_society_management/notification/notifications.dart';
// import 'package:housing_society_management/purchaseOrder/purchaseOrder.dart';
// import 'package:housing_society_management/setting/setting.dart';
// import 'package:housing_society_management/vehicleParking/vehicleParking.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;


// class Home extends StatefulWidget {
//   Home({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   HomeState createState() => HomeState();
// }

// class HomeState extends State<Home> {
  
//   DatabaseHelper databaseHelper = new DatabaseHelper();

//   _save(String token) async {  // , String ipAddress
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'token';
//     final value = token;
//     prefs.setString(key, value);

//   }

//   String name = "";
  
//   String email = "";
  
//   Future _Logout() async {
//     _save('0'); // ,'0'
//     Navigator.of(context).push(new MaterialPageRoute(
//       builder: (BuildContext context) => LoginPage(),
//     ));
//   }

//   userData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'token';
//     final value = prefs.get(key) ?? 0;

//     final baseUrl = 'Base_URL';
//     final urlValue = prefs.get(baseUrl ) ?? 0;

//     final String url = "$urlValue/mobile_api/UserAPI/";

//     //String url = "${Urls.BASE_API_URL}/mobile_api/UserAPI/";

//     try {
//       final response =
//           await http.post(url, headers: {'Authorization': 'token $value'});
//       print('getEmployees new Response: ${response.body}');

//       if (200 == response.statusCode) {
//         Map<String, dynamic> map = json.decode(response.body);
//         print("map ${map['is_success']}");
//         List l1 = map['data'];
//         //print("l1: $l1");
//         var k = l1[0];
//         // print("k : $k");
//         var k2 = k['first_name'];
//         name = k2;
//         email = k['last_name'];
//         print("name: $name");
//       } else {
//         return null;
//       }
//     } catch (e) {
//       return e;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     userData();
//     print("this is home");
//   }
  
//   @override
//   Widget build(BuildContext context) {
    
//       return Scaffold(    
//       appBar: AppBar(
//         title: Text("Home "), //  + name
//         backgroundColor: Color(0xff39687e),
//         actions: <Widget>[
//           // IconButton(
//           //   icon: Icon(Icons.cancel),

//           //   onPressed: (){
//           //     _Logout();
//           //   },),

//           IconButton(
//             icon: const Icon(Icons.notifications),
//             //tooltip: 'Show Snackbar',
//             onPressed: () {
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (BuildContext contex) => Notifications(),));  // Notifications()
//              // showOverlay(context);
//             },
//           ),
//         ],
//       ),

//       drawer: Drawer(   // #222d32

//         child:Container(color: Colors.black,//Color(0xff39687e),
        
//         child: ListView(
//           // padding: EdgeInsets.all(30.0),
//           children: <Widget>[
//             // for user account informations on top of our drawer
//             Container(color:Color(0xff39687e),height: AppBar().preferredSize.height,width: 20.0,
//             child: Padding(
//               padding: EdgeInsets.only(left: 16.0,top: 15.0),
//               child: Text("HSM", style: TextStyle(color: Colors.white,fontSize: 20.0),),
//             )
            
//             ), // height:52.0
//             Padding(padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 18.0),
//             child:Row(
//               children: <Widget>[
//                 GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (BuildContext contex) => UserProfile(name)));
//                 },
//                 child: CircleAvatar(
//                   // backgroundImage: NetworkImage(
//                   //     "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?"),
//                maxRadius: 30.0, ),
                
//               ),
//               Flexible(
//               child:Text("  ${name}\n",style: TextStyle(color: Colors.white,fontSize: 17.0),),//"  ${name}\n  hii"
//               ),
//               // Column(
//               //   children: <Widget>[
//               //     Text("  ${name}\n  hiii",style: TextStyle(color: Colors.white,fontSize: 17.0),),
//               //     Text(" data",style: TextStyle(color: Colors.white,fontSize: 17.0,),textAlign: TextAlign.start,)
//               //   ],
//               // ),

//               ],
//             ),
//         ),

//           //   UserAccountsDrawerHeader(
//           //     accountName: Text(name),
//           //     accountEmail: Text(email),
//           //     currentAccountPicture: GestureDetector(
//           //       onTap: () {
//           //         Navigator.of(context).pop();
//           //         Navigator.of(context).push(MaterialPageRoute(
//           //             builder: (BuildContext contex) => UserProfile(name)));
//           //       },
//           //       child: CircleAvatar(
//           //         backgroundImage: NetworkImage(
//           //             "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?"),
//           //       ),
//           //     ),
//           //     decoration: BoxDecoration(
//           //         color: Colors.black,//Color(0xff39687e),
//           //         image: DecorationImage(
//           //             fit: BoxFit.fill,
//           //             image:
//           //                 NetworkImage("https://picsum.photos/250?image=9rr"))
//           // ), //https://i.picsum.photos/id/9/250/250.jpg
//           //   ),

//             ListTile(
//               title: Text(
//                 "Home",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),//fontStyle: FontStyle.italic,
//               ),
//               leading: Icon(Icons.home,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 // Navigator.of(context).push(MaterialPageRoute(
//                 //     builder: (BuildContext contex) => Home()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Maintenance",
//                 //style: TextStyle(fontSize: 20.0),
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.note,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) =>
//                         Maintenance())); // Maintenance(user_id)));
//               },
//             ),
//             Divider(),
            
//             ListTile(
//               title: Text(
//                 "Notice",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.info,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => Notice()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Members",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.group,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => Members()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Accounting",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.account_box,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => Accounting()));
//               },
//             ),
//             Divider(),
            
//             ListTile(
//               title: Text(
//                 "Purchase order",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.description,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => PurchaseOrder()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Flats",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.room,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => Flats()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Vehicle Parking",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.local_parking,color: Colors.white,),
//               //trailing: Icon(Icons.c),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => VehicleParking()));
//               },
//             ),
//             Divider(),

//             ListTile(
//               title: Text(
//                 "Vendors",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.accessibility_new,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 // Navigator.of(context).pop();
//                 // Navigator.of(context).push(MaterialPageRoute(
//                 //     builder: (BuildContext contex) => Form_create()));
//                 print("button tab");
//               },
//             ),
//             Divider(),
//             ListTile(
//               title: Text(
//                 "Helpdesk",
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               leading: Icon(Icons.help,color: Colors.white,),
//               //trailing: Icon(Icons.arrow_right),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => HelpDesk()));
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.lock_open,color: Colors.white,),
//               title: Text(
//                 'LOGOUT',
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _Logout(); //Logout()  //  LogInUsingFirebase()
//               },
//             ),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.settings,color: Colors.white,),
//               title: Text(
//                 'SETTING',
//                 style: TextStyle(fontSize: 20.0,color: Colors.white,),
//               ),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (BuildContext contex) => Setting()));
//               },
//             ),
//           ],
//         ),
//       ),
//       ),
//       body:
//           HomePageContent(), //Posts(posts),  // HomePageContent(),  // Posts(),
//    // ),    
//     );
//   }
  
// }
