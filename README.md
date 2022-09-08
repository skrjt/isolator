## Isolator

Provides a simplified API for working with isolates.
:negative_squared_cross_mark: :negative_squared_cross_mark: :negative_squared_cross_mark: not ready for use in production

## Using

:negative_squared_cross_mark: not published. 
Local connection only (see example pubspec.yaml).

## Usage

```dart
// Simple counter class.
class Counter {
  int _count = 0;

  int getCount() => _count;
  void inc() => _count++;
}

// Simple abstract class to find the sum of two numbers.
abstract class StaticSummator {
  static int sum(int a, int b) => a + b;
}

// A common class for all events.
abstract class CounterEvent {}
class CounterInc extends CounterEvent {}
class CounterGetCount extends CounterEvent {}

void main() async {
  // Asynchronous initialization due to the creation of an isolate.
  final instanceIsolateController = await InstanceIsolateControllerFactory.build<Counter, CounterEvent, dynamic>(
    instanceBuilder: () => Counter(), // the instance that will be assembled in the isolate.
    isolatesConfiguration: IsolatesConfiguration( // configuration for using multiple isolates.
      isolatesCount: 1, // number of parallel isolates.
      isolatesBalancer: SingleIsolateBalancer(), // balances all calls to the first isolate (used by default).
      lazy: false, // lazy initialization of isolates.
    ),
    operations: {
      CounterInc: (instance, command) => instance.inc(),
      CounterGetCount: (instance, command) => instance.getCount(),
    },
  );
  // Calling the default method, the call will work as a thread according to the bouncer logic.
  final isolateResult = await instanceIsolateController.send(CounterGetCount()).value;
  // You can pass the identifier of a specific isolate to bypass the load balancer (for complex balancing relative to business logic).
  final isolateResultNoBouncer = await instanceIsolateController.send(CounterGetCount(), isolateId: 1).value;

  // For complex classes with different return types, you can use ShortInstanceIsolate.
  final shortInstanceIsolateController = await ShortInstanceIsolateControllerFactory.build<Counter, CounterEvent>(
    instanceBuilder: () => Counter(),
    operations: {
      CounterInc: (instance, command) => instance.inc(),
      CounterGetCount: (instance, command) => instance.getCount(),
    },
  );
  
  // You can also use typed message sending if the returned type does not match the expected one - throw a cast exception.
  await shortInstanceIsolateController.typedSend<int>(CounterGetCount());
  
  // If you use a static class, then you can use StaticIsolateController.
  final staticIsolateController = await StaticIsolateControllerFactory.build<int, int>(
    operations: {
      0: (command) => StaticSummator.sum(2, 3),
      1: (command) => StaticSummator.sum(3, 5),
    },
  );
  
  // operations call
  await staticIsolateController.send(0);
  await staticIsolateController.send(1);
}
```

## Contributing

Pull requests and issues are welcome.
