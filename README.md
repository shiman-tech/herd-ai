# Herd AI

Offline Flutter prototype for AI-powered livestock identification.

## Workflow

This prototype follows the required pipeline:

1. Train the model in Python with TensorFlow/Keras.
2. Export the 128-dimensional embedding model to TensorFlow Lite.
3. Load the local `.tflite` model in Flutter.
4. Run on-device inference and cosine-similarity matching against a local embedding database.

The training reference is in `identification_model.py`.

## Flutter Features

- Capture image with camera
- Select image from gallery
- Run local TFLite inference
- Generate normalized 128-dim embedding
- Compare against local cow embeddings with cosine similarity
- Return best match or `Unknown`
- Register a new cow by saving an embedding locally

## Project Structure

- `identification_model.py`: reference Keras training and embedding logic
- `export_embedding_tflite.py`: converts a trained Keras model to `.tflite`
- `lib/services/tflite_embedding_service.dart`: image preprocessing and TFLite inference
- `lib/services/embedding_database.dart`: local JSON-backed embedding database and matching
- `assets/database/seed_embeddings.json`: starter offline embedding store
- `assets/models/`: location for the exported `cow_identifier.tflite`

## Export The Model

Train and save your Keras model first, then export the embedding model:

```bash
python export_embedding_tflite.py
```

The app expects:

- `assets/models/cow_identifier.tflite`
- Input shape `[1, 224, 224, 3]`
- Output shape `[1, 128]`

## Run The App

```bash
flutter pub get
flutter run
```

## Common Failure Fix

If you can select an image but `Identify` / `Register` do not work, the model
usually was not loaded as a Flutter asset.

Checklist:

1. Ensure the file exists as `assets/models/cow_identifier.tflite` in this repo.
2. Confirm `pubspec.yaml` includes:
   - `assets/models/`
3. Run:
   - `flutter pub get`
   - full app restart (not only hot reload)
4. Verify the app header shows model input/output shapes after startup.

### Windows Desktop Note (critical)

For Windows desktop, `tflite_flutter` needs a native TensorFlow Lite DLL in
addition to the `.tflite` file:

- Required: `blobs/libtensorflowlite_c-win.dll`

If this DLL is missing, the app can still pick images but model inference
(`Identify` / `Register`) will fail during initialization.

## Notes

- Preprocessing mirrors the Python reference: resize to `224x224`, convert to RGB, divide by `255.0`
- Output embeddings are L2-normalized before matching
- Similarity threshold is currently `0.88` and can be tuned in `EmbeddingDatabase`
