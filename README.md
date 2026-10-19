# NestMate

NestMate is a fresh Flutter prototype for a VIT Chennai-inspired hostel resident and warden portal. It uses the VIT Chennai campus photo and logo supplied for this design, VIT navy-and-gold styling, Cupertino-native interactions, adaptive light/dark palettes, and mock data behind repository interfaces. It is a concept, not an official VIT app.

## Run

```sh
flutter pub get
flutter run
```

For a browser preview, run `flutter run -d chrome` (web support is included).

Without Firebase configuration, the account button switches between resident and warden **demo views**; it is not authentication or access control. When Firebase is configured, the sign-in screen also offers **Explore demo** to open the sample portal without signing in; choose **Return to sign in** from the account menu to leave it. A persistent in-app notice identifies demo mode and clarifies that sample requests and payments are not sent to real services. Configure Firebase Auth and Firestore as described in [docs/firebase-setup.md](docs/firebase-setup.md) to enable signed-in resident requests, warden custom-claim authorization, notices, menus, feedback, laundry requests, and read-only fee balances. Online payment is not configured.

## Verify

```sh
flutter analyze
flutter test
```

Product assumptions, information architecture, interaction flows, and accessibility sources are in [docs/research-and-design.md](docs/research-and-design.md). The formative evaluation protocol is in [docs/evaluation-plan.md](docs/evaluation-plan.md).
