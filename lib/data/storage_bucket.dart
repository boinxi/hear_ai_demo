import 'dart:io';

abstract class StorageBucket {
  Future<String> uploadMedia(File media, {void Function(double)? onProgress});
}