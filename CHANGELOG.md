# Changelog

## 1.2.0 — 2026-10-18

- Re-themed the resident portal around VIT's publicly visible navy-and-gold palette and campus identity.
- Replaced the illustrated campus with the supplied VIT Chennai campus photograph and logo.
- Updated semantic dark-mode colors, contrast documentation, and responsive VIT wordmark tests; no official logo is used.
- Added a persistent demo-only notice, clearly labeled demo account/role switching, and payment copy that cannot be mistaken for a real charge.
- Added a subtle hover/press 3D tilt to the campus welcome and tappable cards, plus faceted campus buildings.
- Added optional Firebase Auth and Firestore repositories with role claims, restrictive Firestore rules, and an explicit payment-disabled state in live mode.

## 1.1.0 — 2026-10-18

- Reworked the visual language with a warm palette, editorial serif display typography, custom solar artwork, more spacious surfaces, and an account-controlled light/evening appearance.
- Updated all service screens with editorial page introductions while retaining the request, payment, and warden workflows.
- Added the Flutter web target and Cupertino icon font for a ready-to-run browser preview.
- Verified the new home composition at 200% text scale and updated the measured contrast documentation.

## 1.0.0 — 2026-10-18

- Created a new Cupertino Flutter resident/warden portal in this previously README-only checkout.
- Added repository interfaces with in-memory mock data for requests, hostel services, notices, fees, and triage.
- Added resident Home, Requests, Hostel, Notices, Fees, and warden Triage views with loading, empty, retry, success, and submission recovery states.
- Added outpass date validation and a payment confirmation/retry flow; no real payment or hostel service integration is present.
- Added semantic light/dark tokens, accessibility and contrast documentation, product assumptions, evaluation methods, and widget tests.
- Rationale and design assumptions: [docs/research-and-design.md](docs/research-and-design.md).
