import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:housing_society_management/controller/databasehelper.dart';
import 'package:housing_society_management/helpDesk/helpDesk.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';

class HelpDeskComplain extends StatefulWidget {
  HelpDeskComplain({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HelpDeskComplainState();
  }
}

class _HelpDeskComplainState extends State<HelpDeskComplain> {
  String _mySelection;

  //final String url = "http://192.168.0.114:8000/mobile_api/ComplaintTypeAPI/";//"http://webmyls.com/php/getdata.php";

  List data;// = List();
  String _authTokenForComplain;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  //List helpdeskData;

  // Future<String> getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key) ?? 0;

  //   final baseUrl = 'Base_URL';
  //   final urlValue = prefs.get(baseUrl) ?? 0;

  //   String url = "$urlValue/mobile_api/ComplaintTypeAPI/";

  //   var res = await http
  //       .post(Uri.encodeFull(url), headers: {'Authorization': 'token $value'});
  //   var resBody = json.decode(res.body);

  //   setState(() {
  //     data = resBody['data'];
  //   });
  //   print("complaintype response");
  //   print(resBody['data']);

  //   return "Sucess";
  // }

    _fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		_authTokenForComplain = AuthUtils.getToken(_sharedPreferences);
    //databaseHelper.save(authToken);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    //databaseHelper.saveDetails(society_id, flat_ids);

		print(_authTokenForComplain);

		_fetchHome(_authTokenForComplain,society_id,flat_ids);

		setState(() {
			_authToken = _authTokenForComplain;
			_society_id = society_id;
			_flat_ids = flat_ids;
		});
    
	}

	_fetchHome(String authToken, var society_id, var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/ComplaintTypeAPI', society_id, flat_ids);
    print("fetch response complain : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 

     setState(() {
       data = responseJson["data"];
       print("data: $data");
     }); 
    
  }

  @override
  void initState() {
    super.initState();
    data =[];
     _fetchSessionAndNavigate();
     
    //this.getData();
  }

  final formKey = GlobalKey<FormState>();

  String _complainTypeName;
  String _complainTypeCurrent;
  int _complainTypeStringth;

  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final complainNameController = TextEditingController();
  //final complainTypeController = TextEditingController();
  final commentController = TextEditingController();

  DatabaseHelper databaseHelper = new DatabaseHelper();

  _onPressed() {
    setState(() async {
      if (complainNameController.text.isNotEmpty &&
          _mySelection.isNotEmpty &&
          commentController.text.isNotEmpty) {


      var response=  NetworkUtils.addData(_authTokenForComplain, "mobile_api/HelpDeskAPI", complainNameController.text,  _mySelection, commentController.text);
           if(response!=null){
             _showSuccessDialog();
           }
            else{
               _showDialog();
            }
         
        // databaseHelper
        //     .addData(complainNameController.text, _mySelection,
        //         commentController.text)
        //     .whenComplete(() async {
          
        //   if (databaseHelper.status) {
        //     _showDialog();
        //   } else {
        //     _showSuccessDialog();
            

        //   }
        // });
          }
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failed !"),
          content: new Text("Please Check Your Internet Connection !"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success !"),
          content: new Text("Your Complain Has Been Added Successfully !"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HelpDesk(), //  Dashboard(),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Complain"),backgroundColor: Color(0xff39687e),
        //automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _complainName(context),
              //_complainType(context),
              DropdownButton(
                items: data.map((item) {
                  return new DropdownMenuItem(
                    child: new Text("  ${item['name']}"), // item_name
                    value: item['id'].toString(), // .toString()
                  );
                }).toList(),
                hint: Text("  Select Complain Type"),
                style: TextStyle(fontSize: 20.0, color: Colors.black),
                onChanged: (newVal) {
                  setState(() {
                    _mySelection = newVal;
                  });
                },
                value: _mySelection,
              ),
              Container(
                height: 1.0,
                color: Colors.black38,
              ),
              _complainComment(context),
              _addComplain(context),
            ],
          ),
        ),
      ),
    );
  }

  String validateComplainName(String value) {
    if (value.isEmpty) {
      return 'Please enter a user ComplainName';
    }
    return null;
  }

  Widget _complainName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: complainNameController,
        validator: validateComplainName,
        onSaved: (String value) {
          var name = value;
        },
        key: Key('Complain Name'),
        decoration: InputDecoration(
            hintText: 'Complain Name', labelText: 'Complain Name'),
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }

  String validateComplainComment(String value) {
    if (value.isEmpty) {
      return 'Please enter a user Comment !';
    }
    return null;
  }

  Widget _complainComment(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: commentController,
        validator: validateComplainComment,
        onSaved: (String value) {
          var name = value;
        },
        key: Key('Comment'),
        decoration: InputDecoration(hintText: 'Comment', labelText: 'Comment'),
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }
  _clearValues(){
    complainNameController.text=' ';
    commentController.text=' ';
  }

  Widget _addComplain(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // submit();
          _onPressed();
          _clearValues();
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xff39687e),
            border: Border.all(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text("Add Complain", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
