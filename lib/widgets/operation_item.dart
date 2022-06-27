import 'package:firebase_core/firebase_core.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';

//ignore: must_be_immutable
class OperationItem extends StatefulWidget {
  OperationItem(this.operation);
  String operation;
  DateFormat dateFormat;
  Future op;

  @override
  _OperationItemState createState() => _OperationItemState();
}

class _OperationItemState extends State<OperationItem> {
  bool status1 = true;
  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Map<String, dynamic>>> op;
    op = FirebaseFirestore.instance
        .collection('operations')
        .doc(widget.operation)
        .get();
    return FutureBuilder(
        future: op,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          Timestamp stDate = snapshot.data['startDate'];
          Timestamp endDate = snapshot.data['endDate'];
          DateTime dt = stDate.toDate();
          DateTime et = endDate.toDate();

          initializeDateFormatting('ar_SA');
          var dateformaterAR = new DateFormat.MMMMd('ar_SA');
          return GestureDetector(
            onTap: () {
              if (snapshot.data['type'] == 'irrigation') {
                Navigator.pushNamed(context, AddIrrigation.routeName,
                        arguments: ScreenArguments(
                            id: snapshot.data.id,
                            operationTypeString: snapshot.data['type'],
                            addEdit: 'تعديل'))
                    .then((value) => setState(() {
                          op = FirebaseFirestore.instance
                              .collection('operations')
                              .doc(widget.operation)
                              .get();
                        }));
              } else if (snapshot.data['type'] == 'planting') {
                Navigator.pushNamed(context, AddPlanting.routeName,
                        arguments: ScreenArguments(
                            id: snapshot.data.id,
                            operationTypeString: snapshot.data['type'],
                            addEdit: 'تعديل'))
                    .then((value) => setState(() {
                          op = FirebaseFirestore.instance
                              .collection('operations')
                              .doc(widget.operation)
                              .get();
                        }));
              } else if (snapshot.data['type'] == 'harvest') {
                Navigator.pushNamed(context, AddHarvest.routeName,
                        arguments: ScreenArguments(
                            id: snapshot.data.id,
                            operationTypeString: snapshot.data['type'],
                            addEdit: 'تعديل'))
                    .then((value) => setState(() {
                          op = FirebaseFirestore.instance
                              .collection('operations')
                              .doc(widget.operation)
                              .get();
                        }));
              } else if (snapshot.data['type'] == 'spraying') {
                Navigator.pushNamed(context, AddSpraying.routeName,
                        arguments: ScreenArguments(
                            id: snapshot.data.id,
                            operationTypeString: snapshot.data['type'],
                            addEdit: 'تعديل'))
                    .then((value) => setState(() {
                          op = FirebaseFirestore.instance
                              .collection('operations')
                              .doc(widget.operation)
                              .get();
                        }));
              } else if (snapshot.data['type'] == 'fertilizing') {
                Navigator.pushNamed(context, AddFertilizing.routeName,
                        arguments: ScreenArguments(
                            id: snapshot.data.id,
                            operationTypeString: snapshot.data['type'],
                            addEdit: 'تعديل'))
                    .then((value) => setState(() {
                          op = FirebaseFirestore.instance
                              .collection('operations')
                              .doc(widget.operation)
                              .get();
                        }));
              }
            },
            child: Container(
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
              height: 92,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlutterSwitch(
                      value: snapshot.data['isReminding'],
                      onToggle: (val) {
                        if (snapshot.data['isActive'] == false) {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('لا يمكنك فعل ذلك'),
                                content: Text(
                                    'انتهى وقت التذكير لهذا الاجراء, الرجاء تغيير وقت الانتهاء لكي يتم تفعيل الاجراء مرة اخرى'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('حسنا'))
                                ],
                              ),
                            );
                          });
                        } else {
                          setState(() {
                            bool rem = snapshot.data['isReminding'];
                            FirebaseFirestore.instance
                                .collection('operations')
                                .doc(snapshot.data.id)
                                .update({
                              'isReminding': !rem,
                            });
                          });
                        }
                      },
                      activeColor: Color(0XFF5BAF5E),
                      width: 60,
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            ' من ' +
                                dateformaterAR.format(dt) +
                                ' الى ' +
                                dateformaterAR.format(et),
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0XFF2D9CDB),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/*
class OperationItem extends StatelessWidget {
  OperationItem(this.operation);
  final Operation operation;
  DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    DateFormat dateformat = DateFormat('MM/dd/yyyy');
    DateTime dt = dateformat.parse(operation.date);
    initializeDateFormatting('ar_SA');
    var dateformaterAR = new DateFormat.MMMMEEEEd('ar_SA');

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AddOperation.routeName,
            arguments:
                ScreenArguments(id: operation.id, pid: operation.Plantid));
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          color: Color(0XFFC4C4C4),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.all(10),
        height: 92,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      dateformaterAR.format(dt),
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
