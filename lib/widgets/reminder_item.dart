import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_care/add_fertilizing.dart';
import 'package:plant_care/add_harvest.dart';
import 'package:plant_care/add_spraying.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/operation.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:plant_care/add_irrigation.dart';
import 'package:plant_care/agri_operations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plant_care/providers/operations.dart';
import 'package:plant_care/add_planting.dart';
import 'package:timeago/timeago.dart' as timeago;

//ignore: must_be_immutable
class ReminderItem extends StatelessWidget {
  ReminderItem(this.operation);
  String operation;
  DateFormat dateFormat;
  String getTimeDifferenceFromNow(DateTime dateTime) {
    Duration difference = dateTime.difference(DateTime.now());

    if (difference.inSeconds < 10) {
      return "الان";
    } else if (difference.inMinutes < 1) {
      return 'باقي' + (" ${difference.inSeconds} ثانية");
    } else if (difference.inMinutes < 11) {
      return 'باقي' + (" ${difference.inMinutes} دقائق");
    } else if (difference.inHours < 1) {
      return 'باقي' + (" ${difference.inMinutes} دقيقة ");
    } else if (difference.inHours < 11) {
      return 'باقي' +
          (" ${difference.inHours} ساعات " 'و ' +
              (difference.inMinutes % 60).toString() +
              ' دقيقة ');
    } else if (difference.inHours < 24) {
      return 'باقي' +
          (" ${difference.inHours} ساعة" 'و ' +
              (difference.inMinutes % 60).toString() +
              ' دقيقة ');
    } else if (difference.inHours < 48) {
      return 'باقي يوم' +
          ((difference.inHours % 24).toInt() != 0
              ? ' و ' + (difference.inHours % 24).toString() + ' ساعة '
              : '');
    } else if (difference.inHours < 72) {
      return 'باقي يومين' +
          ((difference.inHours % 24).toInt() != 0
              ? ' و ' + (difference.inHours % 24).toString() + ' ساعة '
              : '');
    } else if (difference.inDays < 11) {
      return 'باقي' +
          (" ${difference.inDays} ايام" +
              ((difference.inHours % 24).toInt() != 0
                  ? ' و ' + (difference.inHours % 24).toString() + ' ساعة '
                  : ''));
    } else {
      return 'باقي' +
          (" ${difference.inDays} يوم" +
              ((difference.inHours % 24).toInt() != 0
                  ? ' و ' + (difference.inHours % 24).toString() + ' ساعة '
                  : ''));
    }
  }
//   @override
//   _ReminderItemState createState() => _ReminderItemState();
// }

// class _ReminderItemState extends State<ReminderItem> {

  @override
  Widget build(BuildContext context) {
    int iconIndex;
    String opName;
    List allicons = [
      Icon(FontAwesomeIcons.tint, size: 33, color: Color(0XFF2D9CDB)),
      Icon(FontAwesomeIcons.magic, size: 33, color: Color(0XFF907B00)),
      Icon(FontAwesomeIcons.tractor, size: 33, color: Color(0XFFFFB904)),
      Icon(FontAwesomeIcons.bug, size: 33, color: Color(0XFFA878F7)),
      Icon(FontAwesomeIcons.spa, size: 33, color: Color(0XFF0E8B13)),
    ];

    DateFormat dateformat = DateFormat('MM/dd/yyyy');
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('operations')
            .doc(operation)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          bool next = true;
          if (snapshot.data['previousReminder'] == null) {
            next = false;
          }
          initializeDateFormatting('ar_SA');
          var dateformaterAR = new DateFormat.MMMMEEEEd('ar_SA');
          if (snapshot.data['type'] == 'irrigation') {
            iconIndex = 0;
            opName = 'الري';
          } else if (snapshot.data['type'] == 'fertilizing') {
            iconIndex = 1;
            opName = 'التسميد';
          } else if (snapshot.data['type'] == 'harvest') {
            iconIndex = 2;
            opName = 'الحصاد';
          } else if (snapshot.data['type'] == 'spraying') {
            iconIndex = 3;
            opName = 'الرش';
          } else if (snapshot.data['type'] == 'planting') {
            iconIndex = 4;
            opName = 'الزراعة';
          }
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
              color: Color(0XFFd8d8d8),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            margin: EdgeInsets.all(10),
            height: 160,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              next
                                  ? timeago.format(
                                      snapshot.data['previousReminder']
                                          .toDate(),
                                      locale: 'ar')
                                  : 'لا يوجد ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'عملية ال' +
                                  snapshot.data['typeAR'] +
                                  '\n السابقة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                snapshot.data['isActive']
                                    ? getTimeDifferenceFromNow(
                                        snapshot.data['nextReminder'].toDate())
                                    : 'العملية منتهية',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: snapshot.data['isActive']
                                      ? Colors.green[600]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'عملية ال' +
                                  snapshot.data['typeAR'] +
                                  '\n القادمة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0XFF587959),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    opName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  allicons[iconIndex],
                ],
              ),
            ),
          );
        });
  }
}
