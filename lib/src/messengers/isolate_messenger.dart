import 'dart:isolate';

/// Provides access to communication with the isolate.
class IsolateMessenger {
  final Isolate isolate;
  final SendPort sendPort;

  late final Finalizer<Isolate> _isolateFinalizer;

  IsolateMessenger({
    required this.isolate,
    required this.sendPort,
  }) {
    _isolateFinalizer = Finalizer<Isolate>((isolate) {
      isolate.kill();
    });
    _isolateFinalizer.attach(this, isolate, detach: this);
  }

  /// Disposes of instance.
  void dispose() {
    _isolateFinalizer.detach(this);
  }
}
