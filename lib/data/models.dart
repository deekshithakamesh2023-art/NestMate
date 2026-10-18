enum RequestStatus { submitted, inReview, inProgress, resolved, declined }

enum ComplaintCategory { maintenance, cleanliness, internet, safety, other }

extension ComplaintCategoryText on ComplaintCategory {
  String get label => switch (this) {
        ComplaintCategory.maintenance => 'Maintenance',
        ComplaintCategory.cleanliness => 'Cleanliness',
        ComplaintCategory.internet => 'Internet',
        ComplaintCategory.safety => 'Safety',
        ComplaintCategory.other => 'Other',
      };
}

extension RequestStatusText on RequestStatus {
  String get label => switch (this) {
        RequestStatus.submitted => 'Submitted',
        RequestStatus.inReview => 'In review',
        RequestStatus.inProgress => 'In progress',
        RequestStatus.resolved => 'Resolved',
        RequestStatus.declined => 'Declined',
      };
}

class ResidentRequest {
  const ResidentRequest({
    required this.id,
    required this.title,
    required this.details,
    required this.status,
    required this.createdAt,
    this.category,
    this.departure,
    this.returnAt,
    this.assignee,
  });

  final String id;
  final String title;
  final String details;
  final RequestStatus status;
  final DateTime createdAt;
  final ComplaintCategory? category;
  final DateTime? departure;
  final DateTime? returnAt;
  final String? assignee;
  bool get isOutpass => departure != null;
}

class PortalNotice {
  const PortalNotice({
    required this.title,
    required this.body,
    required this.date,
    this.urgent = false,
  });

  final String title;
  final String body;
  final DateTime date;
  final bool urgent;
}

class MenuItem {
  const MenuItem(this.name, this.note);
  final String name;
  final String note;
}

class FeeAccount {
  const FeeAccount({
    required this.totalDue,
    required this.dueDate,
    required this.reference,
  });

  final int totalDue;
  final DateTime dueDate;
  final String reference;
}
