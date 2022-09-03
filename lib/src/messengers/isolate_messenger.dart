import 'dart:isolate';

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

  void close() {
    _isolateFinalizer.detach(this);
  }
}
