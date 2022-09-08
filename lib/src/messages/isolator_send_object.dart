import 'dart:isolate';

/// Container with an object that is sent to the isolate.
class IsolatorSendObject<T> {
  final SendPort sendPort;
  final T sendObject;

  IsolatorSendObject({
    required this.sendPort,
    required this.sendObject,
  });
}
