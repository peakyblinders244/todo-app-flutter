import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/theme.dart';
import '../../services/theme_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);
  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Themes _theme = new Themes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ThemeServices().switchTheme();
            },
            icon: Icon(
              Get.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
            ),
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text("Xin chào, ....",
                  style: _theme.notificationScreenHeadingTextStyle),
              const SizedBox(
                height: 10,
              ),
              Text("Bạn có lời nhắc nhở công việc, .....",
                  style: _theme.notificationScreenSubHeadingTextStyle),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryClr,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.text_format,
                              size: 40,
                              color: Colors.white,
                            ),
                            Text(
                              "${widget.payload.split('|')[0]}",
                              style: _theme.notificationScreenBodyTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.description_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                "Nội dung: ",
                                style: _theme.notificationScreenBodyTextStyle,
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.payload.split('|')[1]}",
                                  style: _theme.notificationScreenBodyTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                "Thời gian bắt đầu: ",
                                style: _theme.notificationScreenBodyTextStyle,
                              ),
                              Text(
                                "${widget.payload.split('|')[2]}",
                                style: _theme.notificationScreenBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                "Thời gian kết thúc: ",
                                style: _theme.notificationScreenBodyTextStyle,
                              ),
                              Text(
                                "${widget.payload.split('|')[3]}",
                                style: _theme.notificationScreenBodyTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
