import 'dart:async';
import 'dart:isolate';

import 'package:isolator/src/configurators/isolates_configuration.dart';
import 'package:isolator/src/isolator.dart';
import 'package:isolator/src/messages/response/isolator_response_object.dart';
import 'package:isolator/src/messages/isolator_send_object.dart';

/// Type of operation handler.
typedef OperationHandler<T, V> = FutureOr<V> Function(T command);

/// An isolator that allows to work with static class inside an isolate.
abstract class StaticIsolator<T, V> extends Isolator<T, V> {
  final Map<T, OperationHandler<T, V>> operations;

  StaticIsolator({
    required this.operations,
  }) : super(
          isolatesConfiguration: IsolatesConfiguration(
            isolatesCount: 1,
          ),
        );

  @override
  Future<Isolate> spawnIsolate({required SendPort sendPort}) async {
    return Isolate.spawn(
      _entryPoint<T, V>,
      <Object>[
        sendPort,
        operations,
      ],
    );
  }

  static void _entryPoint<T, V>(List<Object> arguments) {
    final mainToIsolateStream = ReceivePort();

    final isolateToMainStream = arguments[0] as SendPort;
    final operations = arguments[1] as Map<T, OperationHandler<T, V>>;

    isolateToMainStream.send(mainToIsolateStream.sendPort);
    _setEventListener<T, V>(
      mainToIsolateStream: mainToIsolateStream,
      operations: operations,
    );
  }

  static void _setEventListener<T, V>({
    required ReceivePort mainToIsolateStream,
    required Map<T, OperationHandler<T, V>> operations,
  }) async {
    await for (final message in mainToIsolateStream) {
      await _messageHandle<T, V>(
        message: message,
        operations: operations,
      );
    }
  }

  static Future<void> _messageHandle<T, V>({
    required dynamic message,
    required Map<T, OperationHandler<T, V>> operations,
  }) async {
    if (message is IsolatorSendObject) {
      final result = await operations[message.sendObject]?.call(message.sendObject);
      message.sendPort.send(IsolatorResponseObject(sendObject: result));
    }
  }
}
