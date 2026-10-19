import 'package:cloud_firestore/cloud_firestore.dart';

import 'models.dart';
import 'repositories.dart';

class FirebasePortalRepositories {
  FirebasePortalRepositories._(FirestorePortalRepository repository)
      : repositories = PortalRepositories(
          resident: repository,
          hostel: repository,
          notices: repository,
          fees: repository,
          warden: repository,
        );

  final PortalRepositories repositories;

  factory FirebasePortalRepositories.forUser(String uid) =>
      FirebasePortalRepositories._(FirestorePortalRepository(uid));
}

class FirestorePortalRepository
    implements
        ResidentRepository,
        HostelRepository,
        NoticeRepository,
        FeeRepository,
        WardenRepository {
  FirestorePortalRepository(
    this.uid, {
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('requests');

  @override
  Future<List<ResidentRequest>> requests() async {
    final snapshot =
        await _requests.where('ownerId', isEqualTo: uid).limit(100).get();
    return snapshot.docs.map(_requestFromDocument).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> submitComplaint({
    required ComplaintCategory category,
    required String title,
    required String details,
  }) async {
    await _requests.add({
      'ownerId': uid,
      'type': 'complaint',
      'title': title,
      'details': details,
      'category': category.name,
      'status': RequestStatus.submitted.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> submitOutpass({
    required DateTime departure,
    required DateTime returnAt,
    required String reason,
  }) async {
    await _requests.add({
      'ownerId': uid,
      'type': 'outpass',
      'title': 'Outpass request',
      'details': reason,
      'departure': Timestamp.fromDate(departure),
      'returnAt': Timestamp.fromDate(returnAt),
      'status': RequestStatus.submitted.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<MenuItem>> menuFor(DateTime date) async {
    final snapshot =
        await _firestore.collection('menus').doc(_dateKey(date)).get();
    final rawItems = snapshot.data()?['items'];
    if (!snapshot.exists || rawItems == null) return const [];
    if (rawItems is! List) {
      throw const FormatException('Menu items must be a list.');
    }
    return rawItems.map((raw) {
      if (raw is! Map<String, dynamic> ||
          raw['name'] is! String ||
          raw['note'] is! String) {
        throw const FormatException('Menu item data is invalid.');
      }
      return MenuItem(raw['name'] as String, raw['note'] as String);
    }).toList();
  }

  @override
  Future<void> sendMealFeedback(String message) async {
    await _firestore.collection('mealFeedback').add({
      'ownerId': uid,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> requestLaundryPickup(String instructions) async {
    await _firestore.collection('laundryRequests').add({
      'ownerId': uid,
      'instructions': instructions,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<PortalNotice>> notices() async {
    final snapshot = await _firestore
        .collection('notices')
        .where('published', isEqualTo: true)
        .limit(100)
        .get();
    return snapshot.docs.map((document) {
      final data = document.data();
      return PortalNotice(
        title: _requiredString(data, 'title'),
        body: _requiredString(data, 'body'),
        date: _requiredTimestamp(data, 'date'),
        urgent: data['urgent'] == true,
      );
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  bool get supportsPayment => false;

  @override
  Future<FeeAccount> account() async {
    final snapshot = await _firestore.collection('feeAccounts').doc(uid).get();
    final data = snapshot.data();
    if (data == null) throw StateError('Fee account is not available.');
    final amount = data['totalDue'];
    if (amount is! int || amount < 0) {
      throw const FormatException('Fee account amount is invalid.');
    }
    return FeeAccount(
      totalDue: amount,
      dueDate: _requiredTimestamp(data, 'dueDate'),
      reference: _requiredString(data, 'reference'),
    );
  }

  @override
  Future<void> payOutstanding() =>
      throw UnsupportedError('Online payment has not been configured.');

  @override
  Future<List<ResidentRequest>> triageQueue() async {
    final snapshot = await _requests
        .where('status', isNotEqualTo: 'resolved')
        .limit(100)
        .get();
    return snapshot.docs.map(_requestFromDocument).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> updateRequest({
    required String requestId,
    required RequestStatus status,
    required String assignee,
  }) async {
    await _requests.doc(requestId).update({
      'status': status.name,
      'assignee': assignee,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  ResidentRequest _requestFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final status = RequestStatus.values.byName(_requiredString(data, 'status'));
    final categoryName = data['category'];
    final category = categoryName == null
        ? null
        : ComplaintCategory.values.byName(categoryName as String);
    return ResidentRequest(
      id: document.id,
      title: _requiredString(data, 'title'),
      details: _requiredString(data, 'details'),
      status: status,
      createdAt: _requiredTimestamp(data, 'createdAt'),
      category: category,
      departure: _optionalTimestamp(data, 'departure'),
      returnAt: _optionalTimestamp(data, 'returnAt'),
      assignee: data['assignee'] as String?,
    );
  }

  static DateTime _requiredTimestamp(
    Map<String, dynamic> data,
    String field,
  ) {
    final value = data[field];
    if (value is! Timestamp) {
      throw FormatException('Firestore field "$field" must be a timestamp.');
    }
    return value.toDate();
  }

  static DateTime? _optionalTimestamp(
    Map<String, dynamic> data,
    String field,
  ) {
    final value = data[field];
    if (value == null) return null;
    if (value is! Timestamp) {
      throw FormatException('Firestore field "$field" must be a timestamp.');
    }
    return value.toDate();
  }

  static String _requiredString(Map<String, dynamic> data, String field) {
    final value = data[field];
    if (value is! String || value.isEmpty) {
      throw FormatException(
          'Firestore field "$field" must be a non-empty string.');
    }
    return value;
  }

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
