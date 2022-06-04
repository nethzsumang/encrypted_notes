import 'package:encrypted_notes/app/store/auth_bloc.dart';
import 'package:encrypted_notes/app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: BlocBuilder<AuthBloc, Map>(
                builder: (context, credentials) {
                  return SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async {
                          await onLoginFormSubmit(context, credentials);
                        },
                        child: const Text('Next'),
                      )
                  );
                }
              )
            )
          ]
      ),
    );
  }

  onLoginFormSubmit(BuildContext context, Map credentials) async {
    AuthenticationService authenticationService = AuthenticationService();
    Map response = await authenticationService.checkIfUserExists(credentials['username']);
    if (response['success'] == true) {
      Fluttertoast.showToast(
          msg: 'User found. Validating account...',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.black
      );
      bool saveSuccess = await authenticationService.saveKeyOfExistingUser(
          credentials['username'],
          credentials['password'],
          response['data']
      );
      if (saveSuccess) {
        Fluttertoast.showToast(
            msg: 'Validation successful. Redirecting...',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.black
        );
        GoRouter.of(context).go('/home');
      } else {
        Fluttertoast.showToast(
            msg: 'Account validation failed. Possibly incorrect password.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.black
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: 'User not found. Creating new keys...',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.black
      );
      Map keys = await authenticationService.createNewKeysForUser(credentials['password']);
      await authenticationService.saveNewUser({
        'username': credentials['username'],
        'salt': keys['salt'],
        'iv': keys['iv'],
        'k3': keys['k3'],
        'k1': keys['encryptedK1']
      });
      Fluttertoast.showToast(
          msg: 'Keys successfully generated and saved.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.black
      );
    }
  }
}