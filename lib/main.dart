import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:letschat/components/colors.dart';
import 'package:letschat/screens/camera.dart';
import 'package:letschat/screens/provider.dart';
import 'package:letschat/screens/welcome_screen.dart';
import 'package:letschat/screens/login_screen.dart';
import 'package:letschat/screens/registration_screen.dart';
import 'package:letschat/screens/chat_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((_)=>
      runApp( MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatSupportProvider>(create: (_)=>ChatSupportProvider())
        ],
        child: FlashChat(),
      )));
}

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: PalletteColors.lightSkin,
        primaryColor: PalletteColors.primaryRed,

        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context)=> WelcomeScreen(),
        ChatScreen.id:(context) => ChatScreen(),
        LoginScreen.id:(context) => LoginScreen(),
        RegistrationScreen.id:(context) => RegistrationScreen(),
      },
    );
  }
}
