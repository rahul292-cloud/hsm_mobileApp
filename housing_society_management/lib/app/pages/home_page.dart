import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:housing_society_management/accounting/accounting.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/controller/databasehelper.dart';
import 'package:housing_society_management/flats/flats.dart';
import 'package:housing_society_management/helpDesk/helpDesk.dart';
import 'package:housing_society_management/homePage/homePageContent.dart';
import 'package:housing_society_management/loginSystem/userProfile.dart';
import 'package:housing_society_management/maintenance/maintenance.dart';
import 'package:housing_society_management/members/members.dart';
import 'package:housing_society_management/notice/notice.dart';
import 'package:housing_society_management/notification/notifications.dart';
import 'package:housing_society_management/purchaseOrder/purchaseOrder.dart';
import 'package:housing_society_management/setting/setting.dart';
import 'package:housing_society_management/vehicleParking/vehicleParking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
	static final String routeName = 'home';

	@override
	State<StatefulWidget> createState() {
		return new _HomePageState();
	}
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper databaseHelper=new DatabaseHelper();

	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

   var name = "";
  
  String email = "";

	SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids, _homeResponse;
  List userData;

	@override
	void initState() {
		super.initState();
		_fetchSessionAndNavigate();
     //userData();
	}

  // userData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   final baseUrl = 'Base_URL';
  //   final urlValue = prefs.get(baseUrl ) ?? 0;

  //   final String url = "$urlValue/mobile_api/UserAPI/";

  //   //String url = "${Urls.BASE_API_URL}/mobile_api/UserAPI/";

  //   try {
  //     final response =
  //         await http.post(url, headers: {'Authorization': 'token $value'});
  //     print('getEmployees new Response: ${response.body}');

  //     if (200 == response.statusCode) {
  //       Map<String, dynamic> map = json.decode(response.body);
  //       print("map ${map['is_success']}");
  //       List l1 = map['data'];
  //       //print("l1: $l1");
  //       var k = l1[0];
  //       // print("k : $k");
  //       var k2 = k['first_name'];
  //       name = k2;
  //       email = k['last_name'];
  //       print("name: $name");
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return e;
  //   }
  // }

  

	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
    //databaseHelper.save(authToken);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    //databaseHelper.saveDetails(society_id, flat_ids);
    
		print(authToken);

		_fetchHome(authToken);

		setState(() {
			_authToken = authToken;
			_society_id = society_id;
			_flat_ids = flat_ids;
		});

		if(_authToken == null) {
			_logout();
		}
	}

	_fetchHome(String authToken) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/UserAPI', _society_id, _flat_ids);
    print("fetch response : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} else if(responseJson['errors'] != null) {
			_logout();
		}
    
    List data=responseJson["data"];
   
      setState(() {
        userData=data;
      });
      print("userData : $userData");
      name=userData[0]["first_name"];
      print("name $name");

	}

	_logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}

	 @override
	// Widget build(BuildContext context) {
	// 	return new Scaffold(
	// 		key: _scaffoldKey,
	// 		// appBar: new AppBar(
	// 		// 	title: new Text('Home'),
	// 		// ),
	// 		body: Home()
  //     // new Container(
	// 		// 	margin: const EdgeInsets.symmetric(horizontal: 16.0),
	// 		// 	child: new Column(
	// 		// 		crossAxisAlignment: CrossAxisAlignment.stretch,
	// 		// 		children: <Widget>[
	// 		// 			new Container(
	// 		// 				padding: const EdgeInsets.all(8.0),
	// 		// 				child: new Text(
	// 		// 					"USER_ID: $_society_id \nUSER_NAME: $_flat_ids \nHOME_RESPONSE: $_homeResponse",
	// 		// 					style: new TextStyle(
	// 		// 						fontSize: 24.0,
	// 		// 						color: Colors.grey.shade700
	// 		// 					),
	// 		// 				),
	// 		// 			),
	// 		// 			new MaterialButton(
	// 		// 				color: Theme.of(context).primaryColor,
	// 		// 				child: new Text(
	// 		// 					'Logout',
	// 		// 					style: new TextStyle(
	// 		// 						color: Colors.white
	// 		// 					),
	// 		// 				),
	// 		// 				onPressed: _logout
	// 		// 			),
	// 		// 		]
	// 		// 	),
	// 		// )
	// 	);
	// }

  Widget build(BuildContext context) {
    
      return Scaffold(    
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home "), //  + name
        backgroundColor: Color(0xff39687e),
        actions: <Widget>[
         
          IconButton(
            icon: const Icon(Icons.notifications),
            //tooltip: 'Show Snackbar',
            onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(
                   builder: (BuildContext contex) => NewNotifications(),));  // Notifications()
             // showOverlay(context);
            },
          ),
        ],
      ),

      drawer: Drawer(   // #222d32

        child:Container(color: Colors.black,//Color(0xff39687e),
        
        child: ListView(
          // padding: EdgeInsets.all(30.0),
          children: <Widget>[
            // for user account informations on top of our drawer
            Container(color:Color(0xff39687e),height: AppBar().preferredSize.height,width: 20.0,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0,top: 15.0),
              child: Text("HSM", style: TextStyle(color: Colors.white,fontSize: 20.0),),
            )
            
            ), // height:52.0
            Padding(padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 18.0),
            child:Row(
              children: <Widget>[
                GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext contex) => UserProfile(name)));
                },
                child: CircleAvatar(
                  // backgroundImage: NetworkImage(
                  //     "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?"),
               maxRadius: 30.0, ),
                
              ),
              Flexible(
              child:Text("  ${name}\n",style: TextStyle(color: Colors.white,fontSize: 17.0),),//"  ${name}\n  hii"
              ),
              // Column(
              //   children: <Widget>[
              //     Text("  ${name}\n  hiii",style: TextStyle(color: Colors.white,fontSize: 17.0),),
              //     Text(" data",style: TextStyle(color: Colors.white,fontSize: 17.0,),textAlign: TextAlign.start,)
              //   ],
              // ),

              ],
            ),
        ),

          //   UserAccountsDrawerHeader(
          //     accountName: Text(name),
          //     accountEmail: Text(email),
          //     currentAccountPicture: GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).pop();
          //         Navigator.of(context).push(MaterialPageRoute(
          //             builder: (BuildContext contex) => UserProfile(name)));
          //       },
          //       child: CircleAvatar(
          //         backgroundImage: NetworkImage(
          //             "https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?"),
          //       ),
          //     ),
          //     decoration: BoxDecoration(
          //         color: Colors.black,//Color(0xff39687e),
          //         image: DecorationImage(
          //             fit: BoxFit.fill,
          //             image:
          //                 NetworkImage("https://picsum.photos/250?image=9rr"))
          // ), //https://i.picsum.photos/id/9/250/250.jpg
          //   ),

            ListTile(
              title: Text(
                "Home",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),//fontStyle: FontStyle.italic,
              ),
              leading: Icon(Icons.home,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext contex) => Home()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Maintenance",
                //style: TextStyle(fontSize: 20.0),
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.note,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) =>
                        Maintenance())); // Maintenance(user_id)));
              },
            ),
            Divider(),
            
            ListTile(
              title: Text(
                "Notice",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.info,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Notice()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Members",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.group,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Members()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Accounting",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.account_box,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Accounting()));
              },
            ),
            Divider(),
            
            ListTile(
              title: Text(
                "Purchase order",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.description,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => PurchaseOrder()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Flats",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.room,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Flats()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Vehicle Parking",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.local_parking,color: Colors.white,),
              //trailing: Icon(Icons.c),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => VehicleParking()));
              },
            ),
            Divider(),

            ListTile(
              title: Text(
                "Vendors",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.accessibility_new,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext contex) => Form_create()));
                print("button tab");
              },
            ),
            Divider(),
            ListTile(
              title: Text(
                "Helpdesk",
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              leading: Icon(Icons.help,color: Colors.white,),
              //trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => HelpDesk()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.lock_open,color: Colors.white,),
              title: Text(
                'LOGOUT',
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                _logout(); 
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings,color: Colors.white,),
              title: Text(
                'SETTING',
                style: TextStyle(fontSize: 20.0,color: Colors.white,),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Setting()));

                // Navigator.of(_scaffoldKey.currentContext)
					      //     .pushReplacementNamed('Setting.routeName');
               
              },
            ),
          ],
        ),
      ),
      ),
      body:
          HomePageContent(), //Posts(posts),  // HomePageContent(),  // Posts(),
   // ),    
    );
  }
  

}