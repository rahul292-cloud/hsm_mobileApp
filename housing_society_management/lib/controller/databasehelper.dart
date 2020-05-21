//import 'package:hsm/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper{

  //Urls url = new Urls();
  //String serverUrl = "http://192.168.0.111:8000";
   var status ;
  // var token ;
  

  //  loginData(String username , String password ) async{ // , String ipAddress
  //    //_saveURL(ipAddress);
  //    final prefs = await SharedPreferences.getInstance();
  //    final baseUrl = 'Base_URL';
  //    final urlValue = prefs.get(baseUrl ) ?? 0;
  //    final String myUrl = "$urlValue/mobile_api/api-token-auth/";
  //   //String myUrl = "${Urls.BASE_API_URL}/mobile_api/api-token-auth/"; 
  //   final response = await  http.post(myUrl,
  //       headers: {
  //         'Accept':'application/json'
  //       },
  //       body: {

  //         "username": "$username",
  //         "password" : "$password"
  //       } ) ;
  //   status = response.body.contains('error');

  //   var data = json.decode(response.body);
  //   print("login response $data");
  //   print("society ID: ${data["society_id"][0]}");
  //   print("society ID: ${data["flat_ids"][0]}");
  //   if(status){
  //     print('data : ${data["error"]}');
  //   }else{
  //     print('data : ${data["token"]}');   // token
  //     //_save(data["token"]);    // ,data["society_id"][0],data["flat_ids"][0]
  //     saveDetails(data["society_id"][0],data["flat_ids"][0]);
  //     print("key save successfully");
      
  //   }
  
  // }



  // final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //   String myUrl = "${Urls.BASE_API_URL}/mobile_api/UserAPI/"; // "${Urls.BASE_API_URL}/rest-auth/login/"; // "$serverUrl/rest-auth/login/";  //           //   $serverUrl/login
  // final response = await  http.post(myUrl,

  //       headers: {'Authorization':'Token $value'}
  //       // body: {

  //       //    //"email": "$email",
  //       //   // "username": "$username",
  //       //   // "password" : "$password"
  //       // } 
  //       ) ;
  //   status = response.body.contains('error');

  //   var data = json.decode(response.body);
  //   print(data);
  //   print(response.statusCode);
  //   print("new ");

  //   if(status){
  //     print('data : ${data["error"]}');
  //   }else{
  //     // ('data : ${data["token"]}');   // token
  //    print("success: ${data['data']}");
      
  //   }
  
  // }

  // addData(String complainName , String complainType, String complainComment) async{


  //    final prefs = await SharedPreferences.getInstance();
  //     final key = 'token';
  //     final value = prefs.get(key ) ?? 0;

  //     final baseUrl = 'Base_URL';
  //     final urlValue = prefs.get(baseUrl ) ?? 0;


  //   final String myUrl = "$urlValue/mobile_api/HelpDeskAPI/"; // "${Urls.BASE_API_URL}/rest-auth/login/"; // "$serverUrl/rest-auth/login/";  //           //   $serverUrl/login
  //   //String myUrl = "${Urls.BASE_API_URL}/mobile_api/HelpDeskAPI/";
  //    final response = await  http.put(myUrl,
  //       headers: {'Authorization':'token $value'},
  //       body: {
  //         "name": "$complainName",
  //         "complaint_type": "$complainType",
  //         "comment" : "$complainComment"
  //       } ) ;
  //   status = response.body.contains('error');

  //   var data = json.decode(response.body);
  //   print("complain test :$data");

  //   if(status){
  //     print('data : ${data["error"]}');
  //   }else{
  //     //print('data : ${data["token"]}');   // token
  //    // _save(data["token"]);             //  data["token"]
  //     print("complain submitted successfully");
      
  //   }
  
  // }


  //  registerData(String name ,String email , String password) async{

  //   String myUrl = "$serverUrl/register1";
  //   final response = await  http.post(myUrl,
  //       headers: {
  //         'Accept':'application/json'
  //       },
  //       body: {
  //         "name": "$name",
  //         "email": "$email",
  //         "password" : "$password"
  //       } ) ;
  //   status = response.body.contains('error');

  //   var data = json.decode(response.body);

  //   if(status){
  //     print('data : ${data["error"]}');
  //   }else{
  //     print('data : ${data["token"]}');
  //     _save(data["token"]);
  //   }

  // }


  // Future<List> getData() async{

  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key ) ?? 0;

  //   String myUrl = "$serverUrl/products/";
  //   http.Response response = await http.get(myUrl,
  //       headers: {
  //         'Accept':'application/json',
  //         'Authorization' : 'Bearer $value'
  //   });
  //   return json.decode(response.body);
  // }

  // void deleteData(int id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key ) ?? 0;

  //   String myUrl = "$serverUrl/products/$id";
  //   http.delete(myUrl,
  //       headers: {
  //         'Accept':'application/json',
  //         'Authorization' : 'Bearer $value'
  //   } ).then((response){
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }

  // void addData(String noticeName , String noticetype) async {    //  void
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key ) ?? 0;

  //   String myUrl = "http://192.168.0.111:8000/api/v1/notice/";   // $serverUrl/products   //  https://reqres.in/api/users
  //   http.post(myUrl,
  //       headers: {
  //         'Accept':'application/json',
  //          'Authorization' : "token $value",
  //       },
  //       body: {
  //         "title": "$noticeName",
  //         //"price" : "$price"
  //         "description" : "$noticetype"
  //       }).then((response){
        
  //     print('Response status aa : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }


  // void editData(int id,String name , String price) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.get(key ) ?? 0;

  //   String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/$id";
  //   http.put(myUrl,
  //       headers: {
  //         'Accept':'application/json',
  //         'Authorization' : 'Bearer $value'
  //       },
  //       body: {
  //         "name": "$name",
  //         "price" : "$price"
  //       }).then((response){
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });
  // }
    

   save(String token) async {  // , , String society_id, String flat_ids
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value); 
    print("token save in data base helper: $value");
  }



  // _save(String token) async {  // , , String society_id, String flat_ids
  //   final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = token;
  //   prefs.setString(key, value);
    
  // }

  saveDetails(var society_id, var flat_ids ) async {
     final prefs = await SharedPreferences.getInstance();
      prefs.setInt("society_id", society_id);
      prefs.setInt("flat_ids", flat_ids);
      print("Society id and flat id is save in database helper: $society_id and $flat_ids");
  }

  
  // saveURL(String ipAddress) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final baseUrl = 'Base_URL';
  //   final urlValue = ipAddress;
  //   prefs.setString(baseUrl, urlValue);
  //   print("this is save ip in data base address : $urlValue");

  // }

  // _saveURL(String ipAddress) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final baseUrl = 'Base_URL';
  //   final urlValue = ipAddress;
  //   prefs.setString(baseUrl, urlValue);
  // }

//  read() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'token';
//     final value = prefs.get(key ) ?? 0;
//     print('read : $value');
//   }

// static Future<String> deleteData(int pk) async{
//   try{
//     var map = Map<String, dynamic>();
//   }catch (e){
//     return "error";
//   }
// }
  
}


