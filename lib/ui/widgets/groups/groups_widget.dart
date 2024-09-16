import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/ui/widgets/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Future<void> dispose() async {
    await _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupeWidgetBody(),
    );
  }
}

class _GroupeWidgetBody extends StatelessWidget {
  const _GroupeWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
      ),
      body: const _GroupeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupsWidgetModelProvider.of(context)?.model.newForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupeList extends StatelessWidget {
  const _GroupeList();
  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.of(context)?.model.groups.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _GroupListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemCount: groupsCount);
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.of(context)!.model;
    final group = model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const BehindMotion(),
          // dismissible: DismissiblePane(
          //     onDismissed: () => model.deleteGroup(indexInList)),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) =>
                  model.deleteGroup(indexInList),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ]),
      child: ListTile(
        title: Text(
          group.name,
          style: const TextStyle(fontSize: 23),
        ),
        onTap: () => model.selectedGroup(context, indexInList),
        trailing: const Icon(
          Icons.chevron_right,
          size: 30,
        ),
      ),
    );
  }
}
