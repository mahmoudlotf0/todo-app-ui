import 'package:flutter/material.dart';

import 'package:todoapp/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String lable;
  final Function() onTap;
  MyButton({required this.lable, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryClr,
        ),
        width: 100.0,
        height: 45.0,
        child: Text(
          lable,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
