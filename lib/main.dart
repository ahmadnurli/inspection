// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspection/constants/color_constant.dart';
import 'package:inspection/home/screens/screens.dart';
import 'package:inspection/pre_ins/screens/pre_ins_screen.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mobile.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarColor: ColorConstant.colorBoldPrimary,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      
      home: HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var path;

  @override
  void initState() {
    super.initState();
    listDir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: () {
                  _createPDF();
                },
                child: Icon(Icons.create)),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: filesList.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                title: Text(filesList[i].split('/').last),
                leading: Icon(Icons.picture_as_pdf),
                trailing: GestureDetector(
                  onTap: () {
                    shareFile(filesList[i]);
                  },
                  child: Icon(
                    Icons.share,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  print('${filesList[i]}');
                  OpenFile.open('${filesList[i]}');
                },
              ),
            );
          }),
    );
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    document.pages.add();

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output3.pdf');
  }

  Future<void> shareFile(String filesList) async {
    var fileName = filesList.split('/').last;
    await Share.shareFiles(['$path/$fileName'], text: fileName);
  }

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
}
