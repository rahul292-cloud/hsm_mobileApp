import 'dart:convert';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';

import '../main.dart';

class VehicleParking extends StatefulWidget {
  var id;
  VehicleParking();
  @override
  _VehicleParkingState createState() => _VehicleParkingState();
}

class _VehicleParkingState extends State<VehicleParking> {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List vehicleData;
  List vehicleDataFilter;


  final _debouncer = Debouncer(milliseconds: 500);
  bool typing=false;
  
  bool _loading=false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading=false;
    });
    _fetchSessionAndNavigate();
    vehicleData =[];
    vehicleDataFilter =[];
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

	}

	_fetchHome(String authToken, var society_id, var flat_ids) async {
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/VehicleAPI', society_id, flat_ids);
    print("fetch response vehicle : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    List data=responseJson["data"];
   
      setState(() {
        vehicleData=data;
        vehicleDataFilter=data;
        _loading=true;
      });
      

	}

  


  SingleChildScrollView dataBody(){
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:SingleChildScrollView(
        child:FittedBox(
          
      child:DataTable(
        dataRowHeight: 50.0,
        headingRowHeight: 70.0,
      //  sortAscending: sort,
      //  sortColumnIndex: 2,
      columns: [
        
        
        DataColumn(
          label: Text("Owner", style: TextStyle(color: Colors.blueAccent , fontSize: 20.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        DataColumn(
          label: Text("Vehicle Type", style: TextStyle(color: Colors.blueAccent , fontSize: 20.0),),
          numeric: false,
          //tooltip: "This is Last name"
        ),

        DataColumn(
          label: Text("Reg.no.", style: TextStyle(color: Colors.blueAccent , fontSize: 20.0,),),
          numeric: false,
         
         ),

        
      ],
      rows:vehicleDataFilter
            .map(
              (vehicle)=>DataRow(
                cells: [
                  DataCell(
                    Text(vehicle['owner'].toString(), style: TextStyle(fontSize: 19.0),),    //  maintenance.firstName
                    
                    onTap: (){
                    //   print("Row tab pk no. ${vehicle['pk']}");
                    //  var k= vehicle['pk'];
                    //  print("vehicle k :$k");
                    }
                  ),

                   DataCell(
                    Text(vehicle['vehicle'].toString(), style: TextStyle(fontSize: 19.0),),
                  ),

                   DataCell(
                    Text(vehicle['registration_number'].toString(),style: TextStyle(fontSize: 19.0),),
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
          hintText: 'Filter By Name Or Vehicle Type.',
        ),
        onChanged: (string){
          _debouncer.run((){
            setState(() {
              vehicleDataFilter = vehicleData
              .where((u)=> (u['owner'].contains(string)) || u['vehicle'].contains(string)).toList();
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _loading?Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('Vehicle Parking'),backgroundColor: Color(0xff39687e),
      actions: <Widget>[
        IconButton(
          icon: Icon(typing?Icons.cancel:Icons.filter_list),
          onPressed: (){
            setState(() {
              typing=!typing;
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
    body: Container(
      child:Column(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          // verticalDirection: VerticalDirection.down,
          children: <Widget>[
          //  searchField(),
          typing? Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                searchField(),
                Divider(),
                dataBody(),
              ],
            ),
          ):Expanded(
            child: Container(
              child: dataBody(),
            ),
          )
            // Expanded(
             
            // child:Container(
            //   child: dataBody(),
            // )
            // ),
          ],
        ),
  ),
  ):Center(child: CircularProgressIndicator());
}
