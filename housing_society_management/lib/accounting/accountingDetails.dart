import 'package:flutter/material.dart';

class AccountingView extends StatefulWidget{
  var pk;
  AccountingView(this.pk);
  @override
  State<StatefulWidget> createState() {
    
    return AccountingViewState(pk);
  }
}

class AccountingViewState extends State<AccountingView>{
  var pk;
  AccountingViewState(this.pk);
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: 
      Text("Accounting Details"),
      
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
                        child: Text("This is Help desk name ",style: TextStyle(fontSize: 20.0),),
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
                      Text("This is Help desk Date",style: TextStyle(fontSize: 20.0),),
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
                      Text("This is Help desk Complain type",style: TextStyle(fontSize: 20.0),),
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
                      Text("This is Help desk Status",style: TextStyle(fontSize: 20.0),),
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
                      Text("This is Help desk Reply",style: TextStyle(fontSize: 20.0),),
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

                      Text("This is Help desk Comment ",style: TextStyle(fontSize: 20.0),),
                     
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