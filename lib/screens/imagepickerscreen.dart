import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/provider.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class pickerimagescreen extends StatelessWidget {
  String imageurl;
  String myid;
  String otheremail;
  String otherid;
  String sender;

  pickerimagescreen({this.imageurl,this.myid,this.sender,this.otheremail,this.otherid});

  final id = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return xyzxyzxyzxyz(imageurl:imageurl,myid:myid,sender:sender,
        otherid:otherid,otheremail:otheremail);
  }
}

class xyzxyzxyzxyz extends StatefulWidget {
  String imageurl;
  String myid;
  String otheremail;
  String otherid;
  String sender;

  xyzxyzxyzxyz({@required this.imageurl,this.myid,this.sender,this.otheremail,this.otherid});

  @override
  _xyzxyzxyzxyzState createState() => _xyzxyzxyzxyzState();
}

class _xyzxyzxyzxyzState extends State<xyzxyzxyzxyz> {
  TextEditingController controller = new TextEditingController();

  @override
  double width;
  double height;

  Widget build(BuildContext context) {
    var provider = Provider.of<ChatSupportProvider>(context, listen: false);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.black,
        actions: [

         Container(
           margin: EdgeInsets.only(right: 172),
           child:  Row(
             children: [

               SizedBox(
                 width: width * 0.08,
                 //width: width*0.03,
                 child: CircleAvatar(
                   backgroundColor: Colors.red,
                 ),
               ),
               Container(
                 child: Text(
                  '  '+ widget.otheremail,
                   style: TextStyle(
                       fontWeight: FontWeight.bold, color: Colors.white),
                 ),
               )
             ],
           ),
         )

        ],
      ),
       // resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: <Widget>[

              Container(
                // color: Colors.black,
                width: width * 1,
                height: height * 1,
                child: Image.network(widget.imageurl),
              ),
              Positioned(
                bottom: 11,
                child: Row(
                  children: [
                    Container(width: 33,),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.add_box,
                    //       size: 28,
                    //       color: Colors.purpleAccent,
                    //     )),
                    Container(

                        // color: Colors.white,
                        width: width * 0.7,
                        //  height: height*0.2,
                        child: TextField(
                          controller: controller,

                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            hintText: 'Enter your Message',
                          ),
                        )),
                    IconButton(
                        onPressed: () {
                          print(widget.imageurl);
                          provider.sendMessage(
                              text: controller.text,
                              sender: widget.sender,
                              otherid: widget.otherid,
                              otheremail: widget.otheremail,
                              myid: widget.myid,
                          isImage:  true,
                              isText:  false,
                              isVideo: false);
                     //     provider.sendMessage(username: username, fullname: fullname, context: context);
                          Navigator.pop(context);

                        },

                        icon: Icon(Icons.send, color: Colors.blue))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
