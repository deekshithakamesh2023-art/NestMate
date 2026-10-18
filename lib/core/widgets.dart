import 'package:flutter/cupertino.dart';

import 'design_tokens.dart';

class PortalScaffold extends StatelessWidget {
  const PortalScaffold({
    required this.title,
    required this.child,
    this.trailing,
    this.leading,
    this.subtitle,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final Widget? leading;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: leading,
          middle: Text(title),
          trailing: trailing,
          backgroundColor: context.surface.withValues(alpha: .94),
          border: Border(
            bottom: BorderSide(color: context.border.withValues(alpha: .3)),
          ),
        ),
        child: SafeArea(bottom: false, child: child),
      );
}

class PortalScroll extends StatelessWidget {
  const PortalScroll({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(
          PortalTokens.space4,
          PortalTokens.space5,
          PortalTokens.space4,
          PortalTokens.space8,
        ),
        children: children,
      );
}

class PortalCard extends StatelessWidget {
  const PortalCard({
    required this.child,
    this.padding = const EdgeInsets.all(PortalTokens.space4),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(PortalTokens.radiusCard),
        border: Border.all(color: context.border.withValues(alpha: .35)),
      ),
      child: child,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: PortalTokens.space3),
      child: onTap == null
          ? content
          : Semantics(
              button: true,
              onTap: onTap,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.action, super.key});
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: PortalTokens.space3,
          bottom: PortalTokens.space2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (action != null) action!,
          ],
        ),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: context.accent,
          minimumSize: const Size(0, PortalTokens.tapTarget),
          onPressed: busy ? null : onPressed,
          child: busy
              ? CupertinoActivityIndicator(color: context.accentText)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: context.accentText),
                      const SizedBox(width: PortalTokens.space2),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.accentText),
                      ),
                    ),
                  ],
                ),
        ),
      );
}

class StatusTag extends StatelessWidget {
  const StatusTag(this.label, {this.color, super.key});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final statusColor = color ?? context.accent;
    return Container(
      constraints: const BoxConstraints(minHeight: PortalTokens.tapTarget - 8),
      padding: const EdgeInsets.symmetric(
        horizontal: PortalTokens.space3,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          label,
          style: TextStyle(
            color: context.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;

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
                  fontSize: 15,
                ),
              ),
            ),
            CupertinoTextField(
              controller: controller,
              placeholder: hint,
              minLines: maxLines == 1 ? 1 : maxLines,
              maxLines: maxLines,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              autofocus: autofocus,
              padding: const EdgeInsets.all(PortalTokens.space3),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(PortalTokens.radiusSmall),
                border: Border.all(color: context.border),
              ),
            ),
          ],
        ),
      );
}

class LoadState<T> extends StatelessWidget {
  const LoadState({
    required this.future,
    required this.builder,
    required this.onRetry,
    super.key,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(PortalTokens.space6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.wifi_exclamationmark,
                      color: context.error,
                      size: 36,
                    ),
                    const SizedBox(height: PortalTokens.space3),
                    Text(
                      'We couldn’t load this right now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: PortalTokens.space3),
                    CupertinoButton(
                      onPressed: onRetry,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }
          return builder(context, snapshot.requireData);
        },
      );
}

String formatDate(DateTime date) =>
    '${_month(date.month)} ${date.day}, ${date.year}';

String _month(int month) => const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][month - 1];
