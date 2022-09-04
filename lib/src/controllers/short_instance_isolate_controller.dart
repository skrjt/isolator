part of '../../isolator.dart';

/// Type of short operation handler.
typedef ShortOperationHandler<K, T> = FutureOr<dynamic> Function(K instance, T command);

/// A controller that allows to work with an instance of a class in isolate,
///
/// which provides a simpler API with a dynamic return type.
class ShortInstanceIsolateController<K, T> extends InstanceIsolator<K, T, dynamic> {
  ShortInstanceIsolateController._({
    required K Function() instanceBuilder,
    required Map<T, ShortOperationHandler<K, T>> operations,
  }) : super(
          instanceBuilder: instanceBuilder,
          operations: operations,
        );

  /// Typed sending of operations to isolate.
  CancelableOperation<V> typedSend<V>(T operation) => send(operation) as CancelableOperation<V>;
}

/// Factory of [ShortInstanceIsolateController].
abstract class ShortInstanceIsolateControllerFactory<K, T> {
  /// Creates instance of [ShortInstanceIsolateController].
  static Future<ShortInstanceIsolateController> create<K, T>({
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
