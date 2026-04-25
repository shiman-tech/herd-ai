Windows desktop runtime dependency for `tflite_flutter`:

Place this file in this folder before running desktop builds:

`blobs/libtensorflowlite_c-win.dll`

Without it, model loading fails even when `cow_identifier.tflite` exists.

Typical flow:
1. Build or download TensorFlow Lite C library for Windows.
2. Rename/copy to `libtensorflowlite_c-win.dll`.
3. Place inside this `blobs/` folder.
4. Run a full rebuild:
   - `flutter clean`
   - `flutter pub get`
   - `flutter run -d windows`
