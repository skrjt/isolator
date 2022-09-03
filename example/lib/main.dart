import 'package:flutter/material.dart';
import 'package:isolator/isolator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InstanceIsolateController? instanceIsolateController;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _incrementCounter() async {
    instanceIsolateController ??= await InstanceIsolateControllerFactory.build<Counter, int, dynamic>(
      instanceBuilder: () => Counter(),
      operations: {
        0: (instance, command) => instance.inc(),
        1: (instance, command) => instance.getCount(),
        2: (instance, command) => throw UnimplementedError(),
      },
    );

    instanceIsolateController?.send(0);
    _counter = await instanceIsolateController?.send(1).value as int;
    setState(() {});
  }

  Future<void> _errorThrow() async {
    instanceIsolateController ??= await InstanceIsolateControllerFactory.build<Counter, int, dynamic>(
      instanceBuilder: () => Counter(),
      operations: {
        0: (instance, command) => instance.inc(),
        1: (instance, command) => instance.getCount(),
        2: (instance, command) => throw UnimplementedError(),
      },
    );
    try {
      await instanceIsolateController?.send(2).value;
    } catch(e) {
      print(e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _errorThrow,
            tooltip: 'Error throw',
            child: const Icon(Icons.error),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class Counter {
  int _count = 0;

  int getCount() => _count;
  void inc() => _count++;
}
