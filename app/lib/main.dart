import 'api.dart';
import 'config.dart';
import 'object.dart';
import 'component/interaction.dart';
import 'tabs/login.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'component/setting.dart';

// ##### Initialize
bool autoLogin = false;
FluroRouter router = FluroRouter();

// ##### Route
void defineRoutes() {
  router.define(ini.api.login, handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const Login();
  }));

  for (var tabId = 0; tabId < ini.urls.length; tabId++) {
    router.define(ini.urls[tabId].route, handler: Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return RoutePage(page: tabId);
    }));
  }
}

// ##### Main
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await try2Login("", "").then((ret) => autoLogin = ret.isEmpty);

  setPathUrlStrategy();

  defineRoutes();

  runApp(
    EasyLocalization(
      supportedLocales: ini.languages.map((e) => e.ref).toList(),
      path: 'assets/translations',
      fallbackLocale: ini.languages[0].ref,
      child: const SmartHub(),
    ),
  );
}

class SmartHub extends StatelessWidget {
  const SmartHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateTitle: (context) => manager.systemName,
      onGenerateRoute: router.generator,
      home: autoLogin ? const RoutePage(page: 0) : const Login(),
      builder: EasyLoading.init(),
    );
  }
}

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required this.page});

  final int page;

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Url> showTabs = [
    // 1. Dashboard
    if (manager.tabPermission.dashboard > 0) ini.urls[0],
    // 2. Customer
    if (manager.tabPermission.customer > 0) ini.urls[1],
    // 3. Product
    if (manager.tabPermission.product > 0) ini.urls[2],
    // 4. Leads Appointment
    if (manager.tabPermission.leadsAppointment > 0) ini.urls[3],
    // 5. Payment
    if (manager.tabPermission.payment > 0) ini.urls[4],
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: showTabs.length, vsync: this, initialIndex: widget.page);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        manager.icon = text2(manager.systemName, color: Colors.white);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leadingWidth: 12.w,
            leading: Center(child: manager.icon),
            titleSpacing: -50,
            title: TabBar(
              isScrollable: true,
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicator: const UnderlineTabIndicator(),
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
              onTap: (tabIndex) {
                router.navigateTo(context, showTabs[tabIndex].route, transition: TransitionType.none);
              },
              tabs: [
                // 1. Dashboard
                if (manager.tabPermission.dashboard > 0) Tab(text: context.tr('dashboard_tabName')),
                // 2. Customer
                if (manager.tabPermission.customer > 0) Tab(text: context.tr('customer_tabName')),
                // 3. Product
                if (manager.tabPermission.product > 0) Tab(text: context.tr('product_tabName')),
                // 4. Leads Appointment
                if (manager.tabPermission.leadsAppointment > 0) Tab(text: context.tr('leadsAppointment_tabName')),
                // 5. Payment
                if (manager.tabPermission.payment > 0) Tab(text: context.tr('payment_tabName')),
              ],
            ),
            actionsIconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: context.tr('setting'),
                onPressed: () {
                  settingDialog(context);
                },
              ),
              SizedBox(width: 1.w),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: context.tr('logout'),
                onPressed: () {
                  logout();
                  router.navigateTo(context, ini.api.login, transition: TransitionType.none);
                },
              ),
              SizedBox(width: 2.w),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: showTabs.map((e) => e.content as Widget).toList(),
          ),
        );
      },
    );
  }
}
