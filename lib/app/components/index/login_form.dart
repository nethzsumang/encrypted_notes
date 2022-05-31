import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username'
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password'
                  ),
                  obscureText: true,
                )
            ),
          ]
      ),
    );
  }

}