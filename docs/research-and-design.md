# Research basis and product design

## Scope and evidence

This is a prototype, not a report of completed user research. No interviews, surveys, field observations, or usability tests were run for this implementation. The feature set and initial resident/warden roles come from the product brief; the policy details, sample content, user identity, and operational process below are design assumptions to validate with a hostel and its residents.

Accessibility decisions are informed by published standards and platform guidance:

- WCAG 2.2 Success Criterion 1.4.3 sets a 4.5:1 minimum contrast ratio for normal text and 3:1 for large text. Ratios below were computed from the sRGB token values using the WCAG relative-luminance formula. [W3C: Understanding Contrast (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- WCAG 2.2 Success Criterion 2.5.8 sets a 24 by 24 CSS-pixel minimum target size subject to exceptions. This prototype uses 48 logical pixels as a larger tap-target design token; this is a product choice, not a claim that WCAG universally requires 48. [W3C: Understanding Target Size (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)
- WCAG 2.2 Success Criterion 1.4.4 requires text to resize to 200% without loss of content or functionality. Layouts use scrolling, wrapping, and content-driven heights rather than fixed-height text containers where practical. [W3C: Understanding Resize Text](https://www.w3.org/WAI/WCAG22/Understanding/resize-text.html)
- The interface uses Flutter Cupertino components and Flutter's accessibility/semantics facilities to maintain platform-appropriate controls and expose control intent to assistive technology. [Flutter Cupertino library](https://api.flutter.dev/flutter/cupertino/cupertino-library.html) · [Flutter accessibility](https://docs.flutter.dev/ui/accessibility)
- Apple's accessibility guidance emphasizes legible, adaptable content and controls that can be used with assistive technologies. [Apple Human Interface Guidelines: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

## Information architecture

The role-aware bottom navigation is capped at five destinations:

| Position | Resident | Warden |
|---|---|---|
| 1 | Home | Home |
| 2 | Requests | Triage |
| 3 | Hostel | Hostel |
| 4 | Notices | Notices |
| 5 | Fees | Fees |

Account and role switching are available from the account button. A real product should use authenticated role assignment, not this prototype's self-service role switch.

### Main resident flows

Tap counts start on signed-in Home and exclude typing, scrolling, and system navigation inside a picker. A date picker interaction can require extra month-navigation taps. They are design targets, not observed task results.

| Task | Flow | Target taps |
|---|---|---:|
| Submit a complaint | Requests → New complaint → choose category → title → details → Submit | 6 |
| Request an outpass | Requests → New outpass → departure field → departure date → return field → return date → reason → Submit | 8 |
| Find hostel information | Hostel → view menu / send meal feedback / request laundry pickup | 2+ |
| Read a notice | Notices → open/read notice | 2 |
| Review and pay fees | Fees → Review and pay → confirm | 3 |
| Triage a request | Triage → queue item → status control → status → assignee → staff/team → Save update | 7 |

The approved request/outpass flows are deliberately short but keep category, reason, and date details explicit. A failed request submission leaves entered fields in place and provides a retry path. Payment has a confirmation step before the repository call and displays a receipt only after the call succeeds.

## Policies and content: assumptions to validate

- **Outpass policy (prototype assumption):** departure is today through 30 days ahead, return must be after departure, and the trip may not exceed 14 nights. No institution-specific rules were supplied. A production release must replace this policy with an approved policy and explain any exceptions.
- **Role and people (mock):** “Aanya Sharma,” VIT Chennai, sample teams, assignment options, and request records are invented sample data. They do not represent real residents or staff.
- **Money (mock):** ₹18,500 and the October 25 due date are illustrative. The payment interface does not integrate with a payment provider.
- **Operational labels (hypotheses):** complaint categories and statuses, triage ownership, laundry reception pickup window, meal feedback process, notices, and fees are plausible starting points only. Confirm terminology, privacy expectations, escalation paths, and service-level commitments with the hostel.
- **Home greeting/time (assumption):** the “Good morning” copy is static sample content. A production app should localize it and use the resident's configured locale and local time.

## VIT-inspired color tokens and measured contrast

`lib/core/design_tokens.dart` is the single source of spacing, radii, tap targets, and light/dark semantic colors. Text uses normal Flutter/Cupertino text scaling; the app does not override the user's text scale. The visual direction uses VIT's deep navy and gold/yellow as seen on the [official VIT homepage](https://vit.ac.in/) (`#002147` and `#FFC000`), with the user-provided VIT Chennai campus photo and logo. This is a student-portal concept, not an official VIT product or endorsement. Contrast ratios in this table are rounded to two decimals. Standard text pairs meet 4.5:1 in both modes; button labels meet 4.5:1 against the button fill.

The resident dashboard borrows general product ideas from the user's Fitelo reference: a clear daily focus, approachable progress cues, and friendly, scannable cards. Fitelo's App Store listing describes habit and activity tracking; the portal adapts the high-level dashboard pattern to campus requests, mess, laundry, notices, and fees, without using Fitelo branding or reproducing its screens. [Fitelo App Store listing](https://apps.apple.com/in/app/fitelo-weight-loss-diet-app/id1323938554)

| Text role | Light foreground / background | Ratio | Dark foreground / background | Ratio |
|---|---|---:|---|---:|
| Primary | `#002147` / canvas `#F7F5EF` | 14.72:1 | `#F3F6FC` / canvas `#0A1628` | 16.75:1 |
| Primary | `#002147` / surface `#FFFFFF` | 16.05:1 | `#F3F6FC` / surface `#11233A` | 14.64:1 |
| Secondary | `#344B66` / canvas `#F7F5EF` | 8.22:1 | `#C8D4E4` / canvas `#0A1628` | 12.08:1 |
| Secondary | `#344B66` / surface `#FFFFFF` | 8.96:1 | `#C8D4E4` / surface `#11233A` | 10.56:1 |
| Tertiary | `#4E647D` / canvas `#F7F5EF` | 5.59:1 | `#ADBED2` / canvas `#0A1628` | 9.56:1 |
| Tertiary | `#4E647D` / surface `#FFFFFF` | 6.10:1 | `#ADBED2` / surface `#11233A` | 8.35:1 |
| Link | `#064F8C` / canvas `#F7F5EF` | 7.69:1 | `#91CFFF` / canvas `#0A1628` | 10.85:1 |
| Link | `#064F8C` / surface `#FFFFFF` | 8.38:1 | `#91CFFF` / surface `#11233A` | 9.49:1 |
| Error | `#9B2D2D` / canvas `#F7F5EF` | 6.86:1 | `#FFB4AA` / canvas `#0A1628` | 10.67:1 |
| Error | `#9B2D2D` / surface `#FFFFFF` | 7.48:1 | `#FFB4AA` / surface `#11233A` | 9.33:1 |
| Success | `#28613E` / canvas `#F7F5EF` | 6.71:1 | `#A8DEB2` / canvas `#0A1628` | 11.88:1 |
| Success | `#28613E` / surface `#FFFFFF` | 7.32:1 | `#A8DEB2` / surface `#11233A` | 10.38:1 |
| Warning | `#755000` / canvas `#F7F5EF` | 6.63:1 | `#FFD37A` / canvas `#0A1628` | 12.82:1 |
| Warning | `#755000` / surface `#FFFFFF` | 7.23:1 | `#FFD37A` / surface `#11233A` | 11.21:1 |
| Light filled primary label | `#FFFFFF` / VIT navy `#002147` | 16.05:1 | Dark filled primary label | N/A |
| Dark filled primary label | N/A | N/A | `#10243B` / VIT gold `#FFC000` | 9.56:1 |
| Hero white | `#FFFFFF` / darkest navy `#002147` | 16.05:1 | N/A | N/A |
| Hero secondary | `#E0EAF5` / lightest hero navy `#174778` | 7.81:1 | N/A | N/A |
| Status tag label | `#002147` / light tinted surfaces | ≥12.57:1 | `#F3F6FC` / dark tinted surfaces | ≥11.02:1 |

The official VIT gold is an accent color, not body text on the pale surface: its contrast on the light canvas is only 1.50:1. Primary text on the gold hero button is navy (`#002147` on `#FFC000`, 9.78:1). Cupertino tab labels use the secondary-text foreground on the surface background. Status tag fills are a 12% semantic-color tint over the surface and use primary text, with the status also written out as text. Decorative icon colors are not the sole indicator of a state.

## Methods and rationale changelog

- **Fresh implementation:** the supplied workspace had only a short README, with no Flutter app or prototype. The app and architecture were created from scratch rather than altering an existing prototype.
- **Repository interfaces:** resident requests, hostel services, notices, fees, and warden triage have separate interfaces. An in-memory mock supports demo mode; Firebase Auth and Firestore adapters support configured signed-in mode. Firebase rules enforce document ownership and custom-claim warden access. Payment remains disabled until a provider and trusted server integration are configured.
- **Five tabs:** a fixed five-slot bar makes key resident actions available without burying core services; the warden's second tab is adapted to triage.
- **Cupertino-first:** the task specifies an Apple-style Flutter portal. Cupertino navigation, sheets, date picker, controls, and confirmation dialog are used consistently.
- **Recovery and confirmation:** form data remains in local controllers if submission fails; payment confirmation gates the mock operation and success state; the persistent demo notice and payment wording clarify no real transaction or request occurs; load failures offer an explicit retry.
- **Accessibility:** color is not the only signal, interactive controls target at least 48 logical pixels, error/success copy is announced as a live region, and content can scroll and wrap as text grows.
- **Visual refinement:** the VIT Chennai-themed home screen uses the supplied campus photograph and logo, the university's public navy/gold visual cues, clear service status, and student-residence wording. A user-selectable dark appearance adapts the palette.
- **Playful interaction:** the campus hero and tappable cards use restrained perspective tilt on pointer hover and press, with faceted building artwork. The effect is brief, decorative, and does not change the navigation or require drag gestures.
- **No unsupported claims:** mock content and assumed rules are identified as such. The evaluation plan below is prospective; there are no results or invented usability statistics.
