import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NointernetWidgets extends StatefulWidget {

  const NointernetWidgets({
    Key? key,
  }) : super(key: key);

  @override
  State<NointernetWidgets> createState() => _NointernetWidgetsState();
}

class _NointernetWidgetsState extends State<NointernetWidgets> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: Colors.white,
      child:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_connected_no_internet_4,
              color: Colors.red,
              size: 45,
            ),
            SizedBox(height:screenHeight * 0.02),
            AutoSizeText("No Internet Connection",
              style: TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text("Please check your connection and try again.",
              style: TextStyle(
                fontSize:15,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
