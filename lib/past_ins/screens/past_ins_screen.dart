import 'package:flutter/material.dart';
import 'package:inspection/past_ins/widgets/widgets.dart';

class PastInsScreen extends StatefulWidget {
  const PastInsScreen({Key? key}) : super(key: key);

  @override
  State<PastInsScreen> createState() => _PastInsScreenState();
}

class _PastInsScreenState extends State<PastInsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past-Inspection'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: PastInsWidget(),
      ),
    );
  }
}
