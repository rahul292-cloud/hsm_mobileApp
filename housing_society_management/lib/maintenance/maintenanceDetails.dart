import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';

class MaintenanceDetails extends StatefulWidget{
  var pk,state;
  MaintenanceDetails(this.pk,this.state);
  @override 
  State<StatefulWidget> createState() {
    return MaintenanceDetailsState(pk,state);
  }
}

class MaintenanceDetailsState extends State<MaintenanceDetails>{
  var pk,state,society_name,society_address,maintenance_name,bill_date,paid_date,sub_total,
  total,flat_number,flat_owner;
  
  MaintenanceDetailsState(this.pk,this.state);
  //List<Map<String, dynamic>> maintenance =[];
  //List data;
  
  bool _isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List maintenanceView;
  
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchSessionAndNavigate();
    maintenanceView=[];
    
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

	}

	_fetchHome(String authToken) async {
		var responseJson = await NetworkUtils.fetchViews(authToken, 'mobile_api/MaintenanceReportAPI', pk , "Maintenance-id");
    print("fetch response : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
        
     society_name = responseJson['data']['society_name'];
     print("society name: $society_name");
     society_address = responseJson['data']['society_address'];
      maintenance_name = responseJson['data']['maintenance_name'];
      bill_date = responseJson['data']['bill_date'];
      paid_date = responseJson['data']['paid_date'];
      sub_total = responseJson['data']['sub_total'];
      total = responseJson['data']['total'];
      flat_number = responseJson['data']['flat_number'];
      flat_owner = responseJson['data']['flat_owner'];

    List maintenance_lines=responseJson["data"]["maintenance_lines"];
    print("maintenance Data report: $maintenance_lines");
   
      setState(() {
        maintenanceView=maintenance_lines;
       _isLoading=false;
      });
      
	}

  
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Maintenance Details"),backgroundColor: Color(0xff39687e),
      ),
      body: _isLoading?Center(child:CircularProgressIndicator()):ListView.builder(
        itemBuilder: (context, index){
          return Container(
            color: Color(0xFFEFF4F7),//Colors.grey[300],
          child:Padding(
            padding: EdgeInsets.all(0.0),
            
              child:Column(
                  children: <Widget>[
                    Container(    // Card
                    height: 45.0,
                    color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text("Flat no. ", style: TextStyle(fontSize: 22.0),),
                          //Spacer(),
                          Text("$flat_number", style: TextStyle(fontSize: 20.0),),
                                                  
                      ],
                    ),
                    ),
                    ),

                    Container(    // Card
                    height: 45.0,
                    color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text("Status: ", style: TextStyle(fontSize: 22.0),),
                          //Spacer(),
                          Text("$state", style: TextStyle(fontSize: 20.0),),
                                                  
                      ],
                    ),
                    ),
                    ),

                   
                      Container(     // Card
                      height: 45.0,
                      //color: Colors.white,
                      child:Padding(
                        padding:EdgeInsets.all(10.0),
                      
                      child:Row(
                      children: <Widget>[
                        Text("Maintenance",style: TextStyle(fontSize: 22.0),)
                      ],
                    ),
                      ),
                      ),

                      //Container(height: 15.0,),
                      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                        child: Row(
                           children: <Widget>[
                             Expanded(child:Text("$maintenance_name", style: TextStyle(fontSize: 17.0),)),
                             
                           ],
                       ),
                      ),
                ),

                Container(     // Card
                      height: 45.0,
                      //color: Colors.white,
                      child:Padding(
                        padding:EdgeInsets.all(10.0),
                      
                      child:Row(
                      children: <Widget>[
                        Text("From: ",style: TextStyle(fontSize: 22.0),)
                      ],
                    ),
                      ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 40.0,
                        child:Padding(
                          //padding: EdgeInsets.all(10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                        child:   Row(
                           children: <Widget>[
                             Expanded(child:Text("$society_name", style: TextStyle(fontSize: 17.0),)),
                            //  Spacer(),
                            //  Text("total amount", style: TextStyle(fontSize: 17.0),),
                                                          
                           ],
                       ),
                      ),
                      ),
                     
                      SingleChildScrollView(
                        child:Container(color: Colors.white,
                        child:Padding(padding: EdgeInsets.fromLTRB(14.0, 0.0, 10.0, 14.0),
                               child:Text("$society_address", style: TextStyle(fontSize: 17.0),)
                               ),
                      ),
                              ),

                      Container(height: 2.0,),

                      Container(     // Card
                      height: 45.0,
                      //color: Colors.white,
                      child:Padding(
                        padding:EdgeInsets.all(10.0),
                      
                      child:Row(
                      children: <Widget>[
                        Text("To: ",style: TextStyle(fontSize: 22.0),)
                      ],
                    ),
                      ),
                      ),
                      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                        child:   Row(
                           children: <Widget>[
                             Expanded(child:Text("$flat_owner", style: TextStyle(fontSize: 17.0),)),
                            //  Spacer(),
                            //  Text("total amount", style: TextStyle(fontSize: 17.0),),
                                                          
                           ],
                       ),
                      ),
                      ),
 
                      Container(     // Card
                      height: 45.0,
                      //color: Colors.white,
                      child:Padding(
                        padding:EdgeInsets.all(10.0),
                      
                      child:Row(
                      children: <Widget>[
                        Text("Dates",style: TextStyle(fontSize: 22.0),)
                      ],
                    ),
                      ),
                      ),

                      //Container(height: 15.0,),
                      
                        Container(
                          color: Colors.white,
                          height: 45.0,
                          child:Padding(
                            padding: EdgeInsets.all(10.0),
                          child: Row(
                           children: <Widget>[
                             Text("Bill Date", style: TextStyle(fontSize: 17.0),),
                             Spacer(),
                             Text("$bill_date", style: TextStyle(fontSize: 17.0),),
                             //Expanded(child:Text(snapshot.data['title'])),
                             
                           ],
                       ),
                        ),
                        ),
                      // Divider(),
                      Container(height: 2.0,),
                      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                       child:Row(
                           children: <Widget>[
                             Text("Paid Date", style: TextStyle(fontSize: 17.0),),
                             Spacer(),
                             Text("$paid_date", style: TextStyle(fontSize: 17.0),),
                             //Expanded(child:Text(snapshot.data['title'])),
                             
                           ],
                       ),
                      ),
                      ),

                 
                    Container(    // Card
                    height: 45.0,
                    //color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text("Service ", style: TextStyle(fontSize: 22.0),),
                          Spacer(),
                          Text("Cost ", style: TextStyle(fontSize: 20.0),),
                          
                      ],
                    ),
                    ),
                    ),
                      

              maintenanceView.length==0 ? Center(
         child: CircularProgressIndicator(),
       ):

              ListView.builder(
        //children: maintenance.map((listData){
              itemCount: maintenanceView.length,
              itemBuilder: (BuildContext context,int index){
            return Container(
                  color: Colors.grey[300],
                  
                  child:
                  Padding(
                    padding: EdgeInsets.all(0.0),
                child:Column(
                  children: <Widget>[
                    
                    Container(    // Card
                    height: 45.0,
                    color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text(maintenanceView[index]['service_name'], style: TextStyle(fontSize: 17.0),),
                          Spacer(),
                          Text("₹ ${maintenanceView[index]['cost'].toString()}", style: TextStyle(fontSize: 17.0),),
                          //Text(society_name, style: TextStyle(fontSize: 20.0),),
                        
                      ],
                    ),
                    ),
                    ),
                                                     
                  ],
                ),
                  ),
                );
        
        
       // }).toList(),
              },
        physics: ClampingScrollPhysics(),
         shrinkWrap: true,
      ),
      Container(height: 4.0,),
      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                        child:   Row(
                           children: <Widget>[
                             Text("Sub Total", style: TextStyle(fontSize: 17.0),),
                             Spacer(),
                             Text("₹ ${sub_total.toString()}", style: TextStyle(fontSize: 17.0),),
                                                          
                           ],
                       ),
                      ),
                      ),
                      Container(height: 2.0,),
                      Container(
                        height: 45.0,
                        color: Colors.white,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                       child:Row(
                           children: <Widget>[
                             Text("Total", style: TextStyle(fontSize: 17.0),),
                             Spacer(),
                             Text("₹ ${total.toString()}", style: TextStyle(fontSize: 17.0),),
                                                         
                           ],
                       ),
                      ),
                ),

      Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          // submit();
          //_onPressed();
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xff39687e),
            border: Border.all(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text("Download Invoice", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
              
              ],
            ),
          ),
          );
        },
        itemCount: 1,
      ),

    );
  }
}