import 'package:flutter/material.dart';
import 'package:inspection/sejuk/post_ins/widgets/widgets.dart';

class PostInsScreen extends StatefulWidget {
  const PostInsScreen({Key? key}) : super(key: key);

  @override
  State<PostInsScreen> createState() => _PostInsScreenState();
}

class _PostInsScreenState extends State<PostInsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post-Inspection'),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(alignment: Alignment.center, child: Text('Reset')),
              ))
        ],
      ),
      body: Container(
        // height: double.infinity,
        // width: double.infinity,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage('assets/icon/icon.png'),
        //   fit: BoxFit.fitWidth,
        // )),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: PostInsWidget(),
        ),
      ),
    );
  }
}
