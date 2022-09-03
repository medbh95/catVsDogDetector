import 'dart:io';

import 'package:cat_dog/rounded_corner_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = true;
  File? _image;
  List _output = [];
  final picker = ImagePicker();
  detectImage(File img) async {
    var output = await Tflite.runModelOnImage(
        path: img.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.6);

    setState(() {
      _output = output!;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  pickImageGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image!);
  }

  pickImageCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Cat Vs Dog'), backgroundColor: Colors.blueGrey),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select a photo ',
              style: TextStyle(fontSize: 22, color: Colors.blueGrey),
            ),
            SizedBox(
              height: 20,
            ),
            _image != null
                ? SizedBox(
                    width: 250,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.fill,
                        )))
                : SizedBox(
                    height: 250,
                  ),
            SizedBox(
              height: 20,
            ),
            !_output.isEmpty
                ? Text(
                    "${_output[0]['label']}",
                    style: TextStyle(fontSize: 30, color: Colors.blueGrey),
                  )
                : Text(""),
            SizedBox(
              height: 20,
            ),
            RoundedCornersButton(
                child: Text("Import from Camera"),
                fillColor: Colors.blueGrey,
                borderColor: Colors.blueGrey,
                height: 50,
                width: 200,
                borderRadius: 20,
                onpressed: () {
                  pickImageCamera();
                },
                textColor: Colors.white),
            RoundedCornersButton(
                child: Text("Import from Gallery"),
                fillColor: Colors.transparent,
                borderColor: Colors.blueGrey,
                height: 50,
                width: 200,
                borderRadius: 20,
                onpressed: () {
                  pickImageGallery();
                },
                textColor: Colors.blueGrey)
          ],
        ),
      ),
    );
  }
}
