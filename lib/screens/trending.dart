import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  State<Trending> createState() => _TrendingState();
}

// class _TrendingState extends State<Trending> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: const Scaffold(
//         body: Center(child: Text("Coming Soon...")),
//       ),
//     );
//   }
// }






class _TrendingState extends State<Trending> {
  String weather = "Weather:";
  String distance = "Distance:";
  String petrol = "Petrol:";
  String cost = "Cost:";
  String time = "Time:";
  String accidentArea = "Accident Area:";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Text("Trending Routes",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDetails(weather+"Clear", distance+"11km", petrol+"0.27 Liter approx", cost+"₹30 approx", time + "40 min approx", accidentArea+"Wadala-Chembur Rd\n Dockyard Rd");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadiusDirectional.circular(20)
                    ),
                    child: const Center(
                      child: Text(
                        "Wadala to CSMT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showDetails(weather+"Sunny", distance+"1852km", petrol+"80 Liter approx", cost+"₹20000 approx", time + "1d 10hr approx", accidentArea+"Golden Quadrilateral");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadiusDirectional.circular(20)
                    ),
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: Text(
                        "Mumbai to Ladakh",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDetails(String detail1, String detail2, [String? detail3, String? detail4, String? detail5, String? detail6]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Journey Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(detail1),
              Text(detail2),
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
}