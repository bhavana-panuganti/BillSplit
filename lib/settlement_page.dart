import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'expense_provider.dart';

class SettlementsPage extends StatelessWidget {
  const SettlementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserId =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settlements",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 67, 33, 83),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {

          var docs = provider.expenses;

          List<Widget> tiles = [];

          for (var e in docs) {

            String? paidBy = e["paidBy"];
            Map<String, dynamic>? splits = e["splits"];
            Map<String, dynamic>? paidMap = e["paid"];

            if (paidBy == null || splits == null) continue;

           
            if (splits.containsKey(currentUserId) &&
                paidBy != currentUserId) {

              double amount =
                  (splits[currentUserId] as num).toDouble();

              bool isPaid =
                  paidMap != null &&
                  paidMap[currentUserId] == true;

              String paidToName =
                  e["paidByName"] ?? "Unknown";

              tiles.add(
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),

                  child: ListTile(
                    title: Text("You owe ₹$amount"),
                    subtitle: Text("To $paidToName"),

                    trailing: Checkbox(
                      value: isPaid,

                      onChanged: (val) async {

                        
                        await Provider.of<ExpenseProvider>(
                          context,
                          listen: false,
                        ).updatePayment(
                          e["id"], 
                          currentUserId,
                          val!,
                        );
                      },
                    ),
                  ),
                ),
              );
            }
          }

          if (tiles.isEmpty) {
            return const Center(child: Text("No dues"));
          }

          return ListView(children: tiles);
        },
      ),

      
    );


  }}