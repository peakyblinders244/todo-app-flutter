import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/size_config.dart';
import '../../config/theme.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../resources/gen/assets.gen.dart';
import '../../resources/widgets/custom_app_bar.dart';
import '../../resources/widgets/task_tile.dart';
import '../../services/notification_services.dart';
import '../../utils/type_repeat.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController _taskController = Get.put(TaskController());
  NotifyHelper notifyHelper = NotifyHelper();
  DateTime _selectedate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController.getTask();
    SizeConfig.orientation = Orientation.portrait;
    SizeConfig.screenHeight = 100;
    SizeConfig.screenWidth = 100;
    notifyHelper.initializeNotification();
    notifyHelper.requestIosPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        leadingWidget: IconButton(
          onPressed: () {
            notifyHelper.cancelAllNotification();
            _taskController.deleteAllTasks();
          },
          icon: Icon(Icons.delete),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat.yMMMMd().format(DateTime.now())}',
                      style: Themes().homeScreenSubHeadingTextStyle,
                    ),
                    Text(
                      'Today',
                      style: Themes().homeScreenHeadingTextStyle,
                    ),
                  ],
                )
              ],
            ),
            _dateBar(),
            _tasks(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryClr,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Get.to(() => AddTaskScreen(),
            transition: Transition.downToUp,
            duration: Duration(milliseconds: 500)),
      ),
    );
  }

  Widget _dateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        onDateChange: (newDate) {
          setState(() {
            _selectedate = newDate;
          });
        },
        width: 70,
        height: 100,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle:
            TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
        dateTextStyle: TextStyle(
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
            fontSize: 20,
            fontWeight: FontWeight.bold),
        monthTextStyle:
            TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
      ),
    );
  }

  Widget _tasks() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.isEmpty) {
        return _noTasksMessage();
      } else {
        return AnimationLimiter(
          child: ListView.builder(
              scrollDirection:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? Axis.vertical
                      : Axis.horizontal,
              itemCount: _taskController.taskList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = _taskController.taskList[index];
                var date = DateFormat.jm().parse(task.startTime!);
                var myTime = DateFormat('HH:mm').format(date);
                handlingReminder(task.remind!, myTime, task);
                if (task.repeat == TypeRepeat.daily ||
                    task.date == DateFormat.yMd().format(_selectedate) ||
                    (task.repeat == TypeRepeat.weekly &&
                        _selectedate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == TypeRepeat.monthly &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedate.day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 500 + index * 20),
                    child: SlideAnimation(
                      horizontalOffset: 400.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => displayBottomSheet(context, task),
                          child: TaskTile(task: task),
                        ),
                      ),
                    ),
                  );
                } else
                  return SizedBox(
                    height: 0,
                  );
              }),
        );
      }
    }));
  }

  displayBottomSheet(context, Task task) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return _bottomSheet(task);
        });
  }

  Widget _bottomSheet(Task task) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.2
          : MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          task.isCompleted == 0
              ? ElevatedButton(
                  onPressed: () {
                    notifyHelper.cancelNotification(task.id!);
                    _taskController.markAsCompleted(task.id);
                    Get.back();
                  },
                  child: Text("Hoàn thành"))
              : SizedBox(
                  height: 0,
                ),
          ElevatedButton(
              onPressed: () {
                _taskController.deleteTask(task.id);
                notifyHelper.cancelNotification(task.id!);
                Get.back();
              },
              child: Text("Xóa Task")),
          ElevatedButton(onPressed: () => Get.back(), child: Text("Thoát"))
        ],
      ),
    );
  }

  Widget _noTasksMessage() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MediaQuery.of(context).orientation == Orientation.portrait
                ? const SizedBox(
                    height: 0,
                  )
                : const SizedBox(
                    height: 50,
                  ),
            Assets.icons.task.svg(
              height: 200,
              color: primaryClr.withOpacity(0.5),
              semanticsLabel: 'Danh sách Task',
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Hôm nay không có Task"),
          ],
        ),
      ),
    );
  }

  handlingReminder(int reminder, var myTime, Task task) {
    var minutes = int.parse(myTime.toString().split(':')[1]);
    var hours = int.parse(myTime.toString().split(':')[0]);
    if (reminder == 5) {
      notifyHelper.scheduledNotification(minutes < 5 ? hours - 1 : hours,
          minutes < 5 ? minutes + 55 : minutes - 5, task);
    } else if (reminder == 10) {
      notifyHelper.scheduledNotification(minutes < 10 ? hours - 1 : hours,
          minutes < 10 ? minutes + 50 : minutes - 10, task);
    } else if (reminder == 15) {
      notifyHelper.scheduledNotification(minutes < 15 ? hours - 1 : hours,
          minutes < 15 ? minutes + 45 : minutes - 15, task);
    } else {
      notifyHelper.scheduledNotification(minutes < 20 ? hours - 1 : hours,
          minutes < 20 ? minutes + 40 : minutes - 20, task);
    }
  }
}
