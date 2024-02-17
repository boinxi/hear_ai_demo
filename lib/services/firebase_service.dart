import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:uuid/uuid.dart';

class FirebaseService implements StorageBucket {
  @override
  Future<String> uploadMedia(File media, {void Function(double)? onProgress}) async {
    String id = const Uuid().v4();
    Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$id.png');
    UploadTask uploadTask = storageReference.putFile(media);

    if (onProgress != null) uploadTask.snapshotEvents.listen((TaskSnapshot task) => onProgress(task.bytesTransferred / task.totalBytes));

    await uploadTask;
    return await storageReference.getDownloadURL();
  }
}
