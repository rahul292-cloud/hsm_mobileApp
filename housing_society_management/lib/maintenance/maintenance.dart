import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:housing_society_management/maintenance/maintenanceDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/globals.dart' as globals;
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'mentenancePopupMenuItems.dart';


class Maintenance extends StatefulWidget{
  @override 
  State<StatefulWidget> createState() {
    
    return MaintenanceState();
  }
}

class MaintenanceState extends State<Maintenance>{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List maintenanceData;
  List maintenanceDataFilter;


  bool typing = false;
  bool _loading=false;
  bool _dateFilter=false;
  bool _dateValue=false;
  //var k;
  var bill_Paid;

  final _debouncer = Debouncer(milliseconds: 500);

  // List<Map<String, dynamic>> maintenance; 
  // List<Map<String, dynamic>> _maintenanceFilte;

  // trying
  final TextEditingController _startDateController = new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  List<DateTime> days = [];

  DateTime _startDate=DateTime.now();
  DateTime _endDate=DateTime.now().add(Duration(days: 7));

  Future displayDayRangePicker(BuildContext context) async{
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
          context: context,
          initialFirstDate: _startDate,
          initialLastDate: _endDate,
          firstDate: new DateTime(DateTime.now().year -50),
          lastDate: new DateTime(DateTime.now().year +50),
      
      );
      
      if (picked != null && picked.length == 2) {
        setState(() {
          _startDate=picked[0];
          _endDate=picked[1];
          _dateValue=true;
        });
          print("picked: $picked");

      }
      else if(picked==null  ||picked.length==1){
        setState(() {
         _dateFilter=false;
         print("setstate");
        });
        return null;
       // print("picked nill :$picked");
      }          
  }

  bool sort;
  @override 
  void initState(){
    super.initState();
    setState(() {
      _loading=false;
      _dateFilter=false;
      _dateValue=false;
    });
    
   _fetchSessionAndNavigate();
    maintenanceData =[];
    maintenanceDataFilter =[];
    sort = false;
    //getData();
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

		setState(() {
			_authToken = authToken;
			_society_id = society_id;
			_flat_ids = flat_ids;
		});

		// if(_authToken == null) {
		// 	_logout();
		// }
	}

	_fetchHome(String authToken, var society_id, var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/MaintenanceAPI', society_id, flat_ids);
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
        maintenanceData=data;
        maintenanceDataFilter=data;
        _loading=true;
      });
      // print("maintenanceData : $maintenanceData");
     
      // print("name ${maintenanceData[0]["name"]}");

	}

  
  setBillPaid(var billPaid){
    setState(() {
      bill_Paid=billPaid;
    });
  }

  stateFilter(String choice){
    print("check value $choice");
        //var p="07-01-2020";
        //var r="UNPAID";
      // var r="PAID";
     //_debouncer.run((){
            setState(() {
              print("last check $choice");
              maintenanceDataFilter = maintenanceData
              //.where((u)=> (u["state"].toLowerCase().contains(choice))||(u["state"].toUpperCase().contains(choice))).toList();
              .where((u)=> (u['state']==choice) ).toList();
            });
        //  });
  }


searchField() async{
  print("tab");
  //return RaisedButton(
    //child: Text("Select dates"),
    //onPressed: ()async{
      
      await displayDayRangePicker(context);
      print("Start date ${DateFormat('dd/MM/yyyy').format(_startDate).toString()}");
      print("End date ${DateFormat('dd/MM/yyyy').format(_endDate).toString()}");
      print("date type:${_startDate.runtimeType}");
    //  for (int i = _startDate.day; i < _endDate.day+1; i++) {
    //   print("date $i");
  //}
  
  final daysToGenerate = _endDate.difference(_startDate).inDays;
  days = List.generate(daysToGenerate+1, (i) => DateTime(_startDate.year, _startDate.month, _startDate.day + (i)));
  print("iterate days:${days}");
  //print("End date ${DateFormat('MM/dd/yyyy').format(days).toString()}");
  List da=days.toList();
  print("da : $da");
  //dateRangeFilter(da);
  var startDate=DateFormat('dd/MM/yyyy').format(_startDate).toString();  //MM/dd/yyyy
    var endDate=DateFormat('dd/MM/yyyy').format(_endDate).toString();
  print("start date and end date: $startDate , $endDate");
  dateRangeFilter(startDate,endDate);
}

