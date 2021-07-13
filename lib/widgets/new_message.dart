import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/chat_screen.dart';

final _firestore = FirebaseFirestore.instance;
class selectpersonforchat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage1(),
    );
  }
}

class ChatPage1 extends StatefulWidget {
  final _firestore = FirebaseFirestore.instance;

  @override
  _ChatPage1State createState() => _ChatPage1State();
}

class _ChatPage1State extends State<ChatPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SafeArea(
        child: StreamBuilder(
          stream: _firestore
              .collection('AllUsers')
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
              .orderBy("username", descending: true)

              .snapshots(),
          builder: (context, snapshot) {
            // If we do not have data yet, show a progress indicator.
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Create the list of message widgets.

            // final messages = snapshot.data.documents.reversed;
            List<Widget> messageWidgets = snapshot.data.docs.map<Widget>((m) {
              final data = m.data();
              final uesrname = data['username'];
              final otheremail = data['useremail'];
              // final useremail = data['username'];
              final  othertoken = data['token'];

              final id = FirebaseAuth.instance.currentUser.uid;
              final email =FirebaseAuth.instance.currentUser.email;
              return  Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  myuid: id,
                                 // othername: uesrname,
                                  myemail: email,
                                  othertoken: othertoken,
                                  otheremail: otheremail
                              )));
                    },


                    child: (id.toString() ==othertoken.toString())? SizedBox():ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        // child: SvgPicture.asset(
                        // chatModel.isGroup ? "assets/groups.svg" : "assets/person.svg",
                        //   color: Colors.white,
                        //   height: 36,
                        //   width: 36,
                        // ),
                        // backgroundColor: Colors.blueGrey,
                      ),
                      title: Text(
                        // chatModel.name,
                        uesrname.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(Icons.done_all),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            //  chatModel.currentMessage,
                            'Say Hi to '+ uesrname.toString(),
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      //  trailing: Text(chatModel.time),
                      trailing: Text('12:00'),
                    ),


                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 80),
                    child: id.toString() ==othertoken.toString()?SizedBox():Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              );

            }).toList();

            return
                   ListView(
                      // reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageWidgets,

                  );
          },
        ),
      ),
    );
  }
}

