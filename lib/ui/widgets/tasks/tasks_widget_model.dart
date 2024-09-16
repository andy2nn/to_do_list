import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/domain/data_provider/box_meneger.dart';
import 'package:to_do_list/domain/entity/task.dart';
import 'package:to_do_list/ui/navition/navigation.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

class TasksWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration configuration;
  ValueListenable<Object>? _listenableBox;
  late final Future<Box<Task>> _box;

  var _tasks = <Task>[];

  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  Future<void> doneTogle(int index) async {
    final task = (await _box).getAt(index);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  void newForm(BuildContext context) {
    Navigator.pushNamed(context, MainNavigationsName.taskForm,
        arguments: configuration.groupKey);
  }

  Future<void> deleteTask(int index) async {
    (await _box).deleteAt(index);
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManeger.instance.openTaskBox(configuration.groupKey);
    await _readTasksFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManeger.instance.closeBox((await _box));
    super.dispose();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(child: child, notifier: model);

  @override
  // ignore: overridden_fields
  final Widget child;

  static TasksWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }
}
