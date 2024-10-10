import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings/settings_bloc.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

class SettingsScreen extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return FutureBuilder<User>(
              future: _userRepository.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('ФИО'),
                          subtitle: Text(user.fullName),
                        ),
                        ListTile(
                          title: Text('Номер автомобиля'),
                          subtitle: Text(user.carNumber),
                        ),
                        ListTile(
                          title: Text('Номер телефона'),
                          subtitle: Text(user.phoneNumber),
                        ),
                        Divider(),
                        SwitchListTile(
                          title: Text('Темная тема'),
                          value: state.settings.isDarkMode,
                          onChanged: (value) {
                            BlocProvider.of<SettingsBloc>(context).add(
                              SettingsChangeTheme(isDarkMode: value),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Язык интерфейса'),
                          trailing: DropdownButton<String>(
                            value: state.settings.languageCode,
                            items: [
                              DropdownMenuItem(
                                value: 'ru',
                                child: Text('Русский'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'uz',
                                child: Text('O\'zbekcha'),
                              ),
                            ],
                            onChanged: (value) {
                              BlocProvider.of<SettingsBloc>(context).add(
                                SettingsChangeLanguage(languageCode: value!),
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text('Язык оповещений'),
                          trailing: DropdownButton<String>(
                            value: state.settings.notificationLanguageCode,
                            items: [
                              DropdownMenuItem(
                                value: 'ru',
                                child: Text('Русский'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'uz',
                                child: Text('O\'zbekcha'),
                              ),
                            ],
                            onChanged: (value) {
                              BlocProvider.of<SettingsBloc>(context).add(
                                SettingsChangeNotificationLanguage(languageCode: value!),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('Ошибка загрузки данных пользователя'));
                }
              },
            );
          } else {
            return Center(child: Text('Ошибка загрузки настроек'));
          }
        },
      ),
    );
  }
}
