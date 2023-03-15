import 'dart:ffi';

import 'package:ffi/ffi.dart';

class A implements Allocator {
  late Allocator a;
  A([Allocator? allocator]) : a = allocator ?? calloc;

  @override
  Pointer<Uint8> allocate<Uint8 extends NativeType>(int byteCount, {int? alignment}) {
    dynamic result =
    a.allocate<Uint8>(byteCount, alignment: alignment);
    return result;
  }

  @override
  void free(Pointer<NativeType> pointer) {
    a.free(pointer);
  }
}