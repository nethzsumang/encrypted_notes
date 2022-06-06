import 'package:encrypted_notes/app/store/auth_bloc.dart';
import 'package:encrypted_notes/app/services/authentication_service.dart';
import 'package:encrypted_notes/app/libraries/secure_storage_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 300,
      width: width * 0.5,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
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
              padding: const EdgeInsets.only(top: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: BlocBuilder<AuthBloc, Map>(
                    builder: (context, credentials) {
                      return SizedBox(
                        width: 200,
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
              ],
            )
          ]
      ),
    );
  }

  onLoginFormSubmit(BuildContext context, Map credentials) async {
    AuthenticationService authenticationService = AuthenticationService();
    SecureStorageLibrary secureStorageLibrary = SecureStorageLibrary();
    Map response = await authenticationService.checkIfUserExists(credentials['username']);
    if (response['success'] == true) {
      bool saveSuccess = await authenticationService.saveKeyOfExistingUser(
        credentials['username'],
        credentials['password'],
        response['data']
      );
      if (saveSuccess) {
        EasyLoading.showSuccess('Logged in successfully.');
        await secureStorageLibrary.setValue('userNo', response['data']['id'].toString());
        GoRouter.of(context).go('/home');
      } else {
        EasyLoading.showError('Account validation failed. Possibly incorrect password.');
      }
    } else {
      Map keys = await authenticationService.createNewKeysForUser(credentials['password']);
      await authenticationService.saveNewUser({
        'username': credentials['username'],
        'salt': keys['salt'],
        'iv': keys['iv'],
        'k3': keys['k3'],
        'k1': keys['encryptedK1']
      });
      EasyLoading.showSuccess('Keys successfully generated and saved.');
    }
  }
}