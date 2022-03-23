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
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(alignment: Alignment.center, child: Text('Reset')),
              ))
        ],
      ),
      body: Container(
        // height: double.infinity,
        // width: double.infinity,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage('assets/icon/icon.png'),
        //   fit: BoxFit.fitWidth,
        // )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: PreInsWidget()),
        ),
      ),
    );
  }
}
