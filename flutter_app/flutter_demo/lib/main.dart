import 'package:easy_localization/easy_localization.dart';
import 'package:smart_cook/screens/activite_screen.dart';
import 'package:smart_cook/screens/appwrite_test_screen.dart';
import 'package:smart_cook/screens/recipe_runner_screen.dart';
import 'package:smart_cook/screens/setting_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_cook/models/ws_data.dart';
import 'package:smart_cook/screens/preset_screen.dart';
import 'package:smart_cook/screens/category_recipes_screen.dart';
import 'package:smart_cook/screens/category_screen.dart';
import 'package:smart_cook/screens/device_list.dart';
import 'package:smart_cook/screens/add_devices_screen.dart';
import 'package:smart_cook/screens/add_device_screen_route.dart';
import 'package:smart_cook/screens/login_screen.dart';
import 'package:smart_cook/screens/preset/func1_screen.dart';
import 'package:smart_cook/screens/preset/func2_screen.dart';
import 'package:smart_cook/screens/recipe_details_screen.dart';
import 'package:smart_cook/component/runnerplayer/runner_player.dart';
import 'package:smart_cook/sql/appwirte/client.dart';
import 'package:smart_cook/theme/MySize.dart';
import 'package:smart_cook/theme/theme.dart';
import 'package:smart_cook/util/commandPass/pass_command.dart';
import './screens/signup_screen.dart';
import './screens/welcome_screen.dart';
import 'package:smart_cook/awesomeDrawer/main.dart';

import 'screens/preset_list_screen.dart';
import 'constant/constant.dart';

//https://xtmaglszgjmsichnqhvc.supabase.co

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //初始化国际化
  await EasyLocalization.ensureInitialized();
  //加载模板
  PassCommand.loadModelJson();

  initAppwirteClient();
  //方向锁定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('zh')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: StreamProvider<Map>(
          create: (_) => WsData.getInstance().wsData,
          initialData: const {"init": "init"},
          catchError: (_, error) => {"error": error.toString()},
          child: MyApp(),
        )),
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> notifier =
      ValueNotifier(ThemeMode.light);

  final _navigatorKey = GlobalKey<NavigatorState>();

  MyApp({Key? key}) : super(key: key);

  void _insertOverlay(BuildContext context) {
    return Overlay.of(context)?.insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        debugPrint(size.width.toString());
        return RunnerPlayer(
          gotoPage: _gotoPage,
        );
      }),
    );
  }

  void _gotoPage(String routeName) {
    debugPrint(_navigatorKey.currentState.toString());
    _navigatorKey.currentState?.pushNamed(routeName);
  }

  void _gotoPageAndArgs(String routeName, Object args) {
    debugPrint(_navigatorKey.currentState.toString());
    _navigatorKey.currentState?.pushNamed(routeName, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: notifier,
        builder: (_, mode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: mode,
            home: WillPopScope(
              onWillPop: () async =>
                  !await _navigatorKey.currentState!.maybePop(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay(context));
                  MySize.setSize(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.height);
                  return Navigator(
                    key: _navigatorKey,
                    onGenerateRoute: (RouteSettings settings) {
                      switch (settings.name) {
                        case WelcomeScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const WelcomeScreen());
                        case SignupScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const SignupScreen());
                        case LoginScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const LoginScreen());
                        case CategoryScreen.routeName:
                          return MaterialPageRoute(
                            builder: (context) => AwesomeDrawerScreen(
                                child: CategoryScreen(
                                    gotoPageAndArgs: _gotoPageAndArgs),
                                currentPage: 0,
                                isShowDefaultHeader: false),
                          );
                        case CategoryRecipesScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: CategoryRecipesScreen(),
                                  currentPage: 0));
                        case RecipeDetailsScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailsScreen(settings: settings));

                        case RecipeRunnerScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) =>
                                  RecipeRunnerScreen(settings: settings));

                        case PresetScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: PresetScreen(), currentPage: 1));
                        case PresetListScreen.routeName:
                          return MaterialPageRoute(
                            builder: (context) => const AwesomeDrawerScreen(
                                child: PresetListScreen(),
                                currentPage: 1,
                                isShowDefaultHeader: false),
                            settings: settings,
                          );
                        case PresetFunc1Screen.routeName:
                          return MaterialPageRoute(
                              builder: (context) =>
                                  PresetFunc1Screen(settings: settings));
                        case PresetFunc2Screen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const PresetFunc2Screen(
                                    luaFile: '',
                                    uiJsonFile: '',
                                  ));
                        case SettingScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: SettingScreen(), currentPage: 3));
                        case ActivatScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: ActivatScreen(), currentPage: 4));

                        case AppwriteTestScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: AppwriteTestScreen(), currentPage: 5));

                        case AddDeviceScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: AddDeviceScreen(),
                                  currentPage: 2,
                                  isShowDefaultHeader: false));
                        case DeviceListScreen.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AwesomeDrawerScreen(
                                  child: DeviceListScreen(),
                                  isShowDefaultHeader: false,
                                  currentPage: 2));
                        case AddDeviceFlow.routeName:
                          return MaterialPageRoute(
                              builder: (context) => const AddDeviceFlow(
                                  setupPageRoute: 'request_permission'));

                        default:
                          return MaterialPageRoute(
                              builder: (context) => const WelcomeScreen());
                      }
                    },
                  );
                },
              ),
            ),
          );
        });
  }
}
