import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/Screens/DashBoard/home_screen.dart';
import 'package:quizapp/Screens/Login/login_screen.dart';
import 'package:quizapp/Screens/Signup/signup_screen.dart';
import 'package:quizapp/constants.dart';
import 'package:quizapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/Profile/profile_screen.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'core/controller/login_controller.dart';
import 'core/controller/profile_controller.dart';
import 'core/controller/signup_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyDuynpHk9D4hvoCwajiXrSLRL0lBVjfJ6E',
      appId: '1:379939966281:web:dc4c6d48912e2c63d49e98',
      messagingSenderId: '379939966281',
      projectId: 'web-quiz-app-ed588',
    ));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Get
    ..put(LoginController())
    ..put(SignUpController())
    ..put(ProfileController());

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the user is already logged in
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final MyApp myApp = MyApp(
    initialRoute: isLoggedIn ? '/HomeScreen' : '/WelcomeScreen',
    isLoggedIn: isLoggedIn,
  );

  runApp(myApp);
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool isLoggedIn;

  MyApp({Key? key, required this.initialRoute, required this.isLoggedIn})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/LoginScreen': (context) => const LoginScreen(),
        '/SignUpScreen': (context) => const SignUpScreen(),
        '/HomeScreen': (context) => const HomeScreen(),
        '/WelcomeScreen': (context) => const WelcomeScreen(),
        '/ProfileScreen': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
    );
  }
}
