import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'register_screen.dart';
import 'my_farm.dart';
import 'package:plant_care/my_farm.dart';
import 'tab_screen.dart';

class PhoneNumberValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'ادخل رقم الجوال';
    } else if (value.length != 9) {
      return 'الرجاء ادخال رقم جوال صحيح';
    } else {
      return null;
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController numberController = new TextEditingController();
  final TextEditingController otpController = new TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isLoginScreen = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : returnLoginScreen();
  }

  Widget returnLoginScreen() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: true,
          title: Text(
            'صفحة الدخول',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(children: [
          Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    '+966',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                width: 45,
                                height: 43,
                              ),
                              Flexible(
                                child: TextFormField(
                                  enabled: !isLoading,
                                  controller: numberController,
                                  keyboardType: TextInputType.phone,
                                  decoration:
                                      InputDecoration(labelText: 'رقم الجوال'),
                                  validator: PhoneNumberValidator.validate,
                                ),
                              ),
                            ]),
                      )),
                      Container(
                          color: Color(0XFFFDFBF9),
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: !isLoading
                                  ? ElevatedButton(
                                      key: const Key('ElevatedButton'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0XFF11493E)),
                                      ),
                                      onPressed: () async {
                                        if (!isLoading) {
                                          if (_formKey.currentState
                                              .validate()) {
                                            displaySnackBar('ارجوا الانتظار');
                                            await login();
                                          }
                                        }
                                      },
                                      child: Container(
                                          color: Color(0XFF11493E),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15.0,
                                            horizontal: 15.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const <Widget>[
                                              Expanded(
                                                  child: Text(
                                                "تسجيل الدخول",
                                                textAlign: TextAlign.center,
                                              )),
                                            ],
                                          )),
                                    )
                                  : CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ))),
                      Container(
                          margin: EdgeInsets.only(top: 15, bottom: 5),
                          alignment: AlignmentDirectional.center,
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        "ليس لديك حساب؟",
                                      )),
                                  InkWell(
                                    key: const Key('newAccount'),
                                    child: const Text(
                                      'تسجيل جديد',
                                    ),
                                    onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterScreen()))
                                    },
                                  ),
                                ],
                              )))
                    ],
                  ))
            ],
          )
        ]));
  }

  Widget returnOTPScreen() {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: true,
          title: Text(
            'رمز التحقق',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(children: [
          Form(
            key: _formKeyOTP,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Text(
                            !isLoading
                                ? "الرجاء ادخال رمز التحقق"
                                : "جاري الارسال",
                            textAlign: TextAlign.center))),
                !isLoading
                    ? Container(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          key: const Key('OTPtext'),
                          enabled: !isLoading,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: 'رمز التحقق',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'الرجاء ادخال رمز التحقق';
                            }
                          },
                        ),
                      ))
                    : Container(),
                !isLoading
                    ? Container(
                        margin: EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ElevatedButton(
                              key: const Key('OTPButton'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0XFF11493E)),
                              ),
                              onPressed: () async {
                                if (_formKeyOTP.currentState.validate()) {
                                  // If the form is valid, we want to show a loading Snackbar
                                  // If the form is valid, we want to do firebase signup...
                                  setState(() {
                                    isResend = false;
                                    isLoading = true;
                                  });
                                  try {
                                    await _auth
                                        .signInWithCredential(
                                            PhoneAuthProvider.credential(
                                                verificationId:
                                                    verificationCode,
                                                smsCode: otpController.text
                                                    .toString()))
                                        .then((user) async => {
                                              //sign in was success
                                              if (user != null)
                                                {
                                                  //store registration details in firestore database
                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          TabScreen.routeName)
                                                }
                                            })
                                        // ignore: invalid_return_type_for_catch_error
                                        .catchError((error) => {
                                              setState(() {
                                                isLoading = false;
                                                isResend = true;
                                              }),
                                            });
                                    setState(() {
                                      isLoading = true;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "ارسال",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              ].where((c) => c != null).toList(),
                            )
                          ]),
                isResend
                    ? Container(
                        margin: EdgeInsets.only(top: 40, bottom: 5),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: new ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await login();
                              },
                              child: new Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Expanded(
                                      child: Text(
                                        "اعادة ارسال الرمز",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )))
                    : Column()
              ],
            ),
          )
        ]));
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future login() async {
    setState(() {
      isLoading = true;
    });

    var phoneNumber = '+966 ' + numberController.text.trim();

    //first we will check if a user with this cell number exists
    var isValidUser = false;
    var number = numberController.text.trim();

    await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      //ok, we have a valid user, now lets do otp verification
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          //auto code complete (not manually)
          _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
                if (user != null)
                  {
                    //redirect
                    setState(() {
                      isLoading = false;
                      isOTPScreen = false;
                    }),
                    Navigator.pushReplacementNamed(context, TabScreen.routeName)
                  }
              });
        },
        verificationFailed: (FirebaseAuthException error) {
          displaySnackBar('حدث مشكلة');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
            isOTPScreen = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60),
      );
      await verifyPhoneNumber;
    } else {
      //non valid user
      setState(() {
        isLoading = false;
      });
      displaySnackBar('الرقم غير مسجل, يرجى التسجيل');
    }
  }
}
