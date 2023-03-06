import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'convert_image_platform_interface.dart';

class MethodChannelConvertImage extends ConvertImagePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('convertImage');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}