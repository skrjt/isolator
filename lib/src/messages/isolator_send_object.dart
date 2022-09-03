import 'dart:isolate';

class IsolatorSendObject<T> {
  final SendPort sendPort;
  final T sendObject;

  IsolatorSendObject({
    required this.sendPort,
    required this.sendObject,
  });
}
