import 'package:isolator/src/messengers/isolate_messenger.dart';

abstract class IsolatesBalancer {
  IsolateMessenger getIsolate({required List<IsolateMessenger> isolateMessengers});
}