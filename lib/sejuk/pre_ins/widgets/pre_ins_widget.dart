// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, unnecessary_null_comparison, must_call_super, prefer_typing_uninitialized_variables, deprecated_member_use, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inspection/helpers/db.dart';
import 'package:inspection/helpers/diagnosis_model.dart';
import 'package:inspection/helpers/helpers.dart';
import 'package:inspection/sejuk/constants/constants.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:inspection/sejuk/input_remark/screens/input_remark_screen.dart';
import 'package:inspection/mobile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:path/path.dart' as Path;

enum Battery { good, noGood }
enum TypeImages {
  km,
  tampakDepan,
  kisiBlower,
  suhuWindSpd,
  filterCabin,
  resultAccu
}

class PreInsWidget extends StatefulWidget {
  const PreInsWidget({Key? key}) : super(key: key);

  @override
  State<PreInsWidget> createState() => _PreInsWidgetState();
}

class _PreInsWidgetState extends State<PreInsWidget> {
  TextEditingController dateController = TextEditingController();
  TextEditingController noWoController = TextEditingController();
  TextEditingController platNomorController = TextEditingController();
  TextEditingController typeKendaraanController = TextEditingController();
  TextEditingController teknisiController = TextEditingController();
  TextEditingController kisiRemarkController = TextEditingController();
  TextEditingController suhuRemarkController = TextEditingController();
  TextEditingController filterCabinRemarkController = TextEditingController();
  TextEditingController accuKetController = TextEditingController();
  TextEditingController hpController = TextEditingController();
  TextEditingController lpController = TextEditingController();
  TextEditingController suhuBlowerController = TextEditingController();
  TextEditingController windSpeedController = TextEditingController();
  TextEditingController perawatanRemarkController = TextEditingController();
  TextEditingController pergantianRemarkController = TextEditingController();
  TextEditingController lhFrController = TextEditingController();
  TextEditingController lhRrController = TextEditingController();
  TextEditingController rhFrController = TextEditingController();
  TextEditingController rhRrController = TextEditingController();
  TextEditingController keteranganCuciController = TextEditingController();
  TextEditingController diagnosisController = TextEditingController();
  TextEditingController remarkDiagnosisController = TextEditingController();

  FocusNode dateFocus = FocusNode();
  FocusNode noWoFocus = FocusNode();
  FocusNode platNomorFocus = FocusNode();
  FocusNode typeKendaraanFocus = FocusNode();
  FocusNode teknisiFocus = FocusNode();
  FocusNode kisiRemarkFocus = FocusNode();
  FocusNode suhuRemarkFocus = FocusNode();
  FocusNode filterCabinRemarkFocus = FocusNode();
  FocusNode accuKetFocus = FocusNode();
  FocusNode hpFocus = FocusNode();
  FocusNode lpFocus = FocusNode();
  FocusNode suhuBlowerFocus = FocusNode();
  FocusNode windSpeedFocus = FocusNode();
  FocusNode perawatanRemarkFocus = FocusNode();
  FocusNode pergantianRemarkFocus = FocusNode();
  FocusNode lhFrFocus = FocusNode();
  FocusNode lhRrFocus = FocusNode();
  FocusNode rhFrFocus = FocusNode();
  FocusNode rhRrFocus = FocusNode();
  fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  late ProgressDialog pr;

  String _battery = 'Good';
  String _cuci = 'Ya';
  List<String> cuciSpinner = [
    'Ya',
    'Tidak',
  ];
  var xFile,
      kmImg,
      tampakDepanImg,
      kisiBlowerImg,
      suhuWindSpdImg,
      filterCabinImg,
      rsltAccuImg;
  @override
  void initState() {
    pr = ProgressDialog(context);
    pr.style(message: 'Mohon tunggu...');
    // DiagnosisDatabaseProvider.db.getAllDiagnosis();
    DiagnosisDatabaseProvider.db.deleteAllItems();
  }

  getImage(ImageSource source, TypeImages typeImg) async {
    final pickedFile = await ImagePicker.platform.getImage(source: source);
    setState(() {
      xFile = File(pickedFile!.path);
      if (typeImg == TypeImages.km) {
        kmImg = xFile;
      } else if (typeImg == TypeImages.tampakDepan) {
        tampakDepanImg = xFile;
      } else if (typeImg == TypeImages.kisiBlower) {
        kisiBlowerImg = xFile;
      } else if (typeImg == TypeImages.suhuWindSpd) {
        suhuWindSpdImg = xFile;
      } else if (typeImg == TypeImages.filterCabin) {
        filterCabinImg = xFile;
      } else if (typeImg == TypeImages.resultAccu) {
        rsltAccuImg = xFile;
      }
    });

    print('getImage: ${xFile!.path}');
  }

