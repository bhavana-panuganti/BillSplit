import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class userpagew extends StatelessWidget {
  const userpagew
({super.key});


  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Users",style: TextStyle(color: Colors.white),),
         backgroundColor: const Color.fromARGB(255, 67, 33, 83),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
  .collection("users")
  .doc(currentUserId)
  .collection("Friends")
  .snapshots(),
                
                 builder: (context,snapshot){
                  if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());}
              
                  var docs=snapshot.data!.docs;
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context,index){
                      var doc=docs[index];
                      var data=doc.data();
                  
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          color :Color.fromARGB(255, 197, 173, 205),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                          child: ListTile(
                            title: Text(data["name"]) ,
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                showDialog(
                                  context: context, 
                                  builder: (context){
                                    return AlertDialog(
                                 title: Text("Delete User"),
                                 content: Text("Are you sure you want to delete this user?"),
                                 actions: [
                                  TextButton(
                                    onPressed: (){
                                       Navigator.pop(context);
                                    }, child: Text("Cancel"),),
                                    TextButton(
                                      onPressed:() async{
                                       await FirebaseFirestore.instance
                        .collection("users")
                        .doc(currentUserId)
                        .collection("Friends")
                        .doc(doc.id)
                        .delete();
                                Navigator.pop(context);
                                      } ,
                                       child: Text("Delete"))
                                 ],     
                                    );
                                  }
                                  );
                               },
                              
                                        
                          )
                          
                          ),
                        ),
                      );
                     
              
                    }
                    
                    );
              
                 }
                 ),
            ),
          ],
        ),
      ),


    );
  }
}