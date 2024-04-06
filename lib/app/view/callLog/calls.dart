// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CallLog extends StatefulWidget {
  const CallLog({super.key});

  @override
  State<CallLog> createState() => _CallLogState();
}

class _CallLogState extends State<CallLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls'),
      ),
    );
  }
}
