// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_string_interpolations, unnecessary_null_comparison, must_call_super, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:inspection/mitsubishi/constants/constants.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:inspection/mitsubishi/input_remark/screens/input_remark_screen.dart';
import 'package:inspection/mobile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

enum Battery { good, noGood }
enum TypeImages {
  km,
  tampakDepan,
  kisiBlower,
  suhuWindSpd,
  filterCabin,
  resultAccu
}

class PastInsWidget extends StatefulWidget {
  const PastInsWidget({Key? key}) : super(key: key);

  @override
  State<PastInsWidget> createState() => _PastInsWidgetState();
}

class _PastInsWidgetState extends State<PastInsWidget> {
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

    page.graphics.drawString(
        'MITSUBISHI DIPO PLUIT', PdfStandardFont(PdfFontFamily.helvetica, 17),
        brush: PdfBrushes.blue, bounds: Rect.fromLTWH(160, 10, 0, 0));
    page.graphics.drawString(
        'Jl. Joglo Raya No.48, RT.7/RW.8, Joglo, Kec. Kembangan, Kota Jakarta Barat,',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(85, 33, 0, 0));
    page.graphics.drawString('Daerah Khusus Ibukota Jakarta 11640',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(160, 50, 0, 0));
    page.graphics.drawString(
        'Telpon: 021-58907848', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: Rect.fromLTWH(200, 65, 0, 0));
    //pre-inspection check list
    PdfGrid preGrid = PdfGrid();
    preGrid.columns.add(count: 7);
    preGrid.headers.add(1);

    PdfGridRow preHeader = preGrid.headers[0];
    preHeader.cells[0].value = 'POST-INSPECTION CHECK LIST';
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
    grid.columns.add(count: 5);
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
    header.cells[1].columnSpan = 2;
    header.cells[2].value = '';
    header.cells[3].value = 'Pre-Inspection';
    header.cells[4].value = 'Remark';
    grid.headers[0].cells[0].style = gridStyle;
    grid.headers[0].cells[1].style = gridStyle;
    grid.headers[0].cells[3].style = gridStyle;
    grid.headers[0].cells[4].style = gridStyle;

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '1';
    row.cells[1].value = 'KISI-KISI BLOWER';
    row.cells[1].columnSpan = 2;
    try {
      row.cells[3].value =
          PdfBitmap(await _readLclStrgImageData(kisiBlowerImg!.path));
      row.cells[3].style = PdfGridCellStyle();
      row.cells[3].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }
    row.cells[4].value = kisiRemarkController.text;
    row.height = 60;

    row = grid.rows.add();
    row.cells[0].value = '2';
    row.cells[1].value = 'SUHU & WIND SPEED';
    row.cells[1].columnSpan = 2;

    try {
      row.cells[3].value =
          PdfBitmap(await _readLclStrgImageData(suhuWindSpdImg!.path));
      row.cells[3].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }
    row.cells[4].value = suhuRemarkController.text;
    row.height = 60;

    row = grid.rows.add();
    row.cells[0].value = '3';
    row.cells[1].value = 'FILTER CABIN';
    row.cells[1].columnSpan = 2;
    try {
      row.cells[3].value =
          PdfBitmap(await _readLclStrgImageData(filterCabinImg!.path));
      row.cells[3].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }
    row.cells[4].value = filterCabinRemarkController.text;
    row.height = 60;

