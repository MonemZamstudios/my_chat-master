
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class linkscreen extends StatelessWidget {
  final String sender;
  final String otherid;
  final String otheremail;
  final String myid;
   var timestamp;


  linkscreen({@required this.sender,this.otherid,this.otheremail,this.myid,this.timestamp});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:mylink(sender:sender,otherid:otherid,otheremail:otheremail,myid:myid,timestamp:timestamp),
    );
  }
}
class mylink extends StatefulWidget {
  final String sender;
  final String otherid;
  final String otheremail;
  final String myid;
   var timestamp;
  mylink({@required this.sender,this.otherid,this.otheremail,this.myid,this.timestamp});

  @override
  _mylinkState createState() => _mylinkState();
}

class _mylinkState extends State<mylink> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebasestorage = FirebaseStorage.instance;

  TextEditingController controller = new TextEditingController();
  void sendlink(String sender,myid,otheremail,otherid){
    _firestore.collection('All Users').doc(widget.myid)
        .collection('Chats')
        .doc(widget.myid + widget.otherid)
        .collection('chat with')
        .add({
      'sender': widget.sender,
      'text': '',
      'link': controller.text,
      'imageURL': '',
      'timestamp': widget.timestamp,
      'myid': widget.myid,
      'otherid': widget.otherid,
      'otheremail': widget.otheremail,
      'status': true,

    });
    _firestore
        .collection('All Users')
        .doc(widget.otherid)
        .collection('Chats')
        .doc(widget.otherid + widget.myid)
        .collection('chat with')
        .add({
      'sender': widget.sender,
      'text': '',
      'link': controller.text,
      'imageURL': '',

      'timestamp': widget.timestamp,
      'myid': widget.myid,
      'otherid': widget.otherid,
      'otheremail': widget.otheremail,
      'status': 'true',
    });
    _firestore
        .collection(
        widget.sender + 'chat with')
        .add({
      'me': widget.sender,
      'timestamp': widget.timestamp,
      'otheremail': widget.otheremail,
      'othertoken': widget.otherid,
      'myuid': widget.myid,
    });
    _firestore
        .collection(
        widget.otheremail + 'chat with')
        .add({
      'me': widget.otheremail,
      'timestamp': widget.timestamp,
      'otheremail': widget.sender,
      'othertoken': widget.myid,
      'myuid': widget.otherid,
    });
    setState(() {
      print(widget.sender);
      print(widget.otherid);
      print(widget.otheremail);
      print(widget.myid);
      print(controller.text);
    });

  }
  @override
  void initState() {
    print(widget.sender);
    print(widget.otherid);
    print(widget.otheremail);
    print(widget.myid);
    print(controller.text);
    // TODO: implement initState
    super.initState();
  }

 // String url='http://www.youtube.com';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,

        title: Text('Paste OR Type the Link',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

      ),
    //  backgroundColor: Colors.black,
      body: SafeArea(
      child: Column(
        children: [

          Container(
            padding: EdgeInsets.all(22),
            child: new Center(

              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(

                    fillColor: Colors.white,
                    focusColor: Colors.grey
                ),

              ),
            ),

    ),
          Container(
          //  color: Colors.teal,
            child: RaisedButton(
              onPressed: (){
                sendlink(widget.sender,widget.myid,widget.otheremail,widget.otherid);
                Navigator.pop(context);
               // launch(controller.text);
              },
              color: Colors.teal,
              child: Text('Send',style: TextStyle(
                fontWeight: FontWeight.bold,color: Colors.white
              ),),
            ),
          ),
          // InkWell(
          //   onTap:(){
          //    // sendlink();
          //     launch(controller.text);
          //     },
          //   child: Container(
          //
          //     child: Text(controller.text,style: TextStyle(color: Colors.indigo),),
          //   ),
          // )
        ],
      ))
    );
  }
}
