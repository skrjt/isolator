import 'dart:async';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:isolator/src/configurators/isolates_configuration.dart';
import 'package:isolator/src/messengers/isolate_messenger.dart';
import 'package:isolator/src/messengers/isolate_messenger_pool.dart';

abstract class Isolator<T, V> {
  final IsolatesConfiguration isolatesConfiguration;

  late final IsolateMessengerPool<T, V> _isolateMessengers;

  Isolator({required this.isolatesConfiguration});

  Future<void> close() async {
    _isolateMessengers.close();
  }

  Future<Isolate> spawnIsolate({required SendPort sendPort});

  CancelableOperation<V> send(T operation, {int? isolateId, FutureOr Function()? onCancel}) {
    return CancelableOperation.fromFuture(
      _isolateMessengers.send(operation, isolateId: isolateId),
      onCancel: onCancel,
    );
  }

  Future<void> startIsolates() async {
    _isolateMessengers = IsolateMessengerPool(
      buildIsolateMessenger: () => _spawnIsolateMessenger(),
      isolatesConfiguration: isolatesConfiguration,
    );
    await _isolateMessengers.initialize();
  }

  Future<IsolateMessenger> _spawnIsolateMessenger() async {
    final receivePort = ReceivePort();
    final result = IsolateMessenger(
      isolate: await spawnIsolate(sendPort: receivePort.sendPort),
      sendPort: await receivePort.first as SendPort,
    );
    receivePort.close();
    return result;
  }
}