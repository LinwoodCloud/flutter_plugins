// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Future<void> exportFile(
  BuildContext context,
  List<int> bytes,
  String fileName,
  String fileExtension,
  String mimeType,
  String uniformTypeIdentifier,
  String label,
) async {
  final a = document.createElement('a') as AnchorElement;
  // Create data URL
  final blob = Blob([Uint8List.fromList(bytes)], mimeType);
  final url = Url.createObjectUrlFromBlob(blob);
  a.href = url;
  a.download = '$fileName.$fileExtension';
  a.click();
  Url.revokeObjectUrl(url);
}
