import 'package:flutter/cupertino.dart';

import 'core/design_tokens.dart';
import 'data/repositories.dart';
import 'features/resident_screens.dart';

void main() => runApp(const NestMateApp());

class NestMateApp extends StatefulWidget {
  const NestMateApp({super.key});

  @override
  State<NestMateApp> createState() => _NestMateAppState();
}

class _NestMateAppState extends State<NestMateApp> {
  final _repositories = PortalRepositories.mock();
  bool _isWarden = false;
  late final CupertinoTabController _tabController = CupertinoTabController();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'NestMate',
        theme: PortalTokens.theme(Brightness.light),
        builder: (context, child) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          return CupertinoTheme(
            data: PortalTokens.theme(brightness),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: CupertinoTabScaffold(
          controller: _tabController,
          tabBar: CupertinoTabBar(
            items: _isWarden
                ? const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.house),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.checkmark_shield),
                      label: 'Triage',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.building_2_fill),
                      label: 'Hostel',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bell),
                      label: 'Notices',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.creditcard),
                      label: 'Fees',
                    ),
                  ]
                : const [
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.house),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.doc_text),
                      label: 'Requests',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.building_2_fill),
                      label: 'Hostel',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.bell),
                      label: 'Notices',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.creditcard),
                      label: 'Fees',
                    ),
                  ],
          ),
          tabBuilder: (context, index) =>
              CupertinoTabView(builder: (context) => _buildTab(context, index)),
        ),
      );

  Widget _buildTab(BuildContext context, int index) {
    final account = _AccountButton(onSwitchRole: _switchRole);
    return switch (index) {
      0 => HomeScreen(
          repositories: _repositories,
          accountButton: account,
          onOpenRequests: () => _tabController.index = 1,
          onOpenHostel: () => _tabController.index = 2,
          onOpenNotices: () => _tabController.index = 3,
          onOpenFees: () => _tabController.index = 4,
        ),
      1 => _isWarden
          ? TriageScreen(repositories: _repositories, accountButton: account)
          : RequestsScreen(
              repositories: _repositories,
              accountButton: account,
            ),
      2 => HostelScreen(repositories: _repositories, accountButton: account),
      3 => NoticesScreen(
          repository: _repositories.notices,
          accountButton: account,
        ),
      4 => FeesScreen(repository: _repositories.fees, accountButton: account),
      _ => const SizedBox.shrink(),
    };
  }

  void _switchRole(bool isWarden) {
    setState(() {
      _isWarden = isWarden;
      _tabController.index = 0;
    });
  }
}

class _AccountButton extends StatelessWidget {
  const _AccountButton({required this.onSwitchRole});
  final ValueChanged<bool> onSwitchRole;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(44, 44),
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          builder: (context) => CupertinoActionSheet(
            title: const Text('Account'),
            message: const Text('Aanya Sharma · Cedar Hall · Room 204'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSwitchRole(true);
                },
                child: const Text('Switch to warden view'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSwitchRole(false);
                },
                child: const Text('Switch to resident view'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ),
        child: Semantics(
          label: 'Account and role settings',
          button: true,
          child: const Icon(CupertinoIcons.person_crop_circle, size: 24),
        ),
      );
}
