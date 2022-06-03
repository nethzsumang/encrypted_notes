import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/components/index/account_recovery.dart';
import 'package:encrypted_notes/app/components/index/login_form.dart';
import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:encrypted_notes/app/services/authentication_service.dart';
import 'package:encrypted_notes/app/store/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> with AfterLayoutMixin<IndexPage> {
  bool hasSetupAccount = false;
  int currentStep = 0;

  @override
  void afterFirstLayout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? encryptionKey = await secureStorage.read(key: 'k1');

    if (encryptionKey != null) {
      hasSetupAccount = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasSetupAccount) {
      GoRouter.of(context).go('/home');
    }
    
    AuthenticationService authenticationService = AuthenticationService();
    return BlocProvider(
      create: (BuildContext context) => AuthBloc(),
      child: Scaffold(
          body: BlocBuilder<AuthBloc, Map>(
            builder: (context, credentials) {
              return Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep,
                steps: const [
                  Step(
                      title: Text('Account Setup'),
                      content: LoginForm()
                  ),
                ],
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xfff44336)
                                    ),
                                    onPressed: details.onStepCancel,
                                    child: const Text('Back'),
                                  )
                              )
                          ),
                          SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Next'),
                              )
                          )
                        ],
                      ),
                    ],
                  );
                },
                onStepContinue: () async {
                  Map response = await authenticationService.checkIfUserExists(credentials['username']);
                  if (response['success'] == true) {
                    Fluttertoast.showToast(
                      msg: 'User found. Validating account...',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.lightGreen,
                      textColor: Colors.black
                    );
                    print(response);
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
                },
                onStepCancel: () {
                  if (currentStep >= 1) {
                    setState(() => currentStep -= 1);
                  }
                },
                onStepTapped: (index) {
                  setState(() => currentStep = index);
                },
              );
            }
          )
      )
    );
  }
}
