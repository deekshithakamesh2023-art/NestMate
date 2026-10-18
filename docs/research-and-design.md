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
- **Role and people (mock):** “Aanya Sharma,” Cedar Hall, sample teams, assignment options, and request records are invented sample data. They do not represent real residents or staff.
- **Money (mock):** ₹18,500 and the October 25 due date are illustrative. The payment interface does not integrate with a payment provider.
- **Operational labels (hypotheses):** complaint categories and statuses, triage ownership, laundry reception pickup window, meal feedback process, notices, and fees are plausible starting points only. Confirm terminology, privacy expectations, escalation paths, and service-level commitments with the hostel.
- **Home greeting/time (assumption):** the “Good morning” copy is static sample content. A production app should localize it and use the resident's configured locale and local time.

## Semantic color tokens and measured contrast

`lib/core/design_tokens.dart` is the single source of spacing, radii, tap targets, and light/dark semantic colors. Text uses normal Flutter/Cupertino text scaling; the app does not override the user's text scale. Contrast ratios in this table are rounded to two decimals. Standard text pairs meet 4.5:1 in both modes; button labels meet 4.5:1 against the button fill.

| Text role | Light foreground / background | Ratio | Dark foreground / background | Ratio |
|---|---|---:|---|---:|
| Primary | `#17252C` / canvas `#F4F7F6` | 14.57:1 | `#F0F5F4` / canvas `#10191D` | 16.18:1 |
| Primary | `#17252C` / surface `#FFFFFF` | 15.70:1 | `#F0F5F4` / surface `#1B292E` | 13.59:1 |
| Secondary | `#43545B` / canvas `#F4F7F6` | 7.33:1 | `#C5D2D0` / canvas `#10191D` | 11.46:1 |
| Secondary | `#43545B` / surface `#FFFFFF` | 7.90:1 | `#C5D2D0` / surface `#1B292E` | 9.62:1 |
| Tertiary | `#53656C` / canvas `#F4F7F6` | 5.65:1 | `#B5C6C3` / canvas `#10191D` | 10.04:1 |
| Tertiary | `#53656C` / surface `#FFFFFF` | 6.09:1 | `#B5C6C3` / surface `#1B292E` | 8.43:1 |
| Accent/link/error/success/warning* | `#145C4B` / canvas `#F4F7F6` | 7.32:1 | `#91DEC3` / canvas `#10191D` | 11.40:1 |
| Link | `#174FA3` / canvas `#F4F7F6` | 7.26:1 | `#A6C8FF` / canvas `#10191D` | 10.46:1 |
| Error | `#AA261E` / canvas `#F4F7F6` | 6.48:1 | `#FFB4A9` / canvas `#10191D` | 10.48:1 |
| Success | `#17623B` / canvas `#F4F7F6` | 6.84:1 | `#9BE0B0` / canvas `#10191D` | 11.61:1 |
| Warning | `#704400` / canvas `#F4F7F6` | 7.74:1 | `#FFD18A` / canvas `#10191D` | 12.50:1 |
| Filled primary button label | `#FFFFFF` / `#145C4B` | 7.89:1 | `#10231D` / `#91DEC3` | 10.50:1 |
| Status tag label | `#17252C` / tinted light surface | ≥12.95:1 | `#F0F5F4` / tinted dark surface | ≥10.13:1 |

*Accent, link, error, success, and warning have their own foreground tokens; their respective canvas ratios are listed in the following rows. Cupertino tab labels use the secondary-text foreground on the surface background. Status tag fills are a 12% semantic-color tint over their surface and use primary text, with the status also written out as text. Decorative icon colors are not the sole indicator of a state.

## Methods and rationale changelog

- **Fresh implementation:** the supplied workspace had only a short README, with no Flutter app or prototype. The app and architecture were created from scratch rather than altering an existing prototype.
- **Repository interfaces:** resident requests, hostel services, notices, fees, and warden triage have separate interfaces. A mock implementation demonstrates the complete interaction path and can be replaced by a backend adapter.
- **Five tabs:** a fixed five-slot bar makes key resident actions available without burying core services; the warden's second tab is adapted to triage.
- **Cupertino-first:** the task specifies an Apple-style Flutter portal. Cupertino navigation, sheets, date picker, controls, and confirmation dialog are used consistently.
- **Recovery and confirmation:** form data remains in local controllers if submission fails; payment confirmation gates the side effect and success state; load failures offer an explicit retry.
- **Accessibility:** color is not the only signal, interactive controls target at least 48 logical pixels, error/success copy is announced as a live region, and content can scroll and wrap as text grows.
- **No unsupported claims:** mock content and assumed rules are identified as such. The evaluation plan below is prospective; there are no results or invented usability statistics.
