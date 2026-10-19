import 'models.dart';

abstract interface class ResidentRepository {
  Future<List<ResidentRequest>> requests();
  Future<void> submitComplaint({
    required ComplaintCategory category,
    required String title,
    required String details,
  });
  Future<void> submitOutpass({
    required DateTime departure,
    required DateTime returnAt,
    required String reason,
  });
}

abstract interface class HostelRepository {
  Future<List<MenuItem>> menuFor(DateTime date);
  Future<void> sendMealFeedback(String message);
  Future<void> requestLaundryPickup(String instructions);
}

abstract interface class NoticeRepository {
  Future<List<PortalNotice>> notices();
}

abstract interface class FeeRepository {
  bool get supportsPayment;
  Future<FeeAccount> account();
  Future<void> payOutstanding();
}

abstract interface class WardenRepository {
  Future<List<ResidentRequest>> triageQueue();
  Future<void> updateRequest({
    required String requestId,
    required RequestStatus status,
    required String assignee,
  });
}

class PortalRepositories {
  const PortalRepositories({
    required this.resident,
    required this.hostel,
    required this.notices,
    required this.fees,
    required this.warden,
  });

  final ResidentRepository resident;
  final HostelRepository hostel;
  final NoticeRepository notices;
  final FeeRepository fees;
  final WardenRepository warden;

  factory PortalRepositories.mock() {
    final mock = MockPortalRepository();
    return PortalRepositories(
      resident: mock,
      hostel: mock,
      notices: mock,
      fees: mock,
      warden: mock,
    );
  }
}

class MockPortalRepository
    implements
        ResidentRepository,
        HostelRepository,
        NoticeRepository,
        FeeRepository,
        WardenRepository {
  MockPortalRepository({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final List<ResidentRequest> _requests = [
    ResidentRequest(
      id: 'NM-2048',
      title: 'Study room ceiling light',
      details: 'The light above desk 4 is flickering.',
      status: RequestStatus.inProgress,
      createdAt: DateTime(2026, 10, 16),
      category: ComplaintCategory.maintenance,
    ),
    ResidentRequest(
      id: 'NM-2042',
      title: 'Weekend family visit',
      details: 'Visiting home with family.',
      status: RequestStatus.inReview,
      createdAt: DateTime(2026, 10, 14),
      departure: DateTime(2026, 10, 19),
      returnAt: DateTime(2026, 10, 20),
    ),
  ];

  @override
  Future<List<ResidentRequest>> requests() async =>
      List.unmodifiable(_requests);

  @override
  Future<void> submitComplaint({
    required ComplaintCategory category,
    required String title,
    required String details,
  }) async {
    _requests.insert(
      0,
      ResidentRequest(
        id: 'NM-${2100 + _requests.length}',
        title: title,
        details: details,
        status: RequestStatus.submitted,
        createdAt: _clock(),
        category: category,
      ),
    );
  }

  @override
  Future<void> submitOutpass({
    required DateTime departure,
    required DateTime returnAt,
    required String reason,
  }) async {
    _requests.insert(
      0,
      ResidentRequest(
        id: 'NM-${2100 + _requests.length}',
        title: 'Outpass request',
        details: reason,
        status: RequestStatus.submitted,
        createdAt: _clock(),
        departure: departure,
        returnAt: returnAt,
      ),
    );
  }

  @override
  Future<List<MenuItem>> menuFor(DateTime date) async => const [
        MenuItem('Vegetable pulao', 'Fresh herbs · Mild'),
        MenuItem('Dal tadka', 'Yellow lentils · Vegan'),
        MenuItem('Cucumber raita', 'Contains dairy'),
        MenuItem('Seasonal fruit', 'Today’s selection'),
      ];

  @override
  Future<void> sendMealFeedback(String message) async {}

  @override
  Future<void> requestLaundryPickup(String instructions) async {}

  @override
  Future<List<PortalNotice>> notices() async => [
        PortalNotice(
          title: 'Water maintenance, Block B',
          body:
              'Water supply will pause from 2–3 pm tomorrow for scheduled tank cleaning.',
          date: DateTime(2026, 10, 18),
          urgent: true,
        ),
        PortalNotice(
          title: 'Festival dinner this Friday',
          body:
              'Join the community dinner in the courtyard at 7 pm. Please RSVP at reception.',
          date: DateTime(2026, 10, 17),
        ),
        PortalNotice(
          title: 'Quiet hours reminder',
          body:
              'Quiet hours begin at 10 pm in residential wings. Thank you for looking out for one another.',
          date: DateTime(2026, 10, 15),
        ),
      ];

  @override
  bool get supportsPayment => true;

  @override
  Future<FeeAccount> account() async => FeeAccount(
        totalDue: 18500,
        dueDate: DateTime(2026, 10, 25),
        reference: 'FEE-2026-10',
      );

  @override
  Future<void> payOutstanding() async {}

  @override
  Future<List<ResidentRequest>> triageQueue() async => List.unmodifiable(
        _requests.where((item) => item.status != RequestStatus.resolved),
      );

  @override
  Future<void> updateRequest({
    required String requestId,
    required RequestStatus status,
    required String assignee,
  }) async {
    final index = _requests.indexWhere((item) => item.id == requestId);
    if (index < 0) throw StateError('Request $requestId was not found.');
    final item = _requests[index];
    _requests[index] = ResidentRequest(
      id: item.id,
      title: item.title,
      details: item.details,
      status: status,
      createdAt: item.createdAt,
      category: item.category,
      departure: item.departure,
      returnAt: item.returnAt,
      assignee: assignee,
    );
  }
}
