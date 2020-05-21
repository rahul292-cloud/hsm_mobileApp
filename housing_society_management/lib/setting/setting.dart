import 'package:flutter/material.dart';
import 'package:housing_society_management/app/pages/home_page.dart';
import 'package:housing_society_management/app/utils/auth_utils.dart';
import 'package:housing_society_management/app/utils/network_utils.dart';
import 'package:housing_society_management/image.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


// class Setting extends StatefulWidget {  // UploadImageDemo
//   Setting() : super();

//   final String title = "Upload Image Demo";

//   @override
//   SettingState createState() => SettingState();
// }

// class SettingState extends State<Setting> {
//   //
//   static final String uploadEndPoint =
//       'http://localhost/flutter_test/upload_image.php';
//   Future<File> file;
//   String status = '';
//   String base64Image;
//   File tmpFile;
//   String errMessage = 'Error Uploading Image';

//   chooseImage() {
//     setState(() {
//       file = ImagePicker.pickImage(source: ImageSource.gallery);
//     });
//     setStatus('');
//   }

//   setStatus(String message) {
//     setState(() {
//       status = message;
//     });
//   }

//   startUpload() {
//     setStatus('Uploading Image...');
//     if (null == tmpFile) {
//       setStatus(errMessage);
//       return;
//     }
//     String fileName = tmpFile.path.split('/').last;
//     upload(fileName);
//   }

//   upload(String fileName) {
//     http.post(uploadEndPoint, body: {
//       "image": base64Image,
//       "name": fileName,
//     }).then((result) {
//       setStatus(result.statusCode == 200 ? result.body : errMessage);
//     }).catchError((error) {
//       setStatus(error);
//     });
//   }

//   Widget showImage() {
//     return FutureBuilder<File>(
//       future: file,
//       builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             null != snapshot.data) {
//           tmpFile = snapshot.data;
//           base64Image = base64Encode(snapshot.data.readAsBytesSync());
//           return Flexible(
//             child: Image.file(
//               snapshot.data,
//               fit: BoxFit.fill,
//             ),
//           );
//         } else if (null != snapshot.error) {
//           return const Text(
//             'Error Picking Image',
//             textAlign: TextAlign.center,
//           );
//         } else {
//           return const Text(
//             'No Image Selected',
//             textAlign: TextAlign.center,
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Settings"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             OutlineButton(
//               onPressed: chooseImage,
//               child: Text('Choose Image'),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             showImage(),
//             SizedBox(
//               height: 20.0,
//             ),
//             OutlineButton(
//               onPressed: startUpload,
//               child: Text('Upload Image'),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//             Text(
//               status,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.green,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 20.0,
//               ),
//             ),
//             SizedBox(
//               height: 20.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// setting views

class Setting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    
    return _SettingState();
  }
}
class _SettingState extends State<Setting>{

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences _sharedPreferences;

  bool ck_login=false;

@override
	void initState() {
		super.initState();
    setState(() {
      ck_login=false;
    });
		//_fetchSessionAndNavigate();
     //userData();

	}

  	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		
		String authToken = AuthUtils.getToken(_sharedPreferences);
		if(authToken != null) {
      print("this is authtoken");
			// Navigator.of(_scaffoldKey.currentContext)
			// 	.pushReplacementNamed('SettingView.routeName');
		} 
	}

  _logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return Container(
           child: Padding(
             padding: EdgeInsets.all(8.0),
             child: Column(
               children: <Widget>[
                 SizedBox(height:15.0),
                 GestureDetector(
                   onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                       builder: (BuildContext context)=>ImageStyle()
                     ));
                   },
                   child:
                 Row(
                   //crossAxisAlignment: CrossAxisAlignment.end,

                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     //Icon(Icons.edit),
                     Text("Change Profile Picture",style: TextStyle(fontSize: 22.0),),
                     Icon(Icons.arrow_right,size: 25.0, color:Colors.grey[300],),
                   ],
                   
                 ),
                 ),
                 SizedBox(height:15.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Container(height: 1.5,color: Colors.grey[300],),
                ),

                   SizedBox(height:8.0),
                 GestureDetector(
                   onTap: (){
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //    builder: (BuildContext context)=>ImageStyle()
                    //  ));
                   },
                   child:
                 Row(
                   //crossAxisAlignment: CrossAxisAlignment.end,

                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     //Icon(Icons.edit),
                     Text("Change User Name",style: TextStyle(fontSize: 22.0),),
                     Icon(Icons.arrow_right,size: 25.0, color:Colors.grey[300],),
                   ],
                   
                 ),
                 ),

                 SizedBox(height:15.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Container(height: 1.5,color: Colors.grey[300],),
                ),

                   SizedBox(height:15.0),
                 GestureDetector(
                   onTap: (){
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //    builder: (BuildContext context)=>ImageStyle()
                    //  ));
                   },
                   child:
                 Row(
                   //crossAxisAlignment: CrossAxisAlignment.end,

                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     //Icon(Icons.edit),
                     Text("Change Password",style: TextStyle(fontSize: 22.0),),
                     Icon(Icons.arrow_right,size: 25.0, color:Colors.grey[300],),
                   ],
                   
                 ),
                 ),
                //  SizedBox(height:15.0),
                // Padding(
                //   padding: EdgeInsets.only(left: 15.0,right: 15.0),
                //   child: Container(height: 1.5,color: Colors.grey[300],),
                // ),

                //    SizedBox(height:15.0),
                //  GestureDetector(
                //    onTap: (){
                
                    
                //     _logout();
                //    },
                //    child:
                //  Row(
                //    //crossAxisAlignment: CrossAxisAlignment.end,

                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //    children: <Widget>[
                //      //Icon(Icons.edit),
                //      Text("Logout",style: TextStyle(fontSize: 22.0),),
                //      Icon(Icons.arrow_right,size: 25.0, color:Colors.grey[300],),
                //    ],
                   
                //  ),
                //  ),
                 SizedBox(height:15.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Container(height: 1.5,color: Colors.grey[300],),
                )

               ],
             ),
           ),
          );
        },
      ),
    );
    
  }
}




