import 'package:get/get.dart';
import 'package:todoapp/db/db_helper.dart';
import 'package:todoapp/models/task.dart';

class TaskController extends GetxController {
  // el tasks el f homepage gaya mn TaskList
  final RxList<Task> taskList = <Task>[].obs;
  Future<int> addTaskToDatabase({Task? task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    // get data from database
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
