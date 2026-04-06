import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseProvider extends ChangeNotifier{
  List<Map<String,dynamic>> _expenses = [];
  List<Map<String, dynamic>> get expenses => _expenses;
void listenToExpense(String userId){
  FirebaseFirestore.instance
  .collection("expenses")
  .where("participants", arrayContains: userId)
  .snapshots()
  .listen((snapshot){
    _expenses=snapshot.docs
    .map((doc) => {...doc.data(),"id": doc.id,}).toList();
    notifyListeners();
  }

  );
}
Future<void> updatePayment(String docId, String userId, bool val) async {
    await FirebaseFirestore.instance
        .collection("expenses")
        .doc(docId)
        .update({
      "paid.$userId": val
    });
  }

}