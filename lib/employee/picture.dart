import 'package:certify/employee/certificate_details.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'dart:core';

List<CameraDescription> cameras = List.empty(growable: true);

class picture extends StatefulWidget {
  const picture({Key? key}) : super(key: key);

  @override
  _pictureState createState()
  {
    WidgetsFlutterBinding.ensureInitialized();
    return _pictureState();
  }
}

class _pictureState extends State<picture> {

  late CameraController _controller;
  bool initialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeCamera();
  }

  _initializeCamera() async {
    await availableCameras().then((value) {
      cameras = value;
      print("Values are: " + value.toString());
    });

    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((value) {
      setState(() {
        initialized = true;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialized ? Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CameraPreview(_controller),),
        ],
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Take Picture", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            final image = await _controller.takePicture();
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) => certificate_details(image: image)));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        backgroundColor: Color.fromRGBO(46, 49, 146, 1),
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ) : Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}
