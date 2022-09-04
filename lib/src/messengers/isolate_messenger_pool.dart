import 'dart:isolate';

import 'package:isolator/src/configurators/isolates_configuration.dart';
import 'package:isolator/src/messages/response/isolator_error_response.dart';
import 'package:isolator/src/messages/response/isolator_response_message.dart';
import 'package:isolator/src/messages/response/isolator_response_object.dart';
import 'package:isolator/src/messages/isolator_send_object.dart';
import 'package:isolator/src/messengers/isolate_messenger.dart';

/// Hides communication with isolates.
class IsolateMessengerPool<T, V> {
  /// Configuration for working with isolates.
  final IsolatesConfiguration isolatesConfiguration;

  final Future<IsolateMessenger> Function() buildIsolateMessenger;

  late final List<IsolateMessenger> _isolateMessengers;

  IsolateMessengerPool({required this.buildIsolateMessenger, required this.isolatesConfiguration});

  Future<void> initialize() async => _isolateMessengers = await _initIsolateMessengers(
    isolatesCount: isolatesConfiguration.isolatesCount,
    lazy: isolatesConfiguration.lazy,
  );

  Future<List<IsolateMessenger>> _initIsolateMessengers({required int isolatesCount, bool lazy = false}) async {
    if (lazy) return [];

    return [for (var i = 0; i < isolatesCount; i++) await buildIsolateMessenger()];
  }

  /// Sends the operation to the isolate.
  ///
  /// [isolateId] - pass so that the operation is performed by a specific isolate.
  Future<V> send(T operation, {int? isolateId}) async {
    ReceivePort rp = ReceivePort();
    if (_isolateMessengers.isEmpty && isolatesConfiguration.lazy) {
      _isolateMessengers.addAll([
        for (var i = 0; i < isolatesConfiguration.isolatesCount; i++) await buildIsolateMessenger(),
      ]);
    }
    final executableIsolate = isolateId != null
        ? _isolateMessengers[isolateId]
        : isolatesConfiguration.isolatesBalancer.getIsolate(isolateMessengers: _isolateMessengers);
    executableIsolate.sendPort.send(
      IsolatorSendObject<T>(
        sendPort: rp.sendPort,
        sendObject: operation,
      ),
    );
    final resultMessage = await rp.first as IsolatorResponseMessage;
    rp.close();

    if (resultMessage is IsolatorErrorResponse) throw resultMessage.error;
    return (resultMessage as IsolatorResponseObject<V>).sendObject;
  }

  /// Disposes of instance.
  void dispose() {
    for (final isolateMessenger in _isolateMessengers) {
      isolateMessenger.isolate.kill();
    }
  }
}
