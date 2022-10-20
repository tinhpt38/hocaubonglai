import 'package:flutter/material.dart';
import 'package:print_ticket/models/users.dart';
import 'package:print_ticket/modules/home/home.model.dart';
import 'package:print_ticket/modules/permission/permission.model.dart';
import 'package:provider/provider.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final PermissionModel _model = PermissionModel();
  final HomeModel _modelHome = HomeModel();
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _model.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PermissionModel>(
      create: (_) => _model,
      builder: (context, widgets) =>
          Consumer<PermissionModel>(builder: (context, model, widget) {
        return Scaffold(
            appBar: AppBar(title: const Text('Phân quyền')),
            body: FutureBuilder(
                future: _model.usersList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Users>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.retrievedUsers.length,
                      itemBuilder: (context, index) {
                        final Users users = model.retrievedUsers[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(users.photoURL.toString())),
                            title: Text(
                                '${users.displayName.toString()} (${users.role})'),
                            subtitle: Text(users.email.toString()),
                            trailing: SizedBox(
                              width: 98,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _modelHome.changeRole();
                                      model.updateRole(users.id.toString(),
                                          users.role.toString());
                                    },
                                    icon: const Icon(
                                      Icons.change_circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (
                                              BuildContext context,
                                            ) =>
                                                AlertDialog(
                                                  title: const Center(
                                                    child:
                                                        Text('Xóa nhân viên?'),
                                                  ),
                                                  content: Text(
                                                    users.displayName
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'Không'),
                                                      child:
                                                          const Text('Không'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        model.deleteUser(users
                                                            .id
                                                            .toString());
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Xóa'),
                                                    ),
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.deepOrangeAccent,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
      }),
    );
  }
}
