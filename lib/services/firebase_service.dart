import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:uuid/uuid.dart';

class FirebaseService implements StorageBucket {
  @override
  Future<String> uploadMedia(File media, {void Function(double)? onProgress}) async {
    String fileName = const Uuid().v4();
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName.png');
    UploadTask uploadTask = storageReference.putFile(media);

    if (onProgress != null) uploadTask.snapshotEvents.listen((TaskSnapshot task) => onProgress(task.bytesTransferred / task.totalBytes));

    await uploadTask;
    return fileName;
  }

  @override
  Future<void> deleteMedia(String id) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$id.png');
    await storageReference.delete();
    print('File deleted successfully');
  }

  @override
  Future<String> getPublicUrl(String fileName) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$fileName.png');
    return await storageReference.getDownloadURL();
  }
}
