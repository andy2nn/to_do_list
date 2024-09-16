import 'package:flutter/material.dart';
import 'package:to_do_list/ui/widgets/group_form/group_form_widget_model.dart';

class GroupFormWidget extends StatefulWidget {
  const GroupFormWidget({super.key});

  @override
  State<GroupFormWidget> createState() => _GroupFormWidgetState();
}

class _GroupFormWidgetState extends State<GroupFormWidget> {
  final _model = GroupFormWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupeFormWidgetMOdelProvider(
      model: _model,
      child: const _GroupeFormWidgetBody(),
    );
  }
}

class _GroupeFormWidgetBody extends StatelessWidget {
  const _GroupeFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая группа'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: _GroupeNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupeFormWidgetMOdelProvider.of(context)
            ?.model
            .saveGroupe(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupeNameWidget extends StatelessWidget {
  const _GroupeNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = GroupeFormWidgetMOdelProvider.of(context)?.model;
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Название группы',
        errorText: model?.errorText,
      ),
      autofocus: true,
      onEditingComplete: () => model?.saveGroupe(context),
      onChanged: (value) => model?.groupName = value,
    );
  }
}
