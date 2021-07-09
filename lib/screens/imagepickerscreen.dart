
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/provider.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class pickerimagescreen extends StatelessWidget {

  @override
  double width;
  double height;
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatSupportProvider>(context,listen: false);
    width=MediaQuery.of(context).size.width;
    height=MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,

        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: <Widget>[

              Positioned(
                top: 11,
                child: Row(

                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,),color: Colors.white,),
                    SizedBox(
                      width: width*0.08,
                      //width: width*0.03,
                      child: CircleAvatar(backgroundColor: Colors.red,),
                    ),
                    Container(child: Text('  Abdul Monem',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),)
                  ],
                ),
              ),
              Container(
               // color: Colors.black,
                width: width*1,
                height: height*1,
                child: Image.file(provider.filePath),
              ),
              Positioned(



                bottom: 11,
                child: Row(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.add_box,size: 28,color: Colors.purpleAccent,)),

                    Container(

                     // color: Colors.white,
                        width: width*0.7,
                      //  height: height*0.2,
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              filled: true,

                              fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'Enter your name',

                          ),

                        )),
                    IconButton(onPressed: (){}, icon: Icon(Icons.send,color: Colors.blue,))
                  ],
                ),
              ),

            ],

          ),
        ));
  }
}
