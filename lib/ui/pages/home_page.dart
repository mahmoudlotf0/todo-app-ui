import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controllers/task_controller.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/services/notification_services.dart';
import 'package:todoapp/services/theme_services.dart';
import 'package:todoapp/ui/pages/add_task_page.dart';
import 'package:todoapp/ui/size_config.dart';
import 'package:todoapp/ui/widgets/button.dart';
import 'package:todoapp/ui/widgets/task_tile.dart';

import '../theme.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _buildAppbar(),
      body: Column(
        children: [
          _addTask(),
          _addDateBar(),
          const SizedBox(height: 6.0),
          _showTask(),
        ],
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          // notifyHelper.displayNotification(
          //   title: 'the theme changed',
          //   body: 'slss',
          // );
          // notifyHelper.scheduleNotification();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: [
        IconButton(
          icon: Icon(
            Icons.cleaning_services_outlined,
            size: 24.0,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            notifyHelper.cancelAllNotification();
            _taskController.deleteAllTasks();
          },
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _addTask() {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
            lable: '+ Add Task',
            onTap: () async {
              // async faydtha eny lma aro7 ll task w a3ml w arg3 enfz el getTasks()
              await Get.to(() => AddTaskPage());

              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  Widget _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 60,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _taskController.getTasks();
  }

  Widget _showTask() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Task task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      (task.repeat == 'Weekly' &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      (task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    var date = DateFormat.jm().parse(task.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);
                    notifyHelper.scheduledNotification(
                      hour: int.parse(myTime.toString().split(':')[0]),
                      minutes: int.parse(myTime.toString().split(':')[1]),
                      task: task,
                    );

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 1375),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                task,
                              );
                            },
                            child: TaskTile(
                              task,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    color: primaryClr.withOpacity(0.5),
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        notifyHelper.cancelNotification(task);
                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      color: primaryClr,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  notifyHelper.cancelNotification(task);
                  _taskController.deleteTasks(task);
                  Get.back();
                },
                color: Colors.red[300]!,
              ),
              Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                color: primaryClr,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
