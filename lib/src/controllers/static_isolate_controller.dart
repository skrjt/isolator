part of '../../isolator.dart';

typedef StaticOperationHandler<T, V> = FutureOr<V> Function(T command);

class StaticIsolateController<T, V> extends StaticIsolator<T, V> {
  StaticIsolateController._({
    required Map<T, StaticOperationHandler<T, V>> operations,
  }): super(operations: operations);
}

abstract class StaticIsolateControllerFactory<T, V> {
  static Future<StaticIsolateController> build<T, V>({
    required Map<T, StaticOperationHandler<T, T>> operations,
  }) async {
    final instance = StaticIsolateController._(
      operations: operations,
    );
    await instance.startIsolates();
    return instance;
  }
}
