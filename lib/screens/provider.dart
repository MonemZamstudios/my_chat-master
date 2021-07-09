import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'imagepickerscreen.dart';

class ChatSupportProvider extends ChangeNotifier{
FirebaseFirestore _firestore = FirebaseFirestore.instance;

String _imagename='';
String get Imagename=>_imagename;
PickedFile _pickerFile;
PickedFile get pickedFile =>_pickerFile;
File _filePath;
File get filePath=>_filePath;

void sendMessage({
  @required String username,
  @required String fullname,
  @required BuildContext context,
})async{


    final imagePicker = ImagePicker();
    await Permission.photos.request();
    var PermissionStatus = await Permission.photos.status;
    if(PermissionStatus.isGranted){
      _pickerFile =await imagePicker.getImage(source: ImageSource.gallery);
      if(_pickerFile!=null){
        _filePath = File(_pickerFile.path);
         _imagename = _filePath.uri.path.split('/').last;
Navigator.push(context, MaterialPageRoute(builder: (context)=>pickerimagescreen()));
      }
    }
    else{
      print('permission granteed');
    }


}
}