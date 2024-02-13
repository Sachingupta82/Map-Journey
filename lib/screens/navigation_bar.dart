import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:users/screens/first_page.dart';
import 'package:users/screens/fresh_page.dart';
import 'package:users/screens/profile_page.dart';
import 'package:users/screens/trending.dart';

class Navbarpage extends StatefulWidget {
  const Navbarpage({super.key});

  @override
  State<Navbarpage> createState() => _NavbarpageState();
}

class _NavbarpageState extends State<Navbarpage> {
  int _selectedIndex = 0;

   List Screen=[
    JourneyPlannerPage(),
    const Trending(),
    const ProfilePage(),
    const Trending(),
     ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      extendBody: true,
       bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          backgroundColor:Color.fromARGB(255, 168, 216, 181),
          items: const <Widget>[
            Icon(Icons.home, size: 25,),
            Icon(Icons.trending_up_sharp, size: 25),
             Icon(Icons.person, size: 25),
          ],
          onTap: (index) {
            setState(() {
              
              _selectedIndex=index;
            });
           

          },
        ),
        body: Screen[_selectedIndex],
    );
  }
}