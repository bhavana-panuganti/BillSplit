import 'package:flutter/material.dart';

import 'signup_page.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

import 'home_page.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(

options: DefaultFirebaseOptions.currentPlatform,

);

runApp(const MyApp());

}

class MyApp extends StatelessWidget {

const MyApp({super.key});

@override

Widget build(BuildContext context) {

return ChangeNotifierProvider(
  create: (context){
    return ExpenseProvider();
  },
  child: const MaterialApp(
  
  debugShowCheckedModeBanner: false,
  
  home: AuthCheck(),
  
  ),
);

}

}

class AuthCheck extends StatelessWidget {

const AuthCheck({super.key});

@override

Widget build(BuildContext context) {

return StreamBuilder(

stream: FirebaseAuth.instance.authStateChanges(),

builder: (context,snapshot){

if (snapshot.connectionState == ConnectionState.waiting) {

return const Scaffold(

body: Center(child: CircularProgressIndicator()),

);

}

if (snapshot.hasData) {

return const HomePage();

}

return const SignupPage();

});

}}

