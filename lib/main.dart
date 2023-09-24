import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class TimeObject {
  int startTime; // in milliseconds or any other unit you prefer
  int stopTime;  // in milliseconds or any other unit you prefer
  bool running;
  String name;

  // Constructor
  TimeObject({required this.startTime, required this.stopTime, required this.running, required this.name});
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Timer _timer;
  // Create a list of time objects
  List<TimeObject> timeObjects = [
    TimeObject(startTime: 0, stopTime: 0, running: false, name: 'Timer 1'),
    TimeObject(startTime: 0, stopTime: 0, running: false, name: 'Timer 2'),
    TimeObject(startTime: 0, stopTime: 0, running: false, name: 'Timer 3'),
  ];

  @override
  void initState() {
    super.initState();
    // Force the UI to update every second
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      for (int i = 0; i < timeObjects.length; i++) {
        if (timeObjects[i].running) {

          timeObjects[i].stopTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }
      }
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    setState(() {
      for (int i = 0; i < timeObjects.length; i++) {
        if (timeObjects[i].running) {
          timeObjects[i].running = false;
          // In seconds
          timeObjects[i].stopTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        } else {
          timeObjects[i].running = true;
          timeObjects[i].startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Create a list of timer items
            for (int i = 0; i < timeObjects.length; i++)
              TimerItem(
                name: timeObjects[i].name,
                // If the timer is running, use the current time, otherwise use the stop time - start
                time: timeObjects[i].running ? (DateTime.now().millisecondsSinceEpoch ~/ 1000) - timeObjects[i].startTime : timeObjects[i].stopTime - timeObjects[i].startTime,
                running: timeObjects[i].running,
                onPressed: () {
                  setState(() {
                    if (timeObjects[i].running) {
                      timeObjects[i].running = false;
                      timeObjects[i].stopTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

                    } else {
                      timeObjects[i].running = true;
                      timeObjects[i].startTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                    }
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

// List widget for each timer item
// Should have a timer name, timer time, and a button to start/stop the timer
class TimerItem extends StatelessWidget {
  const TimerItem({Key? key, required this.name, required this.time, required this.running, required this.onPressed}) : super(key: key);

  final String name;
  final int time;
  final bool running;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text('$name: '),
          Text('${(time ~/ 3600).toString().padLeft(2, '0')}:${((time % 3600) ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}'),
          ElevatedButton(
            onPressed: () { onPressed(); },
            child: Icon(running ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
