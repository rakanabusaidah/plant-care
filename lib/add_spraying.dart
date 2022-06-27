import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:plant_care/models/operation.dart';
import 'package:plant_care/operations_screen.dart';
import 'providers/operations.dart';
import 'package:provider/provider.dart';
import 'agri_operations.dart';
import 'dart:math';

class AddSpraying extends StatefulWidget {
  static const routeName = '/addSpraying';
  @override
  _AddSprayingState createState() => _AddSprayingState();
}

class _AddSprayingState extends State<AddSpraying> {
  String sprayingTypeDropdownValue = 'مبيد حشري';
  String repDropdownValue = '1';
  DateTime _selectedStartDate;
  DateTime _selectedEndDate;
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

  var _addedSpraying = Spraying(
    id: null,
    Plantid: null,
    sprayingType: '',
    startDate: '',
    time: '',
    repetition: 1,
  );
  @override
  void initState() {
    _getfcm();
    super.initState();
  }

  var _initValues = {
    'Plantid': '',
    'sprayingType': 'مبيد حشري',
    'startDate': '',
    'time': '',
    'repetition': '1',
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
                  'Plantid': value.data()['plantID'],
                  'repetition': value.data()['repetition'].toString(),
                  'sprayingType': value.data()['sprayingType'],
                };

                DateFormat dateformat = DateFormat('MM/dd/yyyy');

                _startDateController.text =
                    dateformat.format(value.data()['startDate'].toDate());
                updatedNextRem = value.data()['nextReminder'].toDate();

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
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final operationID = args.id;
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    DateFormat dateformat = DateFormat('MM/dd/yyyy');
    DateTime st = dateformat.parse(_addedSpraying.startDate);
    DateTime et = dateformat.parse(_addedSpraying.endDate);
    final format = DateFormat('HH:mm');
    TimeOfDay times = TimeOfDay.fromDateTime(format.parse(_addedSpraying.time));
    DateTime startdate =
        DateTime(st.year, st.month, st.day, times.hour, times.minute);
    DateTime enddate =
        DateTime(et.year, et.month, et.day, times.hour, times.minute);
    DateTime nextRem = DateTime(startdate.year, startdate.month,
        startdate.day + _addedSpraying.repetition, times.hour, times.minute);
    Duration difference = enddate.difference(DateTime.now());

