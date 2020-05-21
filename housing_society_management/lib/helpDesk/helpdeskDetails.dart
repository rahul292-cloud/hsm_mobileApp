import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';

class HelpdeskView extends StatefulWidget{
  var pk;
  HelpdeskView(this.pk);
  @override
  State<StatefulWidget> createState() {
    
    return HelpdeskViewState(pk);
  }
}

class HelpdeskViewState extends State<HelpdeskView>{
  var pk;
  HelpdeskViewState(this.pk);

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	//var _authToken, _society_id, _flat_ids;
  List helpdeskData;
  //List maintenanceDataFilter;
   bool _loading=false;

   var compliant_ticket_no,compliant_current_status,compliant_subject,compliant_comment,compliant_reply,
   compliant_date,user_complaint_type,compliant_upload_file;

  @override
  void initState() {
    setState(() {
      _loading=false;
    });
    helpdeskData =[];
     _fetchSessionAndNavigate();
    super.initState();
  }

  _fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    
		print(authToken);

		_fetchHome(authToken);

		setState(() {
			// _authToken = authToken;
			// _society_id = society_id;
			// _flat_ids = flat_ids;
		});

	}

	_fetchHome(String authToken) async {
		var responseJson = await NetworkUtils.fetchViews(authToken, 'mobile_api/HelpDeskReportAPI', pk , "Complaint-id");
    print("fetch response complaint : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    
    var data=responseJson["data"];
    compliant_ticket_no=data["compliant_ticket_no"];
    compliant_current_status=data["compliant_current_status"];
    compliant_subject=data["compliant_subject"];
    compliant_comment=data["compliant_comment"];
    compliant_reply=data["compliant_reply"];
    compliant_date=data["compliant_date"];
    user_complaint_type=data["user_complaint_type"];
    compliant_upload_file=data["compliant_upload_file"];
    print("compliant_ticket_no : $compliant_ticket_no");
      setState(() {
        //helpdeskData=data;
        
        _loading=true;
      });
      // print("maintenanceData : $maintenanceData");
     
      // print("name ${maintenanceData[0]["name"]}");

	}

  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: 
      Text("Helpdesk Details"),
      
      ),
       body:_loading?ListView.builder(
          itemCount: 1,//helpdeskData.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
          //color: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              
              children: <Widget>[
                SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: 50.0,//color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Complaint Ticket No."),
                      SizedBox(height: 8.0,),
                      Expanded(child:
                      SingleChildScrollView(
                        child: Text("$compliant_ticket_no",style: TextStyle(fontSize: 20.0),),
                      )
                      // Text("This is Help desk name",style: TextStyle(fontSize: 20.0),),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
                Container(height: 2.0,color: Colors.grey,),
                SizedBox(height: 15.0,),

                Container(
                  width: double.infinity,
                  height: 50.0,//color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name:"),
                      SizedBox(height: 8.0,),
                      Expanded(child:
                      SingleChildScrollView(
                        child: Text("$compliant_subject",style: TextStyle(fontSize: 20.0),),
                      )
                      // Text("This is Help desk name",style: TextStyle(fontSize: 20.0),),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Date:"),
                      SizedBox(height: 8.0,),
                      Text("$compliant_date",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Complain Type:"),
                      SizedBox(height: 8.0,),
                      Text("$user_complaint_type",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Status:"),
                      SizedBox(height: 8.0,),
                      Text("$compliant_current_status",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 80.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Reply:"),
                      SizedBox(height: 8.0,),
                      Expanded(child:
                      SingleChildScrollView(child:
                      Text("$compliant_reply",style: TextStyle(fontSize: 20.0),),
                      ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 120.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Comment:"),
                      SizedBox(height: 8.0,),
                      Expanded(
                      child: 
                      SingleChildScrollView(child:

                      Text("$compliant_comment",style: TextStyle(fontSize: 20.0),),
                     
                      ),   
                       
                      ),
                     
                    ],
                  )
                ),
              SizedBox(height: 15.0,),
              

              ],
            ),
          ),
        );
          }
        ):Center(child: CircularProgressIndicator(),)
    );
  }
}