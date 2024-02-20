import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FirebaseService implements StorageBucket {
  @override
  Future<String> uploadMedia(File media, {void Function(double)? onProgress, void Function(String? err)? onError}) async {
    String fileName = const Uuid().v4();
    String fileExtension = path.extension(media.path).toLowerCase();
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName$fileExtension');
    UploadTask uploadTask = storageReference.putFile(media);

    uploadTask.snapshotEvents.listen(
      (TaskSnapshot task) {
        var d = task.bytesTransferred / task.totalBytes;
        onProgress?.call(d);
      },
      onError: (Object e) => onError?.call(e.toString()),
    );

    await uploadTask;
    return fileName + fileExtension;
  }

  @override
  Future<void> deleteMedia(String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    await storageReference.delete();
  }

  @override
  Future<String> getPublicUrl(String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName');
    return await storageReference.getDownloadURL();
  }
}
