import 'package:flutter/material.dart';

class MembersView extends StatefulWidget{
  var pk;
  MembersView(this.pk);
  @override
  State<StatefulWidget> createState() {
    
    return MembersViewState(pk);
  }
}

class MembersViewState extends State<MembersView>{
  var pk;
  MembersViewState(this.pk);
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: 
      Text("Members Details"),
      
      ),
      // body: SingleChildScrollView(
      //   child: 
        body:ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Container(
          //color: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              
              children: <Widget>[
                SizedBox(height: 15.0,),
                Container(
                  width: double.infinity,
                  height: 50.0,//color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Name:"),
                      SizedBox(height: 8.0,),
                      Expanded(child:
                      SingleChildScrollView(
                        child: Text("This is Member name ",style: TextStyle(fontSize: 20.0),),
                      )
                      // Text("This is Help desk name",style: TextStyle(fontSize: 20.0),),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Date:"),
                      SizedBox(height: 8.0,),
                      Text("This is member Date",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Complain Type:"),
                      SizedBox(height: 8.0,),
                      Text("This is Help member Complain type",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 50.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Status:"),
                      SizedBox(height: 8.0,),
                      Text("This is member Status",style: TextStyle(fontSize: 20.0),),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 80.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Reply:"),
                      SizedBox(height: 8.0,),
                      Expanded(child:
                      SingleChildScrollView(child:
                      Text("This is member Reply",style: TextStyle(fontSize: 20.0),),
                      ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 15.0,),
              Container(height: 2.0,color: Colors.grey,),
              SizedBox(height: 15.0,),
              Container(
                  width: double.infinity,
                  height: 120.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Comment:"),
                      SizedBox(height: 8.0,),
                      Expanded(
                      child: 
                      SingleChildScrollView(child:

                      Text("This is member Comment ",style: TextStyle(fontSize: 20.0),),
                     
                      ),   
                       
                      ),
                     
                    ],
                  )
                ),
              SizedBox(height: 15.0,),
              

              ],
            ),
          ),
        );
          }
        ),
        
        
      //),
      
    );
  }
}