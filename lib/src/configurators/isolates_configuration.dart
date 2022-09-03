import 'package:isolator/src/isolate_balancer/isolates_balancer.dart';
import 'package:isolator/src/isolate_balancer/single_isolate_balancer.dart';

class IsolatesConfiguration {
  final int isolatesCount;
  late final IsolatesBalancer isolatesBalancer;
  final bool lazy;

  IsolatesConfiguration({
    this.lazy = false,
    required this.isolatesCount,
    IsolatesBalancer? isolatesBalancer,
  }): isolatesBalancer = SingleIsolateBalancer();
}
