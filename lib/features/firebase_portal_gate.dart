import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../core/design_tokens.dart';
import '../core/widgets.dart';
import '../data/firebase_repositories.dart';
import '../data/repositories.dart';

typedef FirebasePortalBuilder = Widget Function(
  PortalRepositories repositories,
  bool isWarden,
  VoidCallback onSignOut,
  String profileLabel,
);

class FirebasePortalGate extends StatelessWidget {
  const FirebasePortalGate({required this.portalBuilder, super.key});

  final FirebasePortalBuilder portalBuilder;

  @override
  Widget build(BuildContext context) => CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: PortalTokens.theme(Brightness.light),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const _AuthMessage(
                title: 'Sign-in is unavailable',
                message: 'Please try again later.',
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }
            final user = snapshot.data;
            if (user == null) return const _SignInScreen();
            return _RoleClaimScreen(
              key: ValueKey(user.uid),
              user: user,
              portalBuilder: portalBuilder,
            );
          },
        ),
      );
}

class _RoleClaimScreen extends StatefulWidget {
  const _RoleClaimScreen({
    required this.user,
    required this.portalBuilder,
    super.key,
  });

  final User user;
  final FirebasePortalBuilder portalBuilder;

  @override
  State<_RoleClaimScreen> createState() => _RoleClaimScreenState();
}

class _RoleClaimScreenState extends State<_RoleClaimScreen> {
  late Future<IdTokenResult> _claims = widget.user.getIdTokenResult(true);

  void _retry() => setState(() => _claims = widget.user.getIdTokenResult(true));

  @override
  Widget build(BuildContext context) => FutureBuilder<IdTokenResult>(
        future: _claims,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _AuthMessage(
              title: 'Account details are unavailable',
              message: 'Try loading your account again.',
              onRetry: _retry,
            );
          }
          if (!snapshot.hasData) return const _LoadingScreen();
          final isWarden = snapshot.data!.claims?['role'] == 'warden';
          return widget.portalBuilder(
            FirebasePortalRepositories.forUser(widget.user.uid).repositories,
            isWarden,
            () => FirebaseAuth.instance.signOut(),
            widget.user.email ?? 'Signed-in resident',
          );
        },
      );
}

class _SignInScreen extends StatefulWidget {
  const _SignInScreen();

  @override
  State<_SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<_SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter your email and password.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      if (mounted) {
        setState(
          () => _error =
              'We couldn’t sign you in. Check your details and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/vit_chennai_login_background.png',
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66002147),
                    Color(0x33002147),
                    Color(0x99002147),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Interactive3DSurface(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.canvas.withValues(alpha: .96),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x44002147),
                              blurRadius: 32,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Icon(
                                CupertinoIcons.building_2_fill,
                                color: Color(0xFF002147),
                                size: 48,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Welcome to NestMate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.primaryText,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in with the account provided by your hostel.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: context.secondaryText),
                              ),
                              const SizedBox(height: 28),
                              CupertinoTextField(
                                controller: _email,
                                placeholder: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.username],
                                textInputAction: TextInputAction.next,
                                padding: const EdgeInsets.all(16),
                                decoration: _fieldDecoration(context),
                              ),
                              const SizedBox(height: 12),
                              CupertinoTextField(
                                controller: _password,
                                placeholder: 'Password',
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                onSubmitted: (_) => _signIn(),
                                padding: const EdgeInsets.all(16),
                                decoration: _fieldDecoration(context),
                              ),
                              if (_error != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Semantics(
                                    liveRegion: true,
                                    child: Text(
                                      _error!,
                                      style: TextStyle(color: context.error),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              CupertinoButton.filled(
                                minimumSize: const Size(0, 48),
                                onPressed: _busy ? null : _signIn,
                                child: _busy
                                    ? const CupertinoActivityIndicator(
                                        color: Color(0xFFFFFFFF),
                                      )
                                    : const Text('Sign in'),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Need an account? Ask your hostel administrator. Warden access is assigned by the server.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: context.secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

BoxDecoration _fieldDecoration(BuildContext context) => BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.border),
    );

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: context.canvas,
        child: const Center(child: CupertinoActivityIndicator(radius: 14)),
      );
}

class _AuthMessage extends StatelessWidget {
  const _AuthMessage({
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        backgroundColor: context.canvas,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.secondaryText),
                  ),
                  if (onRetry != null)
                    CupertinoButton(
                      onPressed: onRetry,
                      child: const Text('Try again'),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
