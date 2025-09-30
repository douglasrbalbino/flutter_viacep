import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 200, color: Colors.orange),
            SizedBox(
              width: 300,
              child: TextField(
                style: TextStyle(color: Colors.orange),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 5),
                  ),
                  labelText: "CEP",
                  labelStyle: TextStyle(color: Colors.orange),
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Buscar")),
          ],
        ),
      ),
    );
  }
}
