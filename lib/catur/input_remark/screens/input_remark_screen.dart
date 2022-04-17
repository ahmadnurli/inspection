import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inspection/catur/constants/constants.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:inspection/catur/input_remark/widgets/widgets.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class InputRemarkScreen extends StatefulWidget {
  const InputRemarkScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<InputRemarkScreen> createState() => _InputRemarkScreenState();
}

class _InputRemarkScreenState extends State<InputRemarkScreen> {
  TextEditingController controllerDailyAct = TextEditingController();
  late ProgressDialog pr;
  MyToast myToast = MyToast();
  void _saveToList(String text, ProgressDialog pr) {
    if (text.length > 0) {
      String dailyItem = text;
      Future.delayed(Duration(seconds: 1)).then((onValue) {
        pr.hide().whenComplete(() {
          Navigator.pop(context, dailyItem);
        });
      });
    } else {
      myToast.showToast(context, 'Silahkan isi Remark');
    }
    // Navigator.pop(context, text);
  }

  // void showToast(String s) {
  //   Toast.values
  //   Toast.show(s, context, duration: Toast.LENGTH_LONG);
  // }

  @override
  void initState() {
    pr = ProgressDialog(context);
    pr.style(message: 'Please wait...');
  }

  moveToLastScreen() {
    if (controllerDailyAct.text.length == 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => moveToLastScreen(),
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: controllerDailyAct,
                        maxLines: 10,
                        maxLength: 500,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: 'Remark',
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstant.colorPrimary),
                                borderRadius: BorderRadius.circular(32.0)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstant.colorPrimary),
                                borderRadius: BorderRadius.circular(32.0)),
                            border: const OutlineInputBorder(),
                            hintText: 'Remark'),
                        onChanged: (value) {
                          debugPrint('Something changed in Title Text Field');
                          // updateActivity();
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        color: ColorConstant.colorPrimary,
                        child: MaterialButton(
                          onPressed: () {
                            _saveToList(controllerDailyAct.text, pr);
                            setState(() {});
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