// =======================================  upload to server

// import 'package:flutter/material.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:dio/dio.dart';



// class Setting extends StatefulWidget {
//   //Setting({Key key, this.title}) : super(key: key);

//   //final String title;

//   @override
//   _SettingState createState() => _SettingState();
// }

// class _SettingState extends State<Setting> {
//   bool select=false;
//   File _loadImage;
//   var image;
//   final GlobalKey<ScaffoldState> _scaffoldstate =
//       new GlobalKey<ScaffoldState>();

  

//   Future getImage(ImageSource source) async {
//     image = await ImagePicker.pickImage(source: source);//ImageSource.gallery
//     // _uploadFile(image);

//     File croppedFile = await ImageCropper.cropImage(
//       sourcePath: image.path,
//       //  ratioX: 1.0,
//       //  ratioY: 1.0,
//       maxWidth: 512,
//       maxHeight: 512,
//     );

//     var result = await FlutterImageCompress.compressAndGetFile(
//       croppedFile.path,
//       //croppedFile.path,
//       image.path,
//       quality: 60,
//     );
    

//     setState(() {
//      // _loadImage = image;
//       _loadImage = result;
//       _loadImage==null?select=false:select=true;
//     });
//   }

  
//   void _uploadFile(filePath) async {
//     // Get base file name
//     String fileName = basename(filePath.path);
//     print("File base name: $fileName");

//     try {
//       FormData formData =
//           new FormData.from({"file": new UploadFileInfo(filePath, fileName)});

//       Response response =
//           await Dio().post("http://192.168.0.101/saveFile.php", data: formData);
//       print("File upload response: $response");

//       // Show the incoming message in snakbar
//       _showSnakBarMsg(response.data['message']);
//     } catch (e) {
//       print("Exception Caught: $e");
//     }
//   }

  
//   void _showSnakBarMsg(String msg) {
//     _scaffoldstate.currentState
//         .showSnackBar(new SnackBar(content: new Text(msg)));
//   }

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       select=false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       key: _scaffoldstate,
//       appBar: AppBar(
        
//         //title: Text(widget.title),
//         title: Text("Select Image"),
//         // title: select?
//         // IconButton(icon:Icon(Icons.check),
//         //   onPressed: (){
//         //     _uploadFile(image);
//         //   },
//         //   ):Text("Select Image")

//       ),
//       body: Center(
        
//         child: _loadImage == null ? Text('Select Image ') 
//         : Image.file(
          
//           _loadImage,
//           height: 320.0,
          
//           ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: getImage,
//       //   tooltip: 'Increment',
//       //   child: Icon(Icons.add),
//       // ),
      
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           select?FloatingActionButton.extended(
//             label: Text("Set"),
//             onPressed: () => _uploadFile(image),//getImageFile(ImageSource.camera),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.check),
//           ):
//           // SizedBox(
//           //   width: 20,
//           // ),

//           Row(
//             children: <Widget>[
//               SizedBox(
//             width: 20,
//           ),
//               FloatingActionButton.extended(
//             label: Text("Camera"),
//             onPressed: () => getImage(ImageSource.camera),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.camera),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           FloatingActionButton.extended(
//             label: Text("Gallery"),
//             onPressed: () => getImage(ImageSource.gallery),//ImageSource.gallery
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.photo_library),
//           )
//             ],
//           )
          
//         ],
//       ),
//     );
//   }
// }