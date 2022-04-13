import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Utility {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Uint8List convert(String base64String) {
    return Base64Decoder().convert(base64String);
  }

  // static Future<String> base64ByteData(Asset asset) async {
  //   ByteData byteData = await rootBundle.load(asset.toString());
  //   var buffer = byteData.buffer;
  //   var result = base64Encode(Uint16List.view(buffer));
  //   return result;
  // }

  static void showTopSnackBar(
    BuildContext context,
    String message,
    Color color,
  ) =>
      showSimpleNotification(Text('Internet Connectivity Update'),
          subtitle: Text(message), background: color);

  static showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static List<T> modelBuilder<M, T>(
          List<M> models, T Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
