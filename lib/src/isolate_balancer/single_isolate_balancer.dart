import 'package:isolator/src/messengers/isolate_messenger.dart';
import 'isolates_balancer.dart';

class SingleIsolateBalancer extends IsolatesBalancer {
  int _getFirstIsolateIndex() => 0;

  @override
  IsolateMessenger getIsolate({required List<IsolateMessenger> isolateMessengers}) {
    return isolateMessengers[_getFirstIsolateIndex()];
  }
}