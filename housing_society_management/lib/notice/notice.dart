import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/notice/noticeView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
//import 'package:hsm/globals.dart' as globals;
import 'package:housing_society_management/globals.dart' as globals;



class Notice extends StatefulWidget{
  Notice(): super();
  @override 
  State<StatefulWidget> createState() {
    
    return _NoticeState();
  }
}

class _NoticeState extends State<Notice>{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	//var _authToken, _society_id, _flat_ids;
  List noticeData;
  //List maintenanceDataFilter;

  bool _loading=false;
  //List<Map<String, dynamic>> notice =[];

  NetworkUtils _network=new NetworkUtils();
 
@override
  void initState() {
    super.initState();
    setState(() {
      _loading=false;
    });
    _fetchSessionAndNavigate();
    //getData();    
    //print("global url in notice ${globals.ur}");
    // _network.getIp();
    // print("getIp in notice: ${_network.getIp()}");

  }

    _fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
    //databaseHelper.save(authToken);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    //databaseHelper.saveDetails(society_id, flat_ids);

		print(authToken);

		_fetchHome(authToken,society_id,flat_ids);


	}

	_fetchHome(String authToken, var society_id, var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/NoticeAPI', society_id, flat_ids);
    print("fetch response : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    // else if(responseJson['errors'] != null) {
		// 	_logout();
		// }
    
    List data=responseJson["data"];
   
      setState(() {
        noticeData=data;
        
        _loading=true;
      });
       
	}
  
  //   getData() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;
      
  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //      int society_value = prefs.get("society_id") ?? 0;

  //     print("society value ${society_value}");
      
  //      String url ="$urlValue/mobile_api/NoticeAPI/";
  //     print("globalsApi $urlValue");

  //   try {
      
  //     final response = await http.post(url , 
  //     headers: {
  //       'Authorization':'token $value',
  //       'AndroidVersion':'${globals.androidVersion}',
  //       'Society-id': '$society_value',
  //       }
  //     );   //  
  //     print('getNotice new Response: ${response.body}');
  //     print("blobal variables in notice: ${globals.androidVersion} and ${globals.deviceId}");
        
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //      List<dynamic> noticeLines = map['data'];
  //     List<Map<String, dynamic>> noticeList =[];
  //     noticeLines.forEach((line){
  //       Map<String, dynamic> map={
  //         "title":line["title"],
  //         "description":line["description"],
  //         "date":line["date"],
  //       };
  //       noticeList.add(map);
  //     });
  //     setState(() {
  //       notice = noticeList;
  //       _loading=true;
  //     });

  //     } else {
  //       return null; // List<NoticeList>();
  //     }
  //    } catch (e) {
  //      return  e; // List<NoticeList>(); // return an empty list on exception/error
  //    }
  // }

  @override 
  Widget build(BuildContext context) {
    return _loading?Scaffold(
      appBar: AppBar(
       title: Text("Notice"),backgroundColor: Color(0xff39687e),
      ),

      body:
      //  notice.length==0 ? Center(   
      //   child: CircularProgressIndicator(),
      // ):
      ListView.builder(
        //children: notice.map((listData){
        itemCount: noticeData.length,
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(onTap: (){
           
          Navigator.of(context).push(MaterialPageRoute(
         builder: (BuildContext context)=>NoticeView("${noticeData[index]['pk']}")
         ));
           
          },
          child:Card(
          // child:GestureDetector(
          //   onTap: ()=>print("hii"),
          child: Padding(
            padding: EdgeInsets.all(0.5),

            child: Padding(padding:EdgeInsets.only(left: 8.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${noticeData[index]['title'].toString()}",style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 18.0
                  ), 
                  ),
                Container(height: 8.0,),
                Text(noticeData[index]['notice_date']),//date
                //Html(data: noticeData[index]['description']),
              ],
            ),
          ),
          ),
          ),
        );
        }

        // return Card(
        //   child: Padding(
        //     padding: EdgeInsets.all(0.5),

        //     child: Padding(padding:EdgeInsets.only(left: 8.0),
        //     child:Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Text(listData['title'].toString(),style: TextStyle(
        //           color: Colors.indigoAccent,
        //           fontSize: 18.0
        //           ), 
        //           ),
        //         Container(height: 8.0,),
        //         Text(listData['date']),
        //         Html(data: listData['description']),
        //       ],
        //     ),
        //   ),
        //   ),
        // );
        
       // }).toList(),

      ),
    
     ):Center(child: CircularProgressIndicator());
    
  }
}

