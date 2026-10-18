import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nestmate_portal/data/models.dart';
import 'package:nestmate_portal/data/repositories.dart';
import 'package:nestmate_portal/features/resident_screens.dart';
import 'package:nestmate_portal/main.dart';

void main() {
  group('Complaint form', () {
    testWidgets(
      'requires category and fields, then confirms a successful submission',
      (tester) async {
        final repository = MockPortalRepository();
        await tester.pumpWidget(
          _testApp(ComplaintForm(repository: repository)),
        );

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
        await tester.tap(find.text('Submit complaint'));
        await tester.pumpAndSettle();

        expect(find.text('Your complaint is submitted.'), findsOneWidget);
        expect((await repository.requests()).first.title, 'Broken lamp');
      },
    );

    testWidgets('preserves the draft after a failed submission and can retry', (
      tester,
    ) async {
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

      await tester.tap(find.text('Submit complaint'));
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

      expect(find.text('Confirm payment'), findsOneWidget);
      expect(repository.paymentCount, 0);
      await tester.tap(find.text('Pay now'));
      await tester.pumpAndSettle();
      expect(repository.paymentCount, 1);
      expect(find.text('Payment confirmed'), findsOneWidget);
    });

    testWidgets('cancel does not invoke payment', (tester) async {
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
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(repository.paymentCount, 0);
      expect(find.text('Payment confirmed'), findsNothing);
    });

    testWidgets('allows retry when payment cannot be confirmed',
        (tester) async {
      final repository = _FailOncePaymentRepository();
      await tester.pumpWidget(
        _testApp(FeesScreen(
            repository: repository, accountButton: const SizedBox.shrink())),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay now'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Payment could not be confirmed.'),
          findsOneWidget);
      expect(find.text('Payment confirmed'), findsNothing);

      await tester.tap(find.text('Review and pay'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pay now'));
      await tester.pumpAndSettle();
      expect(find.text('Payment confirmed'), findsOneWidget);
    });
  });

  testWidgets('shows five role-aware tabs and supports switching to triage', (
    tester,
  ) async {
    await tester.pumpWidget(const NestMateApp());
    await tester.pumpAndSettle();
    expect(find.text('Requests'), findsOneWidget);
    for (final label in ['Home', 'Hostel', 'Notices', 'Fees']) {
      expect(find.text(label), findsWidgets);
    }
    await tester.tap(find.bySemanticsLabel('Account and role settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch to warden view'));
    await tester.pumpAndSettle();
    expect(find.text('Triage'), findsWidgets);
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

Widget _testApp(Widget child) =>
    CupertinoApp(theme: const CupertinoThemeData(), home: child);

class _PaymentRecorder implements FeeRepository {
  int paymentCount = 0;

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
