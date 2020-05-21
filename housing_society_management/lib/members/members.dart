import 'dart:convert';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:housing_society_management/members/membersView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/constants.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;


class Members extends StatefulWidget{
  @override 
  State<StatefulWidget> createState() {
    return MembersState();
  }
}

class MembersState extends State<Members>{
  
  bool typing = false;
  bool _loading=false;
  bool _dateFilter=false;
  bool _dateValue=false;
  bool _searchFilter=false;
  //var k;
  var bill_Paid;


  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;

  List memberData;
  List memberDataFilter;

  final _debouncer = Debouncer(milliseconds: 500);

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


  
  @override 
  void initState(){
    super.initState();
    //getData();
    _fetchSessionAndNavigate();
    setState(() {
      _loading=false;
      _dateValue=false;
      _dateFilter=false;
      _searchFilter=false;
    });
    memberData =[];
    memberDataFilter =[];
    
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
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/MembersAPI', society_id, flat_ids);
    print("fetch response member : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    List data=responseJson["data"];
   
      setState(() {
        memberData=data;
        memberDataFilter=data;
        _loading=true;
      });
      

	}

  
setBillPaid(var billPaid){
    setState(() {
      bill_Paid=billPaid;
    });
  }

  stateFilter(String choice){
    print("check value $choice");
        
            setState(() {
              print("last check $choice");
             // maintenanceDataFilter = maintenanceData
              //.where((u)=> (u["state"].toLowerCase().contains(choice))||(u["state"].toUpperCase().contains(choice))).toList();
              //.where((u)=> (u['state']==choice) ).toList();
            });
        
  }


searchField() async{
  print("tab");
  
      await displayDayRangePicker(context);
      print("Start date ${DateFormat('dd/MM/yyyy').format(_startDate).toString()}");
      print("End date ${DateFormat('dd/MM/yyyy').format(_endDate).toString()}");
      print("date type:${_startDate.runtimeType}");
    
}

dateRangeFilter(String startDate, String endDate){//List choice
  
    
        
            setState(() {
              
              // maintenanceDataFilter = maintenanceData
              // .where((u)=> (u['bill_date_format'].startsWith(_startDate))).toList();//contains(choice)) ).toList();

             
            });
  }


  @override 
  Widget build(BuildContext context) {
    
   
  return Scaffold(backgroundColor: Color(0xFFEFF4F7),//Colors.white70,
  appBar: AppBar(
    title: Text("Members"),
    backgroundColor: Color(0xff39687e),
  ),
      body: Column(
        children: <Widget>[
          _dateValue?Container(
            width: double.infinity,
            height: AppBar().preferredSize.height,
            color: Colors.white,
            
          child:Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child:GestureDetector(child: Row(
              children: <Widget>[
               
                Flexible(child:Text("${bill_Paid} Dates ${DateFormat('MM/dd/yyyy').format(_startDate).toString()} To ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}  "),),
                Text("    Remove Filters"),
                Icon(Icons.arrow_drop_down,),
              ],
            ),
            onTap: (){
              setState(() {
                _dateFilter=false;
                _dateValue=false;
               memberDataFilter = memberData;
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
              setState(() {
                _dateFilter=false;
                 _dateValue=true;
              });
              
              print("bill range tab");
              },
            ),
            ),
          ):
          _searchFilter?Container(
            width: double.infinity,
            height: AppBar().preferredSize.height,
            color: Colors.white,
            child:Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),
           // child:GestureDetector(
              child: Row(
              children: <Widget>[
                
                Flexible(child:TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Filter By Name', //Or Vehicle Type.',
                ),
              onChanged: (string){
              _debouncer.run((){
              setState(() {
              memberDataFilter = memberData
              .where((u)=> (u['member_name'].contains(string)) || u['member_name'].contains(string)).toList();
            });
          });
        },
      ),

              ),

              GestureDetector(
                  
                child:Row(
                  children: <Widget>[
                    //Text(" Filters"),
                    Container(
                      color: Colors.grey[200],
                    //width: double.infinity,
                    //height: AppBar().preferredSize.height,
                    child:Padding(
                      padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 12.0,bottom: 12.0),
                      child: Icon(Icons.cancel),
                    )
                    
                    )
                    // Icon(Icons.cancel), //for remove filter 
                    
                  ],
                ),
                onTap: (){
                  //setBillPaid("Paid");
                //   print("button tab");
                  setState(() {
                  memberDataFilter=memberData;
                _searchFilter=false;

              });     
              print("bullton tab");
              //searchField1(context);


                },
                ),

              ],
            ),
            // onTap: (){
            //   searchField();
            //   setState(() {
            //     _dateFilter=false;
            //      _dateValue=true;
            //   });
              
            //   print("bill range tab");
            //   },
           // ),
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

                GestureDetector(
                  
                child:Row(
                  children: <Widget>[
                    Text("Filters"),
                    Icon(Icons.arrow_drop_down),
                    
                  ],
                ),
                onTap: (){
                  //setBillPaid("Paid");
                //   print("button tab");
                  setState(() {
                _searchFilter=true;

              });     
              print("bullton tab");
              //searchField1(context);


                },
                ),

              // Row(
              //     children: <Widget>[
              //       Text("Filters"),
              //       Icon(Icons.arrow_drop_down,)
                    // PopupMenuButton<String>(
                    //   icon: Icon(Icons.arrow_drop_down),
                    //   //onSelected: choiceAction,
                      
                    //   itemBuilder: (BuildContext context){
                    //     return PupupMenuItems.choices.map((String choice){
                    //       return PopupMenuItem<String>(
                    //         value: choice,
                    //         child: Text(choice),
                    //       );
                    //     }).toList();
                    //   },
                    // )
                //   ],
                // ),
              
              ],),
            ),
          ),
          Expanded(
            
                 child: 
          ListView.builder(
                  itemCount: memberDataFilter.length,
                  itemBuilder: (BuildContext context,int index){
                   
                    return Stack(// //Card
                  children: <Widget>[
                   //child: 
                   GestureDetector(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>MembersView("${memberDataFilter[index]['pk']}"),
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
                                  child: Text("${memberDataFilter[index]['member_name']}",
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
                                    
                                    
                                    Text("${memberDataFilter[index]['mobile_no'].toString()}",
                                      //'\$${activity.price}',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                
                                  ],
                                ),
                              ],
                            ),
                            Container(height: 1.0,),
                            Text("Email ID: ${memberDataFilter[index]['email'].toString()}",
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
                                  child: Text("Alt Mobile No.: ${memberDataFilter[index]['alt_mobile_no'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                            ),
                                ),

                              Container(
                                  // width: 120.0,
                                  child: Text("Dob.: ${memberDataFilter[index]['dob'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                            ),
                                ),



                              
                              // Row(
                              //   children: <Widget>[
                              //     memberDataFilter[index]["state"]=="UNPAID"?CircleAvatar(
                              // radius: 14.0,
                              // backgroundColor: Colors.red,
                              // child: Icon(Icons.info, color: Colors.white,),
                              // )
                              // //     :CircleAvatar(
                              // // radius: 14.0,
                              // // backgroundColor: Colors.green,
                              // // child: Icon(Icons.check, color: Colors.white,),
                              // // ),
                              // :memberDataFilter[index]["state"]=="PAID"?CircleAvatar(
                              // radius: 14.0,
                              // backgroundColor: Colors.green,
                              // child: Icon(Icons.check, color: Colors.white,),
                              // ):CircleAvatar(
                              // radius: 14.0,
                              // backgroundColor: Colors.yellow,
                              // child: Icon(Icons.check, color: Colors.white,),
                              // ),
                                  
                              //     Text(" ${memberDataFilter[index]["state"]} "),
                              //     memberDataFilter[index]["state"]=="UNPAID"?Icon(Icons.warning,color: Colors.red,):
                              //     memberDataFilter[index]["state"]=="PAID"?Icon(Icons.check_circle,color: Colors.green,):
                              //     Text("Confirm"),
                              //   ],
                              // )

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
//   void choiceAction(String choice){
//     if(choice==PupupMenuItems.paid){
//        print("Paid check : $choice");
//       // var val="PAID";
//       stateFilter(choice);
//       //stateFilter("PAID");
//     }else if(choice==PupupMenuItems.unpaid){
//        print("unpaid: $choice");
//       // var val1="UNPAID";
//       stateFilter(choice);
//     }
//     else if(choice==PupupMenuItems.removeFilter){
//       print("remove filter : $choice");
//       setState(() {
//         setState(() {
//               maintenanceDataFilter = maintenanceData;
//               });
//       });
//     }
// }
  



}