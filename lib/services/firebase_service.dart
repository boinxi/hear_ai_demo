import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadMedia(File media, {void Function(TaskSnapshot)? onProgress}) async {
  String id = Uuid().v4();
  Reference storageReference = FirebaseStorage.instance.ref().child('uploads/$id.png');
  UploadTask uploadTask = storageReference.putFile(media);

  if (onProgress != null) uploadTask.snapshotEvents.listen(onProgress);

  await uploadTask;
  return await storageReference.getDownloadURL();
}
