import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../core/design_tokens.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../data/repositories.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.repositories,
    required this.onOpenRequests,
    required this.onOpenHostel,
    required this.onOpenNotices,
    required this.onOpenFees,
    required this.accountButton,
    super.key,
  });

  final PortalRepositories repositories;
  final VoidCallback onOpenRequests;
  final VoidCallback onOpenHostel;
  final VoidCallback onOpenNotices;
  final VoidCallback onOpenFees;
  final Widget accountButton;

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'NestMate',
        trailing: accountButton,
        child: PortalScroll(
          children: [
            Text(
              'Good morning, Aanya',
              style: TextStyle(
                color: context.primaryText,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PortalTokens.space1),
            Text(
              'Your home, taken care of.',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space5),
            PortalCard(
              onTap: onOpenRequests,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(CupertinoIcons.wrench, color: context.accent),
                      const SizedBox(width: PortalTokens.space2),
                      Expanded(
                        child: Text(
                          'Requests in progress',
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: context.secondaryText,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  Text(
                    'Track your hostel requests and outpasses in one place.',
                    style: TextStyle(color: context.secondaryText),
                  ),
                ],
              ),
            ),
            SectionHeading('Today at your hostel'),
            PortalCard(
              onTap: onOpenHostel,
              child: Row(
                children: [
                  Icon(CupertinoIcons.sun_max, color: context.warning),
                  const SizedBox(width: PortalTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lunch menu',
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Vegetable pulao · Dal tadka · Raita',
                          style: TextStyle(color: context.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: context.secondaryText,
                    size: 16,
                  ),
                ],
              ),
            ),
            PortalCard(
              onTap: onOpenNotices,
              child: Row(
                children: [
                  Icon(CupertinoIcons.bell, color: context.accent),
                  const SizedBox(width: PortalTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hostel notices',
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Water maintenance tomorrow, 2–3 pm',
                          style: TextStyle(color: context.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: context.secondaryText,
                    size: 16,
                  ),
                ],
              ),
            ),
            PortalCard(
              onTap: onOpenFees,
              child: Row(
                children: [
                  Icon(CupertinoIcons.creditcard, color: context.link),
                  const SizedBox(width: PortalTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fee reminder',
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'October balance due October 25',
                          style: TextStyle(color: context.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: context.secondaryText,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PortalTokens.space2),
            Text(
              'Need help? Submit a request and follow its status from Requests.',
              style: TextStyle(color: context.tertiaryText, fontSize: 14),
            ),
          ],
        ),
      );
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({
    required this.repositories,
    required this.accountButton,
    super.key,
  });
  final PortalRepositories repositories;
  final Widget accountButton;

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late Future<List<ResidentRequest>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = widget.repositories.resident.requests();
  }

  void _reload() =>
      setState(() => _requests = widget.repositories.resident.requests());

  Future<void> _open(Widget page) async {
    await Navigator.of(context)
        .push<void>(CupertinoPageRoute<void>(builder: (_) => page));
    _reload();
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Requests',
        trailing: widget.accountButton,
        child: PortalScroll(
          children: [
            Text(
              'A clear path from request to resolution.',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space4),
            PrimaryButton(
              label: 'New complaint',
              icon: CupertinoIcons.add,
              onPressed: () => _open(
                  ComplaintForm(repository: widget.repositories.resident)),
            ),
            const SizedBox(height: PortalTokens.space2),
            PrimaryButton(
              label: 'New outpass',
              icon: CupertinoIcons.paperplane,
              onPressed: () =>
                  _open(OutpassForm(repository: widget.repositories.resident)),
            ),
            const SectionHeading('Your requests'),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .52,
              child: LoadState<List<ResidentRequest>>(
                future: _requests,
                onRetry: _reload,
                builder: (context, items) => items.isEmpty
                    ? Center(
                        child: Text(
                          'No requests yet. When you need help, start with a complaint or outpass.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.secondaryText),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.zero,
                        children: items
                            .map((item) => RequestCard(request: item))
                            .toList(),
                      ),
              ),
            ),
          ],
        ),
      );
}

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, super.key});
  final ResidentRequest request;

  @override
  Widget build(BuildContext context) => PortalCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                StatusTag(request.status.label),
              ],
            ),
            const SizedBox(height: PortalTokens.space2),
            Text(
              '${request.id} · ${request.isOutpass ? 'Outpass' : request.category?.label ?? 'Complaint'}',
              style: TextStyle(color: context.secondaryText, fontSize: 14),
            ),
            const SizedBox(height: PortalTokens.space1),
            Text(request.details,
                style: TextStyle(color: context.secondaryText)),
          ],
        ),
      );
}

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({required this.repository, super.key});
  final ResidentRepository repository;

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final _title = TextEditingController();
  final _details = TextEditingController();
  ComplaintCategory? _category;
  bool _busy = false;
  String? _error;
  bool _submitted = false;

  @override
  void dispose() {
    _title.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_category == null ||
        _title.text.trim().isEmpty ||
        _details.text.trim().isEmpty) {
      setState(() => _error = 'Choose a category and complete both fields.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.submitComplaint(
        category: _category!,
        title: _title.text.trim(),
        details: _details.text.trim(),
      );
      HapticFeedback.mediumImpact();
      if (mounted) setState(() => _submitted = true);
    } catch (error) {
      if (mounted)
        setState(
          () => _error =
              'Your complaint wasn’t sent. Your draft is still here. $error',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: _submitted ? 'Complaint received' : 'New complaint',
        child: _submitted
            ? PortalScroll(
                children: [
                  const SizedBox(height: PortalTokens.space8),
                  Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    color: context.success,
                    size: 56,
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  Text(
                    'Your complaint is submitted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  Text(
                    'You can follow its status in Requests.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.secondaryText),
                  ),
                  const SizedBox(height: PortalTokens.space6),
                  PrimaryButton(
                    label: 'Done',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : PortalScroll(
                children: [
                  Text(
                    'Tell us what needs attention. Your details stay with the hostel team.',
                    style: TextStyle(color: context.secondaryText),
                  ),
                  const SizedBox(height: PortalTokens.space5),
                  Text(
                    'Category',
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  Wrap(
                    spacing: PortalTokens.space2,
                    runSpacing: PortalTokens.space2,
                    children: ComplaintCategory.values.map((category) {
                      final selected = _category == category;
                      return Semantics(
                        selected: selected,
                        child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PortalTokens.space3,
                          ),
                          minimumSize: const Size(0, PortalTokens.tapTarget),
                          color: selected ? context.accent : context.surface,
                          onPressed: () => setState(() => _category = category),
                          child: Text(
                            category.label,
                            style: TextStyle(
                              color: selected
                                  ? context.accentText
                                  : context.primaryText,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  LabeledField(
                    label: 'Title',
                    controller: _title,
                    hint: 'A short summary',
                    textInputAction: TextInputAction.next,
                  ),
                  LabeledField(
                    label: 'What happened?',
                    controller: _details,
                    hint: 'Add details to help us resolve it',
                    maxLines: 4,
                  ),
                  if (_error != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: PortalTokens.space3),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(color: context.error),
                        ),
                      ),
                    ),
                  PrimaryButton(
                    label: 'Submit complaint',
                    busy: _busy,
                    onPressed: _submit,
                  ),
                ],
              ),
      );
}

String? outpassDateError({
  required DateTime departure,
  required DateTime returnAt,
  required DateTime today,
}) {
  final start = DateTime(departure.year, departure.month, departure.day);
  final end = DateTime(returnAt.year, returnAt.month, returnAt.day);
  final minimum = DateTime(today.year, today.month, today.day);
  final maximum = minimum.add(const Duration(days: 30));
  if (start.isBefore(minimum) || start.isAfter(maximum)) {
    return 'Choose a departure date within the next 30 days.';
  }
  if (!end.isAfter(start)) return 'Return date must be after departure.';
  if (end.difference(start).inDays > 14) {
    return 'Outpass requests can be up to 14 nights.';
  }
  return null;
}

class OutpassForm extends StatefulWidget {
  const OutpassForm({required this.repository, super.key});
  final ResidentRepository repository;

  @override
  State<OutpassForm> createState() => _OutpassFormState();
}

class _OutpassFormState extends State<OutpassForm> {
  final _reason = TextEditingController();
  DateTime? _departure;
  DateTime? _returnAt;
  bool _busy = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _chooseDate({required bool departure}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final minimum =
        departure ? today : (_departure?.add(const Duration(days: 1)) ?? today);
    final maximum = departure
        ? today.add(const Duration(days: 30))
        : (_departure?.add(const Duration(days: 14)) ??
            today.add(const Duration(days: 44)));
    final initial = departure ? _departure : _returnAt;
    final selected = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => _DatePickerSheet(
        initial: initial ?? now,
        minimum: minimum,
        maximum: maximum,
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        if (departure) {
          _departure = selected;
        } else {
          _returnAt = selected;
        }
        _error = null;
      });
    }
  }

  Future<void> _submit() async {
    if (_departure == null ||
        _returnAt == null ||
        _reason.text.trim().isEmpty) {
      setState(() => _error = 'Choose both dates and add a reason.');
      return;
    }
    final dateError = outpassDateError(
      departure: _departure!,
      returnAt: _returnAt!,
      today: DateTime.now(),
    );
    if (dateError != null) {
      setState(() => _error = dateError);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.submitOutpass(
        departure: _departure!,
        returnAt: _returnAt!,
        reason: _reason.text.trim(),
      );
      HapticFeedback.mediumImpact();
      if (mounted) setState(() => _submitted = true);
    } catch (error) {
      if (mounted)
        setState(
          () => _error =
              'Your request wasn’t sent. Your draft is still here. $error',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: _submitted ? 'Outpass submitted' : 'New outpass',
        child: _submitted
            ? PortalScroll(
                children: [
                  const SizedBox(height: PortalTokens.space8),
                  Icon(
                    CupertinoIcons.checkmark_circle_fill,
                    color: context.success,
                    size: 56,
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  Text(
                    'Your outpass request is in review.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space6),
                  PrimaryButton(
                    label: 'Done',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : PortalScroll(
                children: [
                  Text(
                    'Choose dates within the next 30 days; return must be within 14 nights.',
                    style: TextStyle(color: context.secondaryText),
                  ),
                  const SizedBox(height: PortalTokens.space5),
                  _DateField(
                    label: 'Departure',
                    value: _departure == null
                        ? 'Select departure date'
                        : formatDate(_departure!),
                    onTap: () => _chooseDate(departure: true),
                  ),
                  _DateField(
                    label: 'Return',
                    value: _returnAt == null
                        ? 'Select return date'
                        : formatDate(_returnAt!),
                    onTap: () => _chooseDate(departure: false),
                  ),
                  LabeledField(
                    label: 'Reason',
                    controller: _reason,
                    hint: 'Why are you requesting an outpass?',
                    maxLines: 3,
                  ),
                  if (_error != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: PortalTokens.space3),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(color: context.error),
                        ),
                      ),
                    ),
                  PrimaryButton(
                    label: 'Submit outpass',
                    busy: _busy,
                    onPressed: _submit,
                  ),
                ],
              ),
      );
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: PortalTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: PortalTokens.space2),
              child: Text(
                label,
                style: TextStyle(
                  color: context.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                minimumSize: const Size(0, PortalTokens.tapTarget),
                color: context.surface,
                onPressed: onTap,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.calendar, color: context.accent),
                    const SizedBox(width: PortalTokens.space3),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(color: context.primaryText),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      color: context.secondaryText,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet({
    required this.initial,
    required this.minimum,
    required this.maximum,
  });
  final DateTime initial;
  final DateTime minimum;
  final DateTime maximum;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _selected = widget.initial.isBefore(widget.minimum)
      ? widget.minimum
      : widget.initial.isAfter(widget.maximum)
          ? widget.maximum
          : widget.initial;

  @override
  Widget build(BuildContext context) => Container(
        height: 340,
        color: context.surface,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: const Text('Choose'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selected,
                  minimumDate: widget.minimum,
                  maximumDate: widget.maximum,
                  onDateTimeChanged: (value) =>
                      setState(() => _selected = value),
                ),
              ),
            ],
          ),
        ),
      );
}

class HostelScreen extends StatefulWidget {
  const HostelScreen({
    required this.repositories,
    required this.accountButton,
    super.key,
  });
  final PortalRepositories repositories;
  final Widget accountButton;

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  late Future<List<MenuItem>> _menu;
  final _feedback = TextEditingController();
  bool _busy = false;
  String? _message;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _menu = widget.repositories.hostel.menuFor(DateTime.now());
  }

  @override
  void dispose() {
    _feedback.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    if (_feedback.text.trim().isEmpty) {
      setState(() {
        _message = 'Add a note before sending feedback.';
        _isError = true;
      });
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await widget.repositories.hostel.sendMealFeedback(_feedback.text.trim());
      HapticFeedback.selectionClick();
      if (!mounted) return;
      setState(() {
        _feedback.clear();
        _message = 'Thanks. Your meal feedback has been shared.';
        _isError = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = 'Feedback wasn’t sent. Please try again. $error';
          _isError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _requestLaundry() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await widget.repositories.hostel.requestLaundryPickup('');
      HapticFeedback.mediumImpact();
      if (mounted) {
        setState(() {
          _message =
              'Laundry pickup requested for today. Please leave your bag at reception.';
          _isError = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = 'Pickup wasn’t requested. Please try again. $error';
          _isError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Hostel',
        trailing: widget.accountButton,
        child: PortalScroll(
          children: [
            Text(
              'Everyday essentials, all in one place.',
              style: TextStyle(color: context.secondaryText),
            ),
            const SectionHeading('Today’s mess menu'),
            LoadState<List<MenuItem>>(
              future: _menu,
              onRetry: () => setState(
                () =>
                    _menu = widget.repositories.hostel.menuFor(DateTime.now()),
              ),
              builder: (context, menu) => menu.isEmpty
                  ? PortalCard(
                      child: Text(
                        'No menu posted for today yet.',
                        style: TextStyle(color: context.secondaryText),
                      ),
                    )
                  : Column(
                      children: menu
                          .map(
                            (item) => PortalCard(
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.circle_fill,
                                    color: context.accent,
                                    size: 10,
                                  ),
                                  const SizedBox(width: PortalTokens.space3),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            color: context.primaryText,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.note,
                                          style: TextStyle(
                                            color: context.secondaryText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
            const SectionHeading('Meal feedback'),
            LabeledField(
              label: 'Tell us how it was',
              controller: _feedback,
              hint: 'What worked well or could improve?',
              maxLines: 3,
            ),
            PrimaryButton(
              label: 'Send feedback',
              busy: _busy,
              onPressed: _sendFeedback,
            ),
            const SectionHeading('Laundry pickup'),
            PortalCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pickup from reception today',
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space1),
                  Text(
                    'Pickup window 6–8 pm · Keep your tagged bag at reception.',
                    style: TextStyle(color: context.secondaryText),
                  ),
                  const SizedBox(height: PortalTokens.space3),
                  PrimaryButton(
                    label: 'Request pickup',
                    busy: _busy,
                    onPressed: _requestLaundry,
                  ),
                ],
              ),
            ),
            if (_message != null)
              Semantics(
                liveRegion: true,
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _isError ? context.error : context.success,
                  ),
                ),
              ),
          ],
        ),
      );
}

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({
    required this.repository,
    required this.accountButton,
    super.key,
  });
  final NoticeRepository repository;
  final Widget accountButton;

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  late Future<List<PortalNotice>> _notices;
  @override
  void initState() {
    super.initState();
    _notices = widget.repository.notices();
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Notices',
        trailing: widget.accountButton,
        child: PortalScroll(
          children: [
            Text(
              'Updates from your hostel team.',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space3),
            LoadState<List<PortalNotice>>(
              future: _notices,
              onRetry: () =>
                  setState(() => _notices = widget.repository.notices()),
              builder: (context, notices) => notices.isEmpty
                  ? Center(
                      child: Text(
                        'You’re all caught up.',
                        style: TextStyle(color: context.secondaryText),
                      ),
                    )
                  : Column(
                      children: notices
                          .map(
                            (notice) => PortalCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (notice.urgent)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: PortalTokens.space2,
                                      ),
                                      child: StatusTag(
                                        'Important',
                                        color: context.warning,
                                      ),
                                    ),
                                  Text(
                                    notice.title,
                                    style: TextStyle(
                                      color: context.primaryText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: PortalTokens.space2),
                                  Text(
                                    notice.body,
                                    style:
                                        TextStyle(color: context.secondaryText),
                                  ),
                                  const SizedBox(height: PortalTokens.space2),
                                  Text(
                                    formatDate(notice.date),
                                    style: TextStyle(
                                      color: context.tertiaryText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      );
}

class FeesScreen extends StatefulWidget {
  const FeesScreen({
    required this.repository,
    required this.accountButton,
    super.key,
  });
  final FeeRepository repository;
  final Widget accountButton;

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  late Future<FeeAccount> _account;
  bool _busy = false;
  String? _paymentError;
  bool _paid = false;

  @override
  void initState() {
    super.initState();
    _account = widget.repository.account();
  }

  Future<void> _confirmPayment(FeeAccount account) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm payment'),
        content: Text(
          'Pay ₹${account.totalDue} toward your hostel fees? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Pay now'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _paymentError = null;
    });
    try {
      await widget.repository.payOutstanding();
      HapticFeedback.mediumImpact();
      if (mounted) setState(() => _paid = true);
    } catch (error) {
      if (mounted) {
        setState(
          () => _paymentError =
              'Payment could not be confirmed. No success receipt was created. Try again or contact the hostel office. $error',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Fees',
        trailing: widget.accountButton,
        child: PortalScroll(
          children: [
            Text(
              'Your fee account',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space3),
            LoadState<FeeAccount>(
              future: _account,
              onRetry: () =>
                  setState(() => _account = widget.repository.account()),
              builder: (context, account) => _paid
                  ? PortalCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.checkmark_circle_fill,
                            color: context.success,
                            size: 36,
                          ),
                          const SizedBox(height: PortalTokens.space3),
                          Text(
                            'Payment confirmed',
                            style: TextStyle(
                              color: context.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Reference ${account.reference}',
                            style: TextStyle(color: context.secondaryText),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PortalCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Outstanding balance',
                                style: TextStyle(color: context.secondaryText),
                              ),
                              const SizedBox(height: PortalTokens.space2),
                              Text(
                                '₹${account.totalDue}',
                                style: TextStyle(
                                  color: context.primaryText,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: PortalTokens.space3),
                              StatusTag(
                                'Due ${formatDate(account.dueDate)}',
                                color: context.warning,
                              ),
                              const SizedBox(height: PortalTokens.space3),
                              Text(
                                'Reference ${account.reference}',
                                style: TextStyle(color: context.tertiaryText),
                              ),
                            ],
                          ),
                        ),
                        if (_paymentError != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: PortalTokens.space3,
                            ),
                            child: Semantics(
                              liveRegion: true,
                              child: Text(
                                _paymentError!,
                                style: TextStyle(color: context.error),
                              ),
                            ),
                          ),
                        PrimaryButton(
                          label: 'Review and pay',
                          icon: CupertinoIcons.lock,
                          busy: _busy,
                          onPressed: () => _confirmPayment(account),
                        ),
                        const SizedBox(height: PortalTokens.space3),
                        Text(
                          'You’ll confirm the amount before payment. Don’t retry if your bank shows a pending charge; contact the office so it can be checked.',
                          style: TextStyle(
                            color: context.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      );
}

class TriageScreen extends StatefulWidget {
  const TriageScreen({
    required this.repositories,
    required this.accountButton,
    super.key,
  });
  final PortalRepositories repositories;
  final Widget accountButton;

  @override
  State<TriageScreen> createState() => _TriageScreenState();
}

class _TriageScreenState extends State<TriageScreen> {
  late Future<List<ResidentRequest>> _queue;

  @override
  void initState() {
    super.initState();
    _queue = widget.repositories.warden.triageQueue();
  }

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Triage',
        trailing: widget.accountButton,
        child: PortalScroll(
          children: [
            Text(
              'Review new requests and keep residents informed.',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space3),
            LoadState<List<ResidentRequest>>(
              future: _queue,
              onRetry: () => setState(
                  () => _queue = widget.repositories.warden.triageQueue()),
              builder: (context, requests) => requests.isEmpty
                  ? Center(
                      child: Text(
                        'The queue is clear.',
                        style: TextStyle(color: context.secondaryText),
                      ),
                    )
                  : Column(
                      children: requests
                          .map(
                            (request) => PortalCard(
                              onTap: () {
                                Navigator.of(context)
                                    .push<void>(
                                  CupertinoPageRoute<void>(
                                    builder: (_) => TriageDetail(
                                      repository: widget.repositories.warden,
                                      request: request,
                                    ),
                                  ),
                                )
                                    .then((_) {
                                  if (mounted)
                                    setState(
                                      () => _queue = widget.repositories.warden
                                          .triageQueue(),
                                    );
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          request.title,
                                          style: TextStyle(
                                            color: context.primaryText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '${request.id} · ${request.isOutpass ? 'Outpass' : request.category?.label ?? 'Complaint'}',
                                          style: TextStyle(
                                            color: context.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: PortalTokens.space2),
                                  StatusTag(request.status.label),
                                  Icon(
                                    CupertinoIcons.chevron_right,
                                    color: context.secondaryText,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      );
}

class TriageDetail extends StatefulWidget {
  const TriageDetail({
    required this.repository,
    required this.request,
    super.key,
  });
  final WardenRepository repository;
  final ResidentRequest request;

  @override
  State<TriageDetail> createState() => _TriageDetailState();
}

class _TriageDetailState extends State<TriageDetail> {
  late RequestStatus _status = widget.request.status;
  late String? _assignee = widget.request.assignee;
  bool _busy = false;
  String? _error;
  String? _saved;

  @override
  Widget build(BuildContext context) => PortalScaffold(
        title: 'Request details',
        child: PortalScroll(
          children: [
            Text(
              widget.request.title,
              style: TextStyle(
                color: context.primaryText,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PortalTokens.space2),
            Text(
              '${widget.request.id} · ${widget.request.isOutpass ? 'Outpass' : widget.request.category?.label ?? 'Complaint'}',
              style: TextStyle(color: context.secondaryText),
            ),
            const SizedBox(height: PortalTokens.space4),
            PortalCard(
              child: Text(
                widget.request.details,
                style: TextStyle(color: context.primaryText),
              ),
            ),
            const SectionHeading('Update request'),
            _ChoiceField<RequestStatus>(
              label: 'Status',
              value: _status.label,
              options: RequestStatus.values
                  .map((status) => (status.label, status))
                  .toList(),
              onChanged: (value) => setState(() => _status = value),
            ),
            _ChoiceField<String>(
              label: 'Assign to',
              value: _assignee ?? 'Choose a staff member',
              options: const [
                ('Facilities team', 'Facilities team'),
                ('Housekeeping team', 'Housekeeping team'),
                ('Warden on duty', 'Warden on duty'),
              ],
              onChanged: (value) => setState(() => _assignee = value),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: PortalTokens.space3),
                child: Semantics(
                  liveRegion: true,
                  child: Text(_error!, style: TextStyle(color: context.error)),
                ),
              ),
            if (_saved != null)
              Padding(
                padding: const EdgeInsets.only(bottom: PortalTokens.space3),
                child: Semantics(
                  liveRegion: true,
                  child:
                      Text(_saved!, style: TextStyle(color: context.success)),
                ),
              ),
            PrimaryButton(label: 'Save update', busy: _busy, onPressed: _save),
          ],
        ),
      );

  Future<void> _save() async {
    if (_assignee == null) {
      setState(() => _error = 'Choose an assignee before saving.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _saved = null;
    });
    try {
      await widget.repository.updateRequest(
        requestId: widget.request.id,
        status: _status,
        assignee: _assignee!,
      );
      HapticFeedback.selectionClick();
      if (mounted)
        setState(() => _saved = 'Update saved for ${widget.request.id}.');
    } catch (error) {
      if (mounted)
        setState(
          () => _error =
              'Update couldn’t be saved. Your changes are still here. $error',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _ChoiceField<T> extends StatelessWidget {
  const _ChoiceField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<(String, T)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: PortalTokens.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: PortalTokens.space2),
              child: Text(
                label,
                style: TextStyle(
                  color: context.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                minimumSize: const Size(0, PortalTokens.tapTarget),
                color: context.surface,
                onPressed: () => showCupertinoModalPopup<void>(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: Text(label),
                    actions: options
                        .map(
                          (option) => CupertinoActionSheetAction(
                            onPressed: () {
                              onChanged(option.$2);
                              Navigator.of(context).pop();
                            },
                            child: Text(option.$1),
                          ),
                        )
                        .toList(),
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(color: context.primaryText),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: context.secondaryText,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
