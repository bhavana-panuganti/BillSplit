import 'package:bill_split/home_page.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

const LoginPage({super.key});

@override

State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

Color buttoncolor=Colors.black;

final emailController = TextEditingController();

final passwordController = TextEditingController();

@override

Widget build(BuildContext context) {

return Scaffold(

backgroundColor: const Color.fromARGB(255, 224, 186, 235),


appBar: AppBar(

backgroundColor: const Color.fromARGB(255, 67, 33, 83),


elevation: 0,

leading: IconButton(onPressed: (){

Navigator.pop(context);

}, icon: const Icon(Icons.arrow_back)),

title: const Text("BillSplit",

style: TextStyle(fontWeight: FontWeight.bold,
color: Colors.white),),

),

body: Padding(

padding: const EdgeInsets.all(16.0),

child: Column(

mainAxisAlignment: MainAxisAlignment.center,

children: [

const Text("Login",

style: TextStyle(

fontSize: 50,

fontWeight: FontWeight.bold,

),),

const SizedBox(height: 30,),

const SizedBox(height: 20,),

TextField(

controller: emailController,

decoration: InputDecoration(hintText: "Email",

filled: true,

fillColor: const Color.fromARGB(255, 255, 249, 249),

border: OutlineInputBorder(

borderRadius: BorderRadius.circular(10),),

),),

const SizedBox(height: 20,),

TextField(

obscureText: true,

controller: passwordController,

decoration: InputDecoration(hintText: "Password",

filled: true,

fillColor: const Color.fromARGB(255, 255, 249, 249),

border: OutlineInputBorder(

borderRadius: BorderRadius.circular(10),),

)

),

const SizedBox(height: 20,),

SizedBox(

width: double.infinity,

child: ElevatedButton(onPressed: () async {

setState(() {

buttoncolor = const Color.fromARGB(255, 90, 86, 86);

});

try{

await FirebaseAuth.instance.signInWithEmailAndPassword(email:

emailController.text.trim(),

password: passwordController.text.trim());

Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomePage()));

}

catch(e){

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(content: Text("Invalid email or password")),);

setState(() {

buttoncolor = Colors.black;

});

}

},

style: ElevatedButton.styleFrom(

backgroundColor:buttoncolor,

padding: EdgeInsets.symmetric(vertical: 18),

),

child: Text("Login",style: TextStyle(color: Colors.white),),

),

),

],

),

),

);

}}

