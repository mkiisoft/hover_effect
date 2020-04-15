# hover_effect

Hover - Tilt 3D Effect

## Demo

[<img src="https://raw.githubusercontent.com/mkiisoft/hover_effect/master/assets/demo.gif" width=560>](https://mkiisoft.github.io/hover_effect)

## Getting Started

```dart
import 'package:flutter/material.dart';
import 'package:hover_effect/hover_effect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hover - Tilt 3D Effect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hover - Tilt 3D Effect',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 2),
            ),
            SizedBox(height: 50),
            Container(
              width: 150,
              height: 300,
              child: HoverCard(
                builder: (context, hovering) {
                  return Container(
                    color: Color(0xFFE9E9E9),
                    child: Center(
                      child: FlutterLogo(size: 100),
                    ),
                  );
                },
                depth: 10,
                depthColor: Colors.grey[500],
                onTap: () => print('Hello, World!'),
                shadow: BoxShadow(color: Colors.purple[200], blurRadius: 30, spreadRadius: -20, offset: Offset(0, 40)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```