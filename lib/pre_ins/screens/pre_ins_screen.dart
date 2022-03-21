// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:inspection/pre_ins/widgets/widgets.dart';

class PreInsScreen extends StatefulWidget {
  const PreInsScreen({Key? key}) : super(key: key);

  @override
  State<PreInsScreen> createState() => _PreInsScreenState();
}

class _PreInsScreenState extends State<PreInsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PreInsWidget(),
      ),
    );
  }
}
