import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'screen.dart';

List<CameraDescription>? cameras;

class aslto extends StatefulWidget {
  const aslto({Key? key}) : super(key: key);

  @override
  State<aslto> createState() => _asltoState();
}

class _asltoState extends State<aslto> {
  bool _interpreterBusy = false;
  String answer = "";
  CameraController? cameraController;
  CameraImage? cameraImage;

  Future<bool> _requestCameraPermission() async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _initializeCamera() async {
    final hasCameraPermission = await _requestCameraPermission();
    if (!hasCameraPermission) {
      return;
    }

    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      // perform an explicit null check
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('No camera available'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
  }

  Future<void> loadmodel() async {
    try {
      setState(() {
        _interpreterBusy = true; // set interpreter as busy
      });
      await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
        useGpuDelegate: false,
        // if you want to run using GPU delegate, set it to true
      );
      print("Model loaded successfully!");
    } catch (e) {
      print("Error loading model: $e");
    } finally {
      setState(() {
        _interpreterBusy = false; // set interpreter as not busy
      });
    }
  }

  Future<void> initCamera() async {
    await _initializeCamera();
    if (cameras == null || cameras!.isEmpty) {
      return;
    }

    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    if (cameraController != null) {
      await cameraController!.initialize();
      if (!mounted) {
        return;
      }
      setState(() {
        print('Camera Controller Initialized');
        cameraController!.startImageStream(
          (image) {
            if (mounted) {
              print('Image Stream Received');
              cameraImage = image;
              applymodelonimages();
            }
          },
        );
      });
    }
  }

  Future<void> applymodelonimages() async {
    if (cameraImage != null && !_interpreterBusy) {
      print('Model is applying on camera image...');
      setState(() {
        _interpreterBusy = true;
      });
      print('Image shape: ${cameraImage!.width} x ${cameraImage!.height}');
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map(
          (plane) {
            return plane.bytes;
          },
        ).toList(),
        imageHeight: 1 * cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      if (predictions != null && predictions.isNotEmpty) {
        answer = '';
        predictions.forEach((prediction) {
          answer +=
              prediction['label'].toString().substring(0, 1).toUpperCase() +
                  prediction['label'].toString().substring(1) +
                  " " +
                  (prediction['confidence'] as double).toStringAsFixed(2) +
                  '\n';
          print('Prediction: $prediction');
        });

        if (mounted) {
          setState(() {
            answer = answer;
          });
        }
        print('Answer: $answer');
      }

      if (mounted) {
        setState(() {
          _interpreterBusy = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadmodel();
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    if (cameraController != null) {
      cameraController!.stopImageStream();
      await cameraController!
          .dispose(); // dispose of the camera controller properly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: const Text('ASL to Text'),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: (cameraController?.value.isInitialized ?? false)
                  ? AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    )
                  : Container(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              answer,
              style: const TextStyle(
                height: 1.5,
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
