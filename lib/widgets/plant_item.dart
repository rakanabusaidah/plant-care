import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plant_care/constants.dart';
import 'package:plant_care/models/plant.dart';
import 'package:plant_care/agri_operations.dart';

class PlantItem extends StatelessWidget {
  PlantItem(this.plantid);
  final String plantid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('plantKey'),
      onTap: () {
        Navigator.pushNamed(context, AgriOperations.routeName,
            arguments: plantid);
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
            color: Color(0xFF8eab8f),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.all(10),
          height: 90,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('plants')
                  .doc(plantid)
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                AssetImage icon;
                switch (snapshot.data['plantName']) {
                  case 'خيار':
                    icon = AssetImage('images/cucumber_icon.png');
                    break;
                  case 'طماطم':
                    icon = AssetImage('images/tomato_icon.png');
                    break;
                  case 'فلفل أخضر':
                    icon = AssetImage('images/green_pepper_icon.png');
                    break;
                  case 'فراولة':
                    icon = AssetImage('images/strawberry_icon.png');
                    break;
                  case 'عنب':
                    icon = AssetImage('images/grape_icon.png');
                    break;
                  case 'رمان':
                    icon = AssetImage('images/pomegranate_icon.png');
                    break;
                  default:
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          snapshot.data['plantName'],
                          style: kAppTitlesTextStyle,
                        ),
                        Text(
                          snapshot.data['plantMethod'],
                          style: kUserNotesTextStyle,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    // ignore: prefer_const_constructors
                    Image(
                      image: icon,
                      width: 35,
                      height: 35,
                      color: null,
                    ),
                  ],
                );
              },
            ),
          )),
    );
  }
}
