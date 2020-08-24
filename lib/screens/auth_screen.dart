import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  final _phoneTextController = TextEditingController();
  final _codeController = TextEditingController();

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }


  Future<FirebaseUser> login(String phone, BuildContext context) {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        _auth.signInWithCredential(authCredential);
        Navigator.of(context).pop();
      },
      verificationFailed: (AuthException exception){
        print(exception.message);
      },
      codeSent: (String verificationId, [int forceResendingToken]){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                      _auth.signInWithCredential(credential);
                      Navigator.pop(context);

                    },
                  )
                ],
              );
            }
        );
      },
      codeAutoRetrievalTimeout: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _handleSignIn()
                    .then((FirebaseUser user) => print(user.phoneNumber))
                    .catchError((e) => print(e));
              },
              child: Text('Sign in with Google'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Enter phone no.'),
              controller: _phoneTextController,
              keyboardType: TextInputType.phone,
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: (){
                final phone = _phoneTextController.text.trim();
                login(phone, context);
              },
            )
          ],
        ),
      ),
    );
  }
}
