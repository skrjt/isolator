import 'package:isolator/src/isolate_balancer/isolates_balancer.dart';
import 'package:isolator/src/isolate_balancer/single_isolate_balancer.dart';

/// Configuration for working with isolates.
class IsolatesConfiguration {
  /// Number of isolates.
  final int isolatesCount;
  /// Balancer for determining the isolate executing the command.
  late final IsolatesBalancer isolatesBalancer;
  /// Indicator of lazy initialization of isolates.
  final bool lazy;

  IsolatesConfiguration({
    this.lazy = false,
    required this.isolatesCount,
    IsolatesBalancer? isolatesBalancer,
  }): isolatesBalancer = SingleIsolateBalancer();
}
