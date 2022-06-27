import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_farm.dart';
import 'tab_screen.dart';
import 'card_content.dart';
import 'models/plant.dart';
import 'package:provider/provider.dart';
import 'providers/plants.dart';
import 'widgets/reuasble_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/new_plant_card.dart';

class AddFruits extends StatefulWidget {
  static const routeName = '/addfruits';
  @override
  _AddFruitsState createState() => _AddFruitsState();
}

class _AddFruitsState extends State<AddFruits> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String dropDownValue = 'مكشوف';
  @override
  Widget build(BuildContext context) {
    final plantsData = Provider.of<Plants>(
        context); // i wanna listen to any changes in products
    final plants = plantsData.userPlants;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          'إضافة نبات',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          NewPlantCard(
            imageLink: 'images/strawberries.jpg',
            title: 'فراولة',
            onPress: () {
              showDialog(
                context: context,
                builder: (context) =>
                    buildAlertDialog(context, plantsData, 'فراولة', 4),
              );
            },
          ),
          NewPlantCard(
              imageLink: 'images/grapes.jpg',
              title: 'عنب',
              onPress: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      buildAlertDialog(context, plantsData, 'عنب', 5),
                );
              }),
          NewPlantCard(
              imageLink: 'images/pomegranate.jpg',
              title: 'رمان',
              onPress: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      buildAlertDialog(context, plantsData, 'رمان', 6),
                );
              }),
        ],
      ),
    );
  }

  AlertDialog buildAlertDialog(
      BuildContext context, Plants plantsData, String plantName, int plantid) {
    return AlertDialog(
      title: const Text('نوع الزراعة'),
      content: DropdownButtonFormField<String>(
        value: dropDownValue,
        onChanged: (String newValue) {
          setState(() {
            dropDownValue = newValue;
          });
        },
        items: <String>[
          'مكشوف',
          'محمي عادي',
          'محمي مكيف',
          'مائية',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              child: Text(value),
              width: 200,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          child: Text('الغاء'),
          onPressed: () {
            Navigator.of(context).pop();
            dropDownValue = 'مكشوف';
          },
        ),
        const SizedBox(
          width: 90,
        ),
        TextButton(
          child: Text('اضافة'),
          onPressed: () {
            final ped =
                Plant(name: plantName, plantMethod: dropDownValue, id: plantid);
            FirebaseFirestore.instance.collection('plants').add({
              'plantIDF': plantid,
              'plantMethod': dropDownValue,
              'plantName': plantName,
              'type': 'fruit',
              'dateAdded': Timestamp.now(),
              'userID': auth.currentUser.uid
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0XFF11493E),
                content: Text(
                  'تمت الاضافة',
                  textAlign: TextAlign.end,
                ),
              ),
            );
            Navigator.of(context)
                .pushNamedAndRemoveUntil(TabScreen.routeName, (route) => false);
          },
        ),
      ],
    );
  }
}
