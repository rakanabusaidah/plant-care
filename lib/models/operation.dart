import 'package:flutter/material.dart';

enum operationTypes {
  irrigation,
  harvest,
  spraying,
  planting,
  fertilizing,
}

class Operation {
  Operation(this.id, this.Plantid, this.operationTypeString, this.startDate,
      this.endDate, this.time, this.repetition);
  final String id;
  final String Plantid;
  final String operationTypeString;
  final String startDate;
  final String endDate;
  final String time;
  final int repetition;
}

class Irrigation extends Operation {
  final String operationType;
  final String season;

  final String soilType;
  final String irrigationMethod;

  Irrigation(
      {id,
      Plantid,
      this.operationType,
      operationTypeString,
      this.season,
      startDate,
      time,
      endDate,
      repetition,
      this.soilType,
      this.irrigationMethod})
      : super(id, Plantid, operationTypeString, startDate, endDate, time,
            repetition);
}

/////////////////////////////////////////////////////

class Planting extends Operation {
  Planting(
      {id,
      Plantid,
      startDate,
      endDate,
      time,
      repetition,
      operationTypeString,
      this.ageGroup})
      : super(id, Plantid, operationTypeString, startDate, endDate, time,
            repetition);

  final String ageGroup;
}

class Harvest extends Operation {
  Harvest({
    id,
    Plantid,
    operationTypeString,
    startDate,
    endDate,
    time,
    repetition,
  }) : super(id, Plantid, operationTypeString, startDate, endDate, time,
            repetition);
}

class Fertilizing extends Operation {
  Fertilizing(
      {id,
      Plantid,
      operationTypeString,
      startDate,
      endDate,
      time,
      repetition,
      this.fertilizingType})
      : super(id, Plantid, operationTypeString, startDate, endDate, time,
            repetition);
  final String fertilizingType;
}

class Spraying extends Operation {
  Spraying(
      {id,
      Plantid,
      time,
      repetition,
      startDate,
      endDate,
      operationTypeString,
      this.sprayingType})
      : super(id, Plantid, operationTypeString, startDate, endDate, time,
            repetition);

  final String sprayingType;
}
