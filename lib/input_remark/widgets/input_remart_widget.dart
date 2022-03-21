import 'package:flutter/material.dart';
import 'package:inspection/constants/color_constant.dart';
import 'package:inspection/helpers/toast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class InputRemarkWidget extends StatefulWidget {
  InputRemarkWidget({Key? key}) : super(key: key);

  @override
  State<InputRemarkWidget> createState() => _InputRemarkWidgetState();
}

class _InputRemarkWidgetState extends State<InputRemarkWidget> {
  TextEditingController controllerDailyAct = TextEditingController();
  ProgressDialog? pr;
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

  @override
  void initState() {
    pr = ProgressDialog(context);
    pr!.style(message: 'Please wait...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        borderSide: BorderSide(color: Color(0xff048454)),
                        borderRadius: BorderRadius.circular(32.0)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff048454)),
                        borderRadius: BorderRadius.circular(32.0)),
                    border: OutlineInputBorder(),
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
                    _saveToList(controllerDailyAct.text, pr!);
                    setState(() {});
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
