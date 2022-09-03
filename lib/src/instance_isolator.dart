import 'dart:async';
import 'dart:isolate';
import 'package:isolator/src/configurators/isolates_configuration.dart';
import 'package:isolator/src/isolator.dart';
import 'package:isolator/src/messages/isolator_error_response.dart';
import 'package:isolator/src/messages/isolator_response_object.dart';
import 'package:isolator/src/messages/isolator_send_object.dart';

typedef InstanceOperationHandler<K, T, V> = FutureOr<V> Function(K instance, T command);

abstract class InstanceIsolator<K, T, V> extends Isolator<T, V> {
  late final K Function() _instanceBuilder;

  final Map<T, InstanceOperationHandler<K, T, V>> operations;

  InstanceIsolator({
    IsolatesConfiguration? isolatesConfiguration,
    required this.operations,
    required K Function() instanceBuilder,
  }) : super(
    isolatesConfiguration: IsolatesConfiguration(
      isolatesCount: 1,
    ),
  ) {
    _instanceBuilder = instanceBuilder;
  }

  @override
  Future<Isolate> spawnIsolate({required SendPort sendPort}) async {
    return Isolate.spawn(
      _entryPoint<K, T, V>,
      <Object>[
        sendPort,
        operations,
        _instanceBuilder,
      ],
    );
  }

  static void _entryPoint<K, T, V>(List<Object> arguments) {
    final mainToIsolateStream = ReceivePort();

    final isolateToMainStream = arguments[0] as SendPort;
    final operations = arguments[1] as Map<T, InstanceOperationHandler<K, T, V>>;
    final instanceBuilder = arguments[2] as K Function();

    isolateToMainStream.send(mainToIsolateStream.sendPort);
    final instance = instanceBuilder();
    _setEventListener<K, T, V>(
      mainToIsolateStream: mainToIsolateStream,
      operations: operations,
      instance: instance,
    );
  }

  static void _setEventListener<K, T, V>({
    required ReceivePort mainToIsolateStream,
    required Map<T, InstanceOperationHandler<K, T, V>> operations,
    required K instance,
  }) async {
    await for (final message in mainToIsolateStream) {
      _messageHandle<K, T, V>(
        instance: instance,
        message: message,
        operations: operations,
      );
    }
  }

  static Future<void> _messageHandle<K, T, V>({
    required dynamic message,
    required Map<T, InstanceOperationHandler<K, T, V>> operations,
    required K instance,
  }) async {
    if (message is IsolatorSendObject) {
      try {
        final result = await operations[message.sendObject]?.call(instance, message.sendObject);
        message.sendPort.send(IsolatorResponseObject(sendObject: result));
      } catch (e) {
        message.sendPort.send(IsolatorErrorResponse(error: e));
      }
    }
  }
}
