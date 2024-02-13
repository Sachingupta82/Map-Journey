import 'package:flutter/material.dart';

class CustomDialog {
  
  static void showTwoTextFieldDialog(BuildContext context) {
    TextEditingController textField1Controller = TextEditingController();
    TextEditingController textField2Controller = TextEditingController();
    void showDetails(String detail1, String detail2, [String? detail3, String? detail4, String? detail5, String? detail6]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(" $detail1"),
              Text(" $detail2"),
              if (detail3 != null) Text(" $detail3"),
              if (detail4 != null) Text(" $detail4"),
              if (detail5 != null) Text(" $detail5"),
              if (detail6 != null) Text(" $detail6"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the Journey'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textField1Controller,
                decoration: InputDecoration(labelText: 'Start Location'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: textField2Controller,
                decoration: InputDecoration(labelText: 'Destination'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
              ),
              onPressed: () {
                // Access the values from the text fields
                // String text1 = textField1Controller.text;
                // String text2 = textField2Controller.text;

                // // Do something with the values (e.g., print them)
                // print('Text 1: $text1');
                // print('Text 2: $text2');

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cool Button',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  
}
