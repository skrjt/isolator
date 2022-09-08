part of '../../isolator.dart';

/// Type of static operation handler.
typedef StaticOperationHandler<T, V> = FutureOr<V> Function(T command);

/// A controller that allows to work with static class in isolate.
class StaticIsolateController<T, V> extends StaticIsolator<T, V> {
  StaticIsolateController._({
    required Map<T, StaticOperationHandler<T, V>> operations,
  }): super(operations: operations);
}

/// Factory of [StaticIsolateController].
abstract class StaticIsolateControllerFactory<T, V> {
  /// Creates instance of [StaticIsolateController].
  static Future<StaticIsolateController> create<T, V>({
    required Map<T, StaticOperationHandler<T, V>> operations,
  }) async {
    final instance = StaticIsolateController._(
      operations: operations,
    );
    await instance.startIsolates();
    return instance;
  }
}
