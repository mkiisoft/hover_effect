import 'package:flutter/material.dart';
import 'package:hover_effect/hover_effect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Material(
        child: Center(
          child: Container(
            width: 150,
            height: 300,
            child: HoverCard(
                builder: (context, hovering) {
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xA0000000),
                                    Color(0xFF202020),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                )
                              ),
                            ),
                          );
                        },
                        itemCount: 6,
                      ),
                    ),
                  );
                },
                depth: 10),
          ),
        ),
      ),
    );
  }
}
