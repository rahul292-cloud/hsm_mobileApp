import 'package:flutter/material.dart';

class IpAddressField extends StatelessWidget {
	final TextEditingController setIPAddressController;
	final String ipError;
  IpAddressField({this.setIPAddressController, this.ipError});//, this.userError
  
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
			    controller: setIPAddressController,
			    decoration: new InputDecoration(
						contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
				    errorText: ipError,
				    labelText: 'set IP Address',
			    )
		    )
	    )
    );
  }
	
}