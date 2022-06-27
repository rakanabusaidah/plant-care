import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plant_care/add_fertilizing.dart';
import 'package:plant_care/add_harvest.dart';
import 'package:plant_care/add_planting.dart';
import 'package:plant_care/add_spraying.dart';
import 'widgets/add_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';
import 'package:plant_care/models/operation.dart';
import 'package:plant_care/providers/operations.dart';
import 'package:provider/provider.dart';
import 'models/plant.dart';
import 'providers/plants.dart';
import 'add_irrigation.dart';
import 'widgets/operation_item.dart';
import 'agri_operations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OperationScreen extends StatefulWidget {
  static const routeName = '/operationscreen';
  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // i wanna listen to any changes in products
    void refresh() {
      setState(() {});
    }

    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    args = ScreenArguments(
      id: args.id,
      pid: args.pid,
      ops: args.ops,
      addEdit: 'اضافة',
      operationTypeString: args.operationTypeString,
    );
    var operation = FirebaseFirestore.instance
        .collection('operations')
        .where('plantID', isEqualTo: args.pid);
    Stream operations = operation
        .where('type', isEqualTo: args.operationTypeString)
        .get()
        .asStream();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          args.ops,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AddButton(onPressed: () {
                  if (args.operationTypeString == 'irrigation') {
                    Navigator.pushNamed(
                      context,
                      AddIrrigation.routeName,
                      arguments: args,
                    ).then((_) => setState(() {
                          operation = FirebaseFirestore.instance
                              .collection('operations')
                              .where('plantID', isEqualTo: args.pid);
                          operations = operation
                              .where('type',
                                  isEqualTo: args.operationTypeString)
                              .get()
                              .asStream();
                        }));
                  } else if (args.operationTypeString == 'planting') {
                    Navigator.pushNamed(context, AddPlanting.routeName,
                            arguments: args)
                        .then((_) => setState(() {
                              operation = FirebaseFirestore.instance
                                  .collection('operations')
                                  .where('plantID', isEqualTo: args.pid);
                              operations = operation
                                  .where('type',
                                      isEqualTo: args.operationTypeString)
                                  .get()
                                  .asStream();
                            }));
                  } else if (args.operationTypeString == 'harvest') {
                    Navigator.pushNamed(context, AddHarvest.routeName,
                            arguments: args)
                        .then((_) => setState(() {
                              operation = FirebaseFirestore.instance
                                  .collection('operations')
                                  .where('plantID', isEqualTo: args.pid);
                              operations = operation
                                  .where('type',
                                      isEqualTo: args.operationTypeString)
                                  .get()
                                  .asStream();
                            }));
                  } else if (args.operationTypeString == 'spraying') {
                    Navigator.pushNamed(context, AddSpraying.routeName,
                            arguments: args)
                        .then((_) => setState(() {
                              operation = FirebaseFirestore.instance
                                  .collection('operations')
                                  .where('plantID', isEqualTo: args.pid);
                              operations = operation
                                  .where('type',
                                      isEqualTo: args.operationTypeString)
                                  .get()
                                  .asStream();
                            }));
                  } else if (args.operationTypeString == 'fertilizing') {
                    Navigator.pushNamed(context, AddFertilizing.routeName,
                            arguments: args)
                        .then((_) => setState(() {
                              operation = FirebaseFirestore.instance
                                  .collection('operations')
                                  .where('plantID', isEqualTo: args.pid);
                              operations = operation
                                  .where('type',
                                      isEqualTo: args.operationTypeString)
                                  .get()
                                  .asStream();
                            }));
                  } else {
                    print('wrong');
                  }
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'موعد ' + args.ops,
                      style: const TextStyle(fontSize: 27),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Icon(
                      FontAwesomeIcons.clock,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: operations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data.docs.isEmpty) {
                    return Center(
                      child: Text(' عمليات' + ' ' + args.ops + ' فارغة '),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (ctx, i) {
                      return Dismissible(
                        background: Container(
                          decoration: const BoxDecoration(
                            color: Color(0XFFcc0000),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) {
                          return showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('هل أنت متأكد؟'),
                              content: const Text(
                                  'هل تريد حذف هذه العملية من قائمتك؟'),
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
                              .doc(snapshot.data.docs[i].id)
                              .delete();
                          setState(() {
                            operations = operation
                                .where('type',
                                    isEqualTo: args.operationTypeString)
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
                        child: OperationItem(
                          snapshot.data.docs[i].id,
                        ),
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  );
                }),
          )
        ],
      ),
    );
  }
}
