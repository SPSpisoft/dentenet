import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:time_zone_list/time_zone_list.dart';


class TTT extends StatefulWidget {
  @override
  _TTTState createState() => _TTTState();
}

class _TTTState extends State<TTT> {
  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  @override
  void initState() {

    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    var listNow = await TimeZoneList.getList();
    print(listNow.toString());
    try {
      _timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    try {
      _availableTimezones = await FlutterNativeTimezone.getAvailableTimezones();
      _availableTimezones.sort();
    } catch (e) {
      print('Could not get available timezones');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Local timezone app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Local timezone: $_timezone\n'),
            Text('Available timezones:'),
            Expanded(
              child: ListView.builder(
                itemCount: _availableTimezones.length,
                itemBuilder: (_, index) => Text(_availableTimezones[index]),
              ),
            )
          ],
        ),
      ),
    );
  }
}