import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ExpiryDateCheckerPage extends StatefulWidget {
  const ExpiryDateCheckerPage({Key? key}) : super(key: key);

  @override
  State<ExpiryDateCheckerPage> createState() => _ExpiryDateCheckerState();
}

class _ExpiryDateCheckerState extends State<ExpiryDateCheckerPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  String _detectedText = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
    setState(() {
      _isCameraInitialized = true;
    });

    // Kamera başlatıldığında sürekli metin okumasını başlat
    _startTextRecognition();
  }

  void _startTextRecognition() async {
    // Kameradan sürekli görüntü alarak metinleri algılamak için MobileScanner kullanın
    final scanner = MobileScanner();
    await scanner.scanWindow!;

    // MobileScanner ile sürekli metin algılama işlemini başlat
    scanner.onDetect??(
      onTextRecognized: (text) {
        // Algılanan metinleri kullanarak geri bildirim oluşturun
        setState(() {
          _detectedText = text;
        });
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Date Checker'),
      ),
      body: _isCameraInitialized
          ? Column(
        children: [
          CameraPreview(_controller),
          Text(_detectedText), // Algılanan metni göster
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Kamera kontrolcüsünü kapatın
    super.dispose();
  }
}
