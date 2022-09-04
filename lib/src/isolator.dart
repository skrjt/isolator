import 'dart:async';
import 'dart:isolate';
import 'package:async/async.dart';
import 'package:isolator/src/configurators/isolates_configuration.dart';
import 'package:isolator/src/messengers/isolate_messenger.dart';
import 'package:isolator/src/messengers/isolate_messenger_pool.dart';

/// Hides work with isolates.
abstract class Isolator<T, V> {
  /// Configuration for working with isolates.
  final IsolatesConfiguration isolatesConfiguration;
  /// Hides communication with isolates.
  late final IsolateMessengerPool<T, V> _isolateMessengers;

  Isolator({required this.isolatesConfiguration});

  /// Clears the memory.
  Future<void> close() async {
    _isolateMessengers.dispose();
  }

  /// Instantiates the isolate.
  Future<Isolate> spawnIsolate({required SendPort sendPort});

  /// Sends the operation to the isolate.
  ///
  /// [isolateId] - pass so that the operation is performed by a specific isolate.
  /// [onCancel] - the callback that will be executed after the operation is canceled.
  CancelableOperation<V> send(T operation, {int? isolateId, FutureOr Function()? onCancel}) {
    return CancelableOperation.fromFuture(
      _isolateMessengers.send(operation, isolateId: isolateId),
      onCancel: onCancel,
    );
  }

  /// Launches isolates.
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