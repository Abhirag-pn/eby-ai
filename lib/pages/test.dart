import 'package:flutter/material.dart';
import 'package:grouped_action_buttons/grouped_action_buttons_package.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'grouped action buttons',
          
        ),
      ),
      floatingActionButton: GroupedActionButtons(
        distance: 112,
        openButtonIcon: const Icon(Icons.edit),
        closeButtonIcon: const Icon(Icons.close),
        children: [
          ActionButton(
            onPressed: () => print('b1'),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.abc_rounded),
          ),
          ActionButton(
            onPressed: () => print('b2'),
            icon: const Icon(Icons.ac_unit),
          ),
          ActionButton(
            onPressed: () => print('b3'),
            icon: const Icon(Icons.access_alarms),
          ),
        ],
      ),
    );
  }
}