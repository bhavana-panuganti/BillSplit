import 'package:bill_split/home_page.dart';

import 'package:bill_split/login_page.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {

const SignupPage({super.key});

@override

State<SignupPage> createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {

Color buttoncolor=Colors.black;

final emailController = TextEditingController();

final passwordController = TextEditingController();

final nameController = TextEditingController();

@override

Widget build(BuildContext context) {

return Scaffold(

backgroundColor: const Color.fromARGB(255, 224, 186, 235),

appBar: AppBar(

backgroundColor: const Color.fromARGB(255, 67, 33, 83),


title: const Text("BillSplit",

style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),

),

body: Padding(

padding: const EdgeInsets.all(16.0),

child: Column(

mainAxisAlignment: MainAxisAlignment.center,

children: [

const Text("Sign Up",

style: TextStyle(

fontSize: 50,

fontWeight: FontWeight.bold,

),),

const SizedBox(height: 30,),

TextField(

controller: nameController,

decoration: InputDecoration(

hintText: "Name",

filled: true,

fillColor: const Color.fromARGB(255, 255, 249, 249),

border: OutlineInputBorder(

borderRadius: BorderRadius.circular(10),

),),

),

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

child: ElevatedButton(onPressed: ()

async {

setState(() {

buttoncolor=const Color.fromARGB(255, 95, 98, 91);

});

if (emailController.text.isEmpty || passwordController.text.isEmpty) {

setState(() {

buttoncolor = Colors.black;

});

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(content: Text("Please enter email and password")),

);

return;

}

try{

UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(

email: emailController.text.trim(),

password: passwordController.text.trim(),);
await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
    });
    if (!mounted) return;

Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));

setState(() {

buttoncolor = Colors.black;});

}

catch (e){

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(content: Text("Invalid email or password")),); }

setState(() {

buttoncolor = Colors.black;});

},

style: ElevatedButton.styleFrom(

backgroundColor:buttoncolor,

padding: EdgeInsets.symmetric(vertical: 18),

),

child: Text("Sign Up",style: TextStyle(color: Colors.white),),

),

),

TextButton(onPressed: () {

Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));

},

child:Text("Already have and account? Login") ),

],

),

),

);

}

}