dateRangeFilter(String startDate, String endDate){//List choice
  //   print("check value list choice $choice");
  //   List addChoice;
  //   choice.forEach((ch){
  //     print("End date ${DateFormat('MM/dd/yyyy').format(ch).toString()}");
  //     var dat=DateFormat('MM/dd/yyyy').format(ch).toString();
      
  //     List addSelectedChoice=maintenanceData
  //     .where((u)=> (u['bill_date_format'].contains(dat)) ).toList();
  //     if(addSelectedChoice.contains(null)){
  //       //addChoice.add(addSelectedChoice);
  //       addSelectedChoice.remove(addSelectedChoice);
  //     }
  //     else{
  //       addChoice.add(addSelectedChoice);
  //     }
  // });
    
        
            setState(() {
              //print("last check $choice");
             //maintenanceDataFilter=addChoice;

              // maintenanceDataFilter = maintenanceData
              // .where((u)=> (u['bill_date_format'].startsWith(_startDate))).toList();//contains(choice)) ).toList();

               maintenanceDataFilter = maintenanceData.where((a) {
                    var adate = a['bill_date_format']=startDate; 
                    var bdate = a['bill_date_format']=endDate; 
                  //  return adate.compareTo(bdate); 
                });
             
            });
  }

  // trying filter up 

  @override 
  Widget build(BuildContext context) {
    
   
  return Scaffold(backgroundColor: Color(0xFFEFF4F7),//Colors.white70,
  appBar: AppBar(
    title: Text("Maintenance"),
    backgroundColor: Color(0xff39687e),
  ),
      body: Column(
        children: <Widget>[
          _dateValue?Container(
            width: double.infinity,
            height: AppBar().preferredSize.height,
            color: Colors.white,
            //child:Padding(padding: EdgeInsets.all(12.0),
          //   child:Center(
          //   child: Text("Selected Dates From ${DateFormat('MM/dd/yyyy').format(_startDate).toString()} To ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}"),
          // )
          child:Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child:GestureDetector(child: Row(
              children: <Widget>[
                
                //Icon(Icons.date_range,),//color: Color(0xff39687e),
                Flexible(child:Text("${bill_Paid} Dates ${DateFormat('MM/dd/yyyy').format(_startDate).toString()} To ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}  "),),
                Text("    Remove Filters"),
                Icon(Icons.arrow_drop_down,),
              ],
            ),
            onTap: (){
              setState(() {
                _dateFilter=false;
                _dateValue=false;
               maintenanceDataFilter = maintenanceData;
              });
              print(" tab");
              },
            ),
            ),
          ):
          _dateFilter?Container(
            width: double.infinity,
            height: AppBar().preferredSize.height,
            color: Colors.white,
            child:Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child:GestureDetector(child: Row(
              children: <Widget>[
                
                Icon(Icons.date_range,color: Color(0xff39687e),),
                Text("Select ${bill_Paid} Dates From Start To End For Filter")
              ],
            ),
            onTap: (){
              searchField();
              // setState(() {
              //  // _dateFilter=false;
              //    _dateValue=true;
              // });
              
              print("bill range tab");
              },
            ),
            ),
          )
          :Container(
            width: double.infinity,
            height: AppBar().preferredSize.height,
            color: Colors.white,
            child:Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
              children: <Widget>[
                GestureDetector(
                  child:
                Row(
                  children: <Widget>[
                    Text("Bill Date"),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
                onTap: (){
                  print("button tab");
                  setBillPaid("Bill");
                  setState(() {
               _dateFilter=true;
               
              });
                  //searchField();
                },
                ),
                GestureDetector(
                  
                child:Row(
                  children: <Widget>[
                    Text("Paid Date"),
                    Icon(Icons.arrow_drop_down),
                    
                  ],
                ),
                onTap: (){
                  setBillPaid("Paid");
                  print("button tab");
                  setState(() {
                _dateFilter=true;

              });                
                },
                ),
              Row(
                  children: <Widget>[
                    Text("Filters"),
                    //Icon(Icons.arrow_drop_down,)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: choiceAction,
                      
                      itemBuilder: (BuildContext context){
                        return PupupMenuItems.choices.map((String choice){
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
              
              ],),
            ),
          ),
          Expanded(
            
                 child: 
          ListView.builder(
                  itemCount: maintenanceDataFilter.length,
                  itemBuilder: (BuildContext context,int index){
                   
                    return Stack(// //Card
                  children: <Widget>[
                   //child: 
                   GestureDetector(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>MaintenanceDetails("${maintenanceDataFilter[index]['pk']}","${maintenanceDataFilter[index]['state']}")
                     ));
                    },
                    child:Container(
                      margin: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 0.0),
                      height: 80.0,//115.0,//170.0
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),//20.0
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.5),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,//spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  child: Text("${maintenanceDataFilter[index]['name']}",
                                   // activity.name,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              

                                Column(
                                  
                                  children: <Widget>[
                                    
                                    
                                    SingleChildScrollView(
                                      child:SingleChildScrollView(
                                      child:Text("₹${maintenanceDataFilter[index]['amount'].toString()}",
                                      
                                      //'\$${activity.price}',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(height: 1.0,),
                            Text("Bill Date: ${maintenanceDataFilter[index]['bill_date_format'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                            ),
                            Container(height: 0.5,),
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  // width: 120.0,
                                  child: Text("Paid Date: ${maintenanceDataFilter[index]['paid_date_format'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                            ),
                                ),
                              
                              Row(
                                children: <Widget>[
                                  maintenanceDataFilter[index]["state"]=="UNPAID"?CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.info, color: Colors.white,),
                              )
                              //     :CircleAvatar(
                              // radius: 14.0,
                              // backgroundColor: Colors.green,
                              // child: Icon(Icons.check, color: Colors.white,),
                              // ),
                              :maintenanceDataFilter[index]["state"]=="PAID"?CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.check, color: Colors.white,),
                              ):CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.yellow,
                              child: Icon(Icons.check, color: Colors.white,),
                              ),
                                  
                                  Text(" ${maintenanceDataFilter[index]["state"]} "),
                                  maintenanceDataFilter[index]["state"]=="UNPAID"?Icon(Icons.warning,color: Colors.red,):
                                  maintenanceDataFilter[index]["state"]=="PAID"?Icon(Icons.check_circle,color: Colors.green,):
                                  Text("Confirm"),
                                ],
                              )
                              ],
                            ),
                          
                          ],
                        ),
                      ),
                    ),

                ),
                    
                  ],
                );

                  },

              ),

          ),
        ],
      ),
    );
  }
  void choiceAction(String choice){
    if(choice==PupupMenuItems.paid){
       print("Paid check : $choice");
      // var val="PAID";
      stateFilter(choice);
      //stateFilter("PAID");
    }else if(choice==PupupMenuItems.unpaid){
       print("unpaid: $choice");
      // var val1="UNPAID";
      stateFilter(choice);
    }
    else if(choice==PupupMenuItems.removeFilter){
      print("remove filter : $choice");
      setState(() {
        setState(() {
              maintenanceDataFilter = maintenanceData;
              });
      });
    }
}
}
