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
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/icon/icon.png'),
          fit: BoxFit.fitWidth,
        )),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: PastInsWidget(),
        ),
      ),
    );
  }
}
