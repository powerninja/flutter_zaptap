import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<List<String>> moveImagesFromTmp(List<File> tempImageFiles) async {
    final movedImages = <File>[];
    final uuid = Uuid();
    final fileNames = <String>[];

    // 一時ファイルから画像を移動する
    final moveImageFutures = tempImageFiles.map((tempImageFile) async {
      try {
        if (await tempImageFile.exists()) {
          final noteId = uuid.v7();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final fileName = '${noteId}_$timestamp.png';
          moveImage(tempImageFile, fileName);
          fileNames.add(fileName);
          return fileName;
        } else {
          print('Temp image file does not exist: ${tempImageFile.path}');
          return null;
        }
      } catch (e) {
        print('Error moving image: $e');
        return null;
      }
    });

    final movedImageResults = await Future.wait(moveImageFutures);
    movedImages.addAll(movedImageResults.whereType<File>());
    return fileNames;
  }

  // 画像を移動する
  void moveImage(File sourceFile, String fileName) async {
    try {
      if (await sourceFile.exists()) {
        final localPath = await getLocalPath();
        final destinationPath = '$localPath/$fileName';

        // 移動先にファイルをコピー
        await sourceFile.copy(destinationPath);

        // 元の一時ファイルを削除
        await sourceFile.delete();
      } else {
        print('Source file does not exist: ${sourceFile.path}');
        return null;
      }
    } catch (e) {
      print('Error moving image: $e');
      return null;
    }
  }

  // ローカルパスを取得する
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // ローカルパスを取得する（同期）
  Future<String> getLocalPathSync() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/';
  }
}
