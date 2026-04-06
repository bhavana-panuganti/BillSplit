import 'package:bill_split/Equal_split_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Manualsplit extends StatefulWidget {

const Manualsplit({super.key});

  @override
  State<Manualsplit> createState() => _ManualsplitState();
}

class _ManualsplitState extends State<Manualsplit> {
  final titlecontroller=TextEditingController();
  final amountcontroller=TextEditingController();
  String? paidBy;
  Map<String, TextEditingController> controllers = {};
   
    

final currentUserObj = FirebaseAuth.instance.currentUser;
  
  void save(List users){
    double? total=double.tryParse(amountcontroller.text);
    if (total == null){
      if(mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar( 
          content: Text("Fill the details"),));
          return;}

          Map<String,double> splits={};
          for(var u in users){
             String userId = u["id"];
             double amount = double.tryParse(
      controllers[userId]?.text ?? "0",
    ) ?? 0;

   
            if (userId == paidBy) {
    splits[userId] = 0;
  } else {
    splits[userId] = amount;
  }


        
    }
    List<String> participants = splits.keys.toList();

           FirebaseFirestore.instance.collection("expenses").add({
            "Title": titlecontroller.text,
  "total": total,
  "paidBy": paidBy,
"paidByName": users.firstWhere((u) => u["id"] == paidBy)["name"],

"splits": splits,
"participants": splits.keys.toList(),
"createdAt": FieldValue.serverTimestamp(),

"paid": {
  for (var p in participants) p: false
},
"splitNames": {
  for (var u in users)
    if (splits.containsKey(u["id"]))
      u["id"]: u["name"]
}
            
          });
          if (!mounted) return;
          Navigator.popUntil(context, (route) => route.isFirst);

  }


@override

Widget build(BuildContext context) {
final currentUser= FirebaseAuth.instance.currentUser!.uid;
return Scaffold(
  appBar: AppBar(
    title: Text("Manual Split",style: TextStyle(
      color: Colors.white
    ),),
    backgroundColor: const Color.fromARGB(255, 67, 33, 83),
    ),
   
    body: StreamBuilder(
      stream: FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser)
      .collection("Friends")
      .snapshots()
      , 
      builder: (context,snapshot){
        if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var docs=snapshot.data!.docs;
          final currentUserObj = FirebaseAuth.instance.currentUser;

List<Map<String, dynamic>> users = [
  {
    "id": currentUserObj!.uid,
    "name": currentUserObj.displayName ?? "Me",
  },
  ...docs.map((doc) {
    return {
      "id": doc.id,
      "name": doc["name"],
      "email": doc["email"],
    };
  }).toList(),
];
           for (var u in users) {
            controllers.putIfAbsent(
                u["id"], () => TextEditingController());
          }

      
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
             const SizedBox(height: 20,),
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: amountcontroller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Amount",
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
            ),
            const SizedBox(height: 20,),
            InputDecorator(
              decoration: InputDecoration(
                labelText: "PaidBy",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              
              child:
               DropdownButton(
                
                value: paidBy,
                items: users.map((u){
                  return DropdownMenuItem(
                    value: u["id"],
                    child: Text(u["name"]),);
                }).toList(), 
                onChanged: (v){
                  setState(() {
                    paidBy=v! as String;
                  }
                  );
                }),
            ),
              ...users.map((u){
                if (u["id"] == paidBy) return SizedBox();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controllers[u["id"]],
                    decoration: InputDecoration(labelText: "${u["name"]} owes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                    ),
                    
                                 ),
                ); }
        
              ).toList(),
              ElevatedButton(onPressed:(){
              save(users);
              }, 
              child: Text("Add Expense"),),
              ]),
      ),
    );
      
}) );


}
}