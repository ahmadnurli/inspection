import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({Key? key}) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return const TabBar(tabs: [
      Tab(
          child: Text(
        'Inspection',
        style: TextStyle(color: Colors.white),
      )),
      Tab(
        child: Text(
          'Report',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }
}
