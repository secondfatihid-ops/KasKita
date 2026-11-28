# flutter_mobile

## Backend connection

Start the Express backend before running the app. It listens on port `5000`
and serves the API under `/api`.

- Chrome uses the browser's host name with port `5000`.
- The Android Studio emulator uses `10.0.2.2:5000` to reach the host computer.
- For a physical phone, configure the computer's LAN address:

```sh
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:5000/api
```

Replace the example address with the computer's reachable IP. The phone and
computer must be on the same network, and the computer firewall must allow
connections to port `5000`. Use an HTTPS `API_BASE_URL` when serving the web app
over HTTPS to avoid browser mixed-content restrictions.
