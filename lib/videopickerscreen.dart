import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/provider.dart';
import 'package:provider/provider.dart';

import 'package:video_player/video_player.dart';

class pickervideoscreen extends StatelessWidget {
  String videourl;
  String myid;
  String otheremail;
  String otherid;
  String sender;

  pickervideoscreen({this.videourl,this.myid,this.sender,this.otheremail,this.otherid});

  final id = FirebaseAuth.instance.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return abcabc(videourl:videourl,myid:myid,sender:sender,
        otherid:otherid,otheremail:otheremail);
  }
}

class abcabc extends StatefulWidget {
  String videourl;
  String myid;
  String otheremail;
  String otherid;
  String sender;

  abcabc({@required this.videourl,this.myid,this.sender,this.otheremail,this.otherid});

  @override
  _abcabcState createState() => _abcabcState();
}

class _abcabcState extends State<abcabc> {
  TextEditingController controller = new TextEditingController();
  VideoPlayerController _controllervideo;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    _controllervideo = VideoPlayerController.network(widget.videourl);
_initializeVideoPlayerFuture=_controllervideo.initialize();
_controllervideo.setLooping(true);
_controllervideo.setVolume(1.0);
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _controllervideo.dispose();
    // TODO: implement dispose
    super.dispose();
  }

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
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.done){
                      return AspectRatio(
                          aspectRatio: _controllervideo.value.aspectRatio,
                      child: VideoPlayer(_controllervideo),);
                    }
                    else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Center(
                child: FloatingActionButton(
                  child: Icon(_controllervideo.value.isPlaying?Icons.pause:Icons.play_circle_fill),
                  onPressed: (){
                    setState(() {
                      if(_controllervideo.value.isPlaying){
                        _controllervideo.pause();
                      }
                      else
                        {
                          _controllervideo.play();
                        }
                    });
                  },
                ),
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
                          print(widget.videourl);
                          provider.sendVideo(
                              text: controller.text,
                              sender: widget.sender,
                              otherid: widget.otherid,
                              videourl: widget.videourl,
                              otheremail: widget.otheremail,
                              myid: widget.myid,
                              isImage:  false,
                              isText:  false,
                          isVideo: true);
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
