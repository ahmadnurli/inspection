// ignore_for_file: unnecessary_string_interpolations, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

class ListViewPdfWidget extends StatelessWidget {
  ListViewPdfWidget({Key? key, required this.filesList, required this.path})
      : super(key: key);
  final List<String> filesList;
  var path;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                child: const Icon(
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
        });
  }

  Future<void> shareFile(String filesList) async {
    var fileName = filesList.split('/').last;
    await Share.shareFiles(['$path/$fileName'], text: fileName);
  }
}
