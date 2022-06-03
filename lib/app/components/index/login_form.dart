import 'package:encrypted_notes/app/store/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: BlocBuilder<AuthBloc, Map>(
                  builder: (context, credentials) {
                    return TextFormField(
                      initialValue: credentials['username'],
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username'
                      ),
                      onChanged: (value) {
                        context.read<AuthBloc>().add(UsernameChanged(value));
                      },
                    );
                  }
                )
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: BlocBuilder<AuthBloc, Map>(
                  builder: (context, credentials) {
                    return TextFormField(
                      initialValue: credentials['password'],
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password'
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(PasswordChanged(value));
                      }
                    );
                  },
                )
            ),
          ]
      ),
    );
  }

}