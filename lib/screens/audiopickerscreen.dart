// import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:letschat/screens/provider.dart';
// import 'package:provider/provider.dart';
//
// import 'package:video_player/video_player.dart';
//
// class pickeraudioscreen extends StatelessWidget {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return aqaqaq();
//   }
// }
//
// class aqaqaq extends StatefulWidget {
//
//   @override
//   _aqaqaqState createState() => _aqaqaqState();
// }
//
// class _aqaqaqState extends State<aqaqaq> {
//
//  AudioPlayer audioPlayer = AudioPlayer();
//  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
//  String url = 'https://firebasestorage.googleapis.com/v0/b/chat-app-22aee.appspot.com/o/myaudios%2FAUD-20200911-WA0073?alt=media&token=eed09673-d1e9-48da-acb7-f4212808984f';
//
//  Duration duration = new Duration();
//  Duration position = new Duration();
//  bool playing = false;
// @override
//   void initState() {
//   audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
//     setState(() {
//       audioPlayerState=s;
//     });
//   });
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   void dispose() {
//   audioPlayer.release();
//   audioPlayer.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//    playmusic()async{
//   await audioPlayer.play(url);
//   }
//   pausemusic()async{
//   await audioPlayer.pause();
//   }
//   @override
//   double width;
//   double height;
//
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     return Scaffold(
//
//         body: SafeArea(
//           child: Column(
//             children: [
//               Container(),
//               slider(),
//               InkWell(
//                 onTap: (){
// audioPlayerState==AudioPlayerState.PLAYING?pausemusic():playmusic();                },
//                 child: Icon(audioPlayerState==AudioPlayerState.PLAYING?Icons.pause_rounded:Icons.play_circle_fill,size: 100,color: Colors.blue,),
//               )
//             ],
//           )
//         ));
//
//   }
//
//
//
//
//  Widget slider() {
//    return Slider.adaptive(
//      min: 0.0,
//        max: duration.inSeconds.toDouble(),
//        value: position.inSeconds.toDouble(),
//        onChanged: (double value) { setState(() {
//          audioPlayer.seek(new Duration(seconds: value.toInt()));
//        });}
//    );
//
//  }
//  void getAudio()async{
//    var url ='https://firebasestorage.googleapis.com/v0/b/chat-app-22aee.appspot.com/o/myaudios%2FAUD-20200911-WA0073?alt=media&token=eed09673-d1e9-48da-acb7-f4212808984f';
//    if(playing){
//      var res = await audioPlayer.pause();
//      if(res==1){
//        setState(() {
//          playing==false;
//        });
//      }
//      else{
//        var res = await audioPlayer.play(url,isLocal: true);
//        if(res==1){
//          setState(() {
//            playing==true;
//          });
//        }
//      }
//      audioPlayer.onDurationChanged.listen((Duration dd) {
//        setState(() {
//          duration=dd;
//        });
//      });
//      audioPlayer.onAudioPositionChanged.listen((Duration dd) {
//        setState(() {
//          position=dd;
//        });
//
//      });
//
//    }
//
//  }
//  }
//
