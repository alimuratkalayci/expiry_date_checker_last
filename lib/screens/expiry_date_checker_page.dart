import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ExpiryDateChecker extends StatefulWidget {
  const ExpiryDateChecker({Key? key}) : super(key: key);

  @override
  State<ExpiryDateChecker> createState() => _ExpiryDateCheckerState();
}

class _ExpiryDateCheckerState extends State<ExpiryDateChecker> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
    _initializeControllerFuture = _controller.initialize(); // Kamera kontrolcüsünü başlatma işlemini bir Future içinde gerçekleştirin
    await _initializeControllerFuture; // Kamera başlatma işleminin tamamlanmasını bekleyin
    setState(() {}); // Widget'ı yeniden oluşturmak için setState çağırın
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expiry Date Checker'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Kamera başarıyla başlatıldıysa, Kamera Önizlemesi görüntülenir
            return CameraPreview(_controller);
          } else {
            // Eğer başlatma işlemi hala devam ediyorsa, yükleme göstergesi gösterilir
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
