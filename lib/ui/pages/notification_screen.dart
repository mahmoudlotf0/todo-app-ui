import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

class NotificationScreen extends StatefulWidget {
  final String payload;
  NotificationScreen({required this.payload});
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payLoad = '';
  @override
  void initState() {
    super.initState();
    _payLoad = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: context.theme.backgroundColor,
        title: Text(
          _payLoad.split('|')[1],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Hello, Mahmoud',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w900,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You have a new reminder',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: primaryClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow(icon: Icons.text_format_outlined, text: 'Title'),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _payLoad.split('|')[0],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      buildRow(
                          icon: Icons.description_rounded, text: 'Description'),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _payLoad.split('|')[1],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      buildRow(icon: Icons.date_range, text: 'Date'),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _payLoad.split('|')[2],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildRow({required IconData icon, required String text}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 35,
        color: Colors.white,
      ),
      const SizedBox(width: 10),
      Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    ],
  );
}
