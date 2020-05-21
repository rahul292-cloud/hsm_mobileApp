import 'package:flutter/material.dart';

class UserField extends StatelessWidget {
	final TextEditingController userNameController;
	final String userError;
  UserField({this.userNameController, this.userError});
  
	@override
  Widget build(BuildContext context) {
    return new Container(
	    margin: const EdgeInsets.only(bottom: 16.0),
	    child: new Theme(
		    data: new ThemeData(
			    primaryColor: Theme.of(context).primaryColor,
			    textSelectionColor: Theme.of(context).primaryColor
		    ),
		    child: new TextField(
			    //keyboardType: TextInputType.emailAddress,
			    controller: userNameController,
			    decoration: new InputDecoration(
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
				    errorText: userError,
				    labelText: 'User Name',
			    )
		    )
	    )
    );
  }
	
}