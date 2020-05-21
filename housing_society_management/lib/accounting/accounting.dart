import 'dart:convert';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:hsm/maintenancePage/maintenanceList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/accounting/accountingDetails.dart';

class Accounting extends StatefulWidget{
  @override 
  State<StatefulWidget> createState() {
    
    return AccountingState();
  }
}

class AccountingState extends State<Accounting>{

  bool typing = false;
  final _debouncer = Debouncer(milliseconds: 500);
  bool _loading=false;
  // List<Map<String, dynamic>> account;
  // List<Map<String, dynamic>> _filterAccount;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List accountingData;
  List accountingDataFilter;
  
  
  
  @override 
  void initState(){
    setState(() {
      _loading=false;
    });
    //getData();
    _fetchSessionAndNavigate();
    accountingData =[];
    accountingDataFilter =[];
    super.initState();
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
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/AccountingAPI', society_id, flat_ids);
    print("fetch response Accounting : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    List data=responseJson["data"];
   
      setState(() {
        accountingData=data;
        accountingDataFilter=data;
        _loading=true;
      });
      

	}

  //   getData() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //     String url = "$urlValue/mobile_api/AccountingAPI/";
  //     //String url = "${Urls.BASE_API_URL}/mobile_api/AccountingAPI/";

  //   try {
     
  //     final response = await http.post(url , headers: {'Authorization':'token $value'}); 
  //     print('getEmployees new Response: ${response.body}');
      
      
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     print("map ${map['is_success']}");
  //     List<dynamic> accountLines = map['data'];
  //     List<Map<String, dynamic>> accountList =[];
  //     accountLines.forEach((lines){
  //       Map<String, dynamic> map={
  //         "amount":lines['amount'],
  //         "action_type":lines['action_type'],
  //         "pk":lines['pk'],
  //         "create_date":lines['create_date'],
  //         "payment_type":lines['payment_type'],
  //         "name":lines['name'],
  //         "balance":lines['balance'],
          

  //       };
  //       accountList.add(map);
  //     });

  //     setState(() {
  //       account = accountList;
  //       _filterAccount = accountList;
  //       _loading=true;
  //     });

  //     } else {
  //       return null; 
  //     }
  //    } catch (e) {
  //      return  e; 
  //    }
  // }
    
  SingleChildScrollView dataBody(){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:SingleChildScrollView(
         child:FittedBox(
        //   padding: EdgeInsets.only(left: 3.0, right: 0.4),
      child:
      DataTable(
      //  sortAscending: sort,
      //  sortColumnIndex: 2,
      //columnSpacing: 50.0,
      //dataRowHeight: 5.0,
      columnSpacing: 8.0,
      //columnWidths: {0:FractionColumnWidth(.2)},
      //horizontalMargin: 2.0,
      
      columns: [
        DataColumn(
          label: Text("Name", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        DataColumn(
          label: Text("Balance", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        DataColumn(
          label: Text("Amount", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0,),),
          numeric: false,
          //tooltip: "This is Last name",
          // onSort: (columnIndex, ascending){
          //   setState(() {
          //     sort = !sort;
          //   });
          //  // onSortColum(columnIndex, ascending);
          // }
         ),

        // DataColumn(
        //   label: Text("Payment_Type", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
        //   numeric: false,
        //   //tooltip: "This is Last name"
        // ),

        DataColumn(
          label: Text("Date", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        DataColumn(
          label: Text("Payment_Type", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        
      ],
      rows:accountingDataFilter
            .map(
              (account)=>DataRow(
              
                cells: [
                  DataCell(
                    //Center(
                      //child:
                      Text(account['name']),
                    //  ),   //  maintenance.firstName
                    onTap: (){
                      //print("Row tab pk no. ${account['pk']}");
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>AccountingView("${account['pk']}")
                     ));
                    }
                  ),

                   DataCell(
                    //Center(child:
                    Padding(padding: EdgeInsets.only(left: 5.0),
                      child:
                    Text('₹${account['balance'].toString()}'),
                    ),
                  ),

                   DataCell(
                    //Center(child:
                    Text('₹${account['amount'].toString()}'),
                    //),
                  ),

                 
                   DataCell(
                    //Center(child:
                    Text(account['create_date']),
                    //),
                  ),

                   DataCell(
                    Center(child:
                    Text(account['payment_type']),
                    ),
                  ),

                ] 
              ),
            ).toList(),
    ),
    ), 
    ),   
    );

  }

  searchField(){
    return Container(
      padding: EdgeInsets.all(20.0),
      alignment: Alignment.center,
      //color: Colors.white,
      decoration: BoxDecoration(
      //color: Colors.lightGreenAccent,
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      
    ),
      
      child: TextField(
        
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(10.0),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Filter By Name Or Date',
        ),
        onChanged: (string){
          _debouncer.run((){
            setState(() {
              accountingDataFilter = accountingData
              .where((u)=> (u['name'].contains(string)) || u['create_date'].contains(string)).toList();
            });
          });
        },
      ),
    );
  }

  
  @override 
  Widget build(BuildContext context) {
    
    return _loading?Scaffold(
      
      appBar: AppBar(
        title: Text("Accounting"),
        backgroundColor: Color(0xff39687e),
        actions: <Widget>[
               IconButton(
                 icon: Icon(typing ? Icons.cancel: Icons.filter_list),
                 onPressed: (){
                   setState(() {
                   typing = !typing;
                 });
                 },
               )
             ],
        
        ),

        floatingActionButton: FloatingActionButton(
      onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //  builder: (BuildContext contex) => Form_create()));
              print("button tab");
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xff39687e),
        ),

        body: 
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   verticalDirection: VerticalDirection.down,
        //   children: <Widget>[
        //    // searchField(),
        //     Expanded(
             
        //     child:Container(
        //       child: dataBody(),
        //     )
        //     ),
        //   ],
        // ),

        Container(

          child: Column(
          children: <Widget>[
            typing ? Expanded(
             child:ListView(
               shrinkWrap: true,
            children:<Widget>[
             searchField(),
               
              Divider(),
               dataBody()
                
              ]
              )):
            Expanded(
             
            child:Container(
              child: dataBody(),
            )
            ),
          ],
        ),
        ),
    ):Center(child: CircularProgressIndicator(),);
  }
}