# NestMate

NestMate is a fresh Flutter prototype for a hostel resident and warden portal. It uses Cupertino widgets, adaptive light/dark semantic colors, and mock data behind repository interfaces. No existing prototype was present in this checkout; this implementation does not replace or modify one.

## Run

```sh
flutter pub get
flutter run
```

The account button switches between resident and warden views. All content is mock data; payment does not contact a bank and request submission does not contact a hostel.

## Verify

```sh
flutter analyze
flutter test
```

Product assumptions, information architecture, interaction flows, and accessibility sources are in [docs/research-and-design.md](docs/research-and-design.md). The formative evaluation protocol is in [docs/evaluation-plan.md](docs/evaluation-plan.md).
