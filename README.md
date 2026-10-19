# NestMate

NestMate is a fresh Flutter prototype for a VIT Chennai-inspired hostel resident and warden portal. It uses the VIT Chennai campus photo and logo supplied for this design, VIT navy-and-gold styling, Cupertino-native interactions, adaptive light/dark palettes, and mock data behind repository interfaces. It is a concept, not an official VIT app.

## Run

```sh
flutter pub get
flutter run
```

For a browser preview, run `flutter run -d chrome` (web support is included).

When Firebase is configured, residents and wardens sign in and changes use their signed-in Firebase account; warden access comes from a server-managed role claim. The sign-in screen also offers **Explore prototype preview** so reviewers can try the full UI with sample content. Preview actions stay in memory for that session and are not sent to hostel staff. If Firebase is not configured, the app opens directly in this local prototype preview and the account menu can switch between resident and warden preview views; this is not authentication or access control. Configure Firebase Auth and Firestore as described in [docs/firebase-setup.md](docs/firebase-setup.md) for signed-in requests, hostel feedback and laundry requests, notices, menus, and read-only fee balances. The preview includes a gateway-style checkout handoff with UPI, card, and net-banking choices; it is labeled as a simulation, does not open an external app, and never charges or changes a real balance. A real payment provider is not connected.

On the resident **Requests** tab, each card shows its current status, a visual progress bar, and plain-language resolution state. Warden updates in the connected prototype are reflected in the resident request list after saving. Sample resolved and active requests are included in the preview so both outcomes are visible.

## Verify

```sh
flutter analyze
flutter test
```

Product assumptions, information architecture, interaction flows, and accessibility sources are in [docs/research-and-design.md](docs/research-and-design.md). The formative evaluation protocol is in [docs/evaluation-plan.md](docs/evaluation-plan.md).
