import 'package:flutter/material.dart';
import 'package:medicad/strings.dart';

class  DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.DASHBOARD),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Center(
            child: Text( 'Dashboard')
          ),
        ),
      ),
    );
  }
}