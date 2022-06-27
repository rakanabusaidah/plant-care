import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_care/my_notifications.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  NotificationItem(this.notiID, {Key key}) : super(key: key);
  String notiID;
//   @override
//   _NotificationItemState createState() => _NotificationItemState();
// }

// class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
        color: Color(0XFFFDFBF9),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin: EdgeInsets.all(10),
      height: 85,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('notifications')
                .doc(notiID)
                .get(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(snapshot.data['title'],
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(snapshot.data['text']),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      Text(
                        timeago.format(snapshot.data['date'].toDate(),
                            locale: 'ar'),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      )
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
