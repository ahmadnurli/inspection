// ignore_for_file: override_on_non_overriding_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:inspection/catur/report/widgets/list_view_pdf_widget.dart';
import 'package:path_provider/path_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    listDir();
  }

  var path;
  MyToast myToast = MyToast();
  List<String> filesList = [];
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
    return RefreshIndicator(
        onRefresh: listDir,
        child: ListViewPdfWidget(filesList: filesList, path: path));
  }
}
