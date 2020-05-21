import 'package:flutter/material.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderReport extends StatefulWidget{
  var pk;
  PurchaseOrderReport(this.pk){
    print("this is purchase order pk $pk");
  }
  @override 
  State<StatefulWidget> createState() {
    return PurchaseOrderReportState(pk);
  }
}

class PurchaseOrderReportState extends State<PurchaseOrderReport>{
  var pk,society_name,society_address,vendor_name,vendor_address,purchase_order_no,po_date,grand_total,special_instructions;
  
  PurchaseOrderReportState(this.pk);
  //List<Map<String, dynamic>> purchaseOrderReport =[];

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List purchaseOrderView;

  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    //getData();
    _fetchSessionAndNavigate();
    purchaseOrderView=[];
  }

  _fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
    
		var society_id = _sharedPreferences.getInt(AuthUtils.society_id);
		var flat_ids = _sharedPreferences.getInt(AuthUtils.flat_ids);
    //databaseHelper.saveDetails(society_id, flat_ids);

		print(authToken);

		_fetchHome(authToken);

	}

  _fetchHome(String authToken) async {
		var responseJson = await NetworkUtils.fetchViews(authToken, 'mobile_api/PurchaseOrderReportAPI', pk, "Purchase-order-id");
    print("fetch response : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
        
     society_name = responseJson['data']['society_name'];
     print("society name: $society_name");
      society_name = responseJson['data']['society_name'];
      society_address = responseJson['data']['society_address'];
      vendor_name = responseJson['data']['vendor_name'];
      vendor_address = responseJson['data']['vendor_address'];
      purchase_order_no = responseJson['data']['purchase_order_no'];
      po_date = responseJson['data']['po_date'];
      grand_total = responseJson['data']['grand_total'];
      special_instructions = responseJson['data']['special_instructions'];

    List purchaseOrder_lines=responseJson["data"]["purchase_order_lines"];
    print("purchaseOrder_lines Data report: $purchaseOrder_lines");
   
      setState(() {
        purchaseOrderView=purchaseOrder_lines;
       _isLoading=false;
      });
      
	}

  // getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //     String url = "$urlValue/mobile_api/PurchaseOrderReportAPI/"; // $pk
  //     print("pk value $pk");

  //   try {
      
  //     final response = await http.post(url , 
  //     headers: {
  //       'Authorization':'token $value',
  //       'Purchase-order-id': '$pk',
  //       }
  //     );
  //     print("status code new : ${response.statusCode}");
  //     print('get Purchase Order Report neeeew: ${response.body}');
        
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     print("maintenance data ${map['data']['society_name']}");
  //     society_name = map['data']['society_name'];
  //     society_address = map['data']['society_address'];
  //     vendor_name = map['data']['vendor_name'];
  //     vendor_address = map['data']['vendor_address'];
  //     purchase_order_no = map['data']['purchase_order_no'];
  //     po_date = map['data']['po_date'];
  //     grand_total = map['data']['grand_total'];
  //     special_instructions = map['data']['special_instructions'];
  //     print("purchase_order_lines ${map['data']['purchase_order_lines']}");  
  //     List<dynamic> purchase_order_lines = map['data']['purchase_order_lines'];
  //     List<Map<String, dynamic>> purchaseList =[];
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     purchase_order_lines.forEach((line){
  //       Map<String, dynamic> map={
  //         "product_name":line['product_name'],
  //         "quantity":line['quantity'],
  //         "product_unit_price":line['product_unit_price'], 
  //       };
  //       purchaseList.add(map);
  //     });

  //     setState(() {
  //       purchaseOrderReport = purchaseList;
  //      });
 
  //     } else {
  //       return null; 
  //     }
  //    } catch (e) {
  //      return  e; 
  //    }
  // }


  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Order Report"),backgroundColor: Color(0xff39687e),
      ),
      body: _isLoading?Center(child:CircularProgressIndicator()):ListView.builder(
        itemBuilder: (context, index){
          return Container(
            color: Colors.grey[300],
          // child:Padding(
          //   padding: EdgeInsets.all(0.0),
            
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
                        
                          Text("Purchase Order: ", style: TextStyle(fontSize: 22.0),),
                          //Spacer(),
                          Text("$purchase_order_no", style: TextStyle(fontSize: 20.0),),
                                                  
                      ],
                    ),
                    ),
                    
                    ),

                    Container(    // Card
                    height: 45.0,
                    color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 10.0),//EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text("Date: ", style: TextStyle(fontSize: 18.0),),
                          //Spacer(),
                          Text("$po_date", style: TextStyle(fontSize: 18.0),),
                                                  
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
                        child:Padding(padding: EdgeInsets.fromLTRB(12.0, 0.0, 10.0, 14.0),
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
                        height: 40.0,
                        child:Padding(
                          //padding: EdgeInsets.all(10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                        child:   Row(
                           children: <Widget>[
                             Expanded(child:Text("$vendor_name", style: TextStyle(fontSize: 17.0),)),
                            //  Spacer(),
                            //  Text("total amount", style: TextStyle(fontSize: 17.0),),
                                                          
                           ],
                       ),
                      ),
                      ),
                      
                      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          //padding: EdgeInsets.all(10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child:   Row(
                           children: <Widget>[
                            
                            Flexible(
                              child: Text('$vendor_address'),
                              )
                                                 
                           ],
                       ),
                      ),
                      ),
                     
                    
                    //   Container(     // Card
                    //   height: 45.0,
                    //   //color: Colors.white,
                    //   child:Padding(
                    //     padding:EdgeInsets.all(10.0),
                      
                    //   child:Row(
                    //   children: <Widget>[
                    //     Text("Amount Details",style: TextStyle(fontSize: 22.0),)
                    //   ],
                    // ),
                    //   ),
                    //   ),

                    //   //Container(height: 15.0,),

                    //   Container(
                    //     color: Colors.white,
                    //     height: 45.0,
                    //     child:Padding(
                    //       padding: EdgeInsets.all(10.0),
                    //     child:   Row(
                    //        children: <Widget>[
                    //          Text("Total", style: TextStyle(fontSize: 17.0),),
                    //          Spacer(),
                    //          Text("₹ ${grand_total.toString()}", style: TextStyle(fontSize: 17.0),),
                                                          
                    //        ],
                    //    ),
                    //   ),
                    //   ),
                
                    Container(    // Card
                    height: 45.0,
                    //color: Colors.white,

                   child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                          Text("Product ", style: TextStyle(fontSize: 22.0),),
                          Spacer(),
                          Text("Quantity ", style: TextStyle(fontSize: 20.0),),
                          Spacer(),
                          Text("Unit Price ", style: TextStyle(fontSize: 20.0),),
                          
                      ],
                    ),
                    ),
                    ),
                      

              purchaseOrderView.length==0 ? Center(
         child: CircularProgressIndicator(),
       ):

              ListView(
        children: purchaseOrderView.map((listData){

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
                        
                          Text("${listData['product_name']}", style: TextStyle(fontSize: 17.0),),
                          Spacer(),
                          Text("${listData['quantity'].toString()}", style: TextStyle(fontSize: 17.0),),
                          Spacer(),
                          Text("₹ ${listData['product_unit_price'].toString()}", style: TextStyle(fontSize: 17.0),),
                        
                      ],
                    ),
                    ),
                    ),
                                                     
                  ],
                ),
                  ),
                );
        
        
        }).toList(),
        physics: ClampingScrollPhysics(),
         shrinkWrap: true,
      ),

      Container(
                        //color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          padding: EdgeInsets.all(10.0),
                        child:   Row(
                           children: <Widget>[
                             Text("Grand Total", style: TextStyle(fontSize: 17.0),),
                             Spacer(),
                             Text("₹ ${grand_total.toString()}", style: TextStyle(fontSize: 17.0),),
                                                          
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
                             Text("Special_instructions: ", style: TextStyle(fontSize: 17.0),),
                             //Spacer(),
                                                          
                           ],
                       ),
                      ),
                      ),
                      // Flexible(
                      //          child: Text("$special_instructions", style: TextStyle(fontSize: 17.0),),
                      //        ),
      Container(
                        color: Colors.white,
                        height: 45.0,
                        child:Padding(
                          //padding: EdgeInsets.all(10.0),
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child:   Row(
                           children: <Widget>[
                            
                            Flexible(
                              child: Text('$special_instructions'),
                              )
                                                 
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
            child: Text("Download", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ),
              
              ],
            ),
          //),
          );
        },
        itemCount: 1,
      ),

    );
  }
}