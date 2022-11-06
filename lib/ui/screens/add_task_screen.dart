import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants/local_string.dart';

import '../../config/theme.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../resources/widgets/button_custom.dart';
import '../../resources/widgets/custom_app_bar.dart';
import '../../resources/widgets/input_field.dart';
import '../../utils/type_repeat.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController _taskController = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _reminderController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();


  String _selectedDate = DateFormat.yMd().format(DateTime.now());
  String _startDate = DateFormat('hh:mm a').format(DateTime.now());
  String _endDate =
      DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 15)));

  int _selectedReminder = 5;
  List<int> reminderList = [5, 10, 15, 20];

  String _repeat = TypeRepeat.none;
  List<String> repeatList = [TypeRepeat.none, TypeRepeat.daily, TypeRepeat.weekly, TypeRepeat.monthly];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CustomAppBar(
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocalString.addTask,
                        style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : darkGreyClr,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Nhập tiêu đề',
                    label: 'Tiêu đề',
                    iconOrdrop: 'icon',
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    isEnabled: true,
                    hint: 'Nhập ghi chú',
                    label: 'Ghi chú',
                    iconOrdrop: 'icon',
                    controller: _noteController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _dateController,
                    isEnabled: false,
                    hint: '${_selectedDate.toString()}',
                    label: 'Ngày',
                    iconOrdrop: 'button',
                    widget: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 165,
                          child: InputField(
                            isEnabled: false,
                            controller: _startTimeController,
                            label: 'Giờ bắt đầu',
                            iconOrdrop: 'button',
                            hint: _startDate.toString(),
                            widget: IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () {
                                _selectStartTime(context);
                              },
                            ),
                          )),
                      SizedBox(
                          width: 165,
                          child: InputField(
                            controller: _endTimeController,
                            isEnabled: false,
                            iconOrdrop: 'button',
                            label: 'Giờ kết thúc',
                            hint: _endDate.toString(),
                            widget: IconButton(
                              icon: Icon(Icons.access_time),
                              onPressed: () {
                                _selectEndTime(context);
                              },
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _reminderController,
                    isEnabled: false,
                    hint: '${_selectedReminder.toString()} phút',
                    label: 'Nhắc nhở',
                    iconOrdrop: 'drop',
                    widget: DropdownButton(
                      items: reminderList
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(
                                    '$value',
                                    style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  )))
                          .toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 20,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReminder = int.parse(newValue!);
                          _reminderController.text = _selectedReminder.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputField(
                    controller: _repeatController,
                    isEnabled: false,
                    hint: '${_repeat.toString()}',
                    label: 'Lặp lại',
                    iconOrdrop: 'drop',
                    widget: DropdownButton(
                      items: repeatList
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem<String>(
                                  value: value.toString(),
                                  child: Text(
                                    '$value',
                                    style: TextStyle(
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  )))
                          .toList(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 20,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _repeat = newValue!;
                          _repeatController.text = _repeat;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //_colorPallete(),
                      ButtonCustom(
                          label: 'Thêm Task',
                          onTap: () async {
                            _submitOthers();
                            _submitDate();
                            _submitStartTime();
                            _submitEndTime();
                            if (_formKey.currentState!.validate()) {
                              final Task task = Task();
                              _addTaskToDB(task);
                              await _taskController.addTask(task);
                              Get.back();
                            }
                          },
                          color: primaryClr)
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  _addTaskToDB(Task task) {
    task.id= DateTime.now().microsecondsSinceEpoch%100;
    task.isCompleted = 0;
    task.color = -_selectedColor;
    task.title = _titleController.text;
    task.note = _noteController.text;
    task.repeat = _repeat;
    task.remind = _selectedReminder;
    task.date = _selectedDate.toString();
    task.startTime = _startDate;
    task.endTime = _endDate;
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),

    );
    setState(() {
      if(selected != null){
        _selectedDate = DateFormat.yMd().format(selected).toString();
      }
      else
        _selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
    });
  }

  _submitDate() {
    _dateController.text = _selectedDate;
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _startDate = formattedTime;
    });
  }

  _submitStartTime() {
    _startTimeController.text = _startDate;
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    String formattedTime = selected!.format(context);
    setState(() {
      _endDate = formattedTime;
    });
  }

  _submitEndTime() {
    _endTimeController.text = _endDate;
  }

  _submitOthers(){
    if(_reminderController.text.isEmpty){
      _reminderController.text = _selectedReminder.toString();
    }
    if(_repeatController.text.isEmpty){
      _repeatController.text = _repeat.toString();
    }
  }
}
