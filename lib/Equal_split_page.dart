import 'package:bill_split/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class SingelExpensePage extends StatefulWidget {
  const SingelExpensePage({super.key});

  @override
  State<SingelExpensePage> createState() => _SingelExpensePageState();
}

class _SingelExpensePageState extends State<SingelExpensePage> {
  final titlecontroller = TextEditingController();
  final amountcontroller = TextEditingController();

  String? paidBy;
  
  Map<String, bool> selected = {};
  
  

  void splitAndSave(List users) async{
    double? total = double.tryParse(amountcontroller.text.trim());

if (total == null || total <= 0) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Enter valid amount")),
    );
  }
  return;
}

    List<String> participants =
    selected.entries.where((e) => e.value).map((e) => e.key).toList();


if (paidBy != null && !participants.contains(paidBy)) {
  participants.add(paidBy!);
}
    Map<String, double> splits = {};
if (participants.isEmpty) {
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Select at least one person")),
  );
  return;
};
    
      double share = (total! / participants.length);

      
    for (var p in participants) {
      if (p == paidBy) {
      splits[p] = 0;
    } else {
      splits[p] = share;
    }
    }
    
await FirebaseFirestore.instance.collection("expenses").add({
  "Title": titlecontroller.text,
  "Type": "equal", 
  "total": total,
  "paidBy": paidBy,
"paidByName": users.firstWhere((u) => u["id"] == paidBy)["name"],
"splits": splits,
"splitNames": {
  for (var u in users)
    if (splits.containsKey(u["id"]))
       u["id"]: u["name"]
},
"participants": splits.keys.toList(),
 
  "createdAt": FieldValue.serverTimestamp(),
  "paid": {
    for (var p in participants) p: false},
},

); 
 if (!mounted) return;

    Navigator.popUntil(context, (route) => route.isFirst);
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 67, 33, 83),
        title: Text("Equal Split ",style: TextStyle(
          color: Colors.white
        ),),

      ),
      
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .collection("Friends")
            .snapshots(), 
            

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var docs = snapshot.data!.docs;
final currentUser = FirebaseAuth.instance.currentUser;

    List<Map<String, dynamic>> allUsers = [
      {
        "id": currentUser!.uid,
        "name": currentUser.displayName ?? "Me",
      },
      ...docs.map((doc) => {
            "id": doc.id,
            "name": doc["name"],
          }).toList(),
    ];
          if (paidBy == null && docs.isNotEmpty) {
            paidBy = currentUser!.uid;
          }
      
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text("Enter Details",style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
              TextField(
                controller: titlecontroller,
                decoration: InputDecoration(
                  labelText: "Title",
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  ),
                ),
              
              

              const SizedBox(height: 20),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "PaidBy",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                child: DropdownButton<String>(
                  value: paidBy,
                  isExpanded: true,
                  items:allUsers.map<DropdownMenuItem<String>>((u)
                  
                  {
                     
                   return DropdownMenuItem<String>(
                      value: u["id"],
                      child: Text(u["name"]),
                    );
                  }).toList() , 
                  onChanged: (v){
                    setState(() {
                      paidBy=v as String;
                    });
                  },),
              ),
                
                const SizedBox(height: 10),
                Text("Expense shared by:"),
                Column(
                  children: allUsers
                  .where((u) => u["id"]!=paidBy)
                  .map((u) {

                    return CheckboxListTile(
                      title: Text(u["name"]),
                      value: selected[u["id"]]??false, 
                      onChanged:(val){
                        setState(() {
                          selected[u["id"]] = val!;
                          
                        });
                      }, );
                  }
                  ).toList(),
                  
        
                ),

ElevatedButton(
  onPressed:(){
    splitAndSave(allUsers);},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // 👈 button color
  ),
  child: Text("Add Expense"),
),
        
        ],
            
          ),
        ),
        
      );}
      



    )
 );
 }
}