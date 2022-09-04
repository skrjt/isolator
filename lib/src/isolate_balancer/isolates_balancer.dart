import 'package:isolator/src/messengers/isolate_messenger.dart';

/// Provides an interface for obtaining an isolate.
abstract class IsolatesBalancer {
  /// Returns the isolate that the operation will be performed with.
  IsolateMessenger getIsolate({required List<IsolateMessenger> isolateMessengers});
}