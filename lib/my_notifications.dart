import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plant_care/widgets/add_button.dart';
import 'package:plant_care/widgets/delete_button.dart';
import 'my_farm.dart';
import 'main.dart';
import 'widgets/notification_item.dart';

class MyNotifications extends StatefulWidget {
  static const routeName = '/mynotifications';
  @override
  _MyNotificationsState createState() => _MyNotificationsState();
}

class _MyNotificationsState extends State<MyNotifications> {
  void _deleteAllnoti() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('هل أنت متأكد؟'),
        content: Text('هل تريد حذف جميع التنبيهات من قائمتك؟'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: Text('لا'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userID',
                      isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  element.reference.delete().then((value) => {
                        setState(() {
                          dataList = FirebaseFirestore.instance
                              .collection('notifications')
                              .where('userID',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser.uid)
                              .get()
                              .asStream();
                        })
                      });
                });
              });
              Navigator.of(ctx).pop(true);
            },
            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }

  Stream dataList;
  @override
  void initState() {
    dataList = FirebaseFirestore.instance
        .collection('notifications')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .orderBy('date', descending: true)
        .get()
        .asStream();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: const Text(
          'تنبيهاتي',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: DeleteButton(
            onPressed: _deleteAllnoti,
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: dataList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.docs.length == 0) {
                  return const Center(
                    child: Text('لا يوجد تنبيهات حتى هذي اللحظة'),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (ctx, i) {
                      return Dismissible(
                        child: NotificationItem(snapshot.data.docs[i].id),
                        background: Container(
                          decoration: BoxDecoration(
                            color: Color(0XFFcc0000),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('هل أنت متأكد؟'),
                              content:
                                  Text('هل تريد حذف هذا التنبيه من قائمتك؟'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(false);
                                  },
                                  child: Text('لا'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop(true);
                                  },
                                  child: Text('نعم'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(snapshot.data.docs[i].id)
                              .delete();
                          setState(() {
                            dataList = FirebaseFirestore.instance
                                .collection('notifications')
                                .where('userID',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser.uid)
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
                    itemCount: snapshot.data.docs.length,
                  );
                }
              }),
        ),
      ]),
    );
  }
}

class TempNotification {
  TempNotification(
      this.plantName, this.opName, this.opTime, this.notificationTime);
  String plantName;
  String opName;
  String opTime;
  DateTime notificationTime;
}
