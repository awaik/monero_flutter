import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'entities/error_info.dart';
import 'monero_flutter_bindings_generated.dart';

export 'account_api.dart';
export 'multisig_api.dart';
export 'transaction_api.dart';

const String _libName = 'monero_flutter';

/// The dynamic library in which the symbols for [MoneroAppBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final MoneroApiBindings bindings = MoneroApiBindings(_dylib);

Pointer<ErrorBox> buildErrorBoxPointer() {
  Pointer<ErrorBox> pointerToErrorBox = calloc.call();

  pointerToErrorBox.ref.code = 0;
  pointerToErrorBox.ref.message = nullptr;

  return pointerToErrorBox;
}

ErrorInfo extractErrorInfo(Pointer<ErrorBox> errorBoxPointer) {
  final code = errorBoxPointer.ref.code;
  String? message;

  if (0 != code) {
    message = errorBoxPointer.ref.message.cast<Utf8>().toDartString();
  }

  if (nullptr != errorBoxPointer.ref.message) {
    calloc.free(errorBoxPointer.ref.message);
  }

  calloc.free(errorBoxPointer);

  return ErrorInfo(code: code, message: message);
}

String? extractString(Pointer<Char> charPointer) {
  if (nullptr == charPointer) {
    return null;
  }

  String value = charPointer.cast<Utf8>().toDartString();
  calloc.free(charPointer);
  return value;
}
