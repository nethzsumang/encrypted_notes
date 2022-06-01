import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/components/index/account_preparation.dart';
import 'package:encrypted_notes/app/components/index/account_recovery.dart';
import 'package:encrypted_notes/app/components/index/login_form.dart';
import 'package:encrypted_notes/app/libraries/encryption_library.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
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
    String? iv = await secureStorage.read(key: 'iv');
    String? k3 = await secureStorage.read(key: 'k3');
    String? salt = await secureStorage.read(key: 'salt');

    if (encryptionKey != null && iv != null && k3 != null && salt != null) {
      hasSetupAccount = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasSetupAccount) {
      GoRouter.of(context).go('/home');
    }
    return Scaffold(
       body: Stepper(
         type: StepperType.horizontal,
         currentStep: currentStep,
         steps: const [
           Step(
             title: Text('Account Setup'),
             content: LoginForm()
           ),
           Step(
             title: Text('Key Generation and Preparation'),
             content: AccountPreparation()
           ),
           Step(
               title: Text('Account Privacy and Recovery'),
               content: AccountRecovery()
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
         onStepContinue: () {
           if (currentStep <= 1) {
             setState(() => currentStep += 1);
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
       )
    );
  }
}
