import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/operation.dart';

class Operations with ChangeNotifier {
  List<Operation> _irrigationOperation = [];
  List<Operation> _harvestOperation = [];
  List<Operation> _sprayingOperation = [];
  List<Operation> _plantingOperation = [];
  List<Operation> _fertilizingOperation = [];

  List<Irrigation> get irrigationOperation {
    return [..._irrigationOperation];
  }

  List<Planting> get plantingOperation {
    return [..._plantingOperation];
  }

  List<Harvest> get harvestOperation {
    return [..._harvestOperation];
  }

  List<Spraying> get sprayingOperation {
    return [..._sprayingOperation];
  }

  List<Fertilizing> get fertilizingOperation {
    return [..._fertilizingOperation];
  }

  void addIrrigation(Irrigation op) {
    final newIrrigation = Irrigation(
      id: DateTime.now().toString(),
      Plantid: op.Plantid,
      operationType: op.operationType,
      operationTypeString: op.operationTypeString,
      season: op.season,
      startDate: op.startDate,
      endDate: op.endDate,
      time: op.time,
      repetition: op.repetition,
      soilType: op.soilType,
      irrigationMethod: op.irrigationMethod,
    );

    _irrigationOperation.add(newIrrigation);
    notifyListeners();
  }

  void addPlanting(Planting op) {
    final newPlanting = Planting(
      id: DateTime.now().toString(),
      Plantid: op.Plantid,
      operationTypeString: op.operationTypeString,
      startDate: op.startDate,
      endDate: op.endDate,
      time: op.time,
      ageGroup: op.ageGroup,
    );

    _plantingOperation.add(newPlanting);
    notifyListeners();
  }

  void addHarvest(Harvest op) {
    final newHarvest = Harvest(
        id: DateTime.now().toString(),
        Plantid: op.Plantid,
        operationTypeString: op.operationTypeString,
        startDate: op.startDate,
        endDate: op.endDate,
        time: op.time,
        repetition: op.repetition);

    _harvestOperation.add(newHarvest);
    notifyListeners();
  }

  void addFertilizing(Fertilizing op) {
    final newFertilizing = Fertilizing(
      id: DateTime.now().toString(),
      Plantid: op.Plantid,
      operationTypeString: op.operationTypeString,
      startDate: op.startDate,
      endDate: op.endDate,
      time: op.time,
      fertilizingType: op.fertilizingType,
    );

    _fertilizingOperation.add(newFertilizing);
    notifyListeners();
  }

  void addSpraying(Spraying op) {
    final newSpraying = Spraying(
      id: DateTime.now().toString(),
      Plantid: op.Plantid,
      sprayingType: op.sprayingType,
      operationTypeString: op.operationTypeString,
      startDate: op.startDate,
      endDate: op.endDate,
      time: op.time,
      repetition: op.repetition,
    );

    _sprayingOperation.add(newSpraying);
    notifyListeners();
  }

  void updateIrrigation(String id, Irrigation op) {
    final opIndex =
        _irrigationOperation.indexWhere((element) => element.id == id);
    if (opIndex >= 0) {
      print('here i am');
      _irrigationOperation[opIndex] = op;
      notifyListeners();
    } else
      print('there is an error in updateIrrigation ');
  }

  void updatePlanting(String id, Planting op) {
    final opIndex =
        _plantingOperation.indexWhere((element) => element.id == id);
    if (opIndex >= 0) {
      _plantingOperation[opIndex] = op;
      notifyListeners();
    } else
      print('there is an error in updatePlanting ');
  }

  void updateHarvest(String id, Harvest op) {
    final opIndex = _harvestOperation.indexWhere((element) => element.id == id);
    if (opIndex >= 0) {
      _harvestOperation[opIndex] = op;
      notifyListeners();
    } else
      print('there is an error in updateHarvest ');
  }

  void updateSpraying(String id, Spraying op) {
    final opIndex =
        _sprayingOperation.indexWhere((element) => element.id == id);
    if (opIndex >= 0) {
      _sprayingOperation[opIndex] = op;
      notifyListeners();
    } else
      print('there is an error in updateSpraying ');
  }

  void updateFertilizing(String id, Fertilizing op) {
    final opIndex =
        _fertilizingOperation.indexWhere((element) => element.id == id);
    if (opIndex >= 0) {
      _fertilizingOperation[opIndex] = op;
      notifyListeners();
    } else
      print('there is an error in updateFertilizing ');
  }

  Irrigation findIrrigationByID(String id) {
    return _irrigationOperation.firstWhere((element) => element.id == id);
  }

  Planting findPlantingByID(String id) {
    return _plantingOperation.firstWhere((element) => element.id == id);
  }

  Harvest findHarvestByID(String id) {
    return _harvestOperation.firstWhere((element) => element.id == id);
  }

  Spraying findSprayingByID(String id) {
    return _sprayingOperation.firstWhere((element) => element.id == id);
  }

  Fertilizing findFertilizingByID(String id) {
    return _fertilizingOperation.firstWhere((element) => element.id == id);
  }

  void removeOperation(int index, operationTypes types) {
    if (types == operationTypes.irrigation) {
      _irrigationOperation.removeAt(index);
    } else if (types == operationTypes.planting) {
      _plantingOperation.removeAt(index);
    } else if (types == operationTypes.harvest) {
      _harvestOperation.removeAt(index);
    } else if (types == operationTypes.spraying) {
      _sprayingOperation.removeAt(index);
    } else if (types == operationTypes.fertilizing) {
      _fertilizingOperation.removeAt(index);
    }

    notifyListeners();
  }
}
