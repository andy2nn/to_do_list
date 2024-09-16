import 'package:hive/hive.dart';
import 'package:to_do_list/domain/entity/group.dart';
import 'package:to_do_list/domain/entity/task.dart';

class BoxManeger {
  static final BoxManeger instance = BoxManeger._();
  BoxManeger._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox('group_box', 0, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(makeTasksBoxName(groupKey), 1, TaskAdapter());
  }

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  String makeTasksBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> _openBox<T>(
      String boxName, int typeId, TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(boxName);
  }
}
