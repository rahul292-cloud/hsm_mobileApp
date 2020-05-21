import 'dart:convert';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:housing_society_management/purchaseOrder/purchaseOrderReport.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:housing_society_management/globals.dart' as globals;
import 'package:housing_society_management/purchaseOrder/popupMenuItems.dart';


class PurchaseOrder extends StatefulWidget{
  
  @override 
  State<StatefulWidget> createState() {
    
    return PurchaseOrderState();
  }
}

class PurchaseOrderState extends State<PurchaseOrder>{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List purchaseOrder;
  List purchaseOrderFilter;


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
    purchaseOrder =[];
    purchaseOrderFilter =[];
    sort = false;
    //getData();
 }
  
  _fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    
		print(authToken);

		_fetchHome(authToken,society_id,flat_ids);

		// setState(() {
		// 	_authToken = authToken;
		// 	_society_id = society_id;
		// 	_flat_ids = flat_ids;
		// });

	}

  	_fetchHome(String authToken, var society_id, var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/PurchaseOrderAPI', society_id, flat_ids);
    print("fetch response purchaseOrder: $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
       
    List data=responseJson["data"];
   
      setState(() {
        purchaseOrder=data;
        purchaseOrderFilter=data;
        _loading=true;
      });
      
	}



  // bool typing = false;
  // bool _loading=false;
  // var k;

  // final _debouncer = Debouncer(milliseconds: 500);

  // List<Map<String, dynamic>> purchaseOrder; 
  // List<Map<String, dynamic>> _purchaseOrderFilter;
  //bool sort;



  //@override 
  // void initState(){
  //   setState(() {
  //     _loading=false;
  //   });
  //    purchaseOrder =[];
  //   _purchaseOrderFilter =[];
  //   sort = false;
    
  //   getData();
  //   super.initState();
    
  // }

  
  //   getData() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //     //String url = "${Urls.BASE_API_URL}/mobile_api/MaintenanceAPI/";
  //      String url = "$urlValue/mobile_api/PurchaseOrderAPI/";
  //      int society_value = prefs.get("society_id") ?? 0;

  //   try {
     
  //     final response = await http.post(url , headers: {'Authorization':'token $value','Society-id': '$society_value'}); 
  //     print('getPurchaseOrder new Response: ${response.body}');
  //     print("global version variable in maintenance ${globals.androidVersion}");
  //     print("object deviceId variable in maintenamce ${globals.deviceId}");
      
      
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     print("map ${map['is_success']}");
  //     print("purchase order :$map");
  //     List<dynamic> purchaseOrderLines = map['data'];
  //     List<Map<String, dynamic>> _purchaseOrderList =[];
  //     purchaseOrderLines.forEach((line){
  //       Map<String, dynamic> map={
  //         "pk":line['pk'],
  //         "purchase_order_no":line['purchase_order_no'],
  //         "vendor":line['vendor'],
  //         "date":line['date'],
  //         "grand_total":line['grand_total'],
         
  //       };
  //       _purchaseOrderList.add(map);
  //     });

  //     setState(() {
  //       purchaseOrder = _purchaseOrderList;
  //        _purchaseOrderFilter = _purchaseOrderList;
  //        _loading=true;
  //     });

  //     } else {
  //       return null; 
  //     }
  //    } catch (e) {
  //      return  e; 
  //    }
  // }

  
  // onSortColum(int columnIndex, bool ascending){
  //   if(columnIndex == 0){
  //     if(ascending){
  //       //  maintenanceList.sort((a,b)=>a.firstName.compareTo(b.firstName));
  //       purchaseOrder.sort((a,b)=>a['date'].compareTo(b['date']));
  //     }
  //     else{
  //       // maintenanceList.sort((a,b)=> b.firstName.compareTo(a.firstName));
  //       purchaseOrder.sort((a,b)=> b['date'].compareTo(a['date']));
  //     }
  //   }
  // }

  // 
  
  setBillPaid(var billPaid){
    setState(() {
      bill_Paid=billPaid;
    });
  }

  stateFilter(String choice){
    print("check value $choice");
        
            setState(() {
              print("last check $choice");
              purchaseOrderFilter = purchaseOrder
              //.where((u)=> (u["state"].toLowerCase().contains(choice))||(u["state"].toUpperCase().contains(choice))).toList();
              .where((u)=> (u['state']==choice) ).toList();
            });
        
  }


searchField() async{
  print("tab");
  
      
      await displayDayRangePicker(context);
      print("Start date ${DateFormat('MM/dd/yyyy').format(_startDate).toString()}");
      print("End date ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}");
      
  
}


  // searchField(){
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
  //         hintText: 'Filter By date',
  //       ),
  //       onChanged: (string){
  //         _debouncer.run((){
  //           setState(() {
  //             _purchaseOrderFilter = purchaseOrder
  //             //list = list
  //             .where((u)=> (u['date'].contains(string)) || u['date'].contains(string)).toList();
  //           });
  //         });
  //       },
  //     ),
  //   );
  // }

  // @override 
  // Widget build(BuildContext context) {
    
  //   return _loading?Scaffold(
      
  //     appBar: AppBar(
  //      title: Text("Purchase Order"),
  //     backgroundColor: Color(0xff39687e),
  //            actions: <Widget>[
  //              IconButton(
  //                icon: Icon(typing ? Icons.cancel: Icons.filter_list),
  //                onPressed: (){
  //                  setState(() {
  //                  typing = !typing;
  //                });
  //                },
  //              )
  //            ],
  //       ),
        

  //       floatingActionButton: FloatingActionButton(
  //     onPressed: () {
  //             // Navigator.of(context).push(MaterialPageRoute(
  //             //  builder: (BuildContext contex) => Form_create()));
  //             print("button tab");
  //         },
  //         child: Icon(Icons.add),
  //         backgroundColor: Color(0xff39687e),
  //       ),

  //       body: Container(
  //       child:Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         verticalDirection: VerticalDirection.down,
  //         children: <Widget>[
          
  //         typing ? Expanded(
  //            child:ListView(
  //              shrinkWrap: true,
  //           children:<Widget>[
  //            searchField(),
               
  //             Divider(),
  //              dataBody()
                
  //             ]
  //             )):
  //           Expanded(
             
  //           child:Container(
  //             child: dataBody(),
  //           )
  //           ),

  //         ],
  //       ),
  //   ), 
  //   ):Center(child: CircularProgressIndicator(),);
  // }

  @override 
  Widget build(BuildContext context) {
    
   
  return Scaffold(backgroundColor: Color(0xFFEFF4F7),//Colors.white70,
  appBar: AppBar(
    title: Text("Purchase Order"),
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
               purchaseOrderFilter = purchaseOrder;
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
                  itemCount: purchaseOrderFilter.length,
                  itemBuilder: (BuildContext context,int index){
                   
                    return Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>PurchaseOrderReport("${purchaseOrderFilter[index]['pk']}")
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  child: Text("${purchaseOrderFilter[index]['vendor']}",
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
                                    
                                    Text("₹${purchaseOrderFilter[index]['grand_total'].toString()}",
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
                            Text("Date: ${purchaseOrderFilter[index]['date'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                            ),
                            Container(height: 0.5,),
                           
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //     Container(
                            //       // width: 120.0,
                            //       child: Text("Paid Date: ${purchaseOrderFilter[index]['paid_date_format'].toString()}",
                            //   //activity.type,
                            //   style: TextStyle(
                            //     color: Colors.black38,//grey
                            //     fontSize: 14.0,
                            //   ),
                            // ),
                            //     ),
                              
                            //   Row(
                            //     children: <Widget>[
                            //       purchaseOrderFilter[index]["state"]=="UNPAID"?CircleAvatar(
                            //   radius: 14.0,
                            //   backgroundColor: Colors.red,
                            //   child: Icon(Icons.info, color: Colors.white,),
                            //   )
                            //   //     :CircleAvatar(
                            //   // radius: 14.0,
                            //   // backgroundColor: Colors.green,
                            //   // child: Icon(Icons.check, color: Colors.white,),
                            //   // ),
                            //   :purchaseOrderFilter[index]["state"]=="PAID"?CircleAvatar(
                            //   radius: 14.0,
                            //   backgroundColor: Colors.green,
                            //   child: Icon(Icons.check, color: Colors.white,),
                            //   ):CircleAvatar(
                            //   radius: 14.0,
                            //   backgroundColor: Colors.yellow,
                            //   child: Icon(Icons.check, color: Colors.white,),
                            //   ),
                                  
                            //       Text(" ${purchaseOrderFilter[index]["state"]} "),
                            //       purchaseOrderFilter[index]["state"]=="UNPAID"?Icon(Icons.warning,color: Colors.red,):
                            //       purchaseOrderFilter[index]["state"]=="PAID"?Icon(Icons.check_circle,color: Colors.green,):
                            //       Text("Confirm"),
                            //     ],
                            //   )
                            //   ],
                            // ),
                            Container(height: 1.0,),
                            Text("Purchase Order No. ${purchaseOrderFilter[index]['purchase_order_no'].toString()}",
                              //activity.type,
                              style: TextStyle(
                                color: Colors.black38,//grey
                                fontSize: 14.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Container(height: 0.5,),
                          
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
    if(choice==PopupMenuItems.paid){
       print("Paid check : $choice");
      // var val="PAID";
      stateFilter(choice);
      //stateFilter("PAID");
    }else if(choice==PopupMenuItems.unpaid){
       print("unpaid: $choice");
      // var val1="UNPAID";
      stateFilter(choice);
    }
    else if(choice==PopupMenuItems.removeFilter){
      print("remove filter : $choice");
      setState(() {
        setState(() {
              purchaseOrderFilter = purchaseOrder;
              });
      });
    }
}


}