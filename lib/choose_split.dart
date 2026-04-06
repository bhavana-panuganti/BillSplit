import 'package:flutter/material.dart';
import 'Equal_split_page.dart';
import 'Manualsplit.dart';
class ChooseSplitPage extends StatelessWidget {
  const ChooseSplitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Split Type",style: TextStyle(
        color: Colors.white
      ),),
      backgroundColor: const Color.fromARGB(255, 67, 33, 83),),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 228, 188, 236)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingelExpensePage(),
                    ),
                  );
                },
                child: Text("Equal Split"),
              ),
            ),

            SizedBox(height: 20),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 228, 188, 236)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Manualsplit(),
                    ),
                  );
                },
                child: Text("Manual Split"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}