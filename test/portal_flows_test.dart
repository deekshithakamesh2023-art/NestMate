import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestmate_portal/core/widgets.dart';
import 'package:nestmate_portal/data/models.dart';
import 'package:nestmate_portal/data/repositories.dart';
import 'package:nestmate_portal/features/resident_screens.dart';
import 'package:nestmate_portal/main.dart';

void main() {
  group('Complaint form', () {
    testWidgets(
      'requires category and fields, then confirms a successful submission',
      (tester) async {
        _useTallTestViewport(tester);
        final repository = MockPortalRepository();
        await tester.pumpWidget(
          _testApp(ComplaintForm(repository: repository)),
        );

        await tester.ensureVisible(find.text('Submit complaint'));
        await tester.drag(find.byType(ListView).first, const Offset(0, -240));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Submit complaint'));
        await tester.pump();
        expect(
          find.text('Choose a category and complete both fields.'),
          findsOneWidget,
        );

        await tester.tap(find.text('Maintenance').last);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(CupertinoTextField).at(0),
          'Broken lamp',
        );
        await tester.enterText(
          find.byType(CupertinoTextField).at(1),
          'The desk lamp does not turn on.',
        );
        await tester.ensureVisible(find.text('Submit complaint'));
        await tester.tap(find.text('Submit complaint'));
        await tester.pumpAndSettle();

        expect(find.text('Your complaint is submitted.'), findsOneWidget);
        expect((await repository.requests()).first.title, 'Broken lamp');
      },
    );

    testWidgets('preserves the draft after a failed submission and can retry', (
      tester,
    ) async {
      _useTallTestViewport(tester);
      final repository = _FailOnceResidentRepository();
      await tester.pumpWidget(_testApp(ComplaintForm(repository: repository)));
      await tester.tap(find.text('Maintenance').last);
      await tester.enterText(
        find.byType(CupertinoTextField).at(0),
        'Broken lamp',
      );
      await tester.enterText(
        find.byType(CupertinoTextField).at(1),
        'The desk lamp does not turn on.',
      );
      await tester.ensureVisible(find.text('Submit complaint'));
      await tester.tap(find.text('Submit complaint'));
      await tester.pumpAndSettle();
      expect(
          find.textContaining('Your complaint wasn’t sent.'), findsOneWidget);
      expect(
        (tester.widget<CupertinoTextField>(
          find.byType(CupertinoTextField).first,
        )).controller!.text,
        'Broken lamp',
      );

      await tester.tap(find.text('Retry complaint'));
      await tester.pumpAndSettle();
      expect(find.text('Your complaint is submitted.'), findsOneWidget);
    });
  });

  group('Outpass date validation', () {
    final today = DateTime(2026, 10, 18);

    test('requires return after departure', () {
      expect(
        outpassDateError(
          departure: DateTime(2026, 10, 20),
          returnAt: DateTime(2026, 10, 20),
          today: today,
        ),
        'Return date must be after departure.',
      );
    });

    test('rejects dates outside policy and accepts an allowed trip', () {
      expect(
        outpassDateError(
          departure: DateTime(2026, 11, 18),
          returnAt: DateTime(2026, 11, 19),
          today: today,
        ),
        'Choose a departure date within the next 30 days.',
      );
      expect(
        outpassDateError(
          departure: DateTime(2026, 10, 20),
          returnAt: DateTime(2026, 10, 22),
          today: today,
        ),
        isNull,
      );
    });

    testWidgets('keeps the form and explains the invalid return date', (
      tester,
    ) async {
      await tester.pumpWidget(
        _testApp(OutpassForm(repository: MockPortalRepository())),
      );
      await tester.tap(find.text('Select return date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select departure date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(CupertinoTextField),
        'Visiting family',
      );
      await tester.ensureVisible(find.text('Submit outpass'));
      await tester.tap(find.text('Submit outpass'));
      await tester.pumpAndSettle();
      expect(find.text('Return date must be after departure.'), findsOneWidget);
      expect(find.byType(CupertinoTextField), findsOneWidget);
    });
  });

  group('Payment confirmation', () {
    testWidgets('requires confirmation before showing a payment receipt', (
      tester,
    ) async {
      _useTallTestViewport(tester);
      final repository = _PaymentRecorder();
      await tester.pumpWidget(
        _testApp(
          FeesScreen(
            repository: repository,
            accountButton: const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Prototype preview'),
        findsOneWidget,
      );
      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();

      expect(find.text('Choose how\nto pay.'), findsOneWidget);
      expect(find.text('UPI'), findsOneWidget);
      expect(find.text('Credit or debit card'), findsOneWidget);
      expect(
        find.textContaining('No payment provider is connected'),
        findsOneWidget,
      );
      expect(repository.paymentCount, 0);
      await tester.tap(find.text('Credit or debit card'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Continue with Card'));
      await tester.tap(find.text('Continue with Card'));
      await tester.pumpAndSettle();
      expect(find.text('Prototype payment · no charge'), findsOneWidget);
      await tester.tap(find.text('Preview payment'));
      await tester.pumpAndSettle();
      expect(repository.paymentCount, 1);
      expect(find.text('Prototype payment complete'), findsOneWidget);
      expect(find.textContaining('No real payment was made'), findsOneWidget);
    });

    testWidgets('cancel does not invoke payment', (tester) async {
      _useTallTestViewport(tester);
      final repository = _PaymentRecorder();
      await tester.pumpWidget(
        _testApp(
          FeesScreen(
            repository: repository,
            accountButton: const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(CupertinoIcons.back));
      await tester.pumpAndSettle();
      expect(repository.paymentCount, 0);
      expect(find.text('Prototype payment complete'), findsNothing);
    });

    testWidgets('allows retry when payment cannot be confirmed',
        (tester) async {
      _useTallTestViewport(tester);
      final repository = _FailOncePaymentRepository();
      await tester.pumpWidget(
        _testApp(FeesScreen(
            repository: repository, accountButton: const SizedBox.shrink())),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Continue with UPI'));
      await tester.tap(find.text('Continue with UPI'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview payment'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Payment could not be confirmed.'),
          findsOneWidget);
      expect(find.text('Prototype payment complete'), findsNothing);

      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Continue with UPI'));
      await tester.tap(find.text('Continue with UPI'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Preview payment'));
      await tester.pumpAndSettle();
      expect(find.text('Prototype payment complete'), findsOneWidget);
    });
  });

  group('Hostel services', () {
    testWidgets('validates and submits meal feedback, then requests laundry', (
      tester,
    ) async {
      _useTallTestViewport(tester);
      final repository = _RecordingHostelRepository();
      await tester.pumpWidget(
        _testApp(
          HostelScreen(
            repositories: PortalRepositories(
              resident: MockPortalRepository(),
              hostel: repository,
              notices: MockPortalRepository(),
              fees: _PaymentRecorder(),
              warden: MockPortalRepository(),
            ),
            accountButton: const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Send feedback'));
      await tester.tap(find.text('Send feedback'));
      await tester.pumpAndSettle();
      expect(find.text('Add a note before sending feedback.'), findsOneWidget);

      await tester.enterText(
        find.byType(CupertinoTextField),
        'The dal was tasty.',
      );
      await tester.tap(find.text('Send feedback'));
      await tester.pumpAndSettle();
      expect(repository.feedback, 'The dal was tasty.');
      expect(find.text('Thanks. Your meal feedback has been shared.'),
          findsOneWidget);

      await tester.ensureVisible(find.text('Request pickup'));
      await tester.tap(find.text('Request pickup'));
      await tester.pumpAndSettle();
      expect(repository.laundryRequested, isTrue);
      expect(
        find.textContaining('Laundry pickup requested for today.'),
        findsOneWidget,
      );
    });
  });

  testWidgets(
      'request cards show progress and resolved state in plain language',
      (tester) async {
    _useTallTestViewport(tester);
    final repository = MockPortalRepository();
    await tester.pumpWidget(
      _testApp(
        RequestsScreen(
          repositories: PortalRepositories(
            resident: repository,
            hostel: repository,
            notices: repository,
            fees: repository,
            warden: repository,
          ),
          accountButton: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Issue still in progress'), findsWidgets);
    expect(find.text('Issue resolved'), findsOneWidget);
    expect(find.text('Resolved'), findsOneWidget);
    expect(find.bySemanticsLabel('Request progress'), findsWidgets);
  });

  test('prototype repository records feedback and laundry actions in session',
      () async {
    final repository = MockPortalRepository();
    await repository.sendMealFeedback('More vegetarian options, please.');
    await repository.requestLaundryPickup('Collect after 4 pm.');

    expect(
        repository.mealFeedbackMessages, ['More vegetarian options, please.']);
    expect(repository.laundryPickupRequests, ['Collect after 4 pm.']);
  });

  testWidgets('warden can update a request status and assignee', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    final repository = MockPortalRepository();
    final request = (await repository.triageQueue()).first;
    await tester.pumpWidget(
      _testApp(TriageDetail(repository: repository, request: request)),
    );

    await tester.tap(find.text(request.status.label));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resolved').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Choose a staff member'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Facilities team').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save update'));
    await tester.tap(find.text('Save update'));
    await tester.pumpAndSettle();
    expect(find.text('Update saved for ${request.id}.'), findsOneWidget);
    expect(await repository.triageQueue(), hasLength(1));
    expect((await repository.requests()).first.status, RequestStatus.resolved);
  });

  testWidgets('shows five role-aware tabs and supports switching to triage', (
    tester,
  ) async {
    _useTallTestViewport(tester);
    await tester.pumpWidget(const NestMateApp());
    await tester.pumpAndSettle();
    expect(find.text('VIT  ·  NESTMATE'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('vit-chennai-campus-photo')), findsOneWidget);
    expect(find.byKey(const ValueKey('vit-chennai-logo')), findsOneWidget);
    expect(
      find.textContaining('Prototype preview'),
      findsWidgets,
    );
    expect(find.text('Report an issue'), findsOneWidget);
    expect(find.text('Plan a trip'), findsOneWidget);
    expect(find.text('Requests'), findsOneWidget);
    for (final label in ['Home', 'Hostel', 'Notices', 'Fees']) {
      expect(find.text(label), findsWidgets);
    }
    final hero = find.byType(Interactive3DSurface).first;
    final transform = find.descendant(
      of: hero,
      matching: find.byType(Transform),
    );
    expect(transform, findsOneWidget);

    await tester.tap(find.text('Report an issue'));
    await tester.pumpAndSettle();
    expect(find.text('New complaint'), findsOneWidget);
    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Explore campus services'));
    await tester.tap(find.text('Explore campus services'));
    await tester.pumpAndSettle();
    expect(find.text('Today’s mess menu'), findsOneWidget);
    await tester.tap(find.text('Home').first);
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Account and role settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preview warden view'));
    await tester.pumpAndSettle();
    expect(find.text('Triage'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Account and role settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use dark appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Account and role settings'));
    await tester.pumpAndSettle();
    expect(find.text('Use light appearance'), findsOneWidget);
  });

  testWidgets('prototype preview account menu can return to sign in',
      (tester) async {
    var exitedPreview = false;
    await tester.pumpWidget(
      NestMateApp(onExitPreview: () => exitedPreview = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Account and role settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Return to sign in'));
    await tester.pumpAndSettle();

    expect(exitedPreview, isTrue);
  });

  testWidgets('interactive 3D surface tilts while pressed', (tester) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _testApp(
        Center(
          child: SizedBox(
            width: 320,
            height: 220,
            child: const Interactive3DSurface(
              child: ColoredBox(color: Color(0xFF002147)),
            ),
          ),
        ),
      ),
    );
    final surface = find.byType(Interactive3DSurface);
    final animated = find.descendant(
      of: surface,
      matching: find.byType(AnimatedContainer),
    );
    final before =
        tester.widget<AnimatedContainer>(animated).transform!.storage.toList();
    final pointer = await tester.startGesture(
      tester.getCenter(surface) + const Offset(40, 24),
    );
    await tester.pump(const Duration(milliseconds: 220));
    final duringPress =
        tester.widget<AnimatedContainer>(animated).transform!.storage.toList();
    expect(duringPress, isNot(equals(before)));
    await pointer.up();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('interactive 3D surface tilts with mouse movement', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _testApp(
        Center(
          child: SizedBox(
            width: 320,
            height: 220,
            child: const Interactive3DSurface(
              child: ColoredBox(color: Color(0xFF002147)),
            ),
          ),
        ),
      ),
    );
    final surface = find.byType(Interactive3DSurface);
    final animated = find.descendant(
      of: surface,
      matching: find.byType(AnimatedContainer),
    );
    final before =
        tester.widget<AnimatedContainer>(animated).transform!.storage.toList();
    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await pointer.addPointer(location: tester.getCenter(surface));
    await pointer.moveTo(tester.getCenter(surface) + const Offset(40, 24));
    await tester.pump(const Duration(milliseconds: 220));
    final after =
        tester.widget<AnimatedContainer>(animated).transform!.storage.toList();
    expect(after, isNot(equals(before)));
    await pointer.removePointer();
    await tester.pumpAndSettle();
  });

  testWidgets('complaint form lays out without overflow at 200% text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: ComplaintForm(repository: MockPortalRepository()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('portal screens remain usable at 200% text scale', (
    tester,
  ) async {
    _useMobileTestViewport(tester);
    final repositories = PortalRepositories.mock();
    final request = (await repositories.resident.requests()).first;
    final accountButton = const SizedBox.shrink();
    final screens = <Widget>[
      HomeScreen(
        repositories: repositories,
        onOpenRequests: () {},
        onOpenHostel: () {},
        onOpenNotices: () {},
        onOpenFees: () {},
        accountButton: accountButton,
      ),
      RequestsScreen(repositories: repositories, accountButton: accountButton),
      HostelScreen(repositories: repositories, accountButton: accountButton),
      NoticesScreen(
        repository: repositories.notices,
        accountButton: accountButton,
      ),
      FeesScreen(repository: repositories.fees, accountButton: accountButton),
      TriageScreen(repositories: repositories, accountButton: accountButton),
      OutpassForm(repository: repositories.resident),
      TriageDetail(repository: repositories.warden, request: request),
    ];

    for (final screen in screens) {
      await tester.pumpWidget(
        CupertinoApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: screen,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$screen overflowed');
    }
  });
}

void _useTallTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _useMobileTestViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _testApp(Widget child) =>
    CupertinoApp(theme: const CupertinoThemeData(), home: child);

class _PaymentRecorder implements FeeRepository {
  int paymentCount = 0;

  @override
  bool get supportsPayment => true;

  @override
  Future<FeeAccount> account() async => FeeAccount(
        totalDue: 18500,
        dueDate: DateTime(2026, 10, 25),
        reference: 'FEE-2026-10',
      );

  @override
  Future<void> payOutstanding() async {
    paymentCount++;
  }
}

class _FailOnceResidentRepository extends MockPortalRepository {
  int _attempts = 0;

  @override
  Future<void> submitComplaint({
    required ComplaintCategory category,
    required String title,
    required String details,
  }) async {
    if (_attempts++ == 0) throw StateError('temporary service issue');
    await super.submitComplaint(
      category: category,
      title: title,
      details: details,
    );
  }
}

class _FailOncePaymentRepository extends _PaymentRecorder {
  @override
  Future<void> payOutstanding() async {
    paymentCount++;
    if (paymentCount == 1) throw StateError('temporary payment issue');
  }
}

class _RecordingHostelRepository extends MockPortalRepository {
  String? feedback;
  bool laundryRequested = false;

  @override
  Future<void> sendMealFeedback(String message) async {
    feedback = message;
  }

  @override
  Future<void> requestLaundryPickup(String instructions) async {
    laundryRequested = true;
  }
}
