import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspection/sejuk/constants/color_constant.dart';
import 'package:inspection/sejuk/pre_ins/screens/pre_ins_screen.dart';

import '../../../helpers/helpers.dart';

class InputDiagnosisScreen extends StatefulWidget {
  const InputDiagnosisScreen({Key? key}) : super(key: key);

  @override
  State<InputDiagnosisScreen> createState() => _InputDiagnosisScreenState();
}

class _InputDiagnosisScreenState extends State<InputDiagnosisScreen> {
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController remarkDiagnosisController = TextEditingController();

  var _selectFile;
  XFile? image;
  var resultImage;
  final ImagePicker _imagePicker = ImagePicker();
  getImages(ImageSource camera) async {
    image = await _imagePicker.pickImage(source: camera, imageQuality: 50);
    setState(() {
      resultImage = image;
      _selectFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Diagnosis')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextFormField(
              controller: diagnosisController,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16.0),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.colorPrimary),
                      borderRadius: BorderRadius.circular(10.0)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: ColorConstant.colorPrimary),
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Diagnosis',
                  labelStyle:
                      const TextStyle(color: ColorConstant.colorPrimary),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  // hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextFormField(
              maxLines: 5,
              controller: remarkDiagnosisController,
              textInputAction: TextInputAction.next,
              obscureText: false,
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16.0),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstant.colorPrimary),
                      borderRadius: BorderRadius.circular(10.0)),
                  disabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: ColorConstant.colorPrimary),
                      borderRadius: BorderRadius.circular(10.0)),
                  labelText: 'Remark',
                  labelStyle:
                      const TextStyle(color: ColorConstant.colorPrimary),
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  // hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                child: Text(
                  'Take Photo',
                  style: TextStyle(color: ColorConstant.colorPrimary),
                ),
                onPressed: () {
                  getImages(ImageSource.camera);
                },
              ),
            ),
            SizedBox(height: 8.0),
            _selectFile != null
                ? Image.file(
                    _selectFile,
                    height: 400,
                    width: 200,
                    fit: BoxFit.fill,
                  )
                : Container(),
            // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                  child: RaisedButton(
                    color: ColorConstant.colorPrimary,
                    child: Text(
                      'Save',
                      style: TextStyle(color: ColorConstant.colorWhite),
                    ),
                    onPressed: () async {
                      Diagnosis diagnosis = Diagnosis(
                          title: diagnosisController.text,
                          remark: remarkDiagnosisController.text,
                          img: Utility.base64String(
                              _selectFile.readAsBytesSync()));
                      await PreDiagnosisDatabaseProvider.db
                          .addItemToDatabase(diagnosis);
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (_) {
                      //   return PreInsScreen();
                      // }));
                      Navigator.of(context).pop();
                      PreDiagnosisDatabaseProvider.db.getAllDiagnosis();
                      setState(() {
                        diagnosisController.text = '';
                        remarkDiagnosisController.text = '';
                        _selectFile = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
