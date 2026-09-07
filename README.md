# library_mobile_app

A new Flutter project.

## Android emulator debug connection

Run the app after Android has finished booting:

```powershell
flutter run -d emulator-5554
```

If the APK installs but Flutter reports `DartDevelopmentServiceException` with
`127.0.0.1` connection refused, check the emulator connection with
`adb devices -l` and `adb forward --list`. During the failure investigated on
2026-09-07, ADB repeatedly disconnected and lost the debug port forwarding while
the app stayed alive. Disabling DDS did not prevent the disconnection.

Cold-booting the Pixel_8 emulator restored the connection. Its local AVD settings
were changed to `fastboot.forceColdBoot=yes` and `fastboot.forceFastBoot=no` to
avoid restoring the previous Quick Boot state. Booting will take longer. The
original settings are backed up beside the AVD's `config.ini` as
`config.ini.before-debug-connection-fix.bak`.

If this recurs, stop the Flutter run and use **Cold Boot** for Pixel_8 in Android
Studio's Device Manager. Wait until Android finishes booting before running
Flutter again; `adb -s emulator-5554 shell getprop sys.boot_completed` should
return `1`. A cold boot preserves installed apps and data.

See Android's [emulator startup options](https://developer.android.com/studio/run/emulator-commandline#common).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
