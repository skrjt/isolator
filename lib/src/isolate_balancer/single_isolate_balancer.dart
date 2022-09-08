import 'package:isolator/src/messengers/isolate_messenger.dart';
import 'isolates_balancer.dart';

/// A load balancer that always returns the first isolate.
class SingleIsolateBalancer extends IsolatesBalancer {
  int _getFirstIsolateIndex() => 0;

  @override
  IsolateMessenger getIsolate({required List<IsolateMessenger> isolateMessengers}) =>
      isolateMessengers[_getFirstIsolateIndex()];
}
