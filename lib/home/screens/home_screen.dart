// ignore_for_file: prefer_const_constructors

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:inspection/constants/color_constant.dart';
import 'package:inspection/home/widgets/widgets.dart';
import 'package:inspection/past_ins/screens/screens.dart';
import 'package:inspection/pre_ins/screens/screens.dart';
import 'package:inspection/report/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, TickerProviderStateMixin {
  List<Widget> listTabs = const [
    Tab(
      text: 'Inspection',
    ),
    Tab(
      text: 'Report',
    )
  ];

  TabController? _tabController;
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listTabs.length,
      child: Scaffold(
          appBar: AppBar(title: Text('Inspection')),
          body: Padding(
              padding: const EdgeInsets.all(8.0), child: ReportScreen()),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionBubble(
              // Menu items
              items: <Bubble>[
                // Floating action menu item
                Bubble(
                  title: "Pre - Ins",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.directions_car,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PreInsScreen();
                    }));
                    _animationController!.reverse();
                  },
                ),
                // Floating action menu item
                Bubble(
                  title: "Past - Ins",
                  iconColor: Colors.white,
                  bubbleColor: Colors.blue,
                  icon: Icons.local_car_wash,
                  titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PastInsScreen();
                    }));
                    _animationController!.reverse();
                  },
                ),
              ],

              // animation controller
              animation: _animation!,

              // On pressed change animation state
              onPress: () => _animationController!.isCompleted
                  ? _animationController!.reverse()
                  : _animationController!.forward(),

              // Floating Action button Icon color
              iconColor: Colors.blue,

              // Flaoting Action button Icon
              iconData: Icons.ac_unit,
              backGroundColor: Colors.white,
            ),
          )),
    );
  }
}
