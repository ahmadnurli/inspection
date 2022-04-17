// ignore_for_file: prefer_const_constructors, override_on_non_overriding_member

import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:inspection/sejuk/constants/color_constant.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:inspection/sejuk/post_ins/screens/screens.dart';
import 'package:inspection/sejuk/pre_ins/screens/screens.dart';
import 'package:inspection/sejuk/report/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    listDir();
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController!.dispose();
  }

  List<String> filesList = [];
  var path;

  Future listDir() async {
    setState(() {
      filesList = [];
    });
    path = (await getExternalStorageDirectory())!.path;
    Directory dir = Directory(path!);

    print('listDir $dir');

    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      FileSystemEntityType type = await FileSystemEntity.type(entity.path);
      if (type == FileSystemEntityType.file && entity.path.endsWith('.pdf')) {
        setState(() {
          filesList.add(entity.path);
        });
      }
    }
    print('listDir: $filesList');
    return filesList;
  }

  MyToast myToast = MyToast();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      listDir();
      myToast.showToast(context, 'resumed');
    } else if (state == AppLifecycleState.paused) {
      listDir();
      myToast.showToast(context, 'paused');
    } else if (state == AppLifecycleState.detached) {
      listDir();
      myToast.showToast(context, 'detached');
    } else if (state == AppLifecycleState.inactive) {
      listDir();
      myToast.showToast(context, 'inactive');
    } else if (state == AppLifecycleState.values) {
      listDir();
      myToast.showToast(context, 'values');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inspection'),
        ),
        body: Container(
          color: ColorConstant.grey,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/logo_sejuk_lama.jpeg'),
                    fit: BoxFit.fitWidth,
                  )),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                      onRefresh: listDir,
                      child:
                          ListViewPdfWidget(filesList: filesList, path: path)))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PreInsScreen();
                  }));
                  _animationController!.reverse();
                },
              ),
              // Floating action menu item
              Bubble(
                title: "Post - Ins",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.local_car_wash,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PostInsScreen();
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
        ));
  }
}
