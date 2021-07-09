import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letschat/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:letschat/components/colors.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:letschat/screens/camerastart.dart';
import 'package:letschat/screens/provider.dart';
import 'package:letschat/translator.dart';
import 'package:letschat/widgets/fingersketch.dart';
import 'package:letschat/widgets/gift.dart';
import 'package:letschat/widgets/homescreenofchat.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:letschat/widgets/map.dart';
import 'package:letschat/widgets/speechtotext.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../mainvideo.dart';
import 'audio_add.dart';
import 'camera.dart';
import 'imagepickerscreen.dart';

final database = FirebaseDatabase.instance.reference();

final _firestore = FirebaseFirestore.instance;
User loggedInuser;
final focusNode = FocusNode();
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  final String myuid;

  // final String othername;
  final String myemail;
  final String otheremail;
  final String othertoken;

  ChatScreen({this.myuid, this.myemail, this.otheremail, this.othertoken});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool sendButton = false;

  stt.SpeechToText _speech;
  bool _isListening = false;
  String mytext = '';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            mytext = val.recognizedWords;
            controller.text = mytext;
          //  sendButton=true;

          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  File file;
  Future video() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
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

    setState(() => file = File(path));
  }
  File file2;
// String _imagename='';
// String get imagename => _imagename;
//   PickedFile _pikerfile;
//   PickedFile get pickerfile => _pikerfile;
//   File _filepath;
//   File get filepath => _filepath;
// var fileURL='';
//   Future<void> gallery() async {
//     final _fireStorage = firebase_storage.FirebaseStorage.instance;
//
//     final imagepicker = ImagePicker();
//     PickedFile pickedFile;
//     await Permission.photos.request();
//     var permissionStatus = await Permission.photos.status;
//     if (permissionStatus.isGranted) {
//       pickedFile = await imagepicker.getImage(source: ImageSource.gallery);
//     }
//
//     if(pickedFile!=null) {
//        var file = File(pickedFile.path);
//        String imagename = file.uri.path.split('/').last;
//       var filePath = await _fireStorage.ref().child('demo/$imagename').putFile(file).then((value) {return value;});
//       String dowmloadurl = await filePath.ref.getDownloadURL();
//         fileURL = dowmloadurl;
//        print(fileURL);
//     }
//
//   }
  File file3;
  Future documents() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'word',
        'DOC',
        'DOCX',
        'HTML',
        'HTM',
        'ODT',
        'PDF',
        'XLS',
        'XLSX',
        'ODS',
        'PPT ',
        'PPTX',
        'TXT'
      ],
    );

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file3 = File(path));
  }
  File file4;
  Future audio() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'audios',
        'audio',
        '3GA',
        'AA',
        'AA3',
        'AAC',
        'AAX',
        'ABC',
        'AC3',
        'WAV',
        'WMA',
        'ZVR',
        'M4A',
        'FLAC',
        'WAV',
        'WMA'
      ],
    );

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file4 = File(path));
  }
  File file5;
  Future links() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['com'],
    );

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file5 = File(path));
  }

  //final controller = TextEditingController();
  TextEditingController controller = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  var messageText;
  final id = FirebaseAuth.instance.currentUser.uid;

