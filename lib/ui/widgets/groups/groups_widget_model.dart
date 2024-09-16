import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/domain/data_provider/box_meneger.dart';
import 'package:to_do_list/domain/entity/group.dart';
import 'package:to_do_list/ui/navition/navigation.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }
  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManeger.instance.closeBox((await _box));
    super.dispose();
  }

  void newForm(BuildContext context) {
    Navigator.pushNamed(context, MainNavigationsName.groupForm);
  }

  Future<void> selectedGroup(BuildContext context, index) async {
    final group = (await _box).getAt(index);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(
          groupKey: group.key as int, title: group.name);
      unawaited(
          // ignore: use_build_context_sy nchronously, use_build_context_synchronously
          Navigator.pushNamed(context, MainNavigationsName.tasks,
              arguments: configuration));
    }
  }

  void deleteGroup(int index) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(index) as int;
    await Hive.deleteBoxFromDisk(
        BoxManeger.instance.makeTasksBoxName(groupKey));
    await box.deleteAt(index);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  void _setup() async {
    _box = BoxManeger.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(notifier: model, child: child);

  @override
  // ignore: overridden_fields
  final Widget child;

  static GroupsWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(GroupsWidgetModelProvider oldWidget) {
    return true;
  }
}
