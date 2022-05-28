import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  String title = '';
  double width = 300;
  double height = 300;
  List<Widget> children = [];
  CustomDialog({
    Key? key,
    required String title,
    required double width,
    required double height,
    required List<Widget> children
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
              ...children
            ],
          ),
        )
    );
  }
}