import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/strings.dart';

class AccountTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text( 'Account'),
      )
    );
  }
}