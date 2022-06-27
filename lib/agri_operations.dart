import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'operations_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'card_content.dart';
import 'widgets/reuasble_card.dart';
import 'widgets/reminder_item.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/providers/operations.dart';

class AgriOperations extends StatefulWidget {
  static const routeName = '/agrioperations';

  @override
  _AgriOperationsState createState() => _AgriOperationsState();
}

class _AgriOperationsState extends State<AgriOperations>
    with SingleTickerProviderStateMixin {
  //List<Object> allOps;
  TabController _tabController;
  @override
  void dispose() {
    dataList = null;
    _tabController.dispose();
    super.dispose();
  }

  Stream dataList;

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  void didChangeDependencies() {
    final args = ModalRoute.of(context).settings.arguments as String;

    dataList = FirebaseFirestore.instance
        .collection('operations')
        .where('plantID', isEqualTo: args)
        .orderBy('nextReminder', descending: false)
        .get()
        .asStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final operationsData = Provider.of<Operations>(context);
    final args = ModalRoute.of(context).settings.arguments as String;
    final plant = args;
    var allOps = [
      operationsData.irrigationOperation,
      operationsData.fertilizingOperation,
      operationsData.sprayingOperation,
      operationsData.harvestOperation,
      operationsData.plantingOperation,
    ].expand((element) => element).toList();

    List allPlantOperations =
        allOps.where((num) => num.Plantid == "s").toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('plants').doc(plant).get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Text(
              snapshot.data['plantName'],
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          indicatorColor: Color(0XFF11493E),
          labelStyle: TextStyle(fontSize: 26.0),
          unselectedLabelStyle: TextStyle(fontSize: 21.0),
          tabs: [
            Tab(text: 'الاجراءات الزراعية'),
            Tab(text: 'الاجراءات التذكيرية'),
          ],
          controller: _tabController,
        ),
      ),
      body: StreamBuilder(
          stream: dataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return TabBarView(controller: _tabController, children: [
              Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    ReusableCard(
                      cardColor: Color(0XFF2D9CDB),
                      cardChild: CardContent(
                        cardIcon: FontAwesomeIcons.tint,
                        cardText: 'الري',
                        iconSize: 40,
                      ),
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          OperationScreen.routeName,
                          arguments: ScreenArguments(
                              pid: plant,
                              ops: 'الري',
                              operationTypeString: 'irrigation'), ///////// here
                        );
                      },
                    ),
                    ReusableCard(
                      cardColor: Color(0XFF907B00),
                      cardChild: CardContent(
                        cardIcon: FontAwesomeIcons.magic,
                        cardText: 'السماد',
                        iconSize: 40,
                      ),
                      onPress: () {
                        Navigator.pushNamed(context, OperationScreen.routeName,
                            arguments: ScreenArguments(
                                pid: plant,
                                ops: 'السماد',
                                operationTypeString: 'fertilizing'));
                      },
                    ),
                    ReusableCard(
                      cardColor: Color(0XFFFFB904),
                      cardChild: CardContent(
                        cardIcon: FontAwesomeIcons.tractor,
                        cardText: 'الحصاد',
                        iconSize: 40,
                      ),
                      onPress: () {
                        Navigator.pushNamed(context, OperationScreen.routeName,
                            arguments: ScreenArguments(
                                pid: plant,
                                ops: 'الحصاد',
                                operationTypeString: 'harvest'));
                      },
                    ),
                    ReusableCard(
                      cardColor: const Color(0XFFA878F7),
                      cardChild: CardContent(
                        cardIcon: FontAwesomeIcons.bug,
                        cardText: 'الوقاية',
                        iconSize: 40,
                      ),
                      onPress: () {
                        Navigator.pushNamed(context, OperationScreen.routeName,
                            arguments: ScreenArguments(
                                pid: plant,
                                ops: 'الوقاية',
                                operationTypeString: 'spraying'));
                      },
                    ),
                    ReusableCard(
                      cardColor: const Color(0XFF0E8B13),
                      cardChild: CardContent(
                        cardIcon: FontAwesomeIcons.spa,
                        cardText: 'الزراعة',
                        iconSize: 40,
                      ),
                      onPress: () {
                        Navigator.pushNamed(context, OperationScreen.routeName,
                            arguments: ScreenArguments(
                                pid: plant,
                                ops: 'الزراعة',
                                operationTypeString: 'planting'));
                      },
                    ),
                  ],
                ),
              ),
              Center(
                  child: (snapshot.data.docs.length == 0)
                      ? const Center(
                          child: Text(
                            'لا يوجد اجراءات\nأضف اجراء لكي يظهر لك',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (ctx, i) {
                            return ReminderItem(snapshot.data.docs[i].id);
                          },
                          itemCount: snapshot.data.docs.length,
                        ))
            ]);
          }),
    );
  }
}

class ScreenArguments {
  ScreenArguments(
      {this.id, this.pid, this.ops, this.addEdit, this.operationTypeString});
  String id;
  String pid;
  String ops;
  String addEdit;
  String operationTypeString;
}