  MyToast myToast = MyToast();

  validation() async {
    if (dateController.text.isEmpty) {
      myToast.showToast(context, 'Hari dan tanggal belum diisi!');
    } else if (noWoController.text.isEmpty) {
      myToast.showToast(context, 'No. Work Order belum diisi!');
    } else if (platNomorController.text.isEmpty) {
      myToast.showToast(context, 'Plat Nomor belum diisi!');
    } else if (typeKendaraanController.text.isEmpty) {
      myToast.showToast(context, 'Type Kendaraan belum diisi!');
    } else if (teknisiController.text.isEmpty) {
      myToast.showToast(context, 'Teknisi belum diisi!');
    } else if (kmImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Kilo Moter belum diisi!');
    } else if (tampakDepanImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Kendaraan Tampak Depan belum diisi!');
    } else if (kisiBlowerImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Kisi-Kisi Blower belum diisi!');
    } else if (suhuWindSpdImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Suhu & Wind Speed belum diisi!');
    } else if (filterCabinImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Filter Cabin belum diisi!');
    } else if (kisiRemarkController.text.isEmpty) {
      myToast.showToast(context, 'Remark Kisi-kisi Blower belum diisi!');
    } else if (suhuRemarkController.text.isEmpty) {
      myToast.showToast(context, 'Remark Suhu Blower belum diisi!');
    } else if (filterCabinRemarkController.text.isEmpty) {
      myToast.showToast(context, 'Remark Filter Cabin belum diisi!');
    } else if (lhFrController.text.isEmpty) {
      myToast.showToast(context, 'Kondisi ban LH-FR belum diisi!');
    } else if (lhRrController.text.isEmpty) {
      myToast.showToast(context, 'Kondisi ban LH-RR belum diisi!');
    } else if (rhFrController.text.isEmpty) {
      myToast.showToast(context, 'Kondisi ban RH-FR belum diisi!');
    } else if (rhRrController.text.isEmpty) {
      myToast.showToast(context, 'Kondisi ban RH-FR belum diisi!');
    } else if (keteranganCuciController.text.isEmpty) {
      myToast.showToast(context, 'Keterangan Kondisi Accu belum diisi!');
    } else if (hpController.text.isEmpty) {
      myToast.showToast(context, 'Hasil Cek HP belum diisi!');
    } else if (lpController.text.isEmpty) {
      myToast.showToast(context, 'Hasil Cek LP belum diisi!');
    } else if (suhuBlowerController.text.isEmpty) {
      myToast.showToast(context, 'Suhu Blower belum diisi!');
    } else if (windSpeedController.text.isEmpty) {
      myToast.showToast(context, 'Wind Speed belum diisi!');
    } else if (rsltAccuImg!.path.isEmpty) {
      myToast.showToast(context, 'Foto Result Accu belum diisi!');
    } else if (remarkPerawatanList.isEmpty) {
      myToast.showToast(context, 'Remark Perawatan belum diisi!');
    } else if (remarkPergantianList.isEmpty) {
      myToast.showToast(context, 'Remark Pergantian belum diisi!');
    } else {
      setState(() {
        outputPerawatanRemark = [];
        outputPergantianRemark = [];
      });
      if (remarkPerawatanList.isNotEmpty) {
        // remarkPerawatanList.sort((item1, item2) => item1.compareTo(item2));
        for (int i = 0; i < remarkPerawatanList.reversed.length; i++) {
          var act = remarkPerawatanList[i];

          // if (activities[i].contains(',')) {
          // }
          // String res = act.replaceAll(',', '^');
          print("replace: ${i + 1}. $act");
          outputPerawatanRemark.insert(0, '${i + 1}. $act');
        }
      }
      if (remarkPergantianList.isNotEmpty) {
        // remarkPergantianList.sort((item1, item2) => item1.compareTo(item2));
        for (int i = 0; i < remarkPergantianList.reversed.length; i++) {
          var act = remarkPergantianList[i];
          // if (activities[i].contains(',')) {
          // }
          // String res = act.replaceAll(',', '^');
          print("replace: ${i + 1}. $act");
          outputPergantianRemark.insert(0, '${i + 1}. $act');
        }
      }
      pr.show();

      _createPDF();
    }
  }

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    page.graphics.drawImage(
        PdfBitmap(await _readImageData('assets/logo_sejuk_lama.jpeg')),
        Rect.fromLTWH(0, 0, 80, 80));

