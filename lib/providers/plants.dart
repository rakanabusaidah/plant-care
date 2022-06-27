import 'package:flutter/material.dart';
import '../models/plant.dart';

class Plants with ChangeNotifier {
  List<Plant> _userPlants = [];

  List<Plant> get userPlants {
    return [..._userPlants]; // it returns a copy of the list
  }

  bool addPlant(Plant plant) {
    final plantIndex =
        _userPlants.indexWhere((element) => element.id == plant.id);
    if (plantIndex >= 0) {
      print('مكرر');
      return false;
    } else {
      _userPlants.add(plant);
      notifyListeners();
      return true;
    }
  }

  void removePlant(int index) {
    _userPlants.removeAt(index);
    notifyListeners();
  }
}
