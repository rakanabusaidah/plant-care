import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plant_care/login_screen.dart';
import 'package:provider/provider.dart';
import 'models/plant.dart';
import 'providers/plants.dart';
import 'widgets/add_button.dart';
import 'widgets/plant_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyFarm extends StatefulWidget {
  static const routeName = '/myfarm';
  @override
  _MyFarmState createState() => _MyFarmState();
}

class _MyFarmState extends State<MyFarm> {
  Stream dataList;

  @override
  void initState() {
    dataList = FirebaseFirestore.instance
        .collection('plants')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .orderBy('dateAdded', descending: false)
        .get()
        .asStream();

    super.initState();
  }

  void removePlant(String id) {
    FirebaseFirestore.instance.collection('plants').doc(id).delete();
    setState(() {});
  }

  @override
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    final plantsData = Provider.of<Plants>(
        context); // i wanna listen to any changes in products
    final plants = plantsData.userPlants;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          'نباتاتي',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AddButton(onPressed: () {
              Navigator.pushNamed(context, '/fruitsvegetables');
            }),
          ),
          Expanded(
            child: StreamBuilder(
                stream: dataList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Text("مزرعتك فارغة"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, i) {
                        return Dismissible(
                          child: PlantItem(snapshot.data.docs[i].id),
                          background: Container(
                            decoration: const BoxDecoration(
                              color: Color(0XFFcc0000),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 40,
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) {
                            return showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('هل أنت متأكد؟'),
                                content: const Text(
                                    'هل تريد حذف هذه النبتة من قائمتك؟'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(false);
                                    },
                                    child: const Text('لا'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(true);
                                    },
                                    child: const Text('نعم'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            FirebaseFirestore.instance
                                .collection('operations')
                                .where('plantID',
                                    isEqualTo: snapshot.data.docs[i].id)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                element.reference.delete();
                              }
                            });
                            FirebaseFirestore.instance
                                .collection('plants')
                                .doc(snapshot.data.docs[i].id)
                                .delete();

                            setState(() {
                              dataList = FirebaseFirestore.instance
                                  .collection('plants')
                                  .where('userID',
                                      isEqualTo:
                                          FirebaseAuth.instance.currentUser.uid)
                                  .orderBy('dateAdded', descending: false)
                                  .get()
                                  .asStream();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0XFF11493E),
                                content: Text(
                                  'تم الحذف',
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            );
                          },
                          key: UniqueKey(),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
