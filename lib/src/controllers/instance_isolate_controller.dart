part of '../../isolator.dart';

typedef OperationHandler<K, T, V> = FutureOr<V> Function(K instance, T command);

class InstanceIsolateController<K, T, V> extends InstanceIsolator<K, T, V> {
  InstanceIsolateController._({
    required K Function() instanceBuilder,
    required Map<T, OperationHandler<K, T, V>> operations,
    IsolatesConfiguration? isolatesConfiguration,
  }) : super(
    isolatesConfiguration: isolatesConfiguration,
    instanceBuilder: instanceBuilder,
    operations: operations,
  );
}

abstract class InstanceIsolateControllerFactory<K, T, V> {
  static Future<InstanceIsolateController> build<K, T, V>({
    required K Function() instanceBuilder,
    required Map<T, OperationHandler<K, T, V>> operations,
    IsolatesConfiguration? isolatesConfiguration,
  }) async {
    final instance = InstanceIsolateController._(
      operations: operations,
      instanceBuilder: instanceBuilder,
      isolatesConfiguration: isolatesConfiguration,
    );
    await instance.startIsolates();
    return instance;
  }
}
