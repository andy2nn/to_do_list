import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_meneger.dart';
import 'package:to_do_list/domain/entity/task.dart';

class TasksFormWidgetModel extends ChangeNotifier {
  int groupKey;
  var _taskName = '';

  bool get isValid => _taskName.trim().isNotEmpty;

  set taskName(String value) {
    final isTaskNameEmpty = _taskName.trim().isEmpty;
    _taskName = value;

    if (value.trim().isEmpty != isTaskNameEmpty) {
      notifyListeners();
    }
  }

  TasksFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    final taskName = _taskName.trim();
    if (taskName.isEmpty) return;

    final task = Task(name: taskName, isDone: false);
    final box = await BoxManeger.instance.openTaskBox(groupKey);
    await box.add(task);
    // await BoxManeger.instance.closeBox(box);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetProvider extends InheritedNotifier {
  final TasksFormWidgetModel model;
  const TaskFormWidgetProvider(
      {super.key, required this.model, required this.child})
      : super(child: child, notifier: model);

  @override
  // ignore: overridden_fields
  final Widget child;

  static TaskFormWidgetProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskFormWidgetProvider>();
  }

  @override
  bool updateShouldNotify(TaskFormWidgetProvider oldWidget) {
    return false;
  }
}
