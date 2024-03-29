import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_info_app/screens/main_screen.dart';
import 'package:food_info_app/screens/ocrresult_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRScanScreen extends StatefulWidget {
  const OCRScanScreen({super.key});

  @override
  State<OCRScanScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScanScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;

  late final Future<void> _future;
  CameraController? _cameraController;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    // return Center(child: CameraPreview(_cameraController!));

                    return Center(
                      child: Container(
                        width: 350, // Set the desired width of the bounding box
                        height:
                            500, // Set the desired height of the bounding box
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        child: CameraPreview(_cameraController!),
                      ),
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('OCR Scan'),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Center(
                            // child: ElevatedButton(
                            //   onPressed: _scanImage,
                            //   child: const Text('Scan text'),
                            // ),
                            child: FloatingActionButton.extended(
                                onPressed: _scanImage,
                                label: const Row(
                                  children: [
                                    SizedBox(width: 6),
                                    Text(
                                      "Scan Text",
                                      style: TextStyle(fontSize: 16),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'Camera permission denied',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      String recognizedTextString = recognizedText.text;
      String ingredients = '';
      String allAdditives = '';

      // String firstBlockText = '';
      // if (recognizedText.blocks.isNotEmpty) {
      //   TextBlock firstBlock = recognizedText.blocks[1];

      //   for (TextLine line in firstBlock.lines) {
      //     for (TextElement element in line.elements) {
      //       firstBlockText += element.text + '';
      //     }
      //     firstBlockText += '\n';
      //   }

      //   print("First block text: $firstBlockText");
      // } else {
      //   print("No text blocks found.");
      // }

      int ingredientsStart =
          recognizedTextString.toLowerCase().indexOf('ingredients:');
      int ingredientsEnd = recognizedTextString.indexOf('.', ingredientsStart);
      if (ingredientsStart >= 0 && ingredientsEnd >= 0) {
        ingredients = recognizedTextString
            .substring(ingredientsStart + 'ingredients:'.length, ingredientsEnd)
            .trim();
        print(ingredients);

        // Extract additives
        RegExp exp = RegExp(
            r'\b\d{3,4}\b'); // regular expression to match any three to four-digit number
        Iterable<Match> matches = exp.allMatches(ingredients);
        List<String> additives = [];
        for (Match m in matches) {
          String? additive = m.group(0);
          if (!additives.contains('E$additive')) {
            additives
                .add('E$additive'); // 'E' is added before each additive number
          }
        }
        allAdditives = additives.join(',');
        print('Additives found: $allAdditives');
      } else {
        print('No Additives found');
        allAdditives = 'No Additives found';
      }

      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              // MainScreen(text: recognizedTextString),
              MainScreen(text: allAdditives),
          // MainScreen(text: firstBlockText),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred when scanning text: $e'),
        ),
      );
    }
  }
}
