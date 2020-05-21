import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';
import 'package:housing_society_management/controller/databasehelper.dart';
import 'package:housing_society_management/globals.dart' as globals;



class NetworkUtils {
  

  //DatabaseHelper _databaseHelper=new DatabaseHelper();
  var status;
  //var urBase="ip";

  Future getUrl() async {
    final prefs = await SharedPreferences.getInstance();
     
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ) ?? 0;
      return urlValue;
  }

  // static final String host = productionHost;
	// static final String productionHost = 'https://authflow.herokuapp.com';
	// static final String developmentHost = 'http://192.168.31.110:3000';

	static dynamic authenticateUser(String userName, String password) async {//String email, String password
		//var uri = host + AuthUtils.endPoint;

      final prefs = await SharedPreferences.getInstance();
     
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ) ?? 0;

    //var uri="http://192.168.0.114:8000/mobile_api/api-token-auth/";

    var uri="${urlValue}/mobile_api/api-token-auth/";

		try {
			final response = await http.post(
				uri,
				
        headers: {
          'Accept':'application/json'
        },
        body: {

          "username": "$userName",
          "password" : "$password"
        }
			);

			final responseJson = json.decode(response.body);
			return responseJson;

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  // setIp(var ip){
  //   final ur = 'http://$ip';
  //   urBase=ur;
    
  //   print("setIP: $urBase");
  // }
 
  static authenticateIP(var ipAddress) async {
    //final  ur1 = 'http://$ipAddress';
     
    // urBase=ur;
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = 'Base_URL';
    final  urlValue = 'http://$ipAddress';//;
    prefs.setString(baseUrl, urlValue);
    print("this is save ip address $urlValue");
   
  }

	static logoutUser(BuildContext context, SharedPreferences prefs) {
		prefs.setString(AuthUtils.authTokenKey, null);
		prefs.setInt(AuthUtils.society_id, null);
		prefs.setInt(AuthUtils.flat_ids, null);

    DatabaseHelper _databaseHelper=new DatabaseHelper();
    _databaseHelper.save(AuthUtils.authTokenKey);
    _databaseHelper.saveDetails(AuthUtils.society_id, AuthUtils.flat_ids);

		Navigator.of(context).pushReplacementNamed('/');
	}

	static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
		scaffoldKey.currentState.showSnackBar(
			new SnackBar(
				content: new Text(message ?? 'You are offline'),
			)
		);
	}

	static fetch(var authToken, var endPoint, var _society_id, var _flat_ids) async {
    // var _society_id;
    // var _flat_ids;
    print("society $_society_id");
    final prefs = await SharedPreferences.getInstance();
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ) ?? 0;

		//var uri = host + endPoint;
      var uri="${urlValue}/${endPoint}/";
		try {
			final response = await http.post(
				uri,
				headers: {
					'Authorization': 'token $authToken',
          'Society-id': '$_society_id',
          //'flat_ids': '$_flat_ids',
				},
			);print("response ${response.statusCode}");
      if(response.statusCode==200){
        final responseJson = json.decode(response.body);
			return responseJson;
      }else{
        return null;
      }
			

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  static fetchViews(var authToken, var endPoint, var pk, var idType) async {
    
    final prefs = await SharedPreferences.getInstance();
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ) ?? 0;

      var uri="${urlValue}/${endPoint}/";
		try {
			final response = await http.post(
				uri,
				headers: {
					'Authorization': 'token $authToken',
          '$idType': '$pk',   //Maintenance-id
				},
			);
      if(response.statusCode==200){
        final responseJson = json.decode(response.body);
			return responseJson;
      }else{
        return null;
      }
			

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  static addData(var authToken, var endPoint, var complainName, var complainType , var complainComment) async {
    
    final prefs = await SharedPreferences.getInstance();
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ) ?? 0;

      var uri="${urlValue}/${endPoint}/";
		try {
			final response = await http.put(
				uri,
				headers: {
					'Authorization': 'token $authToken',
          
				},
        body: {

           "name": "$complainName",
          "complaint_type": "$complainType",
          "comment" : "$complainComment"
        }
			);
      
      print("status code: ${response.statusCode}");
      if(response.statusCode==200){
        final responseJson = json.decode(response.body);
			return responseJson;
      }else{
        return null;
      }
			

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

}

