import 'dart:io';

import 'package:drift/drift.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'database.dart';
import 'package:image/image.dart' as img;

class PhotoAnalysisService {
  final AppDatabase db;

  PhotoAnalysisService(this.db);

  Future<void> requestPermissionAndAnalyzePhotos() async {
    var permission = await Permission.photos.request();
    if (permission.isGranted) {
      List<AssetEntity> photos = await _fetchAllPhotos();
      for (var photo in photos) {
        // ここで各写真を非同期に分析
        var isFood = await _analyzePhoto(photo);
        if (isFood) {
          // 分析結果が食べ物であれば、データベースに保存
          await _savePhotoData(photo, isFood);
        }
      }
    } else {
      // アクセス権限が拒否された場合の処理
      print("Photos access was denied.");
    }
  }

  Future<List<AssetEntity>> _fetchAllPhotos() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    List<AssetEntity> photos = [];
    for (var album in albums) {
      // sizeに非常に大きな数値を指定して、実質的に全てのアセットを一度に取得
      List<AssetEntity> albumPhotos =
          await album.getAssetListPaged(page: 0, size: 10000); // 例として10000を指定
      photos.addAll(albumPhotos);
    }
    return photos;
  }

  Future<bool> _analyzePhoto(AssetEntity photo) async {
    // モデルをロード
    final interpreter =
        await Interpreter.fromAsset('assets/gourmet_cnn_vgg_final');
    final file = await photo.file;
    var input = _preprocessImage(file!); // 画像をモデルの入力形式に変換

    // モデルを実行して結果を取得
    var output = List.filled(1, 0); // 出力形式に合わせて調整
    interpreter.run(input, output);

    // 分析結果に基づいてtrueまたはfalseを返す
    return _interpretResult(output); // 結果を解釈して、写真が食べ物かどうかを判断
  }

// 画像を前処理するメソッド
  Future<List> _preprocessImage(File file) async {
    // 画像ファイルを読み込む
    img.Image image = img.decodeImage(file.readAsBytesSync())!;
    // モデルの入力サイズにリサイズ
    img.Image resizedImg = img.copyResize(image, width: 224, height: 224);
    // 画像のピクセル値をリストに変換し、正規化
    var imageBytes = resizedImg.getBytes();
    List<double> input = imageBytes.map((byte) => byte / 255.0).toList();
    return input;
  }

// 分析結果を解釈するメソッド
  bool _interpretResult(List output) {
    // ここでは、出力の最初の要素を確率として使用
    double probability = output[0];
    // 確率が0.5以上であればtrue（食べ物）と判断
    return probability >= 0.5;
  }

  Future<void> _savePhotoData(AssetEntity photo, bool isFood) async {
    final file = await photo.file;
    if (file != null) {
      // 正しくPhotosCompanionをインスタンス化
      final photoModel = PhotosCompanion(
        path: Value(file.path),
        date: Value(DateTime.now()),
        isFood: Value(isFood),
      );
      await db.into(db.photos).insert(photoModel);
    }
  }
}
