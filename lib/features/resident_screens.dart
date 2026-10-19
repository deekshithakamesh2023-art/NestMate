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
        title: 'VIT  ·  NESTMATE',
        trailing: accountButton,
        child: PortalScroll(
          children: [
            const Eyebrow('VIT CHENNAI  ·  RESIDENT LIFE'),
            const SizedBox(height: PortalTokens.space2),
            const DisplayText(
              'A good day\nstarts at home.',
              fontSize: 36,
            ),
            const SizedBox(height: PortalTokens.space2),
            Text(
              'The little details that make hostel life easier.',
              style: TextStyle(
                color: context.secondaryText,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: PortalTokens.space4),
            _CampusWelcome(onOpenHostel: onOpenHostel),
            SectionHeading(
              'Make today easier',
              action: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size(44, 44),
                onPressed: onOpenRequests,
                child: const Text('All requests'),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _HomeActionCard(
                    icon: CupertinoIcons.wrench,
                    title: 'Report an issue',
                    subtitle: 'Repairs & support',
                    onTap: onOpenRequests,
                  ),
                ),
                const SizedBox(width: PortalTokens.space3),
                Expanded(
                  child: _HomeActionCard(
                    icon: CupertinoIcons.airplane,
                    title: 'Plan a trip',
                    subtitle: 'Request an outpass',
                    onTap: onOpenRequests,
                  ),
                ),
              ],
            ),
            const SectionHeading('Your campus menu'),
            Row(
              children: [
                Expanded(
                  child: _CampusMenuButton(
                    icon: CupertinoIcons.doc_text,
                    label: 'Requests',
                    onTap: onOpenRequests,
                  ),
                ),
                Expanded(
                  child: _CampusMenuButton(
                    icon: CupertinoIcons.building_2_fill,
                    label: 'Hostel',
                    onTap: onOpenHostel,
                  ),
                ),
                Expanded(
                  child: _CampusMenuButton(
                    icon: CupertinoIcons.bell,
                    label: 'Notices',
                    onTap: onOpenNotices,
                  ),
                ),
                Expanded(
                  child: _CampusMenuButton(
                    icon: CupertinoIcons.creditcard,
                    label: 'Fees',
                    onTap: onOpenFees,
                  ),
                ),
              ],
            ),
            const SectionHeading('Life at your residence'),
            PortalCard(
              onTap: onOpenHostel,
              child: Row(
                children: [
                  _RoundIcon(
                      icon: CupertinoIcons.sun_max, color: context.warning),
                  const SizedBox(width: PortalTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('FROM THE MESS'),
                        const SizedBox(height: PortalTokens.space1),
                        Text(
                          'A table for today',
                          style: TextStyle(
                              fontFamily: 'sans-serif',
                              color: context.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
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
                  _RoundIcon(icon: CupertinoIcons.bell, color: context.accent),
                  const SizedBox(width: PortalTokens.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('CAMPUS UPDATE'),
                        const SizedBox(height: PortalTokens.space1),
                        Text(
                          'Water maintenance tomorrow',
                          style: TextStyle(
                              fontFamily: 'sans-serif',
                              color: context.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Block B · 2–3 pm',
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
            CupertinoButton(
              padding:
                  const EdgeInsets.symmetric(vertical: PortalTokens.space3),
              alignment: Alignment.centerLeft,
              onPressed: onOpenFees,
              child: Row(
                children: [
                  Icon(CupertinoIcons.creditcard,
                      color: context.link, size: 20),
                  const SizedBox(width: PortalTokens.space2),
                  Expanded(
                    child: Text(
                      'Your VIT hostel balance is due October 25',
                      style: TextStyle(
                          color: context.link, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(CupertinoIcons.arrow_up_right,
                      color: context.link, size: 16),
                ],
              ),
            ),
            const SizedBox(height: PortalTokens.space2),
            Text(
              'Learn here. Live well here.',
              style: TextStyle(
                  fontFamily: 'sans-serif',
                  fontStyle: FontStyle.italic,
                  color: context.tertiaryText,
                  fontSize: 17),
            ),
          ],
        ),
      );
}

class _CampusMenuButton extends StatelessWidget {
  const _CampusMenuButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: label,
        onTap: onTap,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: PortalTokens.space2),
            child: Column(
              children: [
                Interactive3DSurface(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: PortalTokens.vitGold.withValues(alpha: .7),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: PortalTokens.vitNavy.withValues(alpha: .12),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: PortalTokens.vitNavy,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: PortalTokens.space1),
                Text(
                  label,
                  style: TextStyle(
                    color: context.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => PortalCard(
        onTap: onTap,
        padding: const EdgeInsets.all(PortalTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: PortalTokens.vitGold.withValues(alpha: .28),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.primaryText, size: 20),
            ),
            const SizedBox(height: PortalTokens.space3),
            Text(
              title,
              style: TextStyle(
                color: context.primaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PortalTokens.space1),
            Text(
              subtitle,
              style: TextStyle(
                color: context.secondaryText,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
}

class _CampusWelcome extends StatelessWidget {
  const _CampusWelcome({required this.onOpenHostel});
  final VoidCallback onOpenHostel;

  @override
  Widget build(BuildContext context) => Interactive3DSurface(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PortalTokens.radiusLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 330),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/vit_chennai_campus.png',
                    key: const ValueKey('vit-chennai-campus-photo'),
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, .42),
                    semanticLabel: 'VIT Chennai campus entrance',
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF002147).withValues(alpha: .76),
                          const Color(0xFF002147).withValues(alpha: .45),
                          const Color(0xFF002147).withValues(alpha: .84),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Eyebrow(
                              'VIT CHENNAI  ·  STUDENT RESIDENCE',
                              color: PortalTokens.vitGold,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ColoredBox(
                              color: const Color(0xFFFFFFFF),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  'assets/images/vit_chennai_logo.png',
                                  key: const ValueKey('vit-chennai-logo'),
                                  width: 112,
                                  height: 68,
                                  fit: BoxFit.contain,
                                  semanticLabel: 'VIT Chennai logo',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.textScalerOf(context).scale(52),
                      ),
                      const DisplayText(
                        'Your campus.\nYour home.',
                        color: Color(0xFFFFFFFF),
                        fontSize: 38,
                      ),
                      const SizedBox(height: PortalTokens.space2),
                      const Text(
                        'Classes, community, and everything in between.',
                        style: TextStyle(color: Color(0xFFE0EAF5), height: 1.5),
                      ),
                      const SizedBox(height: PortalTokens.space4),
                      CupertinoButton(
                        minimumSize: const Size(48, 48),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        color: PortalTokens.vitGold,
                        onPressed: onOpenHostel,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Flexible(
                              child: Text(
                                'Explore campus services',
                                style: TextStyle(
                                  color: Color(0xFF002147),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: PortalTokens.space2),
                            const Icon(
                              CupertinoIcons.arrow_right,
                              color: Color(0xFF002147),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PortalTokens.space5),
              decoration: BoxDecoration(
                color: PortalTokens.vitNavy,
                borderRadius: BorderRadius.circular(PortalTokens.radiusLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Eyebrow(
                    'RESIDENT CARE DESK',
                    color: PortalTokens.vitGold,
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  const DisplayText(
                    'A little help,\nwhen you need it.',
                    color: Color(0xFFFFFFFF),
                    fontSize: 30,
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  const Text(
                    'Repairs and time away, tracked in one place.',
                    style: TextStyle(color: Color(0xFFE0EAF5)),
                  ),
                ],
              ),
            ),
            const SectionHeading('What do you need?'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RequestActionTile(
                    icon: CupertinoIcons.wrench_fill,
                    title: 'New complaint',
                    detail: 'Something needs fixing',
                    onTap: () => _open(
                      ComplaintForm(repository: widget.repositories.resident),
                    ),
                  ),
                ),
                const SizedBox(width: PortalTokens.space3),
                Expanded(
                  child: _RequestActionTile(
                    icon: CupertinoIcons.airplane,
                    title: 'New outpass',
                    detail: 'Plan time away',
                    onTap: () => _open(
                      OutpassForm(repository: widget.repositories.resident),
                    ),
                  ),
                ),
              ],
            ),
            LoadState<List<ResidentRequest>>(
              future: _requests,
              onRetry: _reload,
              builder: (context, items) {
                final active = items
                    .where((item) =>
                        item.status != RequestStatus.resolved &&
                        item.status != RequestStatus.declined)
                    .length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(
                      'Your requests',
                      action: Text(
                        '${items.length} total',
                        style: TextStyle(
                          color: context.secondaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (items.isNotEmpty)
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: PortalTokens.space3),
                        padding: const EdgeInsets.all(PortalTokens.space3),
                        decoration: BoxDecoration(
                          color: PortalTokens.vitGold.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(
                            PortalTokens.radiusSmall,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.clock,
                              color: PortalTokens.vitNavy,
                              size: 18,
                            ),
                            const SizedBox(width: PortalTokens.space2),
                            Expanded(
                              child: Text(
                                '$active ${active == 1 ? 'item needs' : 'items need'} attention',
                                style: const TextStyle(
                                  color: PortalTokens.vitNavy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: PortalTokens.space5,
                        ),
                        child: Text(
                          'No requests yet. When you need help, start with a complaint or outpass.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.secondaryText),
                        ),
                      )
                    else
                      ...items.map((item) => RequestCard(request: item)),
                  ],
                );
              },
            ),
          ],
        ),
      );
}

class _RequestActionTile extends StatelessWidget {
  const _RequestActionTile({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => PortalCard(
        onTap: onTap,
        padding: const EdgeInsets.all(PortalTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.link, size: 22),
            const SizedBox(height: PortalTokens.space3),
            Text(
              title,
              style: TextStyle(
                color: context.primaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PortalTokens.space1),
            Text(
              detail,
              style: TextStyle(color: context.secondaryText, fontSize: 12),
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
        padding: const EdgeInsets.all(PortalTokens.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: request.isOutpass
                    ? PortalTokens.vitGold
                    : PortalTokens.vitNavy,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: PortalTokens.space3),
            Expanded(
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
                    style:
                        TextStyle(color: context.secondaryText, fontSize: 14),
                  ),
                  const SizedBox(height: PortalTokens.space1),
                  Text(
                    request.details,
                    style: TextStyle(color: context.secondaryText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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
      if (mounted) {
        setState(
          () => _error =
              'Your complaint wasn’t sent. Your draft is still here. $error',
        );
      }
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
                  Container(
                    padding: const EdgeInsets.all(PortalTokens.space4),
                    decoration: BoxDecoration(
                      color: PortalTokens.vitNavy,
                      borderRadius:
                          BorderRadius.circular(PortalTokens.radiusLarge),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          CupertinoIcons.wrench_fill,
                          color: PortalTokens.vitGold,
                          size: 28,
                        ),
                        const SizedBox(width: PortalTokens.space3),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Eyebrow(
                                'RESIDENT CARE · NEW TICKET',
                                color: PortalTokens.vitGold,
                              ),
                              SizedBox(height: PortalTokens.space2),
                              DisplayText(
                                'What needs\na hand?',
                                color: Color(0xFFFFFFFF),
                                fontSize: 28,
                              ),
                              SizedBox(height: PortalTokens.space2),
                              Text(
                                'Share the details and the right hostel team can follow up.',
                                style: TextStyle(color: Color(0xFFE0EAF5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  Text(
                    'Choose a team',
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
                          padding: const EdgeInsets.all(PortalTokens.space3),
                          minimumSize: const Size(96, 88),
                          color:
                              selected ? PortalTokens.vitGold : context.surface,
                          onPressed: () => setState(() => _category = category),
                          borderRadius: BorderRadius.circular(
                            PortalTokens.radiusSmall,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _categoryIcon(category),
                                color: PortalTokens.vitNavy,
                                size: 20,
                              ),
                              const SizedBox(height: PortalTokens.space1),
                              Text(
                                category.label,
                                style: const TextStyle(
                                  color: PortalTokens.vitNavy,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  Container(
                    padding: const EdgeInsets.all(PortalTokens.space3),
                    decoration: BoxDecoration(
                      color: context.surface,
                      border: Border.all(
                        color: context.border.withValues(alpha: .25),
                      ),
                      borderRadius:
                          BorderRadius.circular(PortalTokens.radiusSmall),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.lock_shield,
                          color: context.link,
                          size: 20,
                        ),
                        const SizedBox(width: PortalTokens.space2),
                        Expanded(
                          child: Text(
                            'Only your hostel team can see this report.',
                            style: TextStyle(
                              color: context.secondaryText,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            liveRegion: true,
                            child: Text(
                              _error!,
                              style: TextStyle(color: context.error),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(44, 44),
                            onPressed: _busy ? null : _submit,
                            child: Text(
                              'Retry complaint',
                              style: TextStyle(
                                color: context.link,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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

IconData _categoryIcon(ComplaintCategory category) => switch (category) {
      ComplaintCategory.maintenance => CupertinoIcons.wrench_fill,
      ComplaintCategory.cleanliness => CupertinoIcons.sparkles,
      ComplaintCategory.internet => CupertinoIcons.wifi,
      ComplaintCategory.safety => CupertinoIcons.shield_fill,
      ComplaintCategory.other => CupertinoIcons.ellipsis,
    };

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
      if (mounted) {
        setState(
          () => _error =
              'Your request wasn’t sent. Your draft is still here. $error',
        );
      }
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
                  Container(
                    padding: const EdgeInsets.all(PortalTokens.space4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EEF6),
                      borderRadius:
                          BorderRadius.circular(PortalTokens.radiusLarge),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: PortalTokens.vitNavy,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.airplane,
                            color: PortalTokens.vitGold,
                          ),
                        ),
                        const SizedBox(width: PortalTokens.space3),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Eyebrow('OUTPASS · DATE PLAN'),
                              SizedBox(height: PortalTokens.space1),
                              DisplayText(
                                'A trip home?',
                                fontSize: 28,
                              ),
                              SizedBox(height: PortalTokens.space1),
                              Text(
                                'Choose when you leave and return.',
                                style: TextStyle(color: Color(0xFF344B66)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space3),
                  Container(
                    padding: const EdgeInsets.all(PortalTokens.space3),
                    decoration: BoxDecoration(
                      color: context.surface,
                      borderRadius:
                          BorderRadius.circular(PortalTokens.radiusSmall),
                    ),
                    child: Text(
                      'Departure within 30 days · Return within 14 nights',
                      style: TextStyle(
                        color: context.secondaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
            const EditorialHeading(
              eyebrow: 'LIFE AT YOUR RESIDENCE',
              title: 'Your day,\nwell looked after.',
              description: 'A table, clean clothes, and a place to share.',
            ),
            LoadState<List<MenuItem>>(
              future: _menu,
              onRetry: () => setState(
                () =>
                    _menu = widget.repositories.hostel.menuFor(DateTime.now()),
              ),
              builder: (context, menu) =>
                  menu.isEmpty ? _EmptyMenuCard() : _MessMenuPanel(menu: menu),
            ),
            const SizedBox(height: PortalTokens.space2),
            const SectionHeading('Tell us how it was'),
            PortalCard(
              padding: const EdgeInsets.all(PortalTokens.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.chat_bubble_text,
                        color: PortalTokens.vitNavy,
                      ),
                      const SizedBox(width: PortalTokens.space2),
                      Expanded(
                        child: Text(
                          'A note for the mess team',
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PortalTokens.space3),
                  LabeledField(
                    label: 'Your feedback',
                    controller: _feedback,
                    hint: 'What worked well or could improve?',
                    maxLines: 3,
                  ),
                  PrimaryButton(
                    label: 'Send feedback',
                    busy: _busy,
                    onPressed: _sendFeedback,
                  ),
                ],
              ),
            ),
            const SectionHeading('Laundry, on your schedule'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(PortalTokens.space4),
              decoration: BoxDecoration(
                color: PortalTokens.vitGold.withValues(alpha: .28),
                borderRadius: BorderRadius.circular(PortalTokens.radiusLarge),
                border: Border.all(
                  color: PortalTokens.vitGold.withValues(alpha: .6),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC000),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.drop_fill,
                          color: PortalTokens.vitNavy,
                        ),
                      ),
                      const SizedBox(width: PortalTokens.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Eyebrow(
                              'TODAY · RECEPTION',
                              color: PortalTokens.vitNavy,
                            ),
                            const SizedBox(height: PortalTokens.space1),
                            Text(
                              'Pickup window 6–8 pm',
                              style: TextStyle(
                                color: context.primaryText,
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              'Leave your tagged bag at reception.',
                              style: TextStyle(color: context.secondaryText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: PortalTokens.space4),
                  PrimaryButton(
                    label: 'Request pickup',
                    busy: _busy,
                    onPressed: _requestLaundry,
                  ),
                ],
              ),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(top: PortalTokens.space3),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color: _isError ? context.error : context.success,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _EmptyMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PortalCard(
        child: Text(
          'No menu posted for today yet.',
          style: TextStyle(color: context.secondaryText),
        ),
      );
}

class _MessMenuPanel extends StatelessWidget {
  const _MessMenuPanel({required this.menu});
  final List<MenuItem> menu;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(PortalTokens.space4),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(PortalTokens.radiusLarge),
          border: Border.all(color: context.border.withValues(alpha: .18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.sun_max_fill,
                  color: PortalTokens.vitNavy,
                  size: 24,
                ),
                const SizedBox(width: PortalTokens.space2),
                const Expanded(
                  child: Text(
                    'Today’s mess menu',
                    style: TextStyle(
                      color: PortalTokens.vitNavy,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const StatusTag('TODAY', color: PortalTokens.vitGold),
              ],
            ),
            const SizedBox(height: PortalTokens.space3),
            Container(
              height: 1,
              color: context.border.withValues(alpha: .25),
            ),
            ...menu.indexed.map((entry) {
              final (index, item) = entry;
              return Padding(
                padding: const EdgeInsets.only(top: PortalTokens.space3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: PortalTokens.vitGold.withValues(alpha: .28),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: PortalTokens.vitNavy,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: PortalTokens.space3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: context.primaryText,
                              fontWeight: FontWeight.w700,
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
              );
            }),
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
            const EditorialHeading(
              eyebrow: 'THE HOSTEL BULLETIN',
              title: 'Good to know.',
              description: 'Timely updates for life on campus.',
            ),
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
                      children: [
                        for (var index = 0; index < notices.length; index++)
                          _NoticeTimelineItem(
                            notice: notices[index],
                            isLast: index == notices.length - 1,
                          ),
                      ],
                    ),
            ),
          ],
        ),
      );
}

class _NoticeTimelineItem extends StatelessWidget {
  const _NoticeTimelineItem({
    required this.notice,
    required this.isLast,
  });

  final PortalNotice notice;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: PortalTokens.space3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 34,
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: notice.urgent
                          ? PortalTokens.vitGold
                          : const Color(0xFFE7EEF6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      notice.urgent
                          ? CupertinoIcons.exclamationmark
                          : CupertinoIcons.bell,
                      color: PortalTokens.vitNavy,
                      size: 17,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 28,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: context.border.withValues(alpha: .35),
                    ),
                ],
              ),
            ),
            const SizedBox(width: PortalTokens.space2),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: PortalTokens.space1),
                padding: const EdgeInsets.all(PortalTokens.space4),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(PortalTokens.radiusCard),
                  border: Border.all(
                    color: notice.urgent
                        ? PortalTokens.vitGold.withValues(alpha: .8)
                        : context.border.withValues(alpha: .2),
                    width: notice.urgent ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Eyebrow(
                            formatDate(notice.date).toUpperCase(),
                            color: context.secondaryText,
                          ),
                        ),
                        if (notice.urgent)
                          const StatusTag(
                            'IMPORTANT',
                            color: PortalTokens.vitGold,
                          ),
                      ],
                    ),
                    const SizedBox(height: PortalTokens.space2),
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
                      style: TextStyle(color: context.secondaryText),
                    ),
                  ],
                ),
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
        title: const Text('Demo payment · no charge'),
        content: Text(
          'No real payment will be made and your fees will not change. Simulate a payment of ₹${account.totalDue}?',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Simulate payment'),
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
            const EditorialHeading(
              eyebrow: 'THE PRACTICAL SIDE',
              title: 'Your account.',
              description: 'Clear details, no surprises.',
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
                            'Demo payment complete',
                            style: TextStyle(
                              color: context.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'No real payment was made or fees account updated. Demo reference ${account.reference}.',
                            style: TextStyle(color: context.secondaryText),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(PortalTokens.space5),
                          decoration: BoxDecoration(
                            color: PortalTokens.vitNavy,
                            borderRadius: BorderRadius.circular(
                              PortalTokens.radiusLarge,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x26002147),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.creditcard_fill,
                                    color: PortalTokens.vitGold,
                                  ),
                                  const SizedBox(width: PortalTokens.space2),
                                  const Expanded(
                                    child: Eyebrow(
                                      'RESIDENCE ACCOUNT',
                                      color: PortalTokens.vitGold,
                                    ),
                                  ),
                                  const Icon(
                                    CupertinoIcons.lock_shield,
                                    color: Color(0xFFE0EAF5),
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: PortalTokens.space4),
                              const Text(
                                'Outstanding balance',
                                style: TextStyle(color: Color(0xFFE0EAF5)),
                              ),
                              const SizedBox(height: PortalTokens.space1),
                              Text(
                                '₹${account.totalDue}',
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: PortalTokens.space4),
                              Wrap(
                                spacing: PortalTokens.space2,
                                runSpacing: PortalTokens.space2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PortalTokens.space3,
                                      vertical: PortalTokens.space2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: PortalTokens.vitGold,
                                      borderRadius: BorderRadius.circular(99),
                                    ),
                                    child: Text(
                                      'DUE ${formatDate(account.dueDate).toUpperCase()}',
                                      style: const TextStyle(
                                        color: PortalTokens.vitNavy,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Ref ${account.reference}',
                                    style: const TextStyle(
                                      color: Color(0xFFE0EAF5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: PortalTokens.space3),
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
                        if (widget.repository.supportsPayment)
                          PrimaryButton(
                            label: 'Review and pay',
                            icon: CupertinoIcons.lock,
                            busy: _busy,
                            onPressed: () => _confirmPayment(account),
                          )
                        else
                          PortalCard(
                            child: Text(
                              'Online payment is not configured. Contact the hostel office to pay securely.',
                              style: TextStyle(color: context.secondaryText),
                            ),
                          ),
                        const SizedBox(height: PortalTokens.space3),
                        Text(
                          widget.repository.supportsPayment
                              ? 'Demo only: no real payment will be sent or recorded.'
                              : 'Your live fee balance is read-only here. Payments will be available after a verified payment provider is connected.',
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
            const EditorialHeading(
              eyebrow: 'VIT CHENNAI · WARDEN DESK',
              title: 'Your team’s\nmorning round.',
              description: 'Review, assign, and keep residents in the loop.',
            ),
            LoadState<List<ResidentRequest>>(
              future: _queue,
              onRetry: () => setState(
                  () => _queue = widget.repositories.warden.triageQueue()),
              builder: (context, requests) {
                final outpasses =
                    requests.where((item) => item.isOutpass).length;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(PortalTokens.space4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7EEF6),
                        borderRadius:
                            BorderRadius.circular(PortalTokens.radiusCard),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TriageMetric(
                              value: '${requests.length}',
                              label: 'Open items',
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 44,
                            color: PortalTokens.vitNavy.withValues(alpha: .2),
                          ),
                          Expanded(
                            child: _TriageMetric(
                              value: '$outpasses',
                              label: 'Outpasses',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SectionHeading('Needs your attention'),
                    if (requests.isEmpty)
                      Center(
                        child: Text(
                          'The queue is clear.',
                          style: TextStyle(color: context.secondaryText),
                        ),
                      )
                    else
                      ...requests.map(
                        (request) => _TriageQueueCard(
                          request: request,
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
                              if (mounted) {
                                setState(
                                  () => _queue =
                                      widget.repositories.warden.triageQueue(),
                                );
                              }
                            });
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      );
}

class _TriageMetric extends StatelessWidget {
  const _TriageMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: PortalTokens.vitNavy,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: context.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}

class _TriageQueueCard extends StatelessWidget {
  const _TriageQueueCard({required this.request, required this.onTap});

  final ResidentRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => PortalCard(
        onTap: onTap,
        padding: const EdgeInsets.all(PortalTokens.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: request.isOutpass
                    ? PortalTokens.vitGold.withValues(alpha: .35)
                    : const Color(0xFFE7EEF6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                request.isOutpass
                    ? CupertinoIcons.airplane
                    : _categoryIcon(
                        request.category ?? ComplaintCategory.other,
                      ),
                color: PortalTokens.vitNavy,
                size: 20,
              ),
            ),
            const SizedBox(width: PortalTokens.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.title,
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space1),
                  Text(
                    '${request.id} · ${request.isOutpass ? 'Outpass' : request.category?.label ?? 'Complaint'}',
                    style: TextStyle(
                      color: context.secondaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: PortalTokens.space2),
                  StatusTag(request.status.label),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: context.tertiaryText,
              size: 17,
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
            Eyebrow(
              '${widget.request.id}  ·  ${widget.request.isOutpass ? 'OUTPASS' : 'RESIDENT REQUEST'}',
            ),
            const SizedBox(height: PortalTokens.space2),
            DisplayText(widget.request.title, fontSize: 32),
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
      if (mounted) {
        setState(() => _saved = 'Update saved for ${widget.request.id}.');
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _error =
              'Update couldn’t be saved. Your changes are still here. $error',
        );
      }
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