//////////////////////////////////////////////////////////////
//   var _image;
//   final picker = ImagePicker();

  // Future getimage()async{
  //   var image = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image=image;
  //     print('Image path$_image');
  //     uploadpic2();
  //   });
  // }

  // Future uploadpic2()async{
  //   String url2="";
  //
  //   String fileName = basename(_image.path);
  //   firebase_storage.Reference fff = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
  //   firebase_storage.UploadTask eee = fff.putFile(_image);
  //   eee.then((res)async{
  //     url2 = await res.ref.getDownloadURL();
  //     print(url2);
  //     _firestore.collection('pictures').add({
  //       'picture': url2,
  //
  //     });
  //
  //   });
  // }
  //////////////////////////////////////////////////////////
  @override
  void initState() {
    _speech = stt.SpeechToText();

    print(widget.myuid);
    print(widget.otheremail);
    print(widget.myemail);
    super.initState();
    getCurrentUser();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool isKeyboardVisible) {
      setState(() {
        this.isKeyboardVisible = isKeyboardVisible;
      });

      if (isKeyboardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  Future toggleEmojiKeyboard() async {
    if (isKeyboardVisible) {
      FocusScope.of(this.context).unfocus();
    }

    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  Future<bool> onBackPress() {
    if (isEmojiVisible) {
      toggleEmojiKeyboard();
    } else {
      Navigator.pop(this.context);
    }

    return Future.value(false);
  }

  @override
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInuser = user;
        print(loggedInuser);
      }
    } catch (e) {
      print(e);
    }
  }

  void onEmojiSelected(String emoji) => setState(() {
        controller.text = controller.text + emoji;
      });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatSupportProvider>(context, listen: false);
    Widget buildSticker() {
      return EmojiPicker(
        rows: 3,
        columns: 7,
        buttonMode: ButtonMode.MATERIAL,
        recommendKeywords: ["racing", "horse"],
        numRecommended: 10,
        onEmojiSelected: (emoji, category) {
          onEmojiSelected(emoji.emoji);
        },
      );
    }

    return WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context, builder: (context) => Homescreen());
        },
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: Colors.green,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Homescreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // widget.chatModel.name,
                        widget.otheremail.toString(),
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        mytext,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),
                PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                      PopupMenuItem(
                        child: Text("Media, links, and docs"),
                        value: "Media, links, and docs",
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: "Search",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notification"),
                        value: "Mute Notification",
                      ),
                      PopupMenuItem(
                        child: Text("Wallpaper"),
                        value: "Wallpaper",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Chat"),
                        value: "Mute Chat",
                      ),
                      PopupMenuItem(
                        child: Text("Translate Messages"),
                        value: "Translate Messages",
                      ),
                      PopupMenuItem(
                        child: Text("Pin Chat"),
                        value: "Pin Chat",
                      ),
                      PopupMenuItem(
                        child: Text("Archive Chat"),
                        value: "Archive Chat",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: WillPopScope(
              // onWillPop: onBackPress,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MessagesStream(
                      myuid: widget.myuid, othertoken: widget.othertoken),
                  Container(
                    width: double.infinity,
                    height: 55.0,
                    // decoration: new BoxDecoration(
                    //   border: new Border(
                    //       top: new BorderSide(
                    //           color: Colors.green, width: 0.5)
                    //   ),
                    //   // color: Colors.amber
                    // ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            //color: Colors.red,
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      // color:Colors.blue,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: TextField(

                                          textInputAction: TextInputAction.send,
                                          keyboardType: TextInputType.multiline,
                                          focusNode: focusNode,
                                          onSubmitted: (value) {
                                            // controller.clear();
                                            _firestore.collection('CHAT').add({
                                              'sender': loggedInuser.email,
                                              'text': messageText,
                                              'timestamp': Timestamp.now(),
                                            });
                                          },
                                          maxLines: null,
                                          controller: controller,
                                          onChanged: (value) {
                                            messageText = value;
                                            if (value.length > 0) {
                                              setState(() {

                                                print(controller.text);
                                                sendButton = true;
                                              });
                                            } else {
                                              setState(() {
                                                sendButton = false;
                                              });
                                            }
                                          },
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15.0),
                                          // decoration: kMessageTextFieldDecoration,
                                          decoration: InputDecoration(
                                            hintText: "Type a message",
                                            hintStyle: TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                            prefixIcon: IconButton(
                                              icon: Icon(isEmojiVisible
                                                  ? Icons.keyboard_rounded
                                                  : Icons.emoji_emotions),
                                              onPressed: onClickedEmoji,
                                            ),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.attach_file),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (builder) =>
                                                          Container(
                                                        height: 333,
                                                        width: 203,
                                                        // width: MediaQuery.of(context).size.width,
                                                        child: Card(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(18.0),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        20),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        documents();
                                                                        //  print('pressss');
                                                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.indigo,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.insert_drive_file,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Document",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await Permission
                                                                            .camera
                                                                            .request();
                                                                        //return CameraScreen();

                                                                        video();
                                                                        //  print('pressss');
                                                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.pink,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.video_collection,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Videos",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        provider.sendMessage(
                                                                            context:
                                                                                context);
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.purpleAccent,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.insert_photo,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Gallery",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        audio();
                                                                        //  print('pressss');
                                                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => audioadd()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.orange,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.headset,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Audio",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        // audioadd();
                                                                        //  print('pressss');
                                                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => translate()));
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => GeolocatorWidget()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.teal,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.location_pin,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Location",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        links();
                                                                        //  print('pressss');
                                                                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.blue,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.link,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Links",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        // getimage();
                                                                        //  print('pressss');
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => finguresketch()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.purpleAccent,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.touch_app_rounded,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Creat Sketch",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        //return CameraScreen();

                                                                        // getimage();
                                                                        //  print('pressss');
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => gifts()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.blue,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.card_giftcard,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Gif",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        await Permission
                                                                            .camera
                                                                            .request();
                                                                        //return CameraScreen();

                                                                        // getimage();
                                                                        //  print('pressss');
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => CameraPage()));
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius:
                                                                                30,
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            child: IconButton(
                                                                                icon: Icon(
                                                                              Icons.camera_alt,
                                                                              // semanticLabel: "Help",
                                                                              size: 29,
                                                                              color: Colors.white,
                                                                            )),
                                                                          ),
                                                                          Text(
                                                                            "Camera",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              // fontWeight: FontWeight.w100,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  onPressed: _listen,
                                                  icon: Icon(_isListening
                                                      ? Icons.mic
                                                      : Icons.mic_none),
                                                  color: _isListening
                                                      ? Colors.green
                                                      : Colors.blue,
                                                ),
                                              ],
                                            ),
                                           // contentPadding: EdgeInsets.all(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Material(
                          child: new Container(
                            child: new IconButton(
                              icon: Icon(
                                sendButton ? Icons.send : Icons.mic,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                if (sendButton) {
                                  setState(() {
                                    sendButton = false;
                                  });
                                  controller.clear();
                                  _firestore
                                      .collection('All Users')
                                      .doc(widget.myuid)
                                      .collection('Chats')
                                      .doc(widget.myuid + widget.othertoken)
                                      .collection('chat with')
                                      .add({
                                    'sender': loggedInuser.email,
                                    'text': messageText,
                                    'timestamp': Timestamp.now(),
                                    'myid': id.toString(),
                                    'otherid': widget.othertoken,
                                    'otheremail': widget.otheremail,
                                    'status': true,
                                  });
                                  _firestore
                                      .collection('All Users')
                                      .doc(widget.othertoken)
                                      .collection('Chats')
                                      .doc(widget.othertoken + widget.myuid)
                                      .collection('chat with')
                                      .add({
                                    'sender': loggedInuser.email,
                                    'text': messageText,
                                    'timestamp': Timestamp.now(),
                                    'myid': id.toString(),
                                    'otherid': widget.othertoken,
                                    'otheremail': widget.otheremail,
                                    'status': 'true',
                                  });
                                  _firestore
                                      .collection(
                                          loggedInuser.email + 'chat with')
                                      .add({
                                    'me': loggedInuser.email,
                                    'timestamp': Timestamp.now(),
                                    'otheremail': widget.otheremail,
                                    'othertoken': widget.othertoken,
                                    'myuid': widget.myuid,
                                  });
                                  _firestore
                                      .collection(
                                          widget.otheremail + 'chat with')
                                      .add({
                                    'me': widget.otheremail,
                                    'timestamp': Timestamp.now(),
                                    'otheremail': loggedInuser.email,
                                    'othertoken': widget.myuid,
                                    'myuid': widget.othertoken,
                                  });
                                }
                              },
                              color: Colors.blueGrey,
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  (isEmojiVisible ? buildSticker() : Container()),
                ],
              ),
            ),
          ),
        ));
  }

  void onClickedEmoji() async {
    if (isEmojiVisible) {
      focusNode.requestFocus();
    } else if (isKeyboardVisible) {
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(Duration(milliseconds: 100));
    }
    // toggleEmojiKeyboard();
  }
}

