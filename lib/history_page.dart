import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data_store.dart';
import 'details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

class ExpenseHistoryPage extends StatelessWidget {
  const ExpenseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    void deleteExpense(BuildContext context, String docId) async{
      await FirebaseFirestore.instance.collection("expenses").doc(docId).delete();
      if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Expense deleted")),
  );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: const Color.fromARGB(255, 67, 33, 83),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context,provider,child){
          var docs = provider.expenses;
           if (docs.isEmpty) {
            return const Center(child: Text("No expenses yet"));


        }
        return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {

              var e = docs[i]; 

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: const Color.fromARGB(255, 197, 173, 205),

                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpenseDetailsPage(
                            expense: e,expenseId: e["id"],  )
                      ));
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e["Title"] ?? "No Title",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),

                          Text(
                            "₹${e["total"] ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {

                              
                              deleteExpense(context, e["id"]);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      )
      );

  }}