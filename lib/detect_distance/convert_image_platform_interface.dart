import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'convert_image_method_channel.dart';

abstract class ConvertImagePlatform extends PlatformInterface {
  ConvertImagePlatform() : super(token: _token);

  static final Object _token = Object();

  static ConvertImagePlatform _instance = MethodChannelConvertImage();

  static ConvertImagePlatform get instance => _instance;

  static set instance(ConvertImagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}