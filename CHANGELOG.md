# Changelog

## 1.3.0 — 2026-10-19

- Reframed the no-backend route as a local prototype preview and clarified that sample changes stay in-session and never reach hostel staff.
- Added request progress bars and plain-language resolved, in-progress, and closed-without-resolution states; included a resolved sample request for previewing both outcomes.
- Made prototype meal feedback and laundry pickup actions record in the in-memory repository, and labeled payment as a no-charge prototype simulation.
- Added a dedicated checkout handoff screen with selectable UPI, card, and net-banking preview options before the no-charge payment simulation.
- Preserved Firebase-backed sign-in and repository behavior for connected accounts; online payment remains unavailable until a verified provider is configured.

## 1.2.0 — 2026-10-18

- Refreshed the resident home as a daily campus dashboard, drawing on wellness-app patterns while preserving VIT Chennai branding and hostel workflows.
- Gave requests, outpasses, mess, laundry, notices, fees, and warden triage distinct visual layouts and contextual status details.
- Re-themed the resident portal around VIT's publicly visible navy-and-gold palette and campus identity.
- Replaced the illustrated campus with the supplied VIT Chennai campus photograph and logo.
- Updated semantic dark-mode colors, contrast documentation, and responsive VIT wordmark tests; no official logo is used.
- Added a persistent prototype-only notice, clearly labeled preview role switching, and payment copy that cannot be mistaken for a real charge.
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
