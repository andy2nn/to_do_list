import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/ui/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration {
  final int groupKey;
  final String title;

  TaskWidgetConfiguration({required this.groupKey, required this.title});
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TasksWidget({super.key, required this.configuration});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TasksWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksWidgetModel(configuration: widget.configuration);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TasksWidgetModel(groupKey: groupKey);
  //   }
  // }
  @override
  Future<void> dispose() async {
    await _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TasksWidgetModelProvider(
      model: _model,
      child: const _TasksWidgetBody(),
    );
  }
}

class _TasksWidgetBody extends StatelessWidget {
  const _TasksWidgetBody();

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context)?.model;
    final title = model?.configuration.title ?? 'Задачи';
    return Scaffold(
      body: const _TaskListWidget(),
      appBar: AppBar(title: Text(title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.newForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget();
  @override
  Widget build(BuildContext context) {
    final tasksCount =
        TasksWidgetModelProvider.of(context)?.model.tasks.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _TaskListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: tasksCount);
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TaskListRowWidget({required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone
        ? const Icon(
            Icons.done,
            color: Colors.green,
            size: 30,
          )
        : const Icon(Icons.highlight_remove, color: Colors.red, size: 30);

    final style = task.isDone ? TextDecoration.lineThrough : null;
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const BehindMotion(),
          // dismissible: DismissiblePane(
          //     onDismissed: () => model.deleteGroup(indexInList)),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) =>
                  model.deleteTask(indexInList),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ]),
      child: ListTile(
        title: Text(
          task.name,
          style: TextStyle(decoration: style, fontSize: 23),
        ),
        onTap: () => model.doneTogle(indexInList),
        trailing: icon,
      ),
    );
  }
}
