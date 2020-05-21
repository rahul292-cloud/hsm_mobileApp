import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_society_management/accounting/accounting.dart';
import 'package:housing_society_management/flats/flats.dart';
import 'package:housing_society_management/helpDesk/helpDesk.dart';
import 'package:housing_society_management/maintenance/maintenance.dart';
import 'package:housing_society_management/members/members.dart';
import 'package:housing_society_management/notice/notice.dart';
import 'package:housing_society_management/purchaseOrder/purchaseOrder.dart';
import 'package:housing_society_management/vehicleParking/vehicleParking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class HomePageContent extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _HomePageContent();
  }
}

class _HomePageContent extends State<HomePageContent> {

//   Material myItems(IconData icon, String heading, int color){
//     return Material(
//       color: Colors.white,
//       elevation: 14.0,
//       shadowColor: Color(0x802196F3),
//       borderRadius: BorderRadius.circular(24.0),
      
//       // child: GestureDetector(
//       //   onTap: (){
//       //     if(heading=="Maintenance")
//       //               {
//       //                 print("note icon tab! ");
//       //                 Navigator.of(context).push(MaterialPageRoute(
//       //                builder: (BuildContext contex) =>   Maintenance()));
//       //               }
//       //               else if(icon==Icons.info){
//       //                 print("info icon tab");
//       //               }
//       //   },
        
//       child:
//       Center(
//         child: Padding(
//           padding: const EdgeInsets.all(5.0),  // 0.8
          
//           child:Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 //color: Colors.red,
//                // borderRadius: BorderRadius.circular(24.0),
//               child:Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
                  
//                   // for Text or heading 

//                  // Center(
//                   //  child:
//                     Padding(
//                     padding: const EdgeInsets.all(8.0),
//                   child:Text(heading, style: TextStyle(
//                     color: Color(color),
//                     fontSize: 20.0,
                    
//                   ))
//               ),
//               //),

//           //  for Icon 
//               GestureDetector(
//                 onTap: (){
//                   if(icon==Icons.note)
//                     {
//                       print("note icon tab! ");
//                       //Navigator.of(context).pop();
//                       Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext contex) =>   Maintenance()));
//                     }
//                     else if(icon==Icons.info){
//                       print("info icon tab");
//                       Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext contex) =>   Notice()));
//                     }
//                 },
               
//                 child:
              
//               Material(
//                 color: Color(color),
//                 borderRadius: BorderRadius.circular(24.0),
//                 child: GestureDetector(
//                   onTap: (){
//                    // print("Button Tab !");
//                     if(icon==Icons.note)
//                     {
//                       print("note icon tab! ");
//                       Navigator.of(context).push(MaterialPageRoute(
//                      builder: (BuildContext contex) =>   Maintenance()));
//                     }
//                     else if(icon==Icons.info){
//                       print("info icon tab");
//                     }
//                     else if(icon==Icons.group){
//                       print("group icon tab");
//                     }
//                     else if(icon==Icons.account_balance){
//                       print("account_balance icon tab");
//                     }
//                     else if(icon==Icons.description){
//                       print("description icon tab");
//                     }
//                     else if(icon==Icons.local_hotel){
//                       print("local_hotel icon tab");
//                     }
//                     else if(icon==Icons.help_outline){
//                       print("help_outline icon button tab");
//                     }
//                   },
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Icon(
//                     icon,
//                     color: Colors.white,
//                     size: 35.0,
//                   ),
//                 ),
//               )
//               ),
//               ),

//                 ],
//               ),
//           ),
//             ],
//           ),
        
//         ),),
//       //),
//     );
//   }

// @override 
// Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text("Home"),
//       // ),
//       body: StaggeredGridView.count(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12.0,
//         mainAxisSpacing: 12.0,
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         children: <Widget>[
//           myItems(Icons.note, "Maintenance", 0xFFAA00FF),
//           myItems(Icons.info, "Notice", 0xFF42A5F5),
//           myItems(Icons.group, "Members", 0xFF42A5F5),
//           myItems(Icons.account_balance, "Accounting", 0xFF42A5F5),
//           myItems(Icons.description, "Purchase", 0xFF42A5F5),
//           myItems(Icons.local_hotel, "Flats",0xFFAA00FF),
//           myItems(Icons.help_outline, "HelpDesk", 0xffed622b),
//         ],
//         staggeredTiles: [
//           StaggeredTile.extent(2, 120.0), // 120.0
//           StaggeredTile.extent(1, 120.0),  // 150
//           StaggeredTile.extent(1, 120.0),
//           StaggeredTile.extent(1, 120.0),
//           StaggeredTile.extent(1, 120.0),
//           StaggeredTile.extent(2, 120.0),
//           StaggeredTile.extent(2, 120.0),
//         ],
//       ),
//     );
    
// }

// new 

@override
  Widget build(BuildContext context) {
    // status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff333), // status bar color
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(//backgroundColor: Color(0xff39687e), 
        body: Container( //SafeArea
      child: Container(color: Color(0xFFEFF4F7),//color: Color(0xff39687e),
      child:
      SingleChildScrollView(
      child:Center(
        child:Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),//EdgeInsets.fromLTRB(0, 10, 0, 20),
          
          child: Column(children: [
            Padding(padding: EdgeInsets.fromLTRB(0.0,0.0, 0.0, 10.0),//EdgeInsets.fromLTRB(40.0,0.0, 40.0, 10.0),
              child:
            Container(color: Colors.white,height: 70.0,width: AppBar().preferredSize.width,
            
            child:Padding(padding: EdgeInsets.fromLTRB(22.0,0.0, 22.0, 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Society name ",style: TextStyle(fontSize: 22.0),),
                  subtitle: Text("Society Address",style: TextStyle(fontSize: 16.0),),
                )
              ],
            ),
            ),
            ),
            ),

            // Padding(padding: EdgeInsets.fromLTRB(43.0,0.0, 40.0, 10.0),
            //  // child:
            // //Container(color: Colors.indigoAccent,height: 70.0,
            // child: Row(
            //   children: <Widget>[
            //       Container(color: Color(0xff39687e),height: 50.0,width: 43.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0,bottom: 0.0),
            //       child: Icon(Icons.home,color: Colors.white,)
            //       )
            //       ),
            //       Container(color: Colors.white,height: 50.0,width: 83.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 5.0,right: 0.0,top: 0.0,bottom: 0.0),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
                      
            //           Text("TOTAL\nFLATS"),
            //           Text("12",style: TextStyle(fontWeight: FontWeight.bold),),
            //         ],
            //       )
            //       ),
            //     ),
            //     Container(width: 20.0,color: Colors.grey,),
            //     Container(color: Colors.blueAccent,height: 50.0,width: 43.0,
            //     child:Padding(
            //       padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0,bottom: 0.0),
            //       child: Icon(Icons.thumb_up,color: Colors.white)
            //       )
            //     ),
            //     Container(color: Colors.white,height: 50.0,width: 83.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 5.0,right: 0.0),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text("ALLOCATED\nFLATS"),
            //           Text("12",style: TextStyle(fontWeight: FontWeight.bold),),
            //         ],
            //       )
            //       ),
            //     ),
                
            //   ],
            // ),

            // //)
            // ),

            // Padding(padding: EdgeInsets.fromLTRB(43.0,0.0, 40.0, 10.0),
            //  // child:
            // //Container(color: Colors.indigoAccent,height: 70.0,
            // child: Row(
            //   children: <Widget>[
            //       Container(color: Colors.orangeAccent,height: 50.0,width: 43.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0,bottom: 0.0),
            //       child: Icon(Icons.group,color: Colors.white,)
            //       )
            //       ),
            //       Container(color: Colors.white,height: 50.0,width: 83.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 5.0,right: 0.0,top: 6.0,bottom: 6.0),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
                      
            //           Text("MEMBERS"),
            //           Text("12",style: TextStyle(fontWeight: FontWeight.bold),),
            //         ],
            //       )
            //       ),
            //     ),
            //     Container(width: 20.0,color: Colors.grey,),
            //     Container(color: Colors.red,height: 50.0,width: 43.0,
            //     child:Padding(
            //       padding: EdgeInsets.only(left: 0.0,right: 0.0,top: 0.0,bottom: 0.0),
            //       child: Icon(Icons.star,color: Colors.white)
            //       )
            //     ),
            //     Container(color: Colors.white,height: 50.0,width: 83.0,
            //       child:Padding(
            //       padding: EdgeInsets.only(left: 5.0,right: 0.0,top: 6.0,bottom: 6.0),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text("STARS"),
            //           Text("500",style: TextStyle(fontWeight: FontWeight.bold),),
            //         ],
            //       )
            //       ),
            //     ),
                
            //   ],
            // ),
            // ),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                //Container(color: Colors.green,height: 20.0,),
                Item(title: 'Members', icon: Icons.group, color: 0xFFC6FF00),
                Item(title: 'Maintenance', icon: Icons.note, color: 0xffFD637B),
                Item(
                    title: 'Notice',
                    icon: Icons.info,
                    color: 0xff21CDFF),
                Item(title: 'Helpdesk', icon: Icons.help, color: 0xff7585F6),
                Item(title: 'Flats', icon: Icons.room, color: 0xFFFFAB91),
                Item(title: 'Parking', icon: Icons.local_parking, color: 0xFFAB47BC),
                Item(title: 'Accounting', icon: Icons.account_box, color: 0xff7585F6),
                Item(title: 'Purchase', icon: Icons.description, color: 0xFFF9A825)
              ],
            ),
          ]))
      ),
        ),
    )),
    );
  }

}

class Item extends StatelessWidget {
  final String title;
  final dynamic icon;
  final dynamic color;

  Item({this.title, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (screenWidth - 45 - 17) / 2.3,
      height: (screenWidth - 45 - 17 - 30) / 2.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(color),
      ),
      child:GestureDetector(
        onTap: (){
          if(icon==Icons.group){
           print("members button tab");
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) =>
                        Members())); 
          }
          else if(icon==Icons.note){
            print("Maintenance button tab");
            //Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) =>
                        Maintenance())); 
          }
          else if(icon==Icons.info){
            print("Notice button tab");
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Notice()));
          }
          else if(icon==Icons.help){
            print("helpdesk button tab");
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => HelpDesk()));
          }
          else if(icon==Icons.account_box){
            print("Accounting button tab");
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Accounting()));
          }
          else if(icon==Icons.room){
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => Flats()));
          }
          else if(icon==Icons.local_parking){
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => VehicleParking()));
          }
          else if(icon==Icons.description){
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext contex) => PurchaseOrder()));
          }
          
        },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Icon(icon, size: 45, color: Colors.white),
          margin: EdgeInsets.only(bottom: 10),
        ),
        Text(title,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))
      ]),
    ),
    
    );
  }
}