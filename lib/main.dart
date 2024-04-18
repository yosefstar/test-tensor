import 'package:flutter/material.dart';
import 'photo_service.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppDatabase db = AppDatabase();
  final PhotoService photoService = PhotoService();
  String resultText = '写真を判断してください';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('写真判断アプリ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool result = await photoService.analyzeAndSavePhotos();
                  setState(() {
                    resultText = result ? '写真は食べ物です' : '写真は食べ物ではありません';
                  });
                },
                child: Text('写真を判断'),
              ),
              SizedBox(height: 20),
              Text(resultText),
            ],
          ),
        ),
      ),
    );
  }
}
