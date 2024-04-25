import 'package:permission_handler/permission_handler.dart';

enum PhotoPermissionStatus { granted, denied, permanentlyDenied, restricted }

class PhotoPermissionsHandler {
  Future<bool> get isGranted async {
    final status = await Permission.storage.status;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<PhotoPermissionStatus> request() async {
    final status = await Permission.storage.request();
    print("Storage permission status: $status"); // この行を変更
    switch (status) {
      case PermissionStatus.granted:
        return PhotoPermissionStatus.granted;
      case PermissionStatus.denied:
        return PhotoPermissionStatus.denied;
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return PhotoPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return PhotoPermissionStatus.restricted;
      default:
        return PhotoPermissionStatus.denied;
    }
  }
}
