import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data_store.dart';
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  
  final emailController=TextEditingController();
  Map<String, dynamic>? foundUser;
bool isAdded = false;
  
  
  void AddUserByEmail() async{
    String email = emailController.text.trim();
if(email.isEmpty){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Enter valid Email Id"))
  );
  return;
}
var result= await FirebaseFirestore.instance
.collection("users").where("email", isEqualTo: email).get();
if (result.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found")),
      );
      return;
    }
var doc = result.docs.first;
    var data = doc.data();
    
  final currentUser=FirebaseAuth.instance.currentUser;
  var friendDoc = await FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser!.uid)
      .collection("Friends")
      .doc(doc.id)
      .get();


  
  setState(() {
    foundUser = {
      "id": doc.id,
      "name": data["name"],
      "email": data["email"],
    };

    isAdded = friendDoc.exists;
  });

  emailController.clear();
}
void addUser() async{
    if (foundUser == null) return;
    final currentUser=FirebaseAuth.instance.currentUser;
    
await FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser!.uid)
      .collection("Friends")
      .doc(foundUser!["id"])
      .set({
    "name": foundUser!["name"],
    "email": foundUser!["email"],
    
});
setState(() {
    isAdded = true; 
  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: const Color.fromARGB(255, 67, 33, 83),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Enter email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  onPressed:AddUserByEmail,
                   icon: Icon(Icons.search))
              ),
            ),
            const SizedBox(height: 20),
  
if (foundUser != null)
  Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    
    elevation: 4,
    child: ListTile(
      
      title: Text(foundUser!["name"]),
      subtitle: Text(foundUser!["email"]),
      trailing: ElevatedButton(
        onPressed:  isAdded ? null : addUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: isAdded ? Colors.grey : Colors.blue,
        ),
        child: Text(isAdded ? "Added" : "Add"),
      ),
    ),
  ),
            
          ],
        ),
      ),
    );
  }
}