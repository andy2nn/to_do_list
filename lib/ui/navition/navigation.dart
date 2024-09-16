import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget.dart';
import 'package:to_do_list/ui/widgets/groups/groups_widget.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget.dart';
import 'package:to_do_list/ui/widgets/tasks_form/tasks_form_widget.dart';

class MainNavigationsName {
  static const group = 'groups/';
  static const groupForm = 'groups/form';
  static const tasks = 'groups/tasks';
  static const taskForm = 'groups/task/form';
}

class MainNavigation {
  static Map<String, Widget Function(BuildContext)> mainRoutes = {
    MainNavigationsName.group: (context) => const GroupsWidget(),
    MainNavigationsName.groupForm: (context) => const GroupFormWidget(),
    // MainNavigationsName.tasks: (context) => const TasksWidget(),
    // MainNavigationsName.taskForm: (context) => const TasksFormWidget(),
  };

  static String initialRoute = MainNavigationsName.group;

  static Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationsName.tasks:
        final configuration = settings.arguments as TaskWidgetConfiguration;
        return MaterialPageRoute(builder: (context) {
          return TasksWidget(
            configuration: configuration,
          );
        });

      case MainNavigationsName.taskForm:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(builder: (context) {
          return TasksFormWidget(groupKey: groupKey);
        });
      default:
        const widget = Text('ошибка навигации');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
