part of '../../isolator.dart';

typedef ShortOperationHandler<K, T> = FutureOr<dynamic> Function(K instance, T command);

class ShortInstanceIsolateController<K, T> extends InstanceIsolator<K, T, dynamic> {
  ShortInstanceIsolateController._({
    required K Function() instanceBuilder,
    required Map<T, ShortOperationHandler<K, T>> operations,
  }) : super(
          instanceBuilder: instanceBuilder,
          operations: operations,
        );

  CancelableOperation typedSend<V>(T operation) => send(operation) as CancelableOperation<V>;
}

abstract class ShortInstanceIsolateControllerFactory<K, T> {
  static Future<ShortInstanceIsolateController> build<K, T>({
    required K Function() instanceBuilder,
    required Map<T, ShortOperationHandler<K, T>> operations,
  }) async {
    final instance = ShortInstanceIsolateController._(
      operations: operations,
      instanceBuilder: instanceBuilder,
    );
    await instance.startIsolates();
    return instance;
  }
}
