import 'package:flutter/material.dart';
import 'package:residents_app/widgets/user_botton_navigation.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  final Widget childView;


  const HomeScreen({
    super.key, 
    required this.childView
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
