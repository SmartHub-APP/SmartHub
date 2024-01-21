import 'api.dart';
import 'config.dart';
import 'object.dart';
import 'interaction.dart';
import 'tabs/login.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        manager.icon = text1(manager.systemName, color: Colors.white);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: Center(child: manager.icon),
            leadingWidth: 12.w,
            title: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicatorColor: Colors.white,
              onTap: (tabIndex) {
                router.navigateTo(context, showTabs[tabIndex].route, transition: TransitionType.none);
              },
              indicator: const UnderlineTabIndicator(),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: context.tr('setting'),
                onPressed: () {
                  settingDialog();
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

  settingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setSettingState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            title: Container(
              alignment: Alignment.centerLeft,
              width: 40.w,
              height: 7.h,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Center(child: text2(context.tr('setting'), color: Colors.white)),
            ),
            content: Container(
              alignment: Alignment.topCenter,
              width: 60.w,
              height: 80.h,
              decoration: BoxDecoration(borderRadius: uiStyle.roundCorner),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ExpansionTile(
                      title: text3(context.tr('settingLanguage'), isBold: true),
                      children: [
                        SizedBox(height: 2.h),
                        Wrap(
                          spacing: 10,
                          runSpacing: 5,
                          alignment: WrapAlignment.center,
                          children: ini.languages.map((lang) {
                            return InkWell(
                              onTap: () {
                                context.setLocale(lang.ref);
                              },
                              child: Container(
                                width: 150,
                                height: 45,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: uiStyle.roundCorner2,
                                ),
                                child: text3(lang.langName),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                    ExpansionTile(
                      title: text3(context.tr('settingUserCreate'), isBold: true),
                      children: [
                        SizedBox(height: 2.h),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 150,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: uiStyle.roundCorner2,
                            ),
                            child: text3(context.tr("settingUserCreate")),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        //ListView(),
                        SizedBox(height: 2.h),
                      ],
                    ),
                    ExpansionTile(
                      title: text3(context.tr('settingRoleSetting'), isBold: true),
                      children: [
                        SizedBox(height: 2.h),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 2.h),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: uiStyle.roundCorner)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: text3(context.tr('save'), color: Colors.white),
              ),
            ],
          );
        });
      },
    );
  }
}
