import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspection/report/widgets/list_view_pdf_widget.dart';
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

  List<String> filesList = [];
  Future listDir() async {
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
  Widget build(BuildContext context) {
    return ListViewPdfWidget(filesList: filesList, path: path);
  }
}
