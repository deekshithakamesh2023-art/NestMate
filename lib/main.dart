import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/design_tokens.dart';
import 'core/firebase_config.dart';
import 'core/widgets.dart';
import 'data/repositories.dart';
import 'features/firebase_portal_gate.dart';
import 'features/resident_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (FirebaseConfig.hasAnyConfiguration && !FirebaseConfig.isConfigured) {
    throw StateError(
      'Firebase configuration is incomplete. Set FIREBASE_API_KEY, '
      'FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID, and FIREBASE_PROJECT_ID.',
    );
  }
  if (FirebaseConfig.isConfigured) {
    await Firebase.initializeApp(options: FirebaseConfig.options);
  }
  runApp(
    FirebaseConfig.isConfigured
        ? FirebasePortalGate(
            previewBuilder: (onExitPreview) =>
                NestMateApp(onExitPreview: onExitPreview),
            portalBuilder: (repositories, isWarden, onSignOut, profileLabel) =>
                NestMateApp(
              repositories: repositories,
              isWarden: isWarden,
              prototypePreview: false,
              onSignOut: onSignOut,
              profileLabel: profileLabel,
            ),
          )
        : const NestMateApp(),
  );
}

class NestMateApp extends StatefulWidget {
  const NestMateApp({
    this.repositories,
    this.isWarden,
    this.prototypePreview = true,
    this.onSignOut,
    this.onExitPreview,
    this.profileLabel,
    super.key,
  });

  final PortalRepositories? repositories;
  final bool? isWarden;
  final bool prototypePreview;
  final VoidCallback? onSignOut;
  final VoidCallback? onExitPreview;
  final String? profileLabel;

  @override
  State<NestMateApp> createState() => _NestMateAppState();
}

class _NestMateAppState extends State<NestMateApp> {
  late final _repositories = widget.repositories ?? PortalRepositories.mock();
  late bool _isWarden = widget.isWarden ?? false;
  Brightness _brightness = Brightness.light;
  late final CupertinoTabController _tabController = CupertinoTabController();

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        title: 'NestMate · VIT Hostel Life',
        theme: PortalTokens.theme(Brightness.light),
        builder: (context, child) => PortalEnvironment(
          prototypePreview: widget.prototypePreview,
          child: CupertinoTheme(
            data: PortalTokens.theme(_brightness),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
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
    final account = _AccountButton(
      onSwitchRole: widget.prototypePreview ? _switchRole : null,
      isDark: _brightness == Brightness.dark,
      profileLabel: widget.profileLabel ??
          'Prototype preview · Aanya Sharma · VIT Chennai · Room 204',
      onSignOut: widget.onSignOut,
      onExitPreview: widget.onExitPreview,
      onToggleTheme: () => setState(
        () => _brightness =
            _brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
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
  const _AccountButton({
    required this.onSwitchRole,
    required this.isDark,
    required this.profileLabel,
    required this.onSignOut,
    required this.onExitPreview,
    required this.onToggleTheme,
  });
  final ValueChanged<bool>? onSwitchRole;
  final bool isDark;
  final String profileLabel;
  final VoidCallback? onSignOut;
  final VoidCallback? onExitPreview;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(44, 44),
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          builder: (context) => CupertinoActionSheet(
            title: const Text('Account'),
            message: Text(profileLabel),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  onToggleTheme();
                },
                child: Text(
                  isDark ? 'Use light appearance' : 'Use dark appearance',
                ),
              ),
              if (onSwitchRole != null) ...[
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSwitchRole!(true);
                  },
                  child: const Text('Preview warden view'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSwitchRole!(false);
                  },
                  child: const Text('Preview resident view'),
                ),
              ],
              if (onSignOut != null)
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onSignOut!();
                  },
                  child: const Text('Sign out'),
                ),
              if (onExitPreview != null)
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onExitPreview!();
                  },
                  child: const Text('Return to sign in'),
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
