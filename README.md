# Herd AI

A fully offline Flutter application for AI-powered livestock identification and herd management. Point your camera at a cow, and the app identifies it from your registered herd using on-device machine learning — no internet connection required.

---

## Table of Contents

- [Overview](#overview)
- [How It Works](#how-it-works)
- [ML Pipeline](#ml-pipeline)
  - [1. Training the Model (Python)](#1-training-the-model-python)
  - [2. Exporting to TFLite](#2-exporting-to-tflite)
  - [3. On-Device Inference (Flutter)](#3-on-device-inference-flutter)
  - [4. Cosine Similarity Matching](#4-cosine-similarity-matching)
- [App Features](#app-features)
- [Authentication & Security](#authentication--security)
- [Database & Storage](#database--storage)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Setup & Running](#setup--running)
- [Platform Notes](#platform-notes)
- [Troubleshooting](#troubleshooting)
- [Tuning & Configuration](#tuning--configuration)

---

## Overview

Herd AI solves a real farming problem: reliably identifying individual cows without tags or barcodes. Each cow's visual appearance is encoded into a compact 128-dimensional numerical vector (an *embedding*). When you photograph a cow, the app runs the same encoding on-device and compares the result against every stored embedding using cosine similarity. If the best match exceeds a configurable threshold, the cow is identified; otherwise it is flagged as unknown and can be registered.

All data — embeddings, health records, vaccination history, images, and notes — is stored locally on the device using SQLite. Nothing leaves the phone.

---

## How It Works

```
Photo  →  Resize 224×224  →  Normalize pixels [0,1]  →  TFLite model
                                                               ↓
                                                     128-dim embedding
                                                               ↓
                                                     L2 normalization
                                                               ↓
                                              Cosine similarity vs. database
                                                               ↓
                                               Best match  /  Unknown
```

1. The user captures or uploads a photo.
2. The image is decoded, resized to `224×224`, and each RGB pixel is divided by `255.0`.
3. The preprocessed tensor `[1, 224, 224, 3]` is fed into the on-device TFLite model.
4. The model outputs a `[1, 128]` tensor — the raw embedding.
5. The embedding is L2-normalized so that all stored vectors sit on the unit hypersphere.
6. Cosine similarity is computed between the query embedding and every stored embedding.
7. If the best similarity score is ≥ the threshold (`0.75` by default), the cow is identified. Otherwise the result is `Unknown`.

---

## ML Pipeline

### 1. Training the Model (Python)

**File:** [`identification_model.py`](identification_model.py)

The reference training script uses TensorFlow/Keras with transfer learning on MobileNetV2:

| Step | Detail |
|------|--------|
| **Dataset** | [Cattely Cattle Face Images Dataset](https://github.com/aideep1400/Cattely-Cattle-Face-Images-Dataset) — ~50 cows, ~2,500 frontal images |
| **Augmentation** | Horizontal flip, 30% zoom, ±20° rotation, brightness ±20% |
| **Base model** | `MobileNetV2` pre-trained on ImageNet; last 20 layers unfrozen for fine-tuning |
| **Head** | `GlobalAveragePooling2D` → `Dense(128, relu)` → `Dropout(0.5)` → `Dense(num_classes, softmax)` |
| **Optimizer** | Adam, lr = 0.0001 |
| **Loss** | Categorical cross-entropy |
| **Embedding** | The 128-unit dense layer (second-to-last) is extracted as the embedding model |

After training, the full classifier model is saved. The embedding branch — everything up to and including the 128-dim dense layer — is then extracted and exported separately.

### 2. Exporting to TFLite

**File:** [`export_embedding_tflite.py`](export_embedding_tflite.py)

```bash
# Save your trained model first, then run:
python export_embedding_tflite.py
```

This script:
1. Loads the saved Keras model from `artifacts/cow_identifier.keras`.
2. Reconstructs an embedding-only model using `model.layers[-2].output` (the 128-dim Dense layer).
3. Converts it to TFLite with `DEFAULT` optimizations (dynamic-range quantization).
4. Writes the result to `assets/models/cow_identifier.tflite`.

The app expects:

| Property | Value |
|----------|-------|
| Input tensor shape | `[1, 224, 224, 3]` — float32 |
| Output tensor shape | `[1, 128]` — float32 |
| Asset path | `assets/models/cow_identifier.tflite` |

### 3. On-Device Inference (Flutter)

**File:** [`lib/services/tflite_embedding_service.dart`](lib/services/tflite_embedding_service.dart)

`TfliteEmbeddingService` manages the TFLite interpreter lifecycle:

- **`loadModel()`** — tries two candidate asset paths in order:
  1. `assets/models/cow_identifier.tflite`
  2. `models/cow_identifier.tflite` (fallback)
  
  Validates that input/output tensor shapes match `[1,224,224,3]` / `[1,128]` before returning.

- **`getEmbedding(File imageFile)`** — full preprocessing + inference pipeline:
  1. Reads the file as raw bytes.
  2. Decodes the image with the `image` package.
  3. Resizes to `224×224` using bilinear interpolation.
  4. Builds the input tensor by iterating pixels: `[r/255, g/255, b/255]`.
  5. Runs `interpreter.run(input, output)`.
  6. L2-normalizes the 128-element output vector before returning.

- **`dispose()`** — closes the interpreter to free native resources.

### 4. Cosine Similarity Matching

**File:** [`lib/utils/math_utils.dart`](lib/utils/math_utils.dart)

Two pure-Dart functions power matching:

```dart
// L2-normalize a vector so it lives on the unit hypersphere
List<double> normalizeEmbedding(List<double> embedding)

// Dot product of two unit vectors equals cosine of the angle between them
double cosineSimilarity(List<double> a, List<double> b)
```

**File:** [`lib/services/embedding_database.dart`](lib/services/embedding_database.dart) — `predictCow()`

The matcher iterates every stored embedding across every registered cow and tracks the globally highest cosine similarity score. A cow can have **multiple embeddings** (one per registration photo), making identification more robust:

```
for each CowRecord:
  for each stored embedding:
    score = cosineSimilarity(queryEmbedding, storedEmbedding)
    track best score and corresponding cow ID

if bestScore >= similarityThreshold → identified
else → Unknown
```

---

## App Features

### Identify Tab

- **Capture Image** — opens the device camera (suspends the app-lock timer while the native picker is active so the app does not re-lock mid-capture).
- **Upload Image** — opens the device photo gallery.
- **Identify Cow** — runs on-device TFLite inference and cosine-similarity matching, displaying the predicted cow ID and confidence percentage.
- **Add this cow** — appears when the result is `Unknown`; opens a dialog to assign an ID and optional note, then stores the embedding and photo permanently.

### My Cows Tab

- Searchable list of all registered cows, sorted by most recently registered.
- Each row shows the cow's profile photo thumbnail, ID, and counts of health records, vaccinations, and notes.
- Tap any cow to open the **Cow Detail Page**.

### Cow Detail Page

**File:** [`lib/widgets/cow_detail_page.dart`](lib/widgets/cow_detail_page.dart)

A full record management screen for each individual cow:

| Section | Capabilities |
|---------|-------------|
| **Basic info** | Edit cow ID; rename cascades to all child database rows |
| **Photo gallery** | Add, replace, or delete photos; first photo becomes the profile image |
| **Health records** | Add / edit / delete records with disease name, date, status (`Ongoing` / `Resolved`), symptoms, and treatment notes |
| **Vaccination records** | Add / edit / delete entries with vaccine name, date given, optional next-due date, and notes |
| **Notes** | Add / edit / delete free-text notes |

### Settings

Accessible via the gear icon on the Identify tab:

- **Change PIN** — verifies the current PIN (SHA-256 hash comparison) before accepting a new 4-digit PIN.

---

## Authentication & Security

**Files:** [`lib/widgets/auth_gate.dart`](lib/widgets/auth_gate.dart), [`lib/services/app_auth_service.dart`](lib/services/app_auth_service.dart), [`lib/services/app_lock_controller.dart`](lib/services/app_lock_controller.dart)

The app is protected by a two-factor local authentication flow:

### First Launch — PIN Creation

1. `AuthGate` detects no PIN is stored.
2. A 4-digit PIN pad is shown; the user enters and confirms their PIN.
3. The PIN is SHA-256 hashed and stored in `flutter_secure_storage` (iOS Keychain / Android Keystore).

### Subsequent Launches — Unlock Flow

```
App opens
    ↓
Has PIN?  →  No  →  PIN creation flow
    ↓ Yes
Try biometrics (fingerprint / Face ID)
    ↓ Success → Unlock
    ↓ Fail / unavailable
Enter PIN pad  →  SHA-256 hash == stored hash?  →  Unlock
```

### Background Lock

`AuthGate` observes `AppLifecycleState` changes:
- When the app moves to background/inactive, the timestamp is recorded.
- On resume, if more than **2.5 seconds** have elapsed, the lock screen is shown again.
- Short switches (< 2.5 s) are ignored to prevent locking during camera/gallery operations.
- `AppLockController` (singleton) provides `suspendLock()` / `resumeLock()` so image-picker calls can temporarily prevent the lock from triggering.

### Security Properties

| Property | Implementation |
|----------|---------------|
| PIN storage | SHA-256 hash in `flutter_secure_storage` |
| Biometric | `local_auth` — system-level fingerprint / Face ID |
| PIN length | Exactly 4 digits |
| Lock timeout | 2.5 s after backgrounding |

---

## Database & Storage

**File:** [`lib/services/embedding_database.dart`](lib/services/embedding_database.dart)

### SQLite Schema

All data is persisted in `herd_ai.db` inside the app's documents directory using `sqflite`:

```
cows
  id TEXT PRIMARY KEY
  registration_date TEXT
  profile_image_path TEXT

embeddings
  id INTEGER PRIMARY KEY AUTOINCREMENT
  cow_id TEXT → cows(id) ON DELETE CASCADE
  vector TEXT  ← JSON-encoded List<double>[128]

health_records
  id, cow_id, disease_name, date, status, symptoms, treatment_notes

vaccinations
  id, cow_id, vaccine_name, date_given, next_due_date, notes

notes
  id, cow_id, content

images
  id, cow_id, path
```

### In-Memory Cache

At startup the entire database is loaded into a `Map<String, CowRecord>` in RAM. All read operations (`getAllCows()`, `getCow()`, `predictCow()`) hit memory only; writes go to both the in-memory map and SQLite atomically.

### Image Persistence

When a photo is added, `_persistImage()` copies it from the temporary picker path into a permanent `cow_images/` subdirectory inside the app's documents directory. The file is renamed with a microsecond timestamp to avoid collisions. Broken image paths are pruned from the database on every app start via `_repairImagePaths()`.

### Legacy Migration

On first run after an upgrade from an older JSON-based format (`cow_records.json`), the database automatically migrates all records into SQLite and renames the old file to `cow_records.json.migrated`. Both the newer `{ "records": {...} }` envelope format and the older flat `{ cowId: [[embeddings]] }` format are supported.

### Data Models

**File:** [`lib/models/cow_record.dart`](lib/models/cow_record.dart)

| Model | Fields |
|-------|--------|
| `CowRecord` | `id`, `registrationDate`, `profileImagePath`, `embeddings`, `healthRecords`, `vaccinations`, `notes`, `images` |
| `HealthRecord` | `diseaseName`, `date`, `status`, `symptoms`, `treatmentNotes` |
| `VaccinationRecord` | `vaccineName`, `dateGiven`, `nextDueDate`, `notes` |
| `IdentificationResult` | `predictedCowId`, `similarity`, `isKnown` |

---

## Project Structure

```
herd-ai/
├── identification_model.py          # Reference Keras training script (MobileNetV2)
├── export_embedding_tflite.py       # Converts trained Keras model → .tflite
├── assets/
│   ├── logo.png                     # App launcher icon
│   └── models/
│       └── cow_identifier.tflite    # Exported TFLite model (place here)
├── models/
│   └── cow_identifier.tflite        # Fallback model path (optional)
└── lib/
    ├── main.dart                    # App entry point, theme, home page, tabs
    ├── models/
    │   ├── cow_record.dart          # CowRecord, HealthRecord, VaccinationRecord
    │   └── identification_result.dart
    ├── services/
    │   ├── tflite_embedding_service.dart  # TFLite loader, preprocessor, inferencer
    │   ├── embedding_database.dart        # SQLite persistence + cosine matching
    │   ├── app_auth_service.dart          # PIN (SHA-256) + biometric auth
    │   └── app_lock_controller.dart       # Background lock suspend/resume logic
    ├── utils/
    │   └── math_utils.dart          # L2 norm, normalizeEmbedding, cosineSimilarity
    └── widgets/
        ├── auth_gate.dart           # Lock screen, PIN pad, lifecycle observer
        └── cow_detail_page.dart     # Per-cow record management UI
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `tflite_flutter ^0.12.1` | Run the `.tflite` model on-device |
| `image ^4.5.4` | Decode and resize images in Dart |
| `image_picker ^1.1.2` | Camera capture and gallery access |
| `sqflite ^2.4.2` | Local SQLite database |
| `path_provider ^2.1.5` | Locate the app documents directory |
| `path ^1.9.1` | Cross-platform path joining |
| `flutter_secure_storage ^9.2.4` | Securely store the hashed PIN |
| `local_auth ^2.3.0` | Fingerprint / Face ID biometric unlock |
| `crypto ^3.0.6` | SHA-256 PIN hashing |
| `flutter_launcher_icons ^0.13.1` | Generate platform launcher icons from `assets/logo.png` |

---

## Setup & Running

### Prerequisites

- Flutter SDK (Dart SDK `^3.9.2`)
- Python 3.x + TensorFlow (for model training/export only)
- A trained and exported `.tflite` model file

### 1. Get the TFLite model

**Option A — Use a pre-trained model:** Place `cow_identifier.tflite` directly at `assets/models/cow_identifier.tflite`.

**Option B — Train and export your own:**

```bash
# Train the classifier (edit paths in identification_model.py as needed)
python identification_model.py

# Export the embedding branch to TFLite
python export_embedding_tflite.py
# Output: assets/models/cow_identifier.tflite
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

> **Important:** After adding or replacing the `.tflite` file, always do a full app restart (not hot reload). Hot reload does not re-bundle assets.

---

## Platform Notes

### Android

No special steps required. Camera and storage permissions are requested at runtime.

### iOS

Add the following keys to `ios/Runner/Info.plist` if not already present:

```xml
<key>NSCameraUsageDescription</key>
<string>Used to photograph cows for identification</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to select cow photos from your library</string>
<key>NSFaceIDUsageDescription</key>
<string>Used to unlock the app</string>
```

### Windows Desktop

`tflite_flutter` requires a native TensorFlow Lite DLL in addition to the `.tflite` asset file:

- **Required:** `blobs/libtensorflowlite_c-win.dll`

If this DLL is missing, the app will launch and allow image selection, but model inference (`Identify` / `Register`) will fail during initialization.

### macOS Desktop

`tflite_flutter` requires a TensorFlow Lite `.dylib` bundled with the app. Refer to the [tflite_flutter documentation](https://pub.dev/packages/tflite_flutter) for the correct setup steps.

### Linux Desktop

Requires a TensorFlow Lite `.so` shared library bundled with the app.

---

## Troubleshooting

### Identify / Add cow buttons do nothing after selecting a photo

The TFLite model was not loaded. Work through this checklist:

1. Confirm the file exists at `assets/models/cow_identifier.tflite`.
2. Confirm `pubspec.yaml` lists the asset:
   ```yaml
   flutter:
     assets:
       - assets/models/
   ```
3. Run `flutter pub get` and do a **full restart** (stop and re-run, not hot reload).
4. Check the app's status card on the Identify tab — any initialization error is displayed there with a **Try again** button.

### Wrong tensor shape error

Your exported model must match exactly:

| Tensor | Shape |
|--------|-------|
| Input | `[1, 224, 224, 3]` |
| Output | `[1, 128]` |

Re-export using `export_embedding_tflite.py` and confirm the penultimate layer is a 128-unit Dense layer.

### Biometric unlock not appearing

- Biometric hardware must be enrolled at the OS level.
- If no biometrics are enrolled or the device does not support them, the PIN pad is shown directly.
- Use the **Try fingerprint/face** button on the PIN screen to retry biometrics.

---

## Tuning & Configuration

| Parameter | Location | Default | Effect |
|-----------|----------|---------|--------|
| Similarity threshold | `EmbeddingDatabase` constructor | `0.75` | Lower → more lenient matching (more false positives); higher → stricter (more unknowns) |
| Lock timeout | `auth_gate.dart` | `2500 ms` | How long the app can be backgrounded before re-locking |
| Image quality | `main.dart` `_pickImage()` | `95` | JPEG quality for captured photos (1–100) |
| Max image width | `main.dart` `_pickImage()` | `1600 px` | Downscales very large captures to save memory |
| Model input size | `TfliteEmbeddingService.inputSize` | `224` | Must match the training resolution |
| Embedding size | `TfliteEmbeddingService.embeddingSize` | `128` | Must match the model's penultimate dense layer |
