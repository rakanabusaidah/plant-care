import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:plant_care/login_screen.dart';
import 'package:plant_care/my_profile.dart';
import 'package:plant_care/register_screen.dart';
import 'add_vegetables.dart';
import 'my_farm.dart';
import 'fruits_vegetables.dart';
import 'add_fruits.dart';
import 'providers/plants.dart';
import 'package:provider/provider.dart';
import 'agri_operations.dart';
import 'operations_screen.dart';

import 'add_irrigation.dart';
import 'tab_screen.dart';
import 'providers/operations.dart';
import 'add_planting.dart';
import 'add_harvest.dart';
import 'add_spraying.dart';
import 'add_fertilizing.dart';
import 'my_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PlantCare());
}

class PlantCare extends StatefulWidget {
  @override
  State<PlantCare> createState() => _PlantCareState();
}

class _PlantCareState extends State<PlantCare> {
  StreamSubscription<User> user;
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Plants()),
        ChangeNotifierProvider(create: (ctx) => Operations()),
      ],
      // it provides an instance to ALL child widgets that interested
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0XFFFDFBF9),
            scaffoldBackgroundColor: Color(0XFFFDFBF9),
            accentColor: Color(0XFFE5E5E5),
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black87),
              color: Colors.black,
            )),
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginScreen.routeName
            : TabScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          RegisterScreen.routeName: (context) => RegisterScreen(),
          TabScreen.routeName: (context) => TabScreen(),
          MyFarm.routeName: (context) => MyFarm(),
          FruitsVegetables.routeName: (context) => FruitsVegetables(),
          AddVegetables.routName: (context) => AddVegetables(),
          AddFruits.routeName: (context) => AddFruits(),
          AgriOperations.routeName: (context) => AgriOperations(),
          OperationScreen.routeName: (context) => OperationScreen(),
          AddIrrigation.routeName: (context) => AddIrrigation(),
          AddPlanting.routeName: (context) => AddPlanting(),
          AddHarvest.routeName: (context) => AddHarvest(),
          AddSpraying.routeName: (context) => AddSpraying(),
          AddFertilizing.routeName: (context) => AddFertilizing(),
          MyProfile.routeName: (context) => MyProfile(),
          MyNotifications.routeName: (context) => MyNotifications(),
        },
      ),
    );
  }
}
