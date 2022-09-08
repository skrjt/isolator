part of '../../isolator.dart';

/// A controller that allows to work with an instance of a class in isolate.
class InstanceIsolateController<K, T, V> extends InstanceIsolator<K, T, V> {
  InstanceIsolateController._({
    required K Function() instanceBuilder,
    required Map<T, InstanceOperationHandler<K, T, V>> operations,
    IsolatesConfiguration? isolatesConfiguration,
  }) : super(
    isolatesConfiguration: isolatesConfiguration,
    instanceBuilder: instanceBuilder,
    operations: operations,
  );
}

/// Factory of [InstanceIsolateController].
abstract class InstanceIsolateControllerFactory<K, T, V> {
  /// Creates instance of [InstanceIsolateController].
  static Future<InstanceIsolateController> create<K, T, V>({
    required K Function() instanceBuilder,
    required Map<T, InstanceOperationHandler<K, T, V>> operations,
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
