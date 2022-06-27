import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'widgets/profile_button.dart';

class MyProfile extends StatefulWidget {
  static const routeName = '/myprofile';
  const MyProfile({Key key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _form = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _buttonState = false;
  TextEditingController controller;
  String finalValue;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      final _buttonState = controller.text.isNotEmpty;
      setState(() {
        this._buttonState = _buttonState;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'name': finalValue,
    }).then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Color(0XFF11493E),
                  content: Text(
                    'تم التحديث',
                    textAlign: TextAlign.end,
                  ),
                ),
              )
            });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          'حسابي',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: StreamBuilder(
              stream: getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Text("جاري التحميل...");
                else if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      TextFormField(
                        //initialValue: snapshot.data["name"],
                        textAlign: TextAlign.right,
                        controller: controller,

                        decoration: InputDecoration(
                          hintText: snapshot.data["name"],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'الاسم',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'الرجاء ادخال الاسم';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          finalValue = value;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        initialValue: '0' + snapshot.data["phoneNumber"],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        enabled: false,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'رقم الجوال',
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'الرجاء ادخال الرقم';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        key: const Key('updateButton'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0XFF11493E),
                          onPrimary: Colors.white,
                          onSurface: Color(0XFF11493E),
                        ),
                        onPressed: _buttonState
                            ? () {
                                setState(() {
                                  _buttonState = false;
                                });
                                _saveForm();
                              }
                            : null,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Expanded(
                                    child: Text(
                                  "تحديث",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0XFF8B0000),
                          onPrimary: Colors.white,
                        ),
                        onPressed: () {
                          _auth.signOut().then((value) =>
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName));
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Expanded(
                                    child: Text(
                                  "تسجيل خروج",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                            )),
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }

  getData() async* {
    User user = await FirebaseAuth.instance.currentUser;
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();
  }
}
