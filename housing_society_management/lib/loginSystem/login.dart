// import 'package:flutter/material.dart';
// import 'package:housing_society_management/controller/databasehelper.dart';
// import 'package:housing_society_management/homePage/homePage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:http/http.dart' as http;

// class Login extends StatefulWidget{
  
//   var token;
//   Login(this.token){
//     print("login $token");
//   }

//   @override 
//   State<StatefulWidget> createState() {
//     return LoginState(token);//
//   }
// }
// class LoginState extends State<Login>{
//   var token;
  
//   LoginState(this.token);
  
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   print("this is login init state $token");
  
//   // }
// @override 
// Widget build(BuildContext context) {
//   print("login build token $token");
//       //read();
//     //   return MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   home: Scaffold(
//     //     backgroundColor: Colors.white,
//     //     body: Center(child:Container(
//     //                     child: Image.asset(
//     //                       'images/Logo.png',
//     //                      // height: 60.0,
//     //                       //fit: BoxFit.cover,
//     //                     ),
//     //                   ),
//     //   ),
//     // ),
//     // //home: value1=='0'?LoginPage():Home(),
//     // );
//     //return checklogin?Home():LoginPage();
//     //return token=='0'?LoginPage():Home();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: token=='0'?LoginPage():Home(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget{

//   LoginPage({Key key , this.title}) : super(key : key);
//   final String title;

//   @override
//   LoginPageState  createState() => LoginPageState();
// }

// class LoginPageState extends State<LoginPage> {
//   bool _showPassword = false;
  
//   final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

//   DatabaseHelper databaseHelper = new DatabaseHelper();
//   String msgStatus = '';

//   final TextEditingController _userNameController = new TextEditingController();
//   final TextEditingController _passwordController = new TextEditingController();
//   final TextEditingController _userIpController = new TextEditingController();

//   _onPressed(){
//     setState(() async {
//        if(_userNameController.text.isNotEmpty &&  _passwordController.text.isNotEmpty ){    //  && _userIpController.text.isNotEmpty       
//          databaseHelper.loginData(_userNameController.text,
//             _passwordController.text).whenComplete(() async {  // , _userIpController.text
//               if(databaseHelper.status){
//                 _showDialog();
//                 msgStatus = 'Check email or password';
//               }else{
//                  //Navigator.pushReplacementNamed(context, '/dashboard');
//                   Navigator.of(context).pop();           
//                   Navigator.of(context).push(
//                    new MaterialPageRoute(
//                   builder: (BuildContext context) =>  Home(),  //  Dashboard(),
//                     )
//                   );
//                     print("pushing to the dashboard");
//               }
//         } 
//         );
//       }
//      });
// }
    
//   @override
//   Widget build(BuildContext context) {
            
//         return WillPopScope(
//           onWillPop: () async => false, //_onBackPressed,
//         child:Scaffold( backgroundColor: Colors.white,
//         key: scaffoldkey,
//         appBar: AppBar(
//           title:  Text('Login '),
//           automaticallyImplyLeading: false,backgroundColor: Color(0xff39687e),
//          ),
         
//         body: Container(
//           child: ListView(
//             padding: const EdgeInsets.only(top: 62,left: 12.0,right: 12.0,bottom: 12.0),
//             children: <Widget>[

//             _username(context),
//             _password(context),
//             _buttonLogin(context),
//             _ipAddress(context),
//             _buttonRegister(context),

//             new Padding(padding: new EdgeInsets.only(top: 44.0),),

//               Container(
//                 height: 50,
//                 child: new Text(
//                    '$msgStatus',
//                    textAlign: TextAlign.center,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               new Padding(padding: new EdgeInsets.only(top: 44.0),),
//             ],
//           ),
//         )
//        ),
//     );
    
//   }

//   Widget _ipAddress(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: _userIpController,
//         //validator: validateUser,
//         //onSaved: (String value) {
//         //  var name = value;
//         //},
//         key: Key('IP Address'),
//         decoration:
//             InputDecoration(hintText: 'IP Address', labelText: 'IP Address'),
//         style: TextStyle(fontSize: 20.0, color: Colors.black),
//       ),
//     );
//   }

//    Widget _username(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: _userNameController,
//         //validator: validateUser,
//         //onSaved: (String value) {
//         //  var name = value;
//         //},
//         key: Key('username'),
//         decoration:
//             InputDecoration(hintText: 'username', labelText: 'username'),
//         style: TextStyle(fontSize: 20.0, color: Colors.black),
//       ),
//     );
//   }

//   Widget _password(BuildContext context) {
    
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: _passwordController,
//         // validator: validatePass,
//         // onSaved: (String value) {
//         //   var pass = value;
//         // },
//         key: Key('password'),
//         decoration: InputDecoration(
//             hintText: 'Password', labelText: 'Password',
            
//             suffixIcon: GestureDetector(
//               onTap: (){
//                 setState(() {
//                   _showPassword = !_showPassword;
//                 });
//               },
//               child: Icon(
//                 _showPassword ? Icons.visibility : Icons.visibility_off,
//               ),
//             ) 

//             ), //password
//         style: TextStyle(fontSize: 20.0, color: Colors.black),
//         obscureText:  !_showPassword,   // true
//       ),
//     );
//   }

//   Widget _buttonLogin(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () {
//           _onPressed(); // submit();
//         },
//         child: Container(
//           height: 50.0,
//           decoration: BoxDecoration(
//             color: Color(0xff39687e),
//             border: Border.all(color: Colors.white, width: 2.0),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Center(
//             child: Text("Login", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ),
//     );
//   }  

//   Widget _buttonRegister(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: InkWell(
//         onTap: () {
//           _resetIP();
//            databaseHelper.saveURL(_userIpController.text);
//           _showDialogForIP();
//         },
//         child: Container(
//           height: 50.0,
//           decoration: BoxDecoration(
//             color: Color(0xff39687e),
//             border: Border.all(color: Colors.white, width: 2.0),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Center(
//             child: Text("Register IP", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ),
//     );
//   }


//   void _showDialog(){
    
//           showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           // return object of type Dialog
//           return AlertDialog(
//             title: new Text("Failed !"),
//             content: new Text("Invalid Username or Password !"),
//             actions: <Widget>[
//               // usually buttons at the bottom of the dialog
//               new FlatButton(
//                 child: new Text("Close"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );

//   }

//   Future<void> _showDialogForIP() async {
//     final prefs = await SharedPreferences.getInstance();
//       // final key = 'token';
//       // final value = prefs.get(key ) ?? 0;

//       final baseUrl = 'Base_URL';
//       final urlValue = prefs.get(baseUrl ) ?? 0;

//           showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           // return object of type Dialog
//           return AlertDialog(
//             title: new Text("IP: $urlValue"),
//             content: new Text("Set Successfully "),
//             actions: <Widget>[
//               // usually buttons at the bottom of the dialog
//               new FlatButton(
//                 child: new Text("Ok"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//   } 
// }

// Future _resetIP() async {
//     _saveIp('0'); // ,'0'
//     print("this is reset ip");
//   }

//    _saveIp(String ipAddress) async {  // , String ipAddress
//     final prefs = await SharedPreferences.getInstance();
//     final baseUrl = 'Base_URL';
//     final urlValue = ipAddress;
//     prefs.setString(baseUrl, urlValue);
//     print("this is also reset ip");
        
//   }
