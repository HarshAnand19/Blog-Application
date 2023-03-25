import 'package:blog_app/provider/theme_provider.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:blog_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


late Size mq;
void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>

     ChangeNotifierProvider(
       create: (context)=> ThemeProvider(),
       builder: (context,_) {
         final themeProvider = Provider.of<ThemeProvider>(context);


         return MaterialApp(
           debugShowCheckedModeBanner: false,
           title: 'Blog Demo',
           themeMode:themeProvider.themeMode,
           theme: MyThemes.lightTheme,
           darkTheme: MyThemes.darkTheme,
           home: SplashScreen(),
         );

       },
     );

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}