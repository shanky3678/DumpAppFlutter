import 'package:flutter/material.dart';

class RecycleViewRoute extends StatelessWidget {
  const RecycleViewRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recycle Contact",
        ),
      ),
      body: Column(
        children: [
          cards("testing", "9632033304"),
          space(),
          cards("testing", "9632033304"),
        ],
      ),
    );
  }

  Widget space() {
    return SizedBox(
      height: 6.0,
    );
  }

  Widget cards(String name, String phoneNumber) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
            space(),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "+91 " + phoneNumber,
                  style: TextStyle(fontSize: 22),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
