import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeView extends StatefulWidget{
  var pk;
  NoticeView(this.pk);
  @override
  State<StatefulWidget> createState() {
    
    return NoticeViewState(pk);
  }
}

class NoticeViewState extends State<NoticeView>{
  var pk;
  NoticeViewState(this.pk);

   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	
  //List noticeViewData;
  
   bool _loading=false;

  var notice_title,notice_description,notice_date;


  @override
  void initState() {
    setState(() {
      _loading=false;
      //print("type:${_loading.runtimeType}");
    });
    //noticeViewData =[];
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
		var responseJson = await NetworkUtils.fetchViews(authToken, 'mobile_api/NoticeReportAPI', pk , "Notice-id");
    print("fetch response noticeView : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    
    var data=responseJson["data"];
     notice_title=data["notice_title"];
     notice_description=data["notice_description"];
     notice_date=data["notice_date"];
    
      setState(() {
        //noticeViewData=data;
        
        _loading=true;
      });
     
	}

  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: 
      Text("Notice Details"),
      
      ),
        body:  ListView.builder(
        
        itemCount: 1,//noticeData.length,
        itemBuilder: (BuildContext context,int index){
          return _loading?
          Card(
          child: Padding(
            padding: EdgeInsets.all(0.5),

            child: Padding(padding:EdgeInsets.only(left: 8.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$notice_title",style: TextStyle(
                  //color: Colors.indigoAccent,
                  fontSize: 18.0
                  ), 
                  ),
                Container(height: 8.0,),
                Text("$notice_date"),//date
                //Html(data: noticeData[index]['description']),
                Html(data: "$notice_description"),
              ],
            ),
          ),
          ),
          ):Center(child: CircularProgressIndicator());
        //);
        }

        
      ),      
    );
  }
}