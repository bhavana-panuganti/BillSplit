
import 'package:bill_split/details_page.dart';
import 'package:bill_split/signup_page.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'choose_split.dart';
import 'package:flutter/material.dart';
import 'users_page.dart';
import 'history_page.dart';
import 'usersPage.dart';
import 'settlement_page.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

class HomePage extends StatefulWidget {

const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
@override
void initState(){
  super.initState();
  final user = FirebaseAuth.instance.currentUser;
  if(user!=null){
    Provider.of<ExpenseProvider>(context,listen:false).listenToExpense(user.uid);
  }
}
@override
Widget build(BuildContext context) {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

return Scaffold(
  backgroundColor: const Color.fromARGB(255, 224, 186, 235),

appBar: AppBar(

backgroundColor: const Color.fromARGB(255, 67, 33, 83),

title: const Text("BillSplit",style: TextStyle(
color: Colors.white),),

actions: [

IconButton(onPressed: () async{

await FirebaseAuth.instance.signOut();

},

icon: const Icon(Icons.logout,color: Colors.white,))


],
iconTheme: const IconThemeData(
    color: Colors.white, 
  ),


),
drawer: Drawer(
  backgroundColor: const Color.fromARGB(255, 139, 127, 141),
    child: ListView(
       padding: const EdgeInsets.only(top: 40),
      
      children: [

        const SizedBox(height: 40),

        ListTile(
          leading: Icon(Icons.home),
          title: Text("Home"),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        ListTile(
          leading: Icon(Icons.receipt),
          title: Text("All Expenses"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseHistoryPage()),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.add),
          title: Text("Add Expense"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChooseSplitPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person_add),
          title: Text("Add User"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersPage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user_rounded),
          title: Text("Friends"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => userpagew() ));
          },
        ),
        ListTile(
          leading: Icon(Icons.money),
          title: Text("PaidStatus"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettlementsPage() ));
          },
        ),

        Divider(),

        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Logout"),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
             Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => SignupPage()), 
    (route) => false,);
          },
        ),
      ],
    ),
  ),

floatingActionButton: FloatingActionButton.extended(

backgroundColor: const Color.fromARGB(255, 67, 33, 83),

onPressed: (){

Navigator.push(context, MaterialPageRoute(builder: (context)=> ChooseSplitPage()));

},

label: const Text("Add expense",style: TextStyle(color: Colors.white),),

icon: const Icon(Icons.add,

color: Colors.white,),

),

body: Padding(

padding: const EdgeInsets.all(8.0),

child: Column(

children: [

Consumer<ExpenseProvider>(
  builder: (context,provider,child){
    var expenses = provider.expenses;
    if (expenses.isEmpty) {
                  return const Text("No data");

  }
                 double youOwe = 0;
                double youAreOwed = 0;
                for (var e in expenses) {

                  String? paidBy = e["paidBy"];
                  Map<String, dynamic>? splits = e["splits"];
                  Map<String, dynamic>? paidMap = e["paid"];
                  if (paidBy == null || splits == null) continue;
                  if (paidBy == currentUserId) {
                    splits.forEach((userId, amount) {
                      if (userId != currentUserId) {
                        bool isPaid =
                            paidMap != null && paidMap[userId] == true;

                        if (!isPaid) {
                          youAreOwed += (amount as num).toDouble();
                        }
                      }
                    });
                  } else if (splits.containsKey(currentUserId)) {
                    bool isPaid = paidMap?[currentUserId] == true;

                    if (!isPaid) {
                      youOwe += (splits[currentUserId] as num).toDouble();
                    }
                  }
                  }
                  return Row(
                  children: [
                    Expanded(
                      child: buildBalanceCard(
                        context: context,
                        title: "You Owe",
                        amount: youOwe,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildBalanceCard(
                        context: context,
                        title: "You are Owed",
                        amount: youAreOwed,
                        color: Colors.green,
                      ),
                    ),
                  ],
                );
                
            


}),




const SizedBox(height: 20,),

SizedBox(

width: double.infinity,

child: Card(

color: const Color.fromARGB(255, 152, 110, 156),

elevation: 6,

shape: RoundedRectangleBorder(

borderRadius: BorderRadius.circular(15),

),

child: Padding(

padding: const EdgeInsets.all(16.0),

child: Column(

crossAxisAlignment: CrossAxisAlignment.start,

children: [

const Text("Expenses",style: TextStyle(

fontSize: 18,

fontWeight: FontWeight.bold,

),),


const SizedBox(height: 10,),

Consumer<ExpenseProvider>(

builder: (context, provider, child) {

var expenses=provider.expenses;

if (expenses.isEmpty) {
return const Text("No expenses yet");
  }

return ListView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount:
expenses.length>3?3 : expenses.length,
itemBuilder: (context, index) {

var e=expenses[index];

return ListTile(
title: Text(e["Title"] ??"No Title"),

onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
ExpenseDetailsPage(
expense: e,
expenseId: e["id"], 
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10,),
ElevatedButton(
  onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseHistoryPage()));

  }, child: Text("All expenses")),
                ],
              ),
)),
), 
 
], 
), 
), 
); 
          
}

Widget buildBalanceCard({

required String title,

required double amount,

required Color color,

required BuildContext context,

}){

return Card(

color: const Color.fromARGB(255, 233, 229, 234),

elevation: 6,

shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

child: Padding(padding: const EdgeInsets.all(16),

child: Column(

children: [

Text(

title,

style: const TextStyle(fontSize: 16),

),

const SizedBox(height: 10,),

Text("₹${amount.toStringAsFixed(2)}",

style: TextStyle(

fontSize: 22,

fontWeight: FontWeight.bold,

color: color,

),),

const SizedBox(height: 10,),

TextButton(onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> ExpenseHistoryPage()));
}, child: Text("Veiw Details")),


],

),

),

);

}
}