String giveUsername(String email) {
  return email.replaceAll(new RegExp(r'@g(oogle)?mail\.com$'), '');
}

class MessagesStream extends StatelessWidget {
  final String myuid;
  final String othertoken;

  MessagesStream({this.myuid, this.othertoken});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('All Users')
          .doc(myuid)
          .collection('Chats')
          .doc(myuid + othertoken)
          .collection('chat with')
          // Sort the messages by timestamp DESC because we want the newest messages on bottom.
          .orderBy("timestamp", descending: true)
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
          final messageText = data['text'];
          final messageSender = data['sender'];
          final currentUser = loggedInuser.email;
          final timeStamp = data['timestamp'];
          return MessageBubble(
            sender: messageSender,
            text: messageText,
            timestamp: timeStamp,
            isMe: currentUser == messageSender,
          );
        }).toList();

        return Expanded(

          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.timestamp, this.isMe});

  final String sender;
  final String text;
  final Timestamp timestamp;

  //var timestamp;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${giveUsername(sender)}",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.deepPurple : PalletteColors.lightBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    text.toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: isMe ? Colors.white : Colors.black54,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "${DateFormat('h:mm a').format(dateTime)}",
                      style: TextStyle(
                        // child: Text(dateTime.toString(),style: TextStyle(
                        fontSize: 9.0,
                        color: isMe
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black54.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget iconCreation(IconData icons, Color color, String text) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icons,
            // semanticLabel: "Help",
            size: 29,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w100,
          ),
        )
      ],
    ),
  );
}
