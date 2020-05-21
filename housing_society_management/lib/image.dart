import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';



class ImageStyle extends StatefulWidget {
  //Setting({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _ImageStyleState createState() => _ImageStyleState();
}

class _ImageStyleState extends State<ImageStyle> {
  bool select=false;
  File _loadImage;
  var image;
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  

  Future getImage(ImageSource source) async {
    image = await ImagePicker.pickImage(source: source);//ImageSource.gallery
    // _uploadFile(image);

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      //  ratioX: 1.0,
      //  ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    // var result = await FlutterImageCompress.compressAndGetFile(
    //   croppedFile.path,
    //   //croppedFile.path,
    //   image.path,
    //   quality: 60,
    // );
    

    setState(() {
     // _loadImage = image;
      // _loadImage = result;
      _loadImage = croppedFile;
      _loadImage==null?select=false:select=true;
    });
  }

  
  void _uploadFile(filePath) async {
    // Get base file name
    String fileName = basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData =
          new FormData.from({"file": new UploadFileInfo(filePath, fileName)});

      Response response =
          await Dio().post("http://192.168.0.101/saveFile.php", data: formData);
      print("File upload response: $response");

      // Show the incoming message in snakbar
      _showSnakBarMsg(response.data['message']);
    } catch (e) {
      print("Exception Caught: $e");
      _showSnakBarMsg("Error");
    }
  }

  
  void _showSnakBarMsg(String msg) {
    _scaffoldstate.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      select=false;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        
        //title: Text(widget.title),
        title: Text("Select Image"),
        // title: select?
        // IconButton(icon:Icon(Icons.check),
        //   onPressed: (){
        //     _uploadFile(image);
        //   },
        //   ):Text("Select Image")

      ),
      body: Center(
        
        child: _loadImage == null ? Text('Select Image ') 
        : Image.file(
          
          _loadImage,
          height: 320.0,
          
          ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          select?FloatingActionButton.extended(
            label: Text("Set"),
            onPressed: () => _uploadFile(image),//getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.check),
          ):
          // SizedBox(
          //   width: 20,
          // ),

          Row(
            children: <Widget>[
              SizedBox(
            width: 20,
          ),
              FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => getImage(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => getImage(ImageSource.gallery),//ImageSource.gallery
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
            ],
          )
          
        ],
      ),
    );
  }
}


// ====================================

// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter/material.dart';

// class ImageStyle extends StatefulWidget {
//   @override
//   _ImageStyleState createState() => _ImageStyleState();
// }

// class _ImageStyleState extends State<ImageStyle> {
//   File _image;

//   getImageFile(ImageSource source) async {

//      //Clicking or Picking from Gallery 

//     var image = await ImagePicker.pickImage(source: source);

//     //Cropping the image

//     File croppedFile = await ImageCropper.cropImage(
//       sourcePath: image.path,
//       //  ratioX: 1.0,
//       //  ratioY: 1.0,
//       maxWidth: 512,
//       maxHeight: 512,
//     );

//     //Compress the image

//     var result = await FlutterImageCompress.compressAndGetFile(
//       croppedFile.path,
//       //croppedFile.path,
//       image.path,
//       quality: 60,
//     );

//     setState(() {
//       _image = result;
//       print(_image.lengthSync());
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(_image?.lengthSync());
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Click | Pick | Crop | Compress"),
//       ),
//       body: 
//       Center(
//         child: _image == null
//             ? Text("Image")
//             : Image.file(
//                 _image,
//                 height: 320,//200,
//                 width: 320,//200,
//               ),
//       ),
      
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton.extended(
//             label: Text("Set"),
//             onPressed: () => print('coll the method'),//getImageFile(ImageSource.camera),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.check),
//           ),
//           SizedBox(
//             width: 20,
//           ),


//           FloatingActionButton.extended(
//             label: Text("Camera"),
//             onPressed: () => getImageFile(ImageSource.camera),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.camera),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           FloatingActionButton.extended(
//             label: Text("Gallery"),
//             onPressed: () => getImageFile(ImageSource.gallery),
//             heroTag: UniqueKey(),
//             icon: Icon(Icons.photo_library),
//           )
//         ],
//       ),
//     );
//   }
// }



