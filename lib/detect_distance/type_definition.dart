import 'dart:ffi';

typedef convert_func = Pointer<Int> Function(
    Pointer<Uint8>, Pointer<Uint8>, Int32, Int32,
    Int32, Int32, Int32, Int32
    );

typedef Convert = Pointer<Int> Function(
    Pointer<Uint8>, Pointer<Uint8>, int, int,
    int, int?, int, int
    );