import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/tasks_form/tasks_form_widget_model.dart';

class TasksFormWidget extends StatefulWidget {
  final int groupKey;
  const TasksFormWidget({super.key, required this.groupKey});

  @override
  State<TasksFormWidget> createState() => _TasksFormWidgetState();
}

class _TasksFormWidgetState extends State<TasksFormWidget> {
  late final TasksFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TasksFormWidgetModel(groupKey: widget.groupKey);
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (_model == null) {
  //     final groupKey = ModalRoute.of(context)!.settings.arguments as int;
  //     _model = TasksFormWidgetModel(groupKey: groupKey);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetProvider(
        model: _model, child: const _TaskFormWidgetBody());
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая задача'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _TaskNameWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TaskFormWidgetProvider.of(context)?.model.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskNameWidget extends StatelessWidget {
  const _TaskNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetProvider.of(context)?.model;
    return TextField(
      maxLines: null,
      minLines: null,
      expands: true,
      decoration: const InputDecoration(
        hintText: 'Введите задачу',
        border: InputBorder.none,
      ),
      autofocus: true,
      onEditingComplete: () => model?.saveTask(context),
      onChanged: (value) => model?.taskName = value,
    );
  }
}
