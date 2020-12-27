import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite/tflite.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File _image;
  String _classification;
  bool _isLoading;
  List<dynamic> _output;
  

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.camera, imageQuality: 50
    );

    runModelOnImage(image);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    runModelOnImage(image);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
      );
  }


  loadModel() async{
    await Tflite.loadModel(
      model: "assets/tflite/model.tflite",
      // labels: "assets/tflite/labels.txt",
    );
  }

  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value){
      setState(){
        _isLoading = false;
      }
    });
  }

  runModelOnImage(File image) async {
    print('test 1');
    var output = await Tflite.runModelOnImage(
      path: image.path
    );
    setState(() {
        _isLoading = false;
        _image = image;
        _output = output;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Foodini',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
              ),

              // Text(
              //   'Tap to select an image',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: 10,
              //   ),
              // ),


            ],
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.4, 0.9],
              colors: [Colors.yellow, Colors.red, Colors.indigo]
              // colors: [Colors.red, Colors.indigo, Colors.teal]
            ),
          ),
        ),
      ),
      backgroundColor: Colors.red,
    );
  }
}