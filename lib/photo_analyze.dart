import 'dart:io';

import 'package:drift/drift.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:test_tensor/handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'database.dart';
import 'package:image/image.dart' as img;

class PhotoAnalysisService {
  final AppDatabase db;

  PhotoAnalysisService(this.db);

  Future<bool> requestPermissionAndAnalyzePhotos() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      List<AssetEntity> photos = await _fetchAllPhotos();
      bool foundFood = false; // 食べ物の写真が見つかったかどうかを追跡するフラグ
      for (var photo in photos) {
        // ここで各写真を非同期に分析
        var isFood = await _analyzePhoto(photo);
        if (isFood) {
          // 分析結果が食べ物であれば、データベースに保存
          await _savePhotoData(photo, isFood);
          foundFood = true; // 少なくとも1枚は食べ物の写真が見つかった
        }
      }
      return foundFood; // 食べ物の写真が1枚でも見つかったかどうかを返す
    } else {
      // アクセス権限が拒否された場合の処理
      print("Photos access was denied.");
      return false; // 権限が拒否されたため、分析を行えなかった
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
    tfl.Interpreter interpreter;
    File? file;
    List input;

    // モデルをロード
    try {
      interpreter = await tfl.Interpreter.fromAsset(
          'lib/assets/gourmet_cnn_vgg_final.tflite');
    } catch (e) {
      print('モデルの読み込みに失敗しました: $e');
      return false; // モデルの読み込みに失敗した場合は、分析を中断
    }

    // テンソルのメモリを割り当てる
    interpreter.allocateTensors();

    // 画像ファイルを読み込む
    try {
      file = await photo.file;
      if (file == null) throw Exception('ファイルがnullです。');
      input = await _preprocessImage(file); // 画像をモデルの入力形式に変換
    } catch (e) {
      print('画像の読み込みまたは前処理に失敗しました: $e');
      return false; // 画像の読み込みまたは前処理に失敗した場合は、分析を中断
    }

    // モデルを実行して結果を取得
    var output = List.generate(1, (i) => List.filled(5, 0.0, growable: false),
        growable: false);
    interpreter.run(input, output);

    // 分析結果に基づいてtrueまたはfalseを返す
    return _interpretResult(output); // 結果を解釈して、写真が食べ物かどうかを判断
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File file) async {
    img.Image image = img.decodeImage(file.readAsBytesSync())!;
    img.Image resizedImg = img.copyResize(image, width: 224, height: 224);
    var imageBytes = resizedImg.getBytes();
    List<double> input = imageBytes.map((byte) => byte / 255.0).toList();

    // 画像データを[1, 高さ, 幅, チャンネル数]の形状に変更
    // ここでは、224x224の画像で3チャンネル（RGB）を想定しています。
    List<List<List<List<double>>>> inputAsTensor = [
      List.generate(
          224,
          (y) => List.generate(224,
              (x) => List.generate(3, (c) => input[y * 224 * 3 + x * 3 + c])))
    ];
    return inputAsTensor;
  }

// 分析結果を解釈するメソッド
  bool _interpretResult(List output) {
    // outputがList<List<double>>型であることを前提として、
    // 最初のリストの最初の要素を確率として取得
    double probability = output[0][0];
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

      print('写真がデータベースに保存されました: ${file.path}');
    }
  }

  Future<List<AssetEntity>> fetchAllPhotos() async {
    final PhotoPermissionsHandler permissionsHandler =
        PhotoPermissionsHandler();
    final permissionStatus = await permissionsHandler.request();
    print("Requesting photo permissions..."); // 権限リクエスト前にログを出力

    if (permissionStatus == PhotoPermissionStatus.granted) {
      print("Permission granted. Fetching photos..."); // 権限が許可された場合のログ
      // 写真取得の処理...
    } else {
      print("Permission denied. Cannot fetch photos."); // 権限が拒否された場合のログ
    }

    if (permissionStatus == PhotoPermissionStatus.granted) {
      // アクセス権限が許可された場合、写真を含むアルバムを取得
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
      List<AssetEntity> photos = [];
      for (var album in albums) {
        // アルバムから写真を取得
        List<AssetEntity> albumPhotos =
            await album.getAssetListPaged(page: 0, size: 10000); // 例として10000を指定
        photos.addAll(albumPhotos);
      }
      return photos;
    } else {
      print("Error: Photo access permission was denied.");
      return [];
    }
  }
}
