import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/controller/databasehelper.dart';
  

class AuthUtils {

DatabaseHelper _databaseHelper=new DatabaseHelper();  

	//static final String endPoint = '/api/v1/auth_user';

	// Keys to store and fetch data from SharedPreferences
	static final String authTokenKey = 'auth_token';
	static final String society_id = 'society_id';//String
	static final String flat_ids = 'flat_ids'; // String
	static final String roleKey = 'role';

	static String getToken(SharedPreferences prefs) {
		return prefs.getString(authTokenKey);
	}

	static insertDetails(SharedPreferences prefs, var response) {
		prefs.setString(authTokenKey, response['token']);
		prefs.setInt(society_id, response["society_id"][0]);  //setInt
		prefs.setInt(flat_ids, response["flat_ids"][0]);
    
	}
	
}