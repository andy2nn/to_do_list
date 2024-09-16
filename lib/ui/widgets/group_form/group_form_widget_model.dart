import 'package:flutter/material.dart';
import 'package:to_do_list/domain/data_provider/box_meneger.dart';
import 'package:to_do_list/domain/entity/group.dart';

class GroupFormWidgetModel extends ChangeNotifier {
  var _groupName = '';
  String? errorText;

  set groupName(String value) {
    if (errorText != null && value.trim().isNotEmpty) {
      errorText = null;
      notifyListeners();
    }
    _groupName = value;
  }

  void saveGroupe(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorText = 'Введите название группы';
      notifyListeners();
      return;
    }

    final box = await BoxManeger.instance.openGroupBox();
    final groupe = Group(name: groupName);
    await box.add(groupe);
    // await BoxManeger.instance.closeBox(box);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

class GroupeFormWidgetMOdelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupeFormWidgetMOdelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child, notifier: model);

  @override
  // ignore: overridden_fields
  final Widget child;

  static GroupeFormWidgetMOdelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupeFormWidgetMOdelProvider>();
  }

  @override
  bool updateShouldNotify(GroupeFormWidgetMOdelProvider oldWidget) {
    return false;
  }
}
