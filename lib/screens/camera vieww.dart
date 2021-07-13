// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CameraViewPage extends StatelessWidget {
//   String imageurl;
//   String myid;
//   String otheremail;
//   String otherid;
//   String sender;
//   var timestamp;
//   String path;
//
//
//   CameraViewPage({this.imageurl,this.myid,this.sender,this.otheremail,this.otherid,this.timestamp,this.path});
//
//   @override
//   Widget build(BuildContext context) {
//     return abcxyz(sender: sender,timestamp: timestamp,otheremail: otheremail,myid: myid,otherid: otherid,path: path,);
//   }
// }
//
// class abcxyz extends StatefulWidget {
//   String imageurl;
//   String myid;
//   String otheremail;
//   String otherid;
//   String sender;
//   var timestamp;
//   String path;
//
//
//   abcxyz({this.imageurl,this.myid,this.sender,this.otheremail,this.otherid,this.timestamp,this.path});
//   @override
//   _abcxyzState createState() => _abcxyzState();
// }
//
// class _abcxyzState extends State<abcxyz> {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FirebaseStorage _firebasestorage = FirebaseStorage.instance;
//
//   String _imagename='';
//   String get Imagename=>_imagename;
//   PickedFile _pickerFile;
//   PickedFile get pickedFile =>_pickerFile;
//   File _filePath;
//   File get filePath=>_filePath;
//   void pickeccimage()async{
//     final _fireStorage = firebase_storage.FirebaseStorage.instance;
//     final imagePicker = ImagePicker();
//     await Permission.photos.request();
//     var PermissionStatus = await Permission.photos.status;
//     if(PermissionStatus.isGranted){
//       _pickerFile =await imagePicker.getImage(source: ImageSource.camera);
//       if(_pickerFile!=null){
//         _filePath = File(_pickerFile.path);
//         _imagename = _filePath.uri.path.split('/').last;
//         var filePath = await _fireStorage.ref().child('demo/$_imagename').putFile(_filePath).then((value) {return value;});
//         String dowmloadurl = await filePath.ref.getDownloadURL();
//
//         // Navigator.push(context, MaterialPageRoute(builder: (context)=>pickerimagescreen(imageurl:dowmloadurl,myid:myid,sender:sender,
//         //     otherid:otherid,otheremail:otheremail)));
//       }
//     }
//     else{
//       print('permission granteed');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//               icon: Icon(
//                 Icons.crop_rotate,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: Icon(
//                 Icons.emoji_emotions_outlined,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: Icon(
//                 Icons.title,
//                 size: 27,
//               ),
//               onPressed: () {}),
//           IconButton(
//               icon: Icon(
//                 Icons.edit,
//                 size: 27,
//               ),
//               onPressed: () {
//
//               }),
//         ],
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height - 150,
//               child: Image.file(
//                 File(widget.path),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             RaisedButton(
//                 child:Text('Send image'),onPressed: (){
//
//               pickeccimage();
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
