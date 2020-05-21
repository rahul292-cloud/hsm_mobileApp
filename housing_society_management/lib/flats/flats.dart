import 'dart:convert';
import 'package:housing_society_management/filterMethod/debouncerFilter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';


class Flats extends StatefulWidget{
  @override 
  State<StatefulWidget> createState() {
    
    return FlatsState();
  }
}

class FlatsState extends State<Flats>{

  bool typing = false;
  final _debouncer = Debouncer(milliseconds: 500);
  bool _loading=false;
  // List<Map<String, dynamic>> flat;
  // List<Map<String, dynamic>> _flatFilter;  

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
	var _authToken, _society_id, _flat_ids;
  List flatsData;
  List flatsDataFilter;
  
  
  @override 
  void initState(){
    super.initState();
    setState(() {
      _loading=false;
    });
    //getData();
    _fetchSessionAndNavigate();
    flatsData =[];
    flatsDataFilter =[];
    
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
		var responseJson = await NetworkUtils.fetch(authToken, 'mobile_api/FlatsAPI', society_id, flat_ids);
    print("fetch response flats : $responseJson");
		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} 
    
    List data=responseJson["data"];
   
      setState(() {
        flatsData=data;
        flatsDataFilter=data;
        _loading=true;
      });
      

	}

  //   getData() async {
  //     final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;

  //     int society_value = prefs.get("society_id") ?? 0;

  //     //String url = "${Urls.BASE_API_URL}/mobile_api/FlatsAPI/";
  //     String url = "$urlValue/mobile_api/FlatsAPI/";

  //   try {
     
  //     final response = await http.post(url , headers: {'Authorization':'token $value','Society-id': '$society_value',}); 
  //     print('getEmployees new Response: ${response.body}');
      
      
  //     if (200 == response.statusCode) {
  //     Map<String, dynamic> map = json.decode(response.body);
  //     print("map ${map['is_success']}");
  //     List<dynamic> flatLines = map['data'];
  //     List<Map<String, dynamic>> flatList =[];
  //     flatLines.forEach((lines){
  //       Map<String, dynamic> map={
  //         "owner":lines['owner'],
  //         "number":lines['number'],
  //         "pk":lines['pk'],
  //         "area":lines['area'],
  //         "registration_number":lines['registration_number'],
  //         "registration_date":lines['registration_date'],
  //         "wing":lines['wing'],
  //         "is_allocated":lines['is_allocated'],          

  //       };
  //       flatList.add(map);
  //     });

  //     setState(() {
  //       flat = flatList;
  //       _flatFilter = flatList;
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
        
      child:DataTable(
      //  sortAscending: sort,
      // sortColumnIndex: 2,
      // columnSpacing: 10.0,
      sortColumnIndex: 2,
      columnSpacing: 8.0,
      columns: [
        
        DataColumn(
          label: Text("Owner", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          
        ),

        DataColumn(
          label: Text("No.", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          
        ),

        DataColumn(
          label: Text("Wing", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
         
        ),

        DataColumn(
          label: Text("Reg.No.", style: TextStyle(color: Colors.blueAccent , fontSize: 16.0),),
          numeric: false,
          
        ),

        

               
      ],
      rows:flatsDataFilter
            .map(
              (flats)=>DataRow(
                cells: [
                  DataCell(
                    Text(flats['owner'].toString()),    //  maintenance.firstName
                    onTap: (){
                      print("Row tab pk no. ${flats['pk']}");
                    }
                  ),

                   DataCell(
                    Text(flats['number'].toString()),
                  ),

                  
                   DataCell(
                    Text(flats['wing'].toString()),
                  ),

                   DataCell(
                    Text(flats['registration_number'].toString()),
                  ),

                                    
                ] 
              ),
            ).toList(),
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
          hintText: 'Filter By Name',
        ),
        onChanged: (string){
          _debouncer.run((){
            setState(() {
              flatsDataFilter = flatsData
              .where((u)=> (u['owner'].contains(string)) || u['owner'].contains(string)).toList();
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
        title: Text("Flats"),
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

        // body: Column(
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

       body: Container(

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