import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letschat/api/firebase_api.dart';
import 'package:letschat/videopickerscreen.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'imagepickerscreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatSupportProvider extends ChangeNotifier{
FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseStorage _firebasestorage = FirebaseStorage.instance;

String _imagename='';
String get Imagename=>_imagename;
PickedFile _pickerFile;
PickedFile get pickedFile =>_pickerFile;
File _filePath;
File get filePath=>_filePath;
void sendMessage({
  @required String text,
  @required String sender,
  @required BuildContext context,
  @required timestamp,
  @required otherid,
  @required otheremail,
  @required myid,
  @required videourl,
  @required bool isImage,
  @required bool isVideo,
  @required bool isText,
})async{
  if(isImage)
    {
      imagemessage(text: text, sender: sender, context: context, timestamp: timestamp, otherid: otherid, otheremail: otheremail, myid: myid, isImage: isImage,isVideo:isVideo,isText:isText);
    }

  else {
    textmessage(text: text, sender: sender, context: context, timestamp: timestamp, otherid: otherid, otheremail: otheremail, myid: myid, isImage: isImage,isVideo:isVideo,isText:isText);
  }

}

/////////////////////////////=======================================
//   if(isVideo){
//   videomessage(text: text, sender: sender, context: context, timestamp: timestamp, otherid: otherid, otheremail: otheremail, myid: myid, isImage: isImage,isVideo:isVideo,videourl:videourl,isText:isText);
//   }

////////////////////////////==============================================
  void textmessage({  @required String text,
    @required String sender,
    @required BuildContext context,
    @required timestamp,
    @required otherid,
    @required otheremail,
    @required myid,
    @required bool isImage,
    @required bool isVideo,
    @required bool isText,
  }) async{

      _firestore.collection('All Users').doc(myid)
          .collection('Chats')
          .doc(myid + otherid)
          .collection('chat with')
          .add({
        'sender': sender,
        'text': text,
        'imageURL': '',
        'videoURL': '',
        'timestamp': Timestamp.now(),
        'myid': myid,
        'otherid': otherid,
        'otheremail': otheremail,
        'status': true,
        'link': '',

      });
      _firestore
          .collection('All Users')
          .doc(otherid)
          .collection('Chats')
          .doc(otherid + myid)
          .collection('chat with')
          .add({
        'sender': sender,
        'text': text,
        'imageURL': '',
        'videoURL': '',

        'timestamp': Timestamp.now(),
        'myid': myid,
        'otherid': otherid,
        'otheremail': otheremail,
        'status': 'true',
        'link': '',

      });
      _firestore
          .collection(
          sender + 'chat with')
          .add({
        'me': sender,
        'timestamp': Timestamp.now(),
        'otheremail': otheremail,
        'othertoken': otherid,
        'myuid': myid,
      });
      _firestore
          .collection(
          otheremail + 'chat with')
          .add({
        'me': otheremail,
        'timestamp': Timestamp.now(),
        'otheremail': sender,
        'othertoken': myid,
        'myuid': otherid,
      });


  }


  /////////////////////////////////

  void imagemessage({  @required String text,
    @required String sender,
    @required BuildContext context,
    @required timestamp,
    @required otherid,
    @required otheremail,
    @required myid,
    @required bool isImage,
    @required bool isVideo,
    @required bool isText,
  }) async{
  // showDialog(
  //     context: context,
  // );
  var imagestatus = await _firebasestorage.ref().child('Chat/$_imagename').putFile(_filePath).then((value) => value);
  String imageURL = await imagestatus.ref.getDownloadURL();

    _firestore.collection('All Users').doc(myid)
        .collection('Chats')
        .doc(myid + otherid)
        .collection('chat with')
        .add({
      'sender': sender,
      'text': text,
      'imageURL': '$imageURL',
      'videoURL': '',

      'timestamp': Timestamp.now(),
      'myid': myid,
      'otherid': otherid,
      'otheremail': otheremail,
      'status': true,
      'link': '',

    });
    _firestore
        .collection('All Users')
        .doc(otherid)
        .collection('Chats')
        .doc(otherid + myid)
        .collection('chat with')
        .add({
      'sender': sender,
      'text': text,
      'imageURL': '$imageURL',
      'videoURL': '',

      'timestamp': Timestamp.now(),
      'myid': myid,
      'otherid': otherid,
      'otheremail': otheremail,
      'status': 'true',
      'link': '',

    });
    _firestore
        .collection(
        sender + 'chat with')
        .add({
      'me': sender,
      'timestamp': Timestamp.now(),
      'otheremail': otheremail,
      'othertoken': otherid,
      'myuid': myid,
    });
    _firestore
        .collection(
        otheremail + 'chat with')
        .add({
      'me': otheremail,
      'timestamp': Timestamp.now(),
      'otheremail': sender,
      'othertoken': myid,
      'myuid': otherid,
    });
    // Navigator.of(context,rootNavigator: true).pop();
     Navigator.pop(context);


  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////////
void pickeimage({
  @required BuildContext context,
  @required String text,
  @required String sender,
  @required timestamp,
  @required otherid,
  @required otheremail,
  @required myid,
 })async{
  final _fireStorage = firebase_storage.FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  await Permission.photos.request();
  var PermissionStatus = await Permission.photos.status;
  if(PermissionStatus.isGranted){
    _pickerFile =await imagePicker.getImage(source: ImageSource.gallery);
    if(_pickerFile!=null){
      _filePath = File(_pickerFile.path);
      _imagename = _filePath.uri.path.split('/').last;
      var filePath = await _fireStorage.ref().child('demo/$_imagename').putFile(_filePath).then((value) {return value;});
      String dowmloadurl = await filePath.ref.getDownloadURL();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>pickerimagescreen(imageurl:dowmloadurl,myid:myid,sender:sender,
          otherid:otherid,otheremail:otheremail)));
    }
  }
  else{
    print('permission granteed');
  }
}




  void pickeimagefromcamera({
    @required BuildContext context,
    @required String text,
    @required String sender,
    @required timestamp,
    @required otherid,
    @required otheremail,
    @required myid,
  })async{
    final _fireStorage = firebase_storage.FirebaseStorage.instance;
    final imagePicker = ImagePicker();

    await Permission.photos.request();
    var PermissionStatus = await Permission.photos.status;
    if(PermissionStatus.isGranted){
      _pickerFile =await imagePicker.getImage(source: ImageSource.camera);
      if(_pickerFile!=null){
        _filePath = File(_pickerFile.path);
        _imagename = _filePath.uri.path.split('/').last;
        var filePath = await _fireStorage.ref().child('demo/$_imagename').putFile(_filePath).then((value) {return value;});
        String dowmloadurl = await filePath.ref.getDownloadURL();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>pickerimagescreen(imageurl:dowmloadurl,myid:myid,sender:sender,
            otherid:otherid,otheremail:otheremail)));
      }
    }
    else{
      print('permission granteed');
    }
  }
  //////////////////////////////////////////////////////////////////////////////////////////

  void pickvideo({
    @required BuildContext context,
    @required String text,
    @required String sender,
    @required timestamp,
    @required otherid,
    @required otheremail,
    @required myid,
  })async{
    final _fireStorage = firebase_storage.FirebaseStorage.instance;

    File file;
    //final _fireStorage = firebase_storage.FirebaseStorage.instance;

    final result = await FilePicker.platform.pickFiles(
      // allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'mp4',
        'MOV',
        'WMV',
        'AVI',
        'AVCHD',
        'FLV',
        'F4V',
        'SWF',
        'MKV',
        'WEBM ',
        'HTML5',
        'MPEG-2'
      ],
    );

    if (result == null) return;
    final path = result.files.single.path;

     file = File(path);
    final filename=basename(file.path);
    final destination = 'myvideos/$filename';

    //final uuppllooaadd= FirebaseApi.uploadFile(destination,file);
    var abc = await _fireStorage.ref().child(destination).putFile(file).then((value) {return value;});
    String url = await abc.ref.getDownloadURL();

    Navigator.push(context, MaterialPageRoute(builder: (context)=>pickervideoscreen(videourl:url,myid:myid,sender:sender,
        otherid:otherid,otheremail:otheremail)));
  }





  /////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////

  void sendVideo({
    @required String text,
    @required String sender,
    @required BuildContext context,
    @required timestamp,
    @required otherid,
    @required otheremail,
    @required myid,
    @required videourl,
    @required bool isImage,
    @required bool isVideo,
    @required bool isText,
  })async{

    _firestore.collection('All Users').doc(myid)
        .collection('Chats')
        .doc(myid + otherid)
        .collection('chat with')
        .add({
      'sender': sender,
      'text': text,
      'imageURL': '',
      'videoURL': videourl,
      'timestamp': Timestamp.now(),
      'myid': myid,
      'otherid': otherid,
      'otheremail': otheremail,
      'status': true,
      'link': '',

    });
    _firestore
        .collection('All Users')
        .doc(otherid)
        .collection('Chats')
        .doc(otherid + myid)
        .collection('chat with')
        .add({
      'sender': sender,
      'text': text,
      'imageURL': '',
      'videoURL': videourl,


      'timestamp': Timestamp.now(),
      'myid': myid,
      'otherid': otherid,
      'otheremail': otheremail,
      'status': 'true',
      'link': '',

    });
    _firestore
        .collection(
        sender + 'chat with')
        .add({
      'me': sender,
      'timestamp': Timestamp.now(),
      'otheremail': otheremail,
      'othertoken': otherid,
      'myuid': myid,
    });
    _firestore
        .collection(
        otheremail + 'chat with')
        .add({
      'me': otheremail,
      'timestamp': Timestamp.now(),
      'otheremail': sender,
      'othertoken': myid,
      'myuid': otherid,
    });


  }

  }