    if (operationID != null) {
      bool isn = !difference.isNegative;
      DateTime nextu = DateTime(updatedNextRem.year, updatedNextRem.month,
          updatedNextRem.day, times.hour, times.minute);
      FirebaseFirestore.instance
          .collection('operations')
          .doc(operationID)
          .update({
        'startDate': startdate,
        'endDate': enddate,
        'repetition': _addedSpraying.repetition,
        'nextReminder': nextu,
        'time': _addedSpraying.time,
        'sprayingType': _addedSpraying.sprayingType,
        'isActive': isn,
      });
    } else {
      FirebaseFirestore.instance.collection('operations').add({
        'startDate': startdate,
        'endDate': enddate,
        'type': _addedSpraying.operationTypeString,
        'plantID': _addedSpraying.Plantid,
        'repetition': _addedSpraying.repetition,
        'sprayingType': _addedSpraying.sprayingType,
        'token': fcmToken,
        'nextReminder': nextRem,
        'plantName': Pname,
        'plantMethod': pMethod,
        'typeAR': 'وقاية',
        'userID': FirebaseAuth.instance.currentUser.uid,
        'previousReminder': null,
        'isReminding': true,
        'isActive': true,
        'time': _addedSpraying.time,
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
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: ' (أختر التاريخ) موعد بداية عملية الوقاية',
                  hintText: _selectedStartDate == null
                      ? 'الرجاء اختيار تاريخ موعد بداية عملية الوقاية'
                      : ' موعد بداية عملية الوقاية: ${DateFormat.yMd().format(_selectedStartDate)}',
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: _selectedEndDate == null
                        ? DateTime(DateTime.now().year + 5)
                        : _selectedEndDate,
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      String format = DateFormat.yMd().format(pickedDate);
                      _startDateController.text = format;
                    }
                    setState(() {
                      _selectedStartDate = pickedDate;
                    });
                  });
                  print('...');
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'الرجاء اختيار تاريخ  موعد بداية عملية الوقاية';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addedSpraying = Spraying(
                    id: _addedSpraying.id,
                    Plantid: args.pid,
                    operationTypeString: args.operationTypeString,
                    startDate: value.toString(),
                    endDate: _addedSpraying.endDate,
                    time: _addedSpraying.time,
                    repetition: _addedSpraying.repetition,
                    sprayingType: _addedSpraying.sprayingType,
                  );
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: ' (أختر التاريخ) موعد نهاية عملية الوقاية',
                  hintText: _selectedEndDate == null
                      ? 'الرجاء اختيار تاريخ موعد نهاية عملية الوقاية'
                      : ' موعد نهاية عملية الوقاية: ${DateFormat.yMd().format(_selectedEndDate)}',
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    initialDate: _selectedStartDate == null
                        ? DateTime.now()
                        : _selectedStartDate,
                    firstDate: _selectedStartDate == null
                        ? DateTime.now()
                        : _selectedStartDate,
                    lastDate: DateTime(DateTime.now().year + 5),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      String format = DateFormat.yMd().format(pickedDate);
                      _endDateController.text = format;
                    }
                    setState(() {
                      _selectedEndDate = pickedDate;
                    });
                  });
                  print('...');
                },
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'الرجاء اختيار تاريخ  موعد نهاية عملية الوقاية';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addedSpraying = Spraying(
                    id: _addedSpraying.id,
                    Plantid: args.pid,
                    operationTypeString: args.operationTypeString,
                    startDate: _addedSpraying.startDate,
                    endDate: value.toString(),
                    time: _addedSpraying.time,
                    repetition: _addedSpraying.repetition,
                    sprayingType: _addedSpraying.sprayingType,
                  );
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'الوقت (أختر وقت الوقاية)',
                  hintText: _selectedTime == null
                      ? 'الرجاء اختيار وقت الوقاية'
                      : 'الوقاية القادمة: ',
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 3, minute: 0),
                  ).then((pickedTime) {
                    if (pickedTime != null) {
                      final hours = pickedTime.hour.toString().padLeft(2, '0');
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
                    return 'الرجاء اختيار وقت الوقاية القادمة';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addedSpraying = Spraying(
                    id: _addedSpraying.id,
                    Plantid: args.pid,
                    operationTypeString: args.operationTypeString,
                    startDate: _addedSpraying.startDate,
                    endDate: _addedSpraying.endDate,
                    time: value.toString(),
                    repetition: _addedSpraying.repetition,
                    sprayingType: _addedSpraying.sprayingType,
                  );
                },
              ),
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
                  _addedSpraying = Spraying(
                    id: _addedSpraying.id,
                    Plantid: args.pid,
                    operationTypeString: args.operationTypeString,
                    startDate: _addedSpraying.startDate,
                    endDate: _addedSpraying.endDate,
                    time: _addedSpraying.time,
                    repetition: int.parse(value),
                    sprayingType: _addedSpraying.sprayingType,
                  );
                },
              ),
              DropdownButtonFormField<String>(
                  value: _initValues['sprayingType'],
                  decoration: InputDecoration(labelText: 'نوع الوقاية'),
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                  onChanged: (String newValue) {
                    setState(() {
                      sprayingTypeDropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    'مبيد حشري',
                    'مبيد فطري',
                    'مبيد عناكبي',
                    'تنظيف حشائش',
                    'تهوية البيت المحمي',
                    'تقليم الأوراق',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'الرجاء اختيار نوع الوقاية';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _addedSpraying = Spraying(
                      id: _addedSpraying.id,
                      Plantid: args.pid,
                      operationTypeString: args.operationTypeString,
                      startDate: _addedSpraying.startDate,
                      endDate: _addedSpraying.endDate,
                      time: _addedSpraying.time,
                      repetition: _addedSpraying.repetition,
                      sprayingType: value,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
