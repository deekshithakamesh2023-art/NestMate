import 'package:flutter/cupertino.dart';

import 'design_tokens.dart';

class PortalEnvironment extends InheritedWidget {
  const PortalEnvironment({
    required this.demoMode,
    required super.child,
    super.key,
  });

  final bool demoMode;

  static bool demoModeOf(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<PortalEnvironment>()
          ?.demoMode ??
      true;

  @override
  bool updateShouldNotify(PortalEnvironment oldWidget) =>
      demoMode != oldWidget.demoMode;
}

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
  Widget build(BuildContext context) {
    final demoMode = PortalEnvironment.demoModeOf(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: leading,
        middle: Text(title),
        trailing: trailing,
        backgroundColor: context.canvas.withValues(alpha: .96),
        border: null,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: PortalTokens.space4,
                vertical: PortalTokens.space2,
              ),
              color: context.isDark
                  ? const Color(0xFF2E3633)
                  : const Color(0xFFE0E4E9),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.info_circle,
                    color: context.primaryText,
                    size: 16,
                  ),
                  const SizedBox(width: PortalTokens.space2),
                  Expanded(
                    child: Text(
                      demoMode
                          ? 'Demo only · Sample data; no real hostel requests or payments are sent.'
                          : 'Live mode · Signed-in account; warden access is server-assigned.',
                      style: TextStyle(
                        color: context.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class PortalScroll extends StatelessWidget {
  const PortalScroll({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        children: children,
      );
}

class Interactive3DSurface extends StatefulWidget {
  const Interactive3DSurface({required this.child, super.key});

  final Widget child;

  @override
  State<Interactive3DSurface> createState() => _Interactive3DSurfaceState();
}

class _Interactive3DSurfaceState extends State<Interactive3DSurface> {
  Offset _tilt = Offset.zero;
  bool _pressed = false;

  void _setTilt(Offset localPosition) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        renderObject.size.isEmpty) {
      return;
    }
    final size = renderObject.size;
    setState(() {
      _tilt = Offset(
        (localPosition.dx / size.width - .5) * 2,
        (localPosition.dy / size.height - .5) * 2,
      );
    });
  }

  void _release() {
    setState(() {
      _pressed = false;
      _tilt = Offset.zero;
    });
  }

  Matrix4 _transform() => Matrix4.identity()
    ..setEntry(3, 2, .001)
    ..rotateX(-_tilt.dy * .08)
    ..rotateY(_tilt.dx * .08)
    ..scaleByDouble(
      _pressed ? .985 : 1.0,
      _pressed ? .985 : 1.0,
      _pressed ? .985 : 1.0,
      1.0,
    );

  @override
  Widget build(BuildContext context) => MouseRegion(
        onHover: (event) => _setTilt(event.localPosition),
        onExit: (_) => _release(),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            _setTilt(event.localPosition);
            setState(() => _pressed = true);
          },
          onPointerUp: (_) => _release(),
          onPointerCancel: (_) => _release(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transformAlignment: Alignment.center,
            transform: _transform(),
            child: widget.child,
          ),
        ),
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
        border: Border.all(color: context.border.withValues(alpha: .18)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A3A26)
                .withValues(alpha: context.isDark ? .08 : .045),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
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
                child: Interactive3DSurface(child: content),
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
                  fontFamily: 'sans-serif',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.5,
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

class DisplayText extends StatelessWidget {
  const DisplayText(
    this.text, {
    this.fontSize = 32,
    this.color,
    this.italic = false,
    this.height = 1.05,
    super.key,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final bool italic;
  final double height;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: color ?? context.primaryText,
          fontFamily: 'sans-serif',
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          height: height,
          letterSpacing: -1.2,
        ),
      );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.label, {this.color, super.key});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color ?? context.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.7,
        ),
      );
}

class EditorialHeading extends StatelessWidget {
  const EditorialHeading({
    required this.eyebrow,
    required this.title,
    required this.description,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: PortalTokens.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow(eyebrow),
            const SizedBox(height: PortalTokens.space2),
            DisplayText(title, fontSize: 32),
            const SizedBox(height: PortalTokens.space2),
            Text(description, style: TextStyle(color: context.secondaryText)),
          ],
        ),
      );
}
