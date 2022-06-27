import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_care/my_farm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'card_content.dart';
import 'tab_screen.dart';
import 'models/plant.dart';
import './providers/plants.dart';
import 'package:provider/provider.dart';
import 'widgets/reuasble_card.dart';
import 'widgets/new_plant_card.dart';

class AddVegetables extends StatefulWidget {
  static const routName = '/addvegtables';
  @override
  _AddVegetablesState createState() => _AddVegetablesState();
}

class _AddVegetablesState extends State<AddVegetables> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String dropDownValue = 'مكشوف';
  @override
  Widget build(BuildContext context) {
    final plantsData = Provider.of<Plants>(
        context); // i wanna listen to any changes in products
    final plants = plantsData.userPlants;
    // List<Plant> plants =
    // ModalRoute.of(context).settings.arguments as List<Plant>;
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
            key: const Key('cue'),
            imageLink: 'images/Cucumberr.jpg',
            title: 'خيار',
            onPress: () {
              showDialog(
                context: context,
                builder: (context) =>
                    buildAlertDialog(context, plantsData, 'خيار', 1),
              );
            },
          ),
          NewPlantCard(
            imageLink: 'images/tomatoes.jpg',
            title: 'طماطم',
            onPress: () {
              showDialog(
                context: context,
                builder: (context) =>
                    buildAlertDialog(context, plantsData, 'طماطم', 2),
              );
            },
          ),
          NewPlantCard(
            imageLink: 'images/greenp.jpg',
            title: 'فلفل أخضر',
            onPress: () {
              showDialog(
                context: context,
                builder: (context) =>
                    buildAlertDialog(context, plantsData, 'فلفل أخضر', 3),
              );
            },
          ),
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
          child: const Text('الغاء'),
          onPressed: () {
            Navigator.of(context).pop();
            dropDownValue = 'مكشوف';
          },
        ),
        const SizedBox(
          width: 90,
        ),
        TextButton(
          child: const Text('اضافة'),
          onPressed: () {
            final ped =
                Plant(name: plantName, plantMethod: dropDownValue, id: plantid);

            FirebaseFirestore.instance.collection('plants').add({
              'plantIDF': plantid,
              'plantMethod': dropDownValue,
              'plantName': plantName,
              'type': 'vegetable',
              'dateAdded': Timestamp.now(),
              'userID': auth.currentUser.uid
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
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
