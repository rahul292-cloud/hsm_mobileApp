import 'package:flutter/material.dart';
import 'package:housing_society_management/app/pages/home_page.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/controller/databasehelper.dart';
import 'package:housing_society_management/homePage/homePage.dart';
import 'package:housing_society_management/loginSystem/login.dart';
//import 'package:hsm/loginSystem/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/image.dart';
//import 'package:url_launcher/url_launcher.dart';

class UserProfile extends StatefulWidget{
  String username;
  UserProfile(this.username);

  @override 
  State<StatefulWidget> createState() {
    
    return UserProfileState(username);
  }
}

class UserProfileState extends State<UserProfile>{

  //DatabaseHelper databaseHelper=new DatabaseHelper();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var _authToken, _society_id, _flat_ids;// _homeResponse;

  String username;
  List userData;
  UserProfileState(this.username);

  // note not requred
  final String url = 'https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?';
  final Color green = Color(0xFF1E8161);

  final String _fullName = "Nick Frost";
  final String _status = "Software Developer";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  final String _followers = "173";
  final String _posts = "24";
  final String _scores = "450";

  
  @override
  void initState() {
     super.initState();
    _fetchSessionAndNavigate();
  }

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
      // name=userData[0]["first_name"];
      // print("name $name");

	}


  _logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}

  // Future _Logout() async {
  //   _save('0'); // ,'0'
  //   Navigator.of(context).push(new MaterialPageRoute(
  //     builder: (BuildContext context) => LoginPage(),
  //   ));
  // }

  // _save(String token) async {  // , String ipAddress
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = token;
  //   prefs.setString(key, value);

  //   // final baseUrl = 'Base_URL';
  //   // final urlValue = ipAddress;
  //   // prefs.setString(baseUrl, urlValue);
  // }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      
      decoration: BoxDecoration(color: Color(0xff41738c),//Colors.blue,//#41738c
        // image: DecorationImage(
        //   //image: AssetImage('assets/images/cover.jpeg'),
        //  image: NetworkImage(url),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child:InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return ShowProfile(url);
          }));
        },
      child: Container(
        width: 140.0,
        height: 140.0,//140.0,
        decoration: BoxDecoration(color: Color(0xff39687e),
          // image: DecorationImage(
          //   //image: AssetImage('$url'), // 'assets/images/nickfrost.jpg'
          //   image: NetworkImage(url),
          //   fit: BoxFit.cover,
          // ),
          
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,//10.0,
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      username,//_fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Posts", _posts),
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      // width: screenSize.width / 1.6,
      width: screenSize.width,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Get in Touch with ${_fullName.split(" ")[0]},",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
      ),
    );
  }

  Widget _buildButtons()  {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: SingleChildScrollView(
      child:Column( // Row
        children: <Widget>[
          //  Expanded(
          //    child: 
            InkWell(
              onTap: () => print("Settnig"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  //border: Border.all(),
                  color: Color(0xFF404A5C),
                  //color: Colors.white24,
                ),
                child: Center(
                  child: Text(
                    "Setting",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          //),
          //SizedBox(width: 10.0,),
          Container(width: 100.0,color: Colors.white,),
          Divider(),
          // Expanded(
          //   child: 
            InkWell(
              onTap: () {
                 //_logout();
                 //Navigator.of(context).pop();
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (BuildContext contex) => ImageStyle()));      
              }, 
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  //border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Change Profile",//Logout
                      
                      style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

             Divider(),
          // Expanded(
          //   child: 
            InkWell(
              onTap: () {                
                Navigator.of(context).pop();
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (BuildContext contex) => HomePage()));              
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  //border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Back To Home",
                      
                      style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            

          //),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(backgroundColor: Color(0xffe0e0e0),//Colors.indigo[300],//#e0e0e0
    key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 4.4),// 6.4
                  _buildProfileImage(),
                  _buildFullName(),
                  //_buildStatus(context),
                 // _buildStatContainer(),
                 // _buildBio(context),
                  _buildSeparator(screenSize),////
                  //SizedBox(height: 10.0),
                  //_buildGetInTouch(context),
                  SizedBox(height: 8.0),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}

class ShowProfile extends StatelessWidget{
  final String url;
  ShowProfile(this.url);
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(backgroundColor: Colors.black,
    
      appBar: AppBar(
        title: Text("Profile Photo"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              print("tab");
              Navigator.of(context).pop();
                 Navigator.of(context).push(MaterialPageRoute(
                     builder: (BuildContext contex) => ImageStyle()));
            },
          )
        ],
      ),
      body: Hero(
        tag: "Test",
        child: Center(
          child: Container(
            // color: Color(0xff39687e),
            // child: Image.network(url),
            // width: 140.0,
             height: 320.0,//140.0,
            decoration: BoxDecoration(color: Color(0xff41738c),//Colors.blue,//#41738c
            image: DecorationImage(
          //image: AssetImage('assets/images/cover.jpeg'),
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
          ),
        ),
      ),
    );
  }
}