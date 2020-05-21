// class Constants{
//   //var url="http:192.168.0.112:8000";
 
// }

// class Foo {
//   final int computed;
//   final int copy;

//   Foo._(this.computed, this.copy);

//   factory Foo() {
//     // calculate value
//     int value = 42;
//     return Foo._(value, value);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class B{
  static const p=10;
}

class A{
  
 final x;
 final y;
 //B b= new B();
 //final p=B.p;
 
 var storePreviousData;
 A(this.x) : y = x{
   print("x:$x");
   
   print("y:$y");
   
   //print("k:$k");
   if(y==null){
     //saveP(p);
     saveValue(storePreviousData);
   }
   else{
     final p=y;
     
     storePreviousData=p;
     //setIpLast(p);
     saveValue(storePreviousData);
   }
 }

 

setIpLast(final p) async {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = 'Base_URL';
      final  urlValue = 'http://$p';
      prefs.setString(baseUrl, urlValue);
      print("this is save ip address in constant (!null condition) $urlValue");

      
  }

saveValue(var storePreviousData){//, var storePreviousData1
  final value=storePreviousData!="null"?storePreviousData:"";
  if(storePreviousData==null||storePreviousData=="null"){
    //final value=storePreviousData;
   // return value;
    print("save value of ? when null :$value");
  }
  print("save value of ? :$value");
  // else{
    
  // }
}

  }
  
  
