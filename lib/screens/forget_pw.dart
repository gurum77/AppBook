import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgetPw extends StatefulWidget {
  @override
  _ForgetPwState createState() => _ForgetPwState();
}

class _ForgetPwState extends State<ForgetPw> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forget Password').tr(),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Email'.tr(),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please input correct Email.'.tr();
                }
                return null;
              },
            ),
            FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailController.text);
                final snackbar = SnackBar(
                  content: Text('Check your email for password reset.').tr(),
                );

                Scaffold.of(_formKey.currentContext).showSnackBar(snackbar);
              },
              child: Text('Reset Password').tr(),
            )
          ],
        ),
      ),
    );
  }
}
