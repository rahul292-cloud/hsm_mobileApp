import 'dart:convert';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:housing_society_management/helpDesk/helpDeskComplain.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'popupMenuItems.dart';
import 'package:housing_society_management/helpDesk/helpdeskDetails.dart';

class HelpDesk extends StatefulWidget{
  @override 
  State<StatefulWidget> createState() {
    return HelpDeskState();
  }
}

class HelpDeskState extends State<HelpDesk>{
  final _debouncer = Debouncer(milliseconds: 500);
  bool typing=false;
  bool _loading=false;
  bool _dateFilter=false;
  bool _dateValue=false;
  var bill_Paid;
  //List<Map<String, dynamic>> helpdesk;
  //List<Map<String, dynamic>> _filterHelpdesk;

  //List selectedList;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List helpdeskData;
  List helpdeskDataFilter;

  
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
       setState(() {
      _loading=false;
      _dateFilter=false;
      _dateValue=false;
    });
    
   _fetchSessionAndNavigate();
    helpdeskData =[];
    helpdeskDataFilter =[];
     
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

	}

	_fetchHome(String authToken, var society_id,var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/HelpDeskAPI', society_id, flat_ids);
    print("fetch response : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
   
    List data=responseJson["data"];
    print("helpdesk response: $data");
      setState(() {
        helpdeskData=data;
        helpdeskDataFilter=data;
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
              helpdeskDataFilter = helpdeskData
              //.where((u)=> (u["state"].toLowerCase().contains(choice))||(u["state"].toUpperCase().contains(choice))).toList();
              .where((u)=> (u['status_type']==choice) ).toList();
            }); 
  }
searchField() async{
  print("tab");
 
      await displayDayRangePicker(context);
      print("Start date ${DateFormat('MM/dd/yyyy').format(_startDate).toString()}");
      print("End date ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}");
 
}



  //   getData() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //     String url = "$urlValue/mobile_api/HelpDeskAPI/";
  //     //String url = "${Urls.BASE_API_URL}/mobile_api/HelpDeskAPI/";

  //   try {
     
  //     final response = await http.post(url , headers: {'Authorization':'token $value'}); 
  //     print('getEmployees new Response: ${response.body}');
            
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     print("map ${map['is_success']}");
  //     List<dynamic> helpdesk_lines = map['data'];
  //     List<Map<String, dynamic>> helpdesk_list =[];
  //     helpdesk_lines.forEach((line){
  //       Map<String, dynamic> map={
  //         "name":line['name'],
  //         "status_type":line['status_type'],
  //         "pk":line['pk'],
  //         "reply":line['reply'],
  //         "create_date":line['create_date'],
  //         "complaint_type":line['complaint_type'],
         
  //       };
  //       helpdesk_list.add(map);
  //     });

  //     setState(() {
  //       helpdesk = helpdesk_list;
  //       _filterHelpdesk=helpdesk_list;
  //       _loading=true;
  //       });

  //     } else {
  //       return null; 
  //     }
  //    } catch (e) {
  //      return  e; 
  //    }
  // }
    
//  onSelectedRow(bool selected, List<String> name)async{
//   _filterHelpdesk(Map<String, dynamic> data) {
//   name = data['name'].cast<String>();
// }
//    setState(() {
//      if(selected){
//      selectedList.add(name);
//    }else{
//      selectedList.remove(name);  // helpdesk
//    }
//    });
   
//  }

  // SingleChildScrollView dataBody(){
  //   return SingleChildScrollView(
  //       scrollDirection: Axis.vertical,
  //       child:SingleChildScrollView(
  //         child:FittedBox(
  //       // child:Padding(
  //       //   padding: EdgeInsets.only(right:8.0, left: 0.0),
  //     child:DataTable(
  //     //  sortAscending: sort,
  //     // sortColumnIndex: 2,
  //     // columnSpacing: 3.0,
  //     sortColumnIndex: 2,
  //     columnSpacing: 8.0,
  //     columns: [
  //       DataColumn(
  //         label: Text("Name", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
  //         numeric: false,
  //         //tooltip: "This is Last name"
          
  //       ),

  //       DataColumn(
  //         label: Text("Complain", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
  //         numeric: false,
  //         //tooltip: "This is Last name"
  //       ),

        
  //       DataColumn(
  //         label: Text("Create_Date", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
  //         numeric: false,
  //         //tooltip: "This is Last name"
  //       ),

  //       DataColumn(
  //         label: Text("Status", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
  //         numeric: false,
  //         //tooltip: "This is Last name"
  //       ),

  //       // DataColumn(
  //       //   label: Icon(Icons.delete),
  //       //   numeric: false,
  //       //   ),
               
  //     ],
  //     rows:_filterHelpdesk   
  //           .map(
  //             (helpdesk)=>DataRow(
  //             //  selected: selectedList.contains(helpdesk['name']),
  //             //   onSelectChanged: (b){
  //             //     print("OnSelected $helpdesk['name']");
  //             //     onSelectedRow(b, helpdesk['name']);
  //             //   },
  //               cells: [
  //                 DataCell(
  //                  Text(helpdesk['name']),    //  maintenance.firstName
  //                   onTap: (){
  //                     print("Row tab pk no. ${helpdesk['pk']}");
  //                   }
                    
  //                 ),

  //                  DataCell(
  //                   Text(helpdesk['complaint_type']),
                    
  //                 ),

  //                  DataCell(
  //                   Text(helpdesk['create_date'].toString()),
  //                 ),

  //                  DataCell(
  //                  Text(helpdesk['status_type']),
  //                 ),

  //                 //  DataCell(
  //                 //  IconButton(icon:Icon(Icons.delete),
  //                 //  onPressed: (){
  //                 //    print("Delete button pressed ${helpdesk['name']}");
  //                 //  },
  //                 //  )
  //                 // ),

                  
  //               ] 
  //             ),
  //           ).toList(),
  //   ), 
  //       //),
  //       ),
  //   ),   
  //   );

  // }

  //   searchField(){
  //   return Container(
  //     padding: EdgeInsets.all(20.0),
  //     alignment: Alignment.center,
  //     //color: Colors.white,
  //     decoration: BoxDecoration(
  //     //color: Colors.lightGreenAccent,
  //     borderRadius: BorderRadius.all(Radius.circular(0.0)),
      
  //   ),
      
  //     child: TextField(
        
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         contentPadding: EdgeInsets.all(10.0),
  //         filled: true,
  //         fillColor: Colors.grey[200],
  //         hintText: 'Filter By Name Or Date',
  //       ),
  //       onChanged: (string){
  //         _debouncer.run((){
  //           setState(() {
  //             _filterHelpdesk = helpdesk
  //             .where((u)=> (u['name'].contains(string)) || u['create_date'].contains(string)).toList();
  //           });
  //         });
  //       },
  //     ),
  //   );
  // }
  
  @override 
  Widget build(BuildContext context) {
    
    // return _loading?WillPopScope(
    //   onWillPop: () async => true,
    //   //onWillPop: _onBackPressed,
    // child:Scaffold(
      
    //   appBar: AppBar(
    //     title: Text("HelpDesk"),backgroundColor: Color(0xff39687e),
    //     actions: <Widget>[
    //       IconButton(
    //         icon: Icon(typing?Icons.cancel:Icons.filter_list),
    //         onPressed: (){
    //           setState(() {
    //             typing=!typing;
    //           });
    //           },
    //       )
    //     ],
    //     ),

    //     floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //           Navigator.of(context).pop();
    //           Navigator.of(context).push(MaterialPageRoute(
    //            builder: (BuildContext contex) => HelpDeskComplain(),));   //  Form_create()
    //       },
    //       child: Icon(Icons.add),
    //       backgroundColor: Color(0xff39687e),
    //     ),

    //     body: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       verticalDirection: VerticalDirection.down,
    //       children: <Widget>[
    //         typing?Expanded(
    //           child: ListView(
    //             shrinkWrap: true,
    //             children: <Widget>[
    //               searchField(),
    //               Divider(),
    //               dataBody(),
    //             ],
    //           ),
    //         ):
    //        // searchField(),
    //         Expanded(
             
    //         child:Container(
    //           child: dataBody(),
    //         )
    //         ),
    //       ],
    //     ),
    // ),
    // ):Center(child: CircularProgressIndicator(),);

  return Scaffold(backgroundColor: Color(0xFFEFF4F7),//Colors.white70,
  appBar: AppBar(
    title: Text("helpdesk"),
    backgroundColor: Color(0xff39687e),
  ),
  floatingActionButton: FloatingActionButton(
      onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
               builder: (BuildContext contex) => HelpDeskComplain(),));   //  Form_create()
          },
          child: Icon(Icons.add),
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
               helpdeskDataFilter = helpdeskData;
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
                        return PopupMenuItems.choices.map((String choice){
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
            
                 child: ListView.builder(
                  itemCount: helpdeskDataFilter.length,
                  itemBuilder: (BuildContext context,int index){
                   
                    return Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>HelpdeskView("${helpdeskData[index]['pk']}")
                     ));
                    },
                    child:Container(
                      margin: EdgeInsets.fromLTRB(2.0, 1.0, 2.0, 0.0),//5.0, 1.0, 5.0, 0.0
                      height: 60.0,//115.0,//170.0
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),//20.0
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.5),//10.0, 5.0, 10.0, 0.5
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 140.0,//140.0,
                                  child: Text("${helpdeskDataFilter[index]['name']}",
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
                                    
                                    Text("${helpdeskDataFilter[index]['create_date'].toString()}",
                                      //'\$${activity.price}',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        //fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                   
                                  ],
                                ),
                              ],
                            ),
                            // Container(height: 1.0,),
                            // Text("${helpdeskDataFilter[index]['create_date'].toString()}",
                            //   //activity.type,
                            //   style: TextStyle(
                            //     color: Colors.black38,//grey
                            //     fontSize: 14.0,
                            //   ),
                            // ),
                            Container(height: 0.5,),
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  // width: 120.0,
                                  child: Text("${helpdeskDataFilter[index]['complaint_type'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black,//grey
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                                ),
                              
                              Row(
                                children: <Widget>[
                                  helpdeskDataFilter[index]["status_type"]=="Not Submitted"?CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.info, color: Colors.white,),
                              )
                              //     :CircleAvatar(
                              // radius: 14.0,
                              // backgroundColor: Colors.green,
                              // child: Icon(Icons.check, color: Colors.white,),
                              // ),
                              :helpdeskDataFilter[index]["status_type"]=="Submitted"?CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.yellow,
                              child: Icon(Icons.check, color: Colors.white,),
                              ):CircleAvatar(
                              radius: 14.0,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.check, color: Colors.white,),
                              ),
                                  
                                  Text(" ${helpdeskDataFilter[index]["status_type"]}"),
                                  helpdeskDataFilter[index]["status_type"]=="Not Submitted"?Icon(Icons.warning,color: Colors.red,):
                                  helpdeskDataFilter[index]["status_type"]=="Submitted"?Icon(Icons.check_circle,color: Colors.yellow,):
                                  Text("Confirm",style: TextStyle(color: Colors.green),),
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
    if(choice==PopupMenuItems.submitted){
       print("submited check : $choice");
      // var val="PAID";
      stateFilter(choice);
      //stateFilter("PAID");
    }else if(choice==PopupMenuItems.notSubmitted){
       print("notSubmitted: $choice");
      // var val1="UNPAID";
      stateFilter(choice);
    }
    else if(choice==PopupMenuItems.removeFilter){
      print("remove filter : $choice");
      setState(() {
        setState(() {
              helpdeskDataFilter = helpdeskData;
              });
      });
    }
}

}