    page.graphics.drawString('PT. Sejuk Mandiri Jaya (sejuk ac)',
        PdfStandardFont(PdfFontFamily.helvetica, 17),
        brush: PdfBrushes.blue, bounds: Rect.fromLTWH(160, 10, 0, 0));
    page.graphics.drawString(
        'Jl. Joglo Raya No.48, RT.7/RW.8, Joglo, Kec. Kembangan, Kota Jakarta Barat,',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(85, 33, 0, 0));
    page.graphics.drawString('Daerah Khusus Ibukota Jakarta 11640',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(180, 50, 0, 0));
    page.graphics.drawString(
        'Telpon: 021-58907848', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(220, 65, 0, 0));
    //pre-inspection check list
    PdfGrid preGrid = PdfGrid();
    preGrid.columns.add(count: 7);
    preGrid.headers.add(1);

    PdfGridRow preHeader = preGrid.headers[0];
    preHeader.cells[0].value = 'PRE-INSPECTION CHECK LIST';
    preHeader.cells[0].columnSpan = 7;
    preHeader.cells[0].style = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 20),
      textBrush: PdfBrushes.red,
    );
    preHeader.cells[0].style.stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.center);

    PdfGridRow preRow = preGrid.rows.add();
    preRow.cells[0].value = 'HARI/TANGGAL';
    preRow.cells[1].value = dateController.text;
    preRow.cells[1].columnSpan = 3;
    preRow.cells[4].value = 'KENDARAAN TAMPAK DEPAN';
    preRow.cells[4].columnSpan = 3;
    preRow.cells[4].style.stringFormat =
        PdfStringFormat(alignment: PdfTextAlignment.center);

    preRow = preGrid.rows.add();
    preRow.cells[0].value = 'NO. WORK ORDER';
    preRow.cells[1].value = noWoController.text;
    preRow.cells[1].columnSpan = 3;
    preRow.cells[4].rowSpan = 6;
    try {
      preRow.cells[5].rowSpan = 6;
      preRow.cells[5].value =
          PdfBitmap(await _readLclStrgImageData(tampakDepanImg!.path));
      preRow.cells[5].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }
    preRow.cells[6].rowSpan = 6;

    preRow = preGrid.rows.add();
    preRow.cells[0].value = 'PLAT NOMOR';
    preRow.cells[1].value = platNomorController.text;
    preRow.cells[1].columnSpan = 3;

    preRow = preGrid.rows.add();
    preRow.cells[0].value = 'TYPE KENDARAAN';
    preRow.cells[1].value = typeKendaraanController.text;
    preRow.cells[1].columnSpan = 3;

    preRow = preGrid.rows.add();
    preRow.cells[0].value = 'TEKNISI';
    preRow.cells[1].value = teknisiController.text;
    preRow.cells[1].columnSpan = 3;

    preRow = preGrid.rows.add();
    preRow.cells[0].rowSpan = 2;
    preRow.cells[0].value = 'KILO METER (KM) 140.020 KM';
    preRow.cells[1].rowSpan = 2;
    try {
      preRow.cells[2].rowSpan = 2;
      preRow.cells[2].value =
          PdfBitmap(await _readLclStrgImageData(kmImg!.path));
      preRow.cells[2].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }
    preRow.cells[3].rowSpan = 2;
    preRow.cells[4].value = '';
    preRow.cells[5].value = '';
    preRow.cells[6].value = '';
    preRow.height = 30;

    preRow = preGrid.rows.add();
    preRow.height = 20;
    preRow.cells[4].columnSpan = 3;

    preGrid.columns[0].width = 125;
    preGrid.columns[1].width = 50;
    preGrid.columns[2].width = 120;
    preGrid.columns[3].width = 50;
    preGrid.columns[4].width = 25;
    preGrid.columns[5].width = 120;
    preGrid.columns[6].width = 25;

    preGrid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0));

    preGrid.draw(page: page, bounds: Rect.fromLTWH(0, 100, 0, 0));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 4);
    grid.headers.add(1);

    PdfGridCellStyle gridStyle = PdfGridCellStyle(
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        backgroundBrush: PdfBrushes.red,
        textBrush: PdfBrushes.white);

    PdfStringFormat stringCenter =
        PdfStringFormat(alignment: PdfTextAlignment.center);

    PdfGridCellStyle gridStyleKondisiAccuEnable = PdfGridCellStyle(
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        backgroundBrush: PdfBrushes.pink,
        textBrush: PdfBrushes.black);

    PdfGridCellStyle gridStyleKondisiAccuDisable = PdfGridCellStyle(
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black);
    PdfMargins marginsKisi = PdfMargins();
    marginsKisi.left = 10;
    marginsKisi.right = 10;

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'No';
    header.cells[1].value = 'Decription';
    // header.cells[1].columnSpan = 2;
    // header.cells[2].value = '';
    header.cells[2].value = 'Pre-Inspection';
    header.cells[3].value = 'Remark';
    grid.headers[0].cells[0].style = gridStyle;
    grid.headers[0].cells[1].style = gridStyle;
    grid.headers[0].cells[2].style = gridStyle;
    grid.headers[0].cells[3].style = gridStyle;

    PdfGridRow row;
    for (var item in diagnosiss) {
      row = grid.rows.add();
      row.cells[0].value = '${item.id}';
      row.cells[1].value = '${item.title}';
      // row.cells[1].columnSpan = 2;
      try {
        row.cells[2].value =
            PdfBitmap(await Utility.dataFromBase64String('${item.img}'));
        row.cells[2].style = PdfGridCellStyle();
        row.cells[2].style = PdfGridCellStyle(
            cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
      } catch (e) {
        log(e.toString());
      }
      row.cells[3].value = '${item.remark}';
      row.height = 60;
    }
    // row = grid.rows.add();
    // row.cells[0].value = '1';
    // row.cells[1].value = 'KISI-KISI BLOWER';
    // // row.cells[1].columnSpan = 2;
    // try {
    //   row.cells[2].value =
    //       PdfBitmap(await _readLclStrgImageData(kisiBlowerImg!.path));
    //   row.cells[2].style = PdfGridCellStyle();
    //   row.cells[2].style = PdfGridCellStyle(
    //       cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    // } catch (e) {
    //   log(e.toString());
    // }
    // row.cells[3].value = kisiRemarkController.text;
    // row.height = 60;

    // row = grid.rows.add();
    // row.cells[0].value = '2';
    // row.cells[1].value = 'SUHU & WIND SPEED';
    // // row.cells[1].columnSpan = 2;

    // try {
    //   row.cells[2].value =
    //       PdfBitmap(await _readLclStrgImageData(suhuWindSpdImg!.path));
    //   row.cells[2].style = PdfGridCellStyle(
    //       cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    // } catch (e) {
    //   log(e.toString());
    // }
    // row.cells[3].value = suhuRemarkController.text;
    // row.height = 60;

    // row = grid.rows.add();
    // row.cells[0].value = '3';
    // row.cells[1].value = 'FILTER CABIN';
    // // row.cells[1].columnSpan = 2;
    // try {
    //   row.cells[2].value =
    //       PdfBitmap(await _readLclStrgImageData(filterCabinImg!.path));
    //   row.cells[2].style = PdfGridCellStyle(
    //       cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    // } catch (e) {
    //   log(e.toString());
    // }
    // row.cells[3].value = filterCabinRemarkController.text;
    // row.height = 60;

    grid.columns[0].width = 15;
    grid.columns[1].width = 170;
    // grid.columns[2].width = 90;
    grid.columns[2].width = 90;
    grid.columns[3].width = 240;

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0));

    grid.draw(page: page, bounds: Rect.fromLTWH(0, 280, 0, 0));

    List<int> bytes = document.save();
    document.dispose();

    saveAndLaunchFile(bytes, '${noWoController.text}.pdf');
    pr.hide();
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    print('saveAndLaunchFile: $path');
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    OpenFile.open('$path/$fileName');
    // initEmptyFields();
  }

  initEmptyFields() {
    pr.hide();
    setState(() {
      dateController.text = '';
      noWoController.text = '';
      platNomorController.text = '';
      platNomorController.text = '';
      typeKendaraanController.text = '';
      teknisiController.text = '';
      tampakDepanImg!.path == '';
      kmImg!.path == '';
      tampakDepanImg!.path == '';
      kisiBlowerImg!.path == '';
      suhuWindSpdImg!.path == '';
      filterCabinImg!.path == '';
      kisiRemarkController.text = '';
      suhuRemarkController.text = '';
      filterCabinRemarkController.text = '';
      lhFrController.text = '';
      lhRrController.text = '';
      rhFrController.text = '';
      rhRrController.text = '';
      keteranganCuciController.text = '';
      hpController.text = '';
      lpController.text = '';
      kisiRemarkController.text = '';
      suhuBlowerController.text = '';
      windSpeedController.text = '';
      rsltAccuImg!.path == '';
      remarkPerawatanList.clear();
      remarkPergantianList.clear();
    });
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<Uint8List> _readLclStrgImageData(String img) async {
    final imageData = File(img).readAsBytesSync();
    return imageData.buffer
        .asUint8List(imageData.offsetInBytes, imageData.lengthInBytes);
  }

  DateTime? dateTime;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future pickStartDateTime(BuildContext context) async {
    final date = await pickStartDate(context);
    if (date == null) return "";

    final time = await pickTime(context);
    if (time == null) return "";

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      dateController.text = dateFormat.format(dateTime!);
    });
  }

  Future<DateTime?> pickStartDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return newDate;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();

    if (initialTime == null) return null;

    return initialTime;
  }

  final List<String> remarkPerawatanList = [];
  final List<String> remarkPergantianList = [];

  void showRemarkPerawatanInputPage(context, String title) async {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InputRemarkScreen(title: title)));

      print("_showAddActivityPage: " + result.toString());
      if (result != null) {
        setState(() {
          remarkPerawatanList.insert(0, result.toString());
          remarkPerawatanList.sort((item1, item2) => item1.compareTo(item2));
        });
      }
    });
  }

  void showRemarkPergantianInputPage(context, String title) async {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) async {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InputRemarkScreen(
                    title: title,
                  )));

      print("_showAddActivityPage: " + result.toString());
      if (result != null) {
        setState(() {
          remarkPergantianList.insert(0, result.toString());
          remarkPergantianList.sort((item1, item2) => item1.compareTo(item2));
        });
      }
    });
  }

  _deletePerawatanList(String activity) {
    remarkPerawatanList.remove(activity);
  }

  _deletePergantianList(String activity) {
    remarkPergantianList.remove(activity);
  }

  List<String> outputPerawatanRemark = [];

  List<String> outputPergantianRemark = [];
  late List<Diagnosis> diagnosiss;
  Widget diagnosisFields() {
    return Container(
      child: Column(
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
                labelStyle: const TextStyle(color: ColorConstant.colorPrimary),
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
                labelStyle: const TextStyle(color: ColorConstant.colorPrimary),
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
          image != null
              ? Image.file(
                  File(image!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
              : Container(),
          Spacer(),
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
                    await DiagnosisDatabaseProvider.db
                        .addItemToDatabase(diagnosis);
                    Navigator.of(context).pop();
                    DiagnosisDatabaseProvider.db.getAllDiagnosis();
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
    );
  }

  var _selectFile;
  var image;
  final ImagePicker _imagePicker = ImagePicker();
  void getImages(ImageSource camera) async {
    image = await _imagePicker.pickImage(source: camera, imageQuality: 50);
    setState(() {
      _selectFile = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Text('Pre - Inspection Check List'),
          SizedBox(
            height: 8.0,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: ColorConstant.colorGrey.withOpacity(0.7),
                  border: Border.all(
                      color: ColorConstant.colorBoldPrimary, width: 3.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      onTap: () {
                        pickStartDateTime(context);
                      },
                      controller: dateController,
                      textInputAction: TextInputAction.next,
                      focusNode: dateFocus,
                      onFieldSubmitted: (term) {
                        fieldFocusChange(context, dateFocus, noWoFocus);
                      },
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', fontSize: 16.0),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Hari/Tanggal',
                          labelStyle: const TextStyle(
                              color: ColorConstant.colorPrimary),
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
                      controller: noWoController,
                      textInputAction: TextInputAction.next,
                      focusNode: noWoFocus,
                      onFieldSubmitted: (term) {
                        fieldFocusChange(context, noWoFocus, platNomorFocus);
                      },
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', fontSize: 16.0),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'No. Work Order',
                          labelStyle: const TextStyle(
                              color: ColorConstant.colorPrimary),
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
                      controller: platNomorController,
                      textInputAction: TextInputAction.next,
                      focusNode: platNomorFocus,
                      onFieldSubmitted: (term) {
                        fieldFocusChange(
                            context, platNomorFocus, typeKendaraanFocus);
                      },
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', fontSize: 16.0),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Plat Nomor',
                          labelStyle: const TextStyle(
                              color: ColorConstant.colorPrimary),
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
                      controller: typeKendaraanController,
                      textInputAction: TextInputAction.next,
                      focusNode: typeKendaraanFocus,
                      onFieldSubmitted: (term) {
                        fieldFocusChange(
                            context, typeKendaraanFocus, teknisiFocus);
                      },
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', fontSize: 16.0),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Type Kendaraan',
                          labelStyle: const TextStyle(
                              color: ColorConstant.colorPrimary),
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
                      controller: teknisiController,
                      textInputAction: TextInputAction.next,
                      focusNode: teknisiFocus,
                      obscureText: false,
                      style: const TextStyle(
                          fontFamily: 'Montserrat', fontSize: 16.0),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: ColorConstant.colorPrimary),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Teknisi',
                          labelStyle: const TextStyle(
                              color: ColorConstant.colorPrimary),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          // hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Kilo Meter (KM)'),
                    SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: () {
                        getImage(ImageSource.camera, TypeImages.km);
                      },
                      child: kmImg != null
                          ? Image.file(
                              File(kmImg!.path),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/image_camera.jpg',
                              height: 200,
                              width: 200,
                            ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Kendaraan Tampak Depan'),
                    SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: () {
                        getImage(ImageSource.camera, TypeImages.tampakDepan);
                      },
                      child: tampakDepanImg != null
                          ? Image.file(
                              File(tampakDepanImg!.path),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/image_camera.jpg',
                              height: 200,
                              width: 200,
                            ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: ColorConstant.colorGrey.withOpacity(0.7),
                    border: Border.all(
                      color: ColorConstant.colorRed,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Diagnosis'),
                            InkWell(
                              onTap: () async {
                                await showPlatformDialog(
                                    context: context,
                                    builder: (_) => BasicDialogAlert(
                                          title: Text('Add Diagnosis'),
                                          content: diagnosisFields(),
                                        ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        // Text('Kisi-kisi Blower'),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(right: 8.0),
                        //         child: InkWell(
                        //           onTap: () {
                        //             getImage(ImageSource.camera,
                        //                 TypeImages.kisiBlower);
                        //           },
                        //           child: kisiBlowerImg != null
                        //               ? Image.file(
                        //                   File(kisiBlowerImg!.path),
                        //                   height: 100,
                        //                   width: 100,
                        //                   fit: BoxFit.cover,
                        //                 )
                        //               : Image.asset(
                        //                   'assets/image_camera.jpg',
                        //                   height: 100,
                        //                   width: 100,
                        //                 ),
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Container(
                        //         height: 100,
                        //         child: TextFormField(
                        //           maxLines: 5,
                        //           controller: kisiRemarkController,
                        //           textInputAction: TextInputAction.next,
                        //           obscureText: false,
                        //           style: const TextStyle(
                        //               fontFamily: 'Montserrat', fontSize: 16.0),
                        //           decoration: InputDecoration(
                        //               enabledBorder: OutlineInputBorder(
                        //                   borderSide: BorderSide(
                        //                       color:
                        //                           ColorConstant.colorPrimary),
                        //                   borderRadius:
                        //                       BorderRadius.circular(10.0)),
                        //               disabledBorder: OutlineInputBorder(
                        //                   borderSide: const BorderSide(
                        //                       color:
                        //                           ColorConstant.colorPrimary),
                        //                   borderRadius:
                        //                       BorderRadius.circular(10.0)),
                        //               labelText: 'Remark',
                        //               labelStyle: const TextStyle(
                        //                   color: ColorConstant.colorPrimary),
                        //               contentPadding: const EdgeInsets.fromLTRB(
                        //                   20.0, 15.0, 20.0, 15.0),
                        //               // hintText: "Email",
                        //               border: OutlineInputBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10.0))),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 8.0,
                        // ),
                        FutureBuilder<List<Diagnosis>>(
                            future:
                                DiagnosisDatabaseProvider.db.getAllDiagnosis(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Diagnosis>> snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Diagnosis diagnosis =
                                              snapshot.data![index];
                                          diagnosiss = snapshot.data!;
                                          return Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: Utility
                                                        .imageFromBase64String(
                                                            diagnosis.img),
                                                  ),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        diagnosis.title
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        diagnosis.remark
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                );
                              } else {
                                return Center();
                              }
                            }),
                      ],
                    ),
                  )),
              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                child: Column(
                  children: [
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorConstant.colorPrimary,
                      child: MaterialButton(
                        onPressed: () {
                          // validation();
                          _createPDF();
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Generate',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
