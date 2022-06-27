import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'my_farm.dart';
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

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'ادخل الاسم';
    } else if (value.length < 3) {
      return 'الرجاء ادخال اسم اعلى من ثلاثة أحرف';
    } else {
      return null;
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyOTP = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  //Form controllers
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isOTPScreen ? returnOTPScreen() : registerScreen();
  }

  Widget registerScreen() {
    final node = FocusScope.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 90,
          centerTitle: true,
          title: Text(
            'تسجيل مستخدم جديد',
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
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'الاسم'),
                          validator: NameValidator.validate,
                        ),
                      )),
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
                                height: 54,
                              ),
                              Flexible(
                                child: TextFormField(
                                  enabled: !isLoading,
                                  keyboardType: TextInputType.phone,
                                  controller: phoneNumberController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => node.unfocus(),
                                  decoration: InputDecoration(
                                      hintText: 'رقم الجوال',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: 'رقم الجوال'),
                                  validator: PhoneNumberValidator.validate,
                                ),
                              )
                            ]),
                      )),
                      Container(
                          margin: EdgeInsets.only(top: 40, bottom: 5),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0XFF11493E)),
                                ),
                                onPressed: () {
                                  if (!isLoading) {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        signUp();
                                        isRegister = false;
                                        isOTPScreen = true;
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
                                      Expanded(
                                        child: Text(
                                          "التالي",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
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
                            !isLoading ? "ادخل رمز التحقق" : "جاري الارسال",
                            textAlign: TextAlign.center))),
                !isLoading
                    ? Container(
                        child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          enabled: !isLoading,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          initialValue: null,
                          autofocus: true,
                          decoration: const InputDecoration(
                              labelText: 'رمز التحقق',
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'ادخل رمز التحقق';
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
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0XFF11493E)),
                              ),
                              onPressed: () async {
                                if (_formKeyOTP.currentState.validate()) {
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
                                              if (user != null)
                                                {
                                                  await _firestore
                                                      .collection('users')
                                                      .doc(
                                                          _auth.currentUser.uid)
                                                      .set(
                                                          {
                                                        'name': nameController
                                                            .text
                                                            .trim(),
                                                        'phoneNumber':
                                                            phoneNumberController
                                                                .text
                                                                .trim(),
                                                      },
                                                          SetOptions(
                                                              merge:
                                                                  true)).then(
                                                          (value) => {
                                                                //then move to authorised area
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                  isResend =
                                                                      false;
                                                                })
                                                              }),
                                                  setState(() {
                                                    isLoading = false;
                                                    isResend = false;
                                                  }),
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          TabScreen(),
                                                    ),
                                                    (route) => false,
                                                  )
                                                }
                                            })
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
                                    Expanded(
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
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isResend = false;
                                  isLoading = true;
                                });
                                await signUp();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 15.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "اعد ارسال الكود",
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

  Future signUp() async {
    setState(() {
      isLoading = true;
    });
    var phoneNumber = '+966 ' + phoneNumberController.text.toString();
    var verifyPhoneNumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        _auth.signInWithCredential(phoneAuthCredential).then((user) async => {
              if (user != null)
                {
                  await _firestore
                      .collection('users')
                      .doc(_auth.currentUser.uid)
                      .set({
                        'name': nameController.text.trim(),
                        'phoneNumber': phoneNumberController.text.trim()
                      }, SetOptions(merge: true))
                      .then((value) => {
                            setState(() {
                              isLoading = false;
                              isRegister = false;
                              isOTPScreen = false;

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TabScreen(),
                                ),
                                (route) => false,
                              );
                            })
                          })
                      .catchError((onError) => {})
                }
            });
      },
      verificationFailed: (FirebaseAuthException error) {
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (verificationId, [forceResendingToken]) {
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
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
  }
}
