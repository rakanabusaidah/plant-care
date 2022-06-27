import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:plant_care/models/operation.dart';
import 'package:plant_care/operations_screen.dart';
import 'providers/operations.dart';
import 'package:provider/provider.dart';
import 'agri_operations.dart';
import 'dart:math';

class AddIrrigation extends StatefulWidget {
  AddIrrigation({this.state});
  Function state;
  static const routeName = '/addIrrigation';
  @override
  _AddIrrigationState createState() => _AddIrrigationState();
}

class _AddIrrigationState extends State<AddIrrigation> {
  String sznDropdownValue = 'صيف';
  String repDropdownValue = '1';
  String soilTypeDropdownValue = 'طينية';
  String irrigationMethodDropdownValue = 'غمر';
  DateTime _startSelectedDate;
  DateTime _endSelectedDate;
  TimeOfDay _selectedTime;
  final _form = GlobalKey<FormState>();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String fcmToken;
  String Pname;
  String pMethod;
  DateTime updatedNextRem;

  _getfcm() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        fcmToken = value;
      });
    });
  }

  @override
  void initState() {
    _getfcm();
    super.initState();
  }

  var _addedIrrigation = Irrigation(
    id: null,
    Plantid: '',
    operationTypeString: '',
    season: '',
    startDate: '',
    endDate: '',
    time: '',
    repetition: 1,
    soilType: '',
    irrigationMethod: '',
  );

  var _initValues = {
    'Plantid': '',
    'season': 'صيف',
    'startDate': '',
    'enddate': '',
    'time': '',
    'repetition': '1',
    'soilType': 'طينية',
    'irrigationMethod': 'غمر',
  };
  var _isInit = true;
  void _getOperation(String operationID) {
    FirebaseFirestore.instance
        .collection('operations')
        .doc(operationID)
        .get()
        .then((value) => {
              setState(() {
                _initValues = {
                  'season': value.data()['season'],
                  'soilType': value.data()['soilType'],
                  'irrigationMethod': value.data()['irrigationMethod'],
                  'Plantid': value.data()['plantID'],
                  'repetition': value.data()['repetition'].toString(),
                };

                DateFormat dateformat = DateFormat('MM/dd/yyyy');

                updatedNextRem = value.data()['nextReminder'].toDate();

                _startDateController.text =
                    dateformat.format(value.data()['startDate'].toDate());

                _endDateController.text =
                    dateformat.format(value.data()['endDate'].toDate());
                _timeController.text = value.data()['time'];
              })
            });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      final operationID = args.id;
      if (operationID != null) {
        _getOperation(operationID);
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final operationID = args.id;

    DateFormat dateformat = DateFormat('MM/dd/yyyy');
    DateTime st = dateformat.parse(_addedIrrigation.startDate);
    DateTime et = dateformat.parse(_addedIrrigation.endDate);
    final format = DateFormat('HH:mm');
    TimeOfDay times =
        TimeOfDay.fromDateTime(format.parse(_addedIrrigation.time));
    DateTime startdate =
        DateTime(st.year, st.month, st.day, times.hour, times.minute);
    DateTime enddate =
        DateTime(et.year, et.month, et.day, times.hour, times.minute);
    DateTime nextRem = DateTime(startdate.year, startdate.month,
        startdate.day + _addedIrrigation.repetition, times.hour, times.minute);

    Duration difference = enddate.difference(DateTime.now());

    if (operationID != null) {
      //UPDATE
      DateTime nextu = DateTime(updatedNextRem.year, updatedNextRem.month,
          updatedNextRem.day, times.hour, times.minute);
      bool isn = !difference.isNegative;

      FirebaseFirestore.instance
          .collection('operations')
          .doc(operationID)
          .update({
        'season': _addedIrrigation.season,
        'startDate': startdate,
        'endDate': enddate,
        'repetition': _addedIrrigation.repetition,
        'soilType': _addedIrrigation.soilType,
        'irrigationMethod': _addedIrrigation.irrigationMethod,
        'type': _addedIrrigation.operationTypeString,
        'nextReminder': nextu,
        'time': _addedIrrigation.time,
        'isActive': isn,
      });
    } else {
      FirebaseFirestore.instance.collection('operations').add({
        'season': _addedIrrigation.season,
        'startDate': startdate,
        'endDate': enddate,
        'repetition': _addedIrrigation.repetition,
        'soilType': _addedIrrigation.soilType,
        'irrigationMethod': _addedIrrigation.irrigationMethod,
        'type': _addedIrrigation.operationTypeString,
        'plantID': _addedIrrigation.Plantid,
        'token': fcmToken,
        'nextReminder': nextRem,
        'plantName': Pname,
        'plantMethod': pMethod,
        'typeAR': 'ري',
        'userID': FirebaseAuth.instance.currentUser.uid,
        'previousReminder': null,
        'isReminding': true,
        'isActive': true,
        'time': _addedIrrigation.time,
      });
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args = ModalRoute.of(context).settings.arguments;
    FirebaseFirestore.instance
        .collection('plants')
        .doc(args.pid)
        .get()
        .then((value) => {
              setState(() {
                Pname = value['plantName'];
                pMethod = value['plantMethod'];
              })
            });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          args.addEdit,
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          TextButton(
              onPressed: _saveForm,
              child: Text(
                'تم',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _initValues['season'],
                decoration: InputDecoration(labelText: 'الوضع (أختر الموسم)'),
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
                onChanged: (String newValue) {
                  setState(() {
                    sznDropdownValue = newValue;
                  });
                },
                items: <String>['صيف', 'شتاء']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'الرجاء اختيار الموسم';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addedIrrigation = Irrigation(
                    id: _addedIrrigation.id,
                    Plantid: args.pid,
                    operationTypeString: args.operationTypeString,
                    season: value,
                    startDate: _addedIrrigation.startDate,
                    endDate: _addedIrrigation.endDate,
                    time: _addedIrrigation.time,
                    repetition: _addedIrrigation.repetition,
                    soilType: _addedIrrigation.soilType,
                    irrigationMethod: _addedIrrigation.irrigationMethod,
                  );
                },
              ),
              TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: ' (أختر التاريخ) بداية موعد السقية',
                    hintText: _startSelectedDate == null
                        ? 'الرجاء اختيار تاريخ لبداية موعد السقية'
                        : 'بداية موعد السقية : ${DateFormat.yMd().format(_startSelectedDate)}',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: _endSelectedDate == null
                          ? DateTime(DateTime.now().year + 5)
                          : _endSelectedDate,
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        String format = DateFormat.yMd().format(pickedDate);
                        _startDateController.text = format;
                      }
                      setState(() {
                        _startSelectedDate = pickedDate;
                      });
                    });
                    print('...');
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار تاريخ بداية موعد السقية';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                      id: _addedIrrigation.id,
                      Plantid: args.pid,
                      operationTypeString: args.operationTypeString,
                      season: _addedIrrigation.season,
                      startDate: value.toString(),
                      endDate: _addedIrrigation.endDate,
                      time: _addedIrrigation.time,
                      repetition: _addedIrrigation.repetition,
                      soilType: _addedIrrigation.soilType,
                      irrigationMethod: _addedIrrigation.irrigationMethod,
                    );
                  }),
              TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: ' (أختر التاريخ) نهاية موعد السقية',
                    hintText: _endSelectedDate == null
                        ? 'الرجاء اختيار تاريخ نهاية موعد السقية'
                        : 'نهاية موعد السقية : ${DateFormat.yMd().format(_endSelectedDate)}',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showDatePicker(
                      context: context,
                      initialDate: _startSelectedDate == null
                          ? DateTime.now()
                          : _startSelectedDate,
                      firstDate: _startSelectedDate == null
                          ? DateTime.now()
                          : _startSelectedDate,
                      lastDate: DateTime(DateTime.now().year + 5),
                    ).then((pickedDate) {
                      if (pickedDate != null) {
                        String format = DateFormat.yMd().format(pickedDate);
                        _endDateController.text = format;
                      }
                      setState(() {
                        _endSelectedDate = pickedDate;
                      });
                    });
                    print('...');
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار تاريخ نهاية موعد السقية';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                      id: _addedIrrigation.id,
                      Plantid: args.pid,
                      operationTypeString: args.operationTypeString,
                      season: _addedIrrigation.season,
                      startDate: _addedIrrigation.startDate,
                      endDate: value.toString(),
                      time: _addedIrrigation.time,
                      repetition: _addedIrrigation.repetition,
                      soilType: _addedIrrigation.soilType,
                      irrigationMethod: _addedIrrigation.irrigationMethod,
                    );
                  }),
              TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: 'الوقت (أختر وقت السقية)',
                    hintText: _selectedTime == null
                        ? 'الرجاء اختيار وقت السقية'
                        : 'السقية القادمة: ',
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 3, minute: 0),
                    ).then((pickedTime) {
                      if (pickedTime != null) {
                        final hours =
                            pickedTime.hour.toString().padLeft(2, '0');
                        final minutes =
                            pickedTime.minute.toString().padLeft(2, '0');
                        _timeController.text = '$hours:$minutes';
                      }
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    });
                    print('...');
                  },
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار وقت السقية القادمة';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                        id: _addedIrrigation.id,
                        Plantid: args.pid,
                        operationTypeString: args.operationTypeString,
                        season: _addedIrrigation.season,
                        startDate: _addedIrrigation.startDate,
                        endDate: _addedIrrigation.endDate,
                        time: value.toString(),
                        repetition: _addedIrrigation.repetition,
                        soilType: _addedIrrigation.soilType,
                        irrigationMethod: _addedIrrigation.irrigationMethod);
                  }),
              DropdownButtonFormField<String>(
                  value: _initValues['repetition'],
                  decoration:
                      InputDecoration(labelText: 'التكرار (كل # يوم / ايام)'),
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                  onChanged: (String newValue) {
                    setState(() {
                      repDropdownValue = newValue;
                    });
                  },
                  items: <String>['1', '2', '3', '4', '5', '6', '7']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'الرجاء اختيار عدد التكرار';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                        id: _addedIrrigation.id,
                        Plantid: args.pid,
                        operationTypeString: args.operationTypeString,
                        season: _addedIrrigation.season,
                        startDate: _addedIrrigation.startDate,
                        endDate: _addedIrrigation.endDate,
                        time: _addedIrrigation.time,
                        repetition: int.parse(value),
                        soilType: _addedIrrigation.soilType,
                        irrigationMethod: _addedIrrigation.irrigationMethod);
                  }),
              DropdownButtonFormField<String>(
                  value: _initValues['soilType'],
                  decoration: InputDecoration(labelText: 'نوع التربة'),
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                  onChanged: (String newValue) {
                    setState(() {
                      soilTypeDropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'طينية',
                    'رملية',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار نوع التربة';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                        id: _addedIrrigation.id,
                        Plantid: args.pid,
                        operationTypeString: args.operationTypeString,
                        season: _addedIrrigation.season,
                        startDate: _addedIrrigation.startDate,
                        endDate: _addedIrrigation.endDate,
                        time: _addedIrrigation.time,
                        repetition: _addedIrrigation.repetition,
                        soilType: value,
                        irrigationMethod: _addedIrrigation.irrigationMethod);
                  }),
              DropdownButtonFormField<String>(
                  value: _initValues['irrigationMethod'],
                  decoration: InputDecoration(labelText: 'طريقة الري'),
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                  onChanged: (String newValue) {
                    setState(() {
                      irrigationMethodDropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'غمر',
                    'تنقيط',
                    'محوري',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار طريقة الري';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedIrrigation = Irrigation(
                        id: _addedIrrigation.id,
                        Plantid: args.pid,
                        operationTypeString: args.operationTypeString,
                        season: _addedIrrigation.season,
                        startDate: _addedIrrigation.startDate,
                        endDate: _addedIrrigation.endDate,
                        time: _addedIrrigation.time,
                        repetition: _addedIrrigation.repetition,
                        soilType: _addedIrrigation.soilType,
                        irrigationMethod: value);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
