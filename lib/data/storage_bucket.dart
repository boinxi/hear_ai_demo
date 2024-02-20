import 'dart:io';

abstract class StorageBucket {
  Future<String> uploadMedia(File media, {void Function(double)? onProgress, void Function(String? err)? onError});
  Future<void> deleteMedia(String id);
  Future<String> getPublicUrl(String fileName);
}