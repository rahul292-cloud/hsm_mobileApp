import 'dart:async';
import 'package:flutter/material.dart';
import 'package:housing_society_management/app/components/ipAddress_field.dart';
import 'package:housing_society_management/app/components/ip_button.dart';
import 'package:housing_society_management/app/components/user_field.dart';
import 'package:housing_society_management/app/components/error_box.dart';
import 'package:housing_society_management/app/components/login_button.dart';
import 'package:housing_society_management/app/components/password_field.dart';
import 'package:housing_society_management/app/pages/home_page.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/app/validators/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_society_management/globals.dart' as globals;
import 'package:housing_society_management/constants.dart';


class LoginPage extends StatefulWidget {
  


	@override
	LoginPageState createState() => new LoginPageState();

}

class LoginPageState extends State<LoginPage> {

  
  //NetworkUtils network=new NetworkUtils();
  
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
	SharedPreferences _sharedPreferences;
	bool _isError = false;
	bool _obscureText = true;
	bool _isLoading = false;
	TextEditingController _userNameController, _passwordController , _setIPAddressController;
	String _errorText, _userError, _passwordError, _ipError;
  bool _loadHome=true;//added

  // final TextEditingController ipController =
  //     TextEditingController();

	@override
	void initState() {
		super.initState();
    
    setState(() {//added
      _loadHome=true;
    });
		_fetchSessionAndNavigate();
		_userNameController = new TextEditingController();
		_passwordController = new TextEditingController();
    _setIPAddressController = new TextEditingController();
    _checkUrl();
	}

  _checkUrl() async {
    
    
    final prefs = await SharedPreferences.getInstance();
      final baseUrl = 'Base_URL';
      final urlValue = prefs.get(baseUrl ); //?? 0;
      print("url : $urlValue");
      //globals.ur=urlValue;
     // print("global url ${globals.ur}");
  }

	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String authToken = AuthUtils.getToken(_sharedPreferences);
		if(authToken != null) {
			Navigator.of(_scaffoldKey.currentContext)
				.pushReplacementNamed(HomePage.routeName);
		}
    else{  // added
      setState(() {
        _loadHome=false;
      });
    }
	}

	_showLoading() {
		setState(() {
		  _isLoading = true;
		});
	}

	_hideLoading() {
		setState(() {
		  _isLoading = false;
		});
	}

  _authenticateIP() {
    _showLoading();
    if(_validIP()){
      //network.setIp(_setIPAddressController.text);
      //A(_setIPAddressController.text);
      
      
      NetworkUtils.authenticateIP(null);
      NetworkUtils.authenticateIP(
				_setIPAddressController.text
			);
      _hideLoading();
    }
    
  }

  _validIP(){
    bool valid = true;
    if(_setIPAddressController.text.isEmpty){
      valid=false;
      _ipError="IP can't be blank";
    }
    return valid;
  }

	_authenticateUser() async {
		_showLoading();
		if(_valid()) {
			var responseJson = await NetworkUtils.authenticateUser(
				_userNameController.text, _passwordController.text
			);

			print("Last response $responseJson");

			if(responseJson == null) {

				NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

			} else if(responseJson == 'NetworkError') {

				NetworkUtils.showSnackBar(_scaffoldKey, null);

			} else if(responseJson['errors'] != null) {

				NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password');

			}else if(responseJson['non_field_errors'] != null) {

				NetworkUtils.showSnackBar(_scaffoldKey, 'Invalid Email/Password'); 
      }
      else {

				AuthUtils.insertDetails(_sharedPreferences, responseJson);
				/**
				 * Removes stack and start with the new page.
				 * In this case on press back on HomePage app will exit.
				 * **/
				Navigator.of(_scaffoldKey.currentContext)
					.pushReplacementNamed(HomePage.routeName);

			}
			_hideLoading();
		} else {
			setState(() {
				_isLoading = false;
				_userError;
				_passwordError;
        _ipError;
			});
		}
	}

	_valid() {
		bool valid = true;

		if(_userNameController.text.isEmpty) {
			valid = false;
			_userError = "Email can't be blank!";
		} 
    // else if(!_emailController.text.contains(EmailValidator.regex)) {
		// 	valid = false;
		// 	_emailError = "Enter valid email!";
		// }

		if(_passwordController.text.isEmpty) {
			valid = false;
			_passwordError = "Password can't be blank!";
		} 
    // else if(_passwordController.text.length < 6) {
		// 	valid = false;
		// 	_passwordError = "Password is invalid!";
		// }

    
		return valid;
	}

	Widget _loginScreen() {
		return new Container(
			child: new ListView(
				padding: const EdgeInsets.only(
					top: 15.0,
					left: 16.0,
					right: 16.0
				),
				children: <Widget>[
					new ErrorBox(
						isError: _isError,
						errorText: _errorText
					),
					new UserField(
						userNameController: _userNameController,
						userError: _userError
					),
					new PasswordField(
						passwordController: _passwordController,
						obscureText: _obscureText,
						passwordError: _passwordError,
						togglePassword: _togglePassword,
					),
					new LoginButton(onPressed: _authenticateUser),

          new IpAddressField(
            setIPAddressController: _setIPAddressController,
            ipError:_ipError,
          ),
          new IpAddressButton(onPressed: _authenticateIP),
				],
			),
		);
	}

	_togglePassword() {
		setState(() {
			_obscureText = !_obscureText;
		});
	}

	Widget _loadingScreen() {
		return new Container(
			margin: const EdgeInsets.only(top: 100.0),
			child: new Center(
				child: new Column(
					children: <Widget>[
						new CircularProgressIndicator(
							strokeWidth: 4.0
						),
						new Container(
							padding: const EdgeInsets.all(8.0),
							child: new Text(
								'Please Wait',
								style: new TextStyle(
									color: Colors.grey.shade500,
									fontSize: 16.0
								),
							),
						)
					],
				)
			)
		);
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
			//body: _isLoading ? _loadingScreen() : _loginScreen()
      body: _loadHome?_loadingScreen():_isLoading ? _loadingScreen() : _loginScreen() // added
		);
	}

}