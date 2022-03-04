import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/users_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final backend = ref.watch(backendProvider);
    final users = ref.watch(usersProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios (${users != null ? users.length : '0'})'),
      ),
      body: ref.watch(usersProvider).when(
            data: ((users) {
              return RefreshIndicator(
                onRefresh: () async => ref.refresh(usersProvider),
                child: ListView.builder(
                  itemCount: users.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  itemBuilder: (context, i) {
                    final user = users[i];

                    return Dismissible(
                      key: ValueKey(i),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.redAccent,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.person_remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await backend.modifyUser(user, delete: true);
                      },
                      child: ListTile(
                        leading: Icon(
                          user.online
                              ? Icons.blur_on_rounded
                              : Icons.blur_off_rounded,
                          color: user.online ? Colors.green : Colors.red,
                        ),
                        title: Text(user.email),
                        trailing: Switch.adaptive(
                          value: user.enabled,
                          onChanged: (val) async {
                            setState(() {
                              user.enabled = !user.enabled;
                            });
                            final resp = await backend.modifyUser(user);

                            if (!resp) {
                              setState(() {
                                user.enabled = !user.enabled;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            error: (o, e) => null,
            loading: () => const CustomCircularProgressIndicator(),
          ),
    );
  }
}