    row = grid.rows.add();
    row.cells[0].value = '4';
    row.cells[0].rowSpan = 5;
    row.cells[1].value = 'KONDISI BAN';
    row.cells[1].columnSpan = 2;
    row.cells[1].columnSpan = 4;
    row.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.red,
      textBrush: PdfBrushes.white,
    );
    row.cells[1].style.stringFormat = stringCenter;

    row = grid.rows.add();
    row.cells[0].value = '';
    try {
      row.cells[1].columnSpan = 2;
      row.cells[1].value = PdfBitmap(await _readImageData('assets/wheel.jpg'));
      row.cells[1].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 23, right: 23, top: 0));
    } catch (e) {
      log(e.toString());
    }
    row.cells[3].value = 'LH';
    row.cells[4].value = 'RH';
    row.cells[3].style = PdfGridCellStyle(
        format: stringCenter,
        backgroundBrush: PdfBrushes.pink,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 15));
    row.cells[4].style = PdfGridCellStyle(
        format: stringCenter,
        backgroundBrush: PdfBrushes.pink,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 15));
    row.height = 25;

    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = 'FR';
    row.cells[1].columnSpan = 2;
    row.cells[2].value = '';
    row.cells[3].value = lhFrController.text;
    row.cells[4].value = rhFrController.text;
    row.cells[1].style = PdfGridCellStyle(
        format: stringCenter,
        backgroundBrush: PdfBrushes.pink,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 15));
    row.height = 25;

    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = 'RR';
    row.cells[1].columnSpan = 2;
    row.cells[2].value = '';
    row.cells[3].value = rhFrController.text;
    row.cells[4].value = rhRrController.text;
    row.cells[1].style = PdfGridCellStyle(
        format: stringCenter,
        backgroundBrush: PdfBrushes.pink,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.helvetica, 15));
    row.height = 25;

    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = 'Limit ketebalan ban 2 mm';
    row.cells[1].columnSpan = 4;
    row.cells[2].value = '';
    row.cells[3].value = '';
    row.cells[4].value = '';
    row.height = 30;
    row.cells[1].style.stringFormat = stringCenter;

    row = grid.rows.add();
    row.cells[0].value = '5';
    row.cells[0].rowSpan = 2;
    row.cells[1].value = 'KONDISI ACCU';
    row.cells[1].columnSpan = 4;
    row.cells[1].style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.red,
      textBrush: PdfBrushes.white,
    );
    row.cells[1].style.stringFormat = stringCenter;

    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = 'BATTERY';
    row.cells[1].columnSpan = 2;
    row.cells[1].style = PdfGridCellStyle(
      format: stringCenter,
      textBrush: PdfBrushes.blue,
    );
    row.cells[3].value = 'GOOD';
    row.cells[3].style = _battery == 'Good'
        ? gridStyleKondisiAccuEnable
        : gridStyleKondisiAccuDisable;

    row.cells[4].value = 'NO GOOD';
    row.cells[4].style = _battery == 'No Good'
        ? gridStyleKondisiAccuEnable
        : gridStyleKondisiAccuDisable;
    row.height = 35;

    row = grid.rows.add();
    row.cells[0].value = '6';
    row.cells[0].rowSpan = 2;
    row.cells[1].value = 'CUCI';
    row.cells[1].rowSpan = 2;
    row.cells[1].style = PdfGridCellStyle(
      format: stringCenter,
      textBrush: PdfBrushes.blue,
    );
    row.cells[2].value = 'YA';
    row.cells[2].style = _cuci == 'Ya'
        ? gridStyleKondisiAccuEnable
        : gridStyleKondisiAccuDisable;
    row.cells[3].value = 'KET: ${keteranganCuciController.text}';
    row.cells[3].rowSpan = 2;
    row.cells[3].columnSpan = 2;
    row.cells[4].value = '';

    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = '';
    row.cells[2].value = 'TIDAK';
    row.cells[2].style = _cuci == 'Tidak'
        ? gridStyleKondisiAccuEnable
        : gridStyleKondisiAccuDisable;
    row.cells[3].value = '';
    row.cells[3].columnSpan = 2;
    row.cells[4].value = '';

    grid.columns[0].width = 15;
    grid.columns[1].width = 30;
    grid.columns[2].width = 40;
    grid.columns[3].width = 80;
    grid.columns[4].width = 80;

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0));

    grid.draw(page: page, bounds: Rect.fromLTWH(0, 280, 0, 0));

    PdfGrid gridHasilCek = PdfGrid();
    gridHasilCek.columns.add(count: 2);
    gridHasilCek.headers.add(1);

    PdfGridCellStyle styleHeaderHasil = PdfGridCellStyle(
        format: stringCenter,
        font: PdfStandardFont(PdfFontFamily.helvetica, 15,
            style: PdfFontStyle.bold));
    PdfGridCellStyle styleRowHasil = PdfGridCellStyle(
      format: stringCenter,
    );

    PdfGridRow headerHasil = gridHasilCek.headers[0];
    headerHasil.cells[0].value = 'HASIL CEK';
    headerHasil.cells[0].columnSpan = 2;
    headerHasil.cells[0].style = styleHeaderHasil;

    PdfGridRow rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'HP';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '${hpController.text} PSI';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'LP';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '${lpController.text} PSI';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'ANEMOMETER';
    rowHasilCek.cells[0].columnSpan = 2;
    rowHasilCek.cells[0].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'SUHU BLOWER';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '${suhuBlowerController.text} °C';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'WIND SPEED';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '${windSpeedController.text} M/S';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'STANDAR NORMAL';
    rowHasilCek.cells[0].columnSpan = 2;
    rowHasilCek.cells[0].style = styleHeaderHasil;
    rowHasilCek.cells[1].value = '';

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'HP';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '200 - 250 PSI';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'LP';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '20 - 40 PSI';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'ANEMOMETER';
    rowHasilCek.cells[0].columnSpan = 2;
    rowHasilCek.cells[0].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'SUHU BLOWER';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '< 7 °C';
    rowHasilCek.cells[1].style = styleRowHasil;

    rowHasilCek = gridHasilCek.rows.add();
    rowHasilCek.cells[0].value = 'WIND SPEED';
    rowHasilCek.cells[0].style = styleRowHasil;
    rowHasilCek.cells[1].value = '2.0 M/S';
    rowHasilCek.cells[1].style = styleRowHasil;

    gridHasilCek.columns[0].width = 127;
    gridHasilCek.columns[1].width = 127;

    gridHasilCek.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0),
        backgroundBrush: PdfBrushes.yellow);

    gridHasilCek.draw(page: page, bounds: Rect.fromLTWH(260, 280, 0, 0));

    PdfGrid gridResultAccu = PdfGrid();
    gridResultAccu.columns.add(count: 1);
    gridResultAccu.headers.add(1);

    PdfGridRow headerResultAccu = gridResultAccu.headers[0];
    headerResultAccu.cells[0].value = 'RESULT ACCU';
    headerResultAccu.cells[0].style = styleHeaderHasil;

    PdfGridRow rowResultAccu = gridResultAccu.rows.add();
    rowResultAccu.height = 150;
    try {
      rowResultAccu.cells[0].value =
          PdfBitmap(await _readLclStrgImageData(rsltAccuImg!.path));
      rowResultAccu.cells[0].style = PdfGridCellStyle(
          cellPadding: PdfPaddings(bottom: 0, left: 0, right: 0, top: 0));
    } catch (e) {
      log(e.toString());
    }

    gridResultAccu.columns[0].width = 125;

    gridResultAccu.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0),
    );

    gridResultAccu.draw(page: page, bounds: Rect.fromLTWH(260, 510, 0, 0));

    PdfGrid gridRemark = PdfGrid();
    gridRemark.columns.add(count: 1);
    gridRemark.headers.add(1);

    PdfGridCellStyle styleRemark = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 10),
      textBrush: PdfBrushes.red,
    );

    PdfGridRow headerRemark = gridRemark.headers[0];
    headerRemark.cells[0].value = 'REMARK';
    headerRemark.cells[0].style = styleHeaderHasil;

    PdfGridRow rowRemark = gridRemark.rows.add();
    rowRemark.cells[0].value = 'PERAWATAN: ';
    rowRemark.cells[0].style = styleRemark;

    outputPerawatanRemark.sort((item1, item2) => item1.compareTo(item2));
    rowRemark = gridRemark.rows.add();
    rowRemark.cells[0].value = outputPerawatanRemark.join('\n');
    // rowRemark.height = 55;

    rowRemark = gridRemark.rows.add();
    rowRemark.cells[0].value = 'PERGANTIAN: ';
    rowRemark.cells[0].style = styleRemark;

    outputPergantianRemark.sort((item1, item2) => item1.compareTo(item2));
    rowRemark = gridRemark.rows.add();
    rowRemark.cells[0].value = outputPergantianRemark.join('\n');
    // rowRemark.height = 55;

    gridRemark.columns[0].width = 125;

    gridRemark.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 0, top: 4, bottom: 0),
    );

    gridRemark.draw(page: page, bounds: Rect.fromLTWH(390, 520, 0, 0));

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

  Widget _remarkPerawatanList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.0),
        itemCount: remarkPerawatanList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 7.0,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    '${index + 1}. ${remarkPerawatanList[index]}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              _deletePerawatanList(remarkPerawatanList[index]);
                              setState(() {
                                // if (remarkPerawatanList.isEmpty) {
                                //   remarkPerawatanList.clear();
                                // }
                              });
                            }),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget _remarkPergantianList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.0),
        itemCount: remarkPergantianList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Card(
                  elevation: 7.0,
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    '${index + 1}. ${remarkPergantianList[index]}',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              _deletePergantianList(
                                  remarkPergantianList[index]);
                              setState(() {
                                // if (remarkPergantianList.isEmpty) {
                                //   remarkPergantianList.clear();
                                // }
                              });
                            }),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  List<String> outputPerawatanRemark = [];

  List<String> outputPergantianRemark = [];

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
                        Text('Diagnosis'),
                        Text('Kisi-kisi Blower'),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.camera,
                                        TypeImages.kisiBlower);
                                  },
                                  child: kisiBlowerImg != null
                                      ? Image.file(
                                          File(kisiBlowerImg!.path),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/image_camera.jpg',
                                          height: 100,
                                          width: 100,
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: kisiRemarkController,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'Remark',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Suhu & Wind Speed'),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.camera,
                                        TypeImages.suhuWindSpd);
                                  },
                                  child: suhuWindSpdImg != null
                                      ? Image.file(
                                          File(suhuWindSpdImg!.path),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/image_camera.jpg',
                                          height: 100,
                                          width: 100,
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: suhuRemarkController,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'Remark',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Filter Cabin'),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.camera,
                                        TypeImages.filterCabin);
                                  },
                                  child: filterCabinImg != null
                                      ? Image.file(
                                          File(filterCabinImg!.path),
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/image_camera.jpg',
                                          height: 100,
                                          width: 100,
                                        ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: TextFormField(
                                  maxLines: 5,
                                  controller: filterCabinRemarkController,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'Remark',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Kondisi Ban'),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextFormField(
                                  controller: lhFrController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: lhFrFocus,
                                  onFieldSubmitted: (term) {
                                    fieldFocusChange(
                                        context, lhFrFocus, lhRrFocus);
                                  },
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'LH-FR',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextFormField(
                                  controller: rhFrController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: rhFrFocus,
                                  onFieldSubmitted: (term) {
                                    fieldFocusChange(
                                        context, rhFrFocus, rhRrFocus);
                                  },
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'RH-FR',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextFormField(
                                  controller: lhRrController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: lhRrFocus,
                                  onFieldSubmitted: (term) {
                                    fieldFocusChange(
                                        context, lhRrFocus, rhFrFocus);
                                  },
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'LH-RR',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextFormField(
                                  controller: rhRrController,
                                  textInputAction: TextInputAction.next,
                                  focusNode: rhRrFocus,
                                  obscureText: false,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 16.0),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color:
                                                  ColorConstant.colorPrimary),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'RH-RR',
                                      labelStyle: const TextStyle(
                                          color: ColorConstant.colorPrimary),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      // hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Kondisi Accu'),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Battery'),
                        Column(
                          children: [
                            ListTile(
                              title: Text('Good'),
                              leading: Radio(
                                  value: 'Good',
                                  groupValue: _battery,
                                  onChanged: (value) {
                                    setState(() {
                                      _battery = value.toString();
                                    });
                                    print(_battery);
                                  }),
                            ),
                            ListTile(
                              title: Text('No Good'),
                              leading: Radio(
                                  value: 'No Good',
                                  groupValue: _battery,
                                  onChanged: (value) {
                                    setState(() {
                                      _battery = value.toString();
                                    });
                                    print(_battery);
                                  }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text('Cuci'),
                        DropdownButton<String>(
                          value: _cuci,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: ColorConstant.colorPrimary, fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: ColorConstant.colorBoldPrimary,
                          ),
                          onChanged: (data) {
                            setState(() {
                              _cuci = data!;
                            });
                            print(_cuci);
                          },
                          items: cuciSpinner
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          maxLines: 5,
                          controller: keteranganCuciController,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          style: const TextStyle(
                              fontFamily: 'Montserrat', fontSize: 16.0),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstant.colorPrimary),
                                  borderRadius: BorderRadius.circular(10.0)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: ColorConstant.colorPrimary),
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: 'Keterangan',
                              labelStyle: const TextStyle(
                                  color: ColorConstant.colorPrimary),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              // hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 8.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: ColorConstant.colorGrey.withOpacity(0.7),
                    border: Border.all(
                      color: ColorConstant.colorYellow,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Hasil Cek'),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            controller: hpController,
                            textInputAction: TextInputAction.next,
                            focusNode: hpFocus,
                            onSubmitted: (term) {
                              if (int.parse(hpController.text) < 200 ||
                                  int.parse(hpController.text) > 250) {
                                myToast.showToastCenter(context,
                                    'HP melewati batas standar normal!');
                              }
                              fieldFocusChange(context, hpFocus, lpFocus);
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 16.0),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'HP',
                                labelStyle: const TextStyle(
                                    color: ColorConstant.colorPrimary),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                // hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            controller: lpController,
                            textInputAction: TextInputAction.next,
                            focusNode: lpFocus,
                            onSubmitted: (term) {
                              if (int.parse(lpController.text) < 20 ||
                                  int.parse(lpController.text) > 40) {
                                myToast.showToastCenter(context,
                                    'LP melawati batas standar normal!');
                              }
                              fieldFocusChange(
                                  context, lpFocus, suhuBlowerFocus);
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 16.0),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'LP',
                                labelStyle: const TextStyle(
                                    color: ColorConstant.colorPrimary),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                // hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text('Anemometer'),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            controller: suhuBlowerController,
                            textInputAction: TextInputAction.next,
                            focusNode: suhuBlowerFocus,
                            onSubmitted: (term) {
                              if (int.parse(suhuBlowerController.text) > 6) {
                                myToast.showToastCenter(context,
                                    'Suhu Blower melewati batas standar normal!');
                              }
                              fieldFocusChange(
                                  context, suhuBlowerFocus, windSpeedFocus);
                            },
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            style: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 16.0),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Suhu Blower',
                                labelStyle: const TextStyle(
                                    color: ColorConstant.colorPrimary),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                // hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextField(
                            controller: windSpeedController,
                            textInputAction: TextInputAction.next,
                            focusNode: windSpeedFocus,
                            obscureText: false,
                            onSubmitted: (term) {
                              if (double.parse(windSpeedController.text) >
                                  2.0) {
                                myToast.showToastCenter(context,
                                    'Wind Speed melewati batas standar normal!');
                              }
                            },
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontFamily: 'Montserrat', fontSize: 16.0),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: ColorConstant.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: 'Wind Speed',
                                labelStyle: const TextStyle(
                                    color: ColorConstant.colorPrimary),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                // hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ColorConstant.colorYellow.withOpacity(0.7),
                            border: Border.all(
                              color: ColorConstant.colorYellow,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(7.0)),
                        child: Column(
                          children: [
                            Text('Standar Normal'),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 16.0),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: '200 - 250 PSI',
                                  labelStyle: const TextStyle(
                                      color: ColorConstant.colorBlack),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  // hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 16.0),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: '20 - 40 PSI',
                                  labelStyle: const TextStyle(
                                      color: ColorConstant.colorBlack),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  // hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text('Anemometer'),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 16.0),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: '< 7 °C',
                                  labelStyle: const TextStyle(
                                      color: ColorConstant.colorBlack),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  // hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              enabled: false,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 16.0),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: ColorConstant.colorBlack),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  labelText: '2.0 M/S',
                                  labelStyle: const TextStyle(
                                      color: ColorConstant.colorBlack),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  // hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorConstant.blue100.withOpacity(0.7),
                      border: Border.all(
                        color: ColorConstant.colorRed,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      Text('Result Accu'),
                      SizedBox(
                        height: 8.0,
                      ),
                      InkWell(
                        onTap: () {
                          getImage(ImageSource.camera, TypeImages.resultAccu);
                        },
                        child: rsltAccuImg != null
                            ? Image.file(
                                File(rsltAccuImg!.path),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/image_camera.jpg',
                                height: 100,
                                width: 100,
                              ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 8.0,
              ),
              Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ColorConstant.blue100.withOpacity(0.7),
                      border: Border.all(
                        color: ColorConstant.colorRed,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: [
                      Text('Remark'),
                      SizedBox(
                        height: 8.0,
                      ),
                      InkWell(
                        onTap: () {
                          showRemarkPerawatanInputPage(
                              context, 'Remark Perawatan');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'PERAWATAN :',
                              style: TextStyle(color: ColorConstant.colorRed),
                            ),
                            Icon(Icons.edit)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(height: 130, child: _remarkPerawatanList()),
                      SizedBox(
                        height: 8.0,
                      ),
                      InkWell(
                        onTap: () {
                          showRemarkPergantianInputPage(
                              context, 'Remark Pergantian');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'PERGANTIAN :',
                              style: TextStyle(color: ColorConstant.colorRed),
                            ),
                            Icon(Icons.edit)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(height: 130, child: _remarkPergantianList()),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  )),
              SizedBox(
                height: 8.0,
              ),
              Container(
                color: ColorConstant.colorBlack,
                height: 2.0,
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
                          validation();
                          // _createPDF();
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
