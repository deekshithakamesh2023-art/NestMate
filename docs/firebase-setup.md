# Firebase setup

The app uses Firebase when all required public client configuration values are supplied. Without them it runs the labeled in-memory prototype preview; its sample changes are not sent to hostel staff or persisted after the app session ends. Never put a Firebase Admin SDK service-account key in this Flutter app or repository.

## Configure a project

1. The configured project is `webapp-666e2`, with its Web app client settings supplied in `lib/core/firebase_config.dart`. Register separate Firebase apps before targeting Android or iOS.
2. Enable **Authentication → Email/Password**. Create resident accounts through an administrator-controlled process; the app intentionally has no public sign-up or role selector in Firebase mode.
3. Create a Cloud Firestore database and deploy `firestore.rules`:

   ```sh
   firebase deploy --only firestore:rules
   ```

4. Assign wardens the Firebase Auth custom claim `{ "role": "warden" }` using a trusted Admin SDK or Cloud Function. Never let a client write role claims or role fields. Residents need no elevated claim.
5. The Web app configuration is used by default. You can override its public values when launching or building:

   ```sh
   flutter run -d chrome \
     --dart-define=FIREBASE_API_KEY=YOUR_WEB_API_KEY \
     --dart-define=FIREBASE_APP_ID=YOUR_WEB_APP_ID \
     --dart-define=FIREBASE_MESSAGING_SENDER_ID=YOUR_SENDER_ID \
     --dart-define=FIREBASE_PROJECT_ID=YOUR_PROJECT_ID \
     --dart-define=FIREBASE_AUTH_DOMAIN=YOUR_PROJECT_ID.firebaseapp.com
   ```

   For a web release, pass the same defines to `flutter build web --release`. Firebase client configuration is not a secret; Firestore rules and Auth are the access controls. Restrict the API key to the required Firebase APIs in Google Cloud Console. Never add Admin SDK credentials, passwords, or private keys to `--dart-define`.

The Firebase path authenticates with email/password, reads the warden custom claim from the ID token, stores resident requests/feedback/laundry actions in Firestore, and reads menus, published notices, and the signed-in user's fee account. Warden queue reads and updates are allowed only by the server rules to accounts with the `warden` custom claim. An account without that claim receives the resident view.

## Firestore document shape

Admin/server-created data must follow these shapes:

- `menus/{YYYY-MM-DD}`: `{ "items": [{ "name": string, "note": string }] }`
- `notices/{noticeId}`: `{ "title": string, "body": string, "date": Timestamp, "urgent": bool, "published": bool }`
- `feeAccounts/{uid}`: `{ "totalDue": integer, "dueDate": Timestamp, "reference": string }`
- `users/{uid}` is private to that account and not client-writable.

The app creates `requests`, `mealFeedback`, and `laundryRequests` with the signed-in UID and server timestamps. Request ownership and field limits are checked in `firestore.rules`.

Online payment is deliberately unavailable in Firebase mode. Reading fee balances from Firestore is not a payment integration; connect a trusted payment provider through a server-side endpoint and verify its signed callback before enabling payment or recording a receipt.

## Scope and production checklist

- Firebase options currently target the registered Web app. Use FlutterFire CLI to register and configure separate Android/iOS apps before running Firebase mode on those platforms.
- Configure authorized email domains, password policy, account recovery, App Check, backups, monitoring, retention, and least-privilege staff provisioning in the Firebase project.
- Publish and test `firestore.rules` in the Firebase Emulator Suite before using real resident data. The local Flutter widget tests do not prove cloud rule enforcement.
- Confirm hostel policy and retention for outpasses, complaint details, feedback, fees, and student identifiers before production.
