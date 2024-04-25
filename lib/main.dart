import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:test_tensor/photo_analyze.dart';
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
  String resultText = '写真を判断してください';
  List<AssetEntity> photos = [];

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
                  final PhotoAnalysisService service = PhotoAnalysisService(db);
                  try {
                    photos = await service.fetchAllPhotos();
                    setState(() {
                      // 写真のリストが更新されたことをUIに反映
                    });
                  } catch (e) {
                    print('写真のロード中にエラーが発生しました: $e');
                  }
                },
                child: Text('写真をロード'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final PhotoAnalysisService service = PhotoAnalysisService(db);

                  try {
                    bool foundFood =
                        await service.requestPermissionAndAnalyzePhotos();
                    // SnackBarを表示するコードを削除しました
                  } catch (e) {
                    print('写真分析中にエラーが発生しました: $e');
                  }
                },
                child: Text('写真を分析して保存'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final List<Photo> photos = await db.getAllPhotos();
                  for (var photo in photos) {
                    print(photo.path);
                  }
                },
                child: Text('DBのパスを表示'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    AssetEntity photo = photos[index];
                    return FutureBuilder<File?>(
                      future: photo.file,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.file(snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  },
                ),
              ),
              Text(resultText),
            ],
          ),
        ),
      ),
    );
  }
}
