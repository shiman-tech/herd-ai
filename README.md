# Herd AI

A fully offline, production-grade Flutter application for AI-powered livestock identification, indigenous breed recognition, and end-to-end dairy herd management. Point your camera at a cow or buffalo to identify it from your registered herd using on-device machine learning, detect its breed across 34 classes, track daily milk yield & lactation cycles, manage health and vaccination schedules, and receive proactive alerts — 100% offline with zero cloud dependency.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
  - [1. AI Identification & Breed Recognition](#1-ai-identification--breed-recognition)
  - [2. Herd Registry & Multi-Faceted Filtering](#2-herd-registry--multi-faceted-filtering)
  - [3. Cattle Detail & Lifecycle Management](#3-cattle-detail--lifecycle-management)
  - [4. Milk Yield Management & Lactation Analytics](#4-milk-yield-management--lactation-analytics)
  - [5. Smart Notifications & Proactive Alerts](#5-smart-notifications--proactive-alerts)
  - [6. Multi-Language Support (10 Indian Languages)](#6-multi-language-support-10-indian-languages)
- [Dual On-Device ML Pipeline](#dual-on-device-ml-pipeline)
  - [1. Facial Identification Model (MobileNetV2 Embedding)](#1-facial-identification-model-mobilenetv2-embedding)
  - [2. Breed Classification Model (EfficientNet)](#2-breed-classification-model-efficientnet)
  - [3. Cosine Similarity Matching Engine](#3-cosine-similarity-matching-engine)
- [Authentication & Security](#authentication--security)
- [Database Architecture & Storage](#database-architecture--storage)
  - [SQLite Schema (v8)](#sqlite-schema-v8)
  - [In-Memory Cache & Threading](#in-memory-cache--threading)
  - [Media Management & Integrity](#media-management--integrity)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Setup & Getting Started](#setup--getting-started)
- [Platform Notes](#platform-notes)
  - [Android](#android)
  - [iOS](#ios)
  - [Desktop (Windows / macOS / Linux)](#desktop-windows--macos--linux)
- [Tuning & Configuration](#tuning--configuration)
- [Troubleshooting](#troubleshooting)

---

## Overview

Herd AI is built for farmers, dairy cooperatives, veterinarians, and livestock managers operating in rural and remote environments without reliable cellular connectivity. By leveraging on-device TensorFlow Lite neural networks, Herd AI turns any standard smartphone into an intelligent livestock biometric terminal and herd record-keeper.

### Core Capabilities
- **Biometric Face Identification:** Replaces physical tags, RFID chips, and barcodes with 128-dimensional facial embedding vectors.
- **Indigenous Breed Classification:** Identifies 34 prominent cattle and buffalo breeds (e.g., Gir, Sahiwal, Red Sindhi, Tharparkar, Ongole, Kankrej) with confidence scoring.
- **Lactation & Milk Yield Tracking:** Morning/evening yield logging, Days in Milk (DIM), Gestation tracking, Dry-off calculators, and interactive analytics charts.
- **Health & Preventative Care:** Diagnostic history, symptom records, and automated vaccination status (Up to Date, Due Soon, Overdue).
- **Proactive Farm Alerts:** Missing milk entry detection, sudden yield drops, upcoming dry-off, and calving reminders.
- **100% Offline & Private:** All ML inference and data persistence run entirely on the local device via SQLite and secure storage.

---

## Key Features

### 1. AI Identification & Breed Recognition
- **Live Camera / Gallery Picker:** Capture or select cattle portraits with automatic image downsampling and quality optimization.
- **Simultaneous Dual Inference:** Runs face embedding extraction and breed classification concurrently.
- **Confidence Scoring & Warnings:** Visual confidence badges with borderline similarity alerts to prevent accidental duplicates.
- **Quick Registration:** Seamlessly register unknown cattle with auto-populated AI breed predictions, custom tags, and notes.

### 2. Herd Registry & Multi-Faceted Filtering
- **Interactive Search:** Instant search by cattle ID, breed, or custom tags.
- **Multi-Parameter Filtering Sheet:** Filter herd by:
  - **Sex:** Male, Female, Unknown
  - **Life Stage:** Calf (<12 mo auto-assigned), Heifer, Cow, Bull, Steer
  - **Health Status:** Healthy, Under Observation, Diseased, Recovered
  - **Reproductive Status:** Pregnant, Not Pregnant, Unknown
  - **Vaccination Status:** Up to Date, Due Soon, Overdue, No Record
  - **Breed:** Filter by specific indigenous or cross breeds
- **Smart Sorting:** Sort by Registration Date, ID, Age, or Milk Yield.

### 3. Cattle Detail & Lifecycle Management
- **Demographics:** Age calculation (years & months), life stage, sex, and reproductive health.
- **Breed Verification:** View top-5 AI predicted breeds with confidence bars; allows user manual override and confirmation.
- **Multi-Photo Gallery:** Attach multiple reference photos per animal; manage linked embedding vectors per photo to continuously improve identification accuracy over time.
- **Health & Treatment Log:** Log disease incidents, active symptoms, resolution status, and veterinary treatment notes.
- **Vaccination Manager:** Track administered vaccines, schedule next due dates, and view auto-calculated overdue alerts.
- **Cascading ID Renaming & Deletion:** Safely rename or delete cattle with full relational integrity across all database tables.

### 4. Milk Yield Management & Lactation Analytics
- **Dedicated Milk Dashboard:** 
  - Today's Total Yield (Liters)
  - Active Milking Cows Count & Herd Average per Cow
  - Top and Lowest Producing Cows of the day
  - Weekly and Monthly Cumulative Totals
- **Lactation Cycle Tracking:**
  - **Days in Milk (DIM):** Auto-computed from calving date.
  - **Lactation Stages:** Automated classification into *Fresh* (0–30 d), *Early* (31–100 d), *Mid* (101–200 d), *Late* (201–305 d), *Extended* (>305 d), and *Dry*.
  - **Gestation & Dry-Off Calculations:** Estimated calving date (~283 days post-insemination) and target dry-off date (~220 days).
- **Interactive Visualizations:** 7-day milk yield trends, lactation stage distribution, and herd performance curves.
- **Reporting & CSV Export:** Generate Daily, Weekly, and Monthly milk reports with cow performance rankings and export to CSV files for cooperative record-keeping.

### 5. Smart Notifications & Proactive Alerts
- **Notification Drawer:** Accessible from the main app bar with badge counters for active alerts.
- **Alert Types:**
  - ⚠️ **Missing Daily Entry:** Alerts when an active milking cow has no yield recorded for today.
  - 📉 **Low Yield Warning:** Triggers when yield drops significantly below 30-day averages or target benchmarks.
  - ⏳ **Upcoming Dry-Off:** Reminders when cows approach target dry-off dates before calving.
  - 🍼 **Calving Reminders:** Alerts when pregnant cows reach their expected calving window.
  - 💉 **Vaccination Due / Overdue:** Notifications for pending preventative vaccines.
- **Persistent Dismissal:** Dismiss alerts individually or in bulk, with state saved in `SharedPreferences`.

### 6. Multi-Language Support (10 Indian Languages)
Fully localized UI strings and farm terminology across 10 official languages:
- **English** (`en`)
- **हिन्दी** (Hindi - `hi`)
- **বাংলা** (Bengali - `bn`)
- **ગુજરાતી** (Gujarati - `gu`)
- **ಕನ್ನಡ** (Kannada - `kn`)
- **मराठी** (Marathi - `mr`)
- **ଓଡ଼ିଆ** (Odia - `or`)
- **தமிழ்** (Tamil - `ta`)
- **తెలుగు** (Telugu - `te`)
- **اردو** (Urdu - `ur`)

Switch languages instantly in the Settings menu with real-time UI refresh.

---

## Dual On-Device ML Pipeline

```
                                  Input Image (Camera / Gallery)
                                                │
                       ┌────────────────────────┴────────────────────────┐
                       ▼                                                 ▼
             [ Preprocessing 224×224 ]                         [ Preprocessing 224×224 ]
             [  Pixel Norm [0, 1]    ]                         [  Pixel Norm [0, 1]    ]
                       │                                                 │
                       ▼                                                 ▼
            MobileNetV2 Embedding Model                       EfficientNet Breed Model
          (cow_identifier.tflite)                     (efficientnet_breed_classifier.tflite)
                       │                                                 │
                       ▼                                                 ▼
                128-dim Vector                                 Softmax Probabilities (34 classes)
                       │                                                 │
                       ▼                                                 ▼
                L2 Normalization                               Top-5 Breed Predictions
                       │                                       (e.g., Gir 94%, Sahiwal 4%)
                       ▼
        Cosine Similarity Matching Engine
         (vs. In-Memory SQLite Vectors)
                       │
       ┌───────────────┴───────────────┐
       ▼                               ▼
Match ≥ 0.75                    Match < 0.75
Identified Cow ID               Unknown (New Cattle)
```

### 1. Facial Identification Model (MobileNetV2 Embedding)
- **Model Path:** `assets/models/cow_identifier.tflite`
- **Input Tensor:** `[1, 224, 224, 3]` (float32)
- **Output Tensor:** `[1, 128]` (float32)
- **Architecture:** MobileNetV2 feature extractor with a 128-dimensional dense projection head trained on cattle face datasets.

### 2. Breed Classification Model (EfficientNet)
- **Model Path:** `assets/models/efficientnet_breed_classifier.tflite`
- **Class Map:** `assets/models/class_names.json` (34 classes)
- **Input Tensor:** `[1, 224, 224, 3]` (float32)
- **Output Tensor:** `[1, 34]` (float32 softmax probabilities)
- **Supported Breeds:** Amritmahal, Ayrshire, Bargur, Dangi, Deoni, Gir, Hallikar, Hariana, Kangayam, Kankrej, Kenkatha, Kosali, Ladakhi, Lakhimi, Mewati, Nari, Ongole, Poda Thirupu, Pulikulam, Punganur, Purnea, Rathi, Red Kandhari, Red Sindhi, Sahiwal, Tharparkar, Vechur, Bachaur, Gaolao, Motu, Nagori, Ponwar, Siri, Thutho.

### 3. Cosine Similarity Matching Engine
- Vectors are L2-normalized upon inference:
  $$\hat{\mathbf{v}} = \frac{\mathbf{v}}{\|\mathbf{v}\|_2}$$
- Cosine similarity between query vector $\mathbf{q}$ and stored vector $\mathbf{s}$:
  $$\text{Similarity}(\mathbf{q}, \mathbf{s}) = \mathbf{q} \cdot \mathbf{s} = \sum_{i=1}^{128} q_i s_i$$
- Multiple embeddings per animal are evaluated against the query; the maximum similarity across all registered photos determines identification.
- **Threshold Defaults:**
  - **Known Match:** $\ge 0.75$
  - **Borderline Warning:** $0.65 \le \text{Score} < 0.75$
  - **Unknown:** $< 0.65$

---

## Authentication & Security

- **Two-Factor Local Authentication:** Protects sensitive farm and herd data.
- **Biometric Unlock:** System-level Fingerprint / Face ID integration via `local_auth`.
- **4-Digit Secure PIN:** First-launch PIN setup and PIN fallback with SHA-256 cryptographic hashing.
- **Hardware Keystore Storage:** Hashed PIN stored in iOS Keychain / Android Keystore using `flutter_secure_storage`.
- **Intelligent Background Auto-Lock:** Re-locks the application after 2.5 seconds of background inactivity, while seamlessly suspending the lock timer during native camera and file picker actions (`AppLockController`).

---

## Database Architecture & Storage

All data is stored locally in SQLite (`herd_ai.db`) using `sqflite`.

### SQLite Schema (v8)

```sql
-- Cattle Primary Table
CREATE TABLE cattle (
  id TEXT PRIMARY KEY,
  registration_date TEXT NOT NULL,
  profile_image_path TEXT,
  breed_name TEXT,
  breed_confidence REAL,
  breed_alternatives_json TEXT,
  confirmed_breed TEXT,
  breed_confirmed_by_user INTEGER NOT NULL DEFAULT 0,
  sex TEXT,
  date_of_birth TEXT,
  life_stage TEXT,
  health_status TEXT,
  reproductive_status TEXT,
  is_milking INTEGER DEFAULT 0,
  is_pregnant INTEGER DEFAULT 0,
  calving_date TEXT,
  insemination_date TEXT,
  dry_off_date TEXT,
  expected_daily_yield REAL
);

-- Milk Yield Records
CREATE TABLE milk_records (
  id TEXT PRIMARY KEY,
  cattle_id TEXT NOT NULL,
  date TEXT NOT NULL,
  morning_yield REAL NOT NULL DEFAULT 0.0,
  evening_yield REAL NOT NULL DEFAULT 0.0,
  total_yield REAL NOT NULL DEFAULT 0.0,
  notes TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE,
  UNIQUE(cattle_id, date)
);

-- 128-dim Facial Embeddings
CREATE TABLE embeddings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  vector TEXT NOT NULL,
  source_image_path TEXT,
  image_id INTEGER,
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE,
  FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE CASCADE
);

-- Health Diagnostic Records
CREATE TABLE health_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  disease_name TEXT NOT NULL DEFAULT '',
  date TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'Ongoing',
  symptoms TEXT NOT NULL DEFAULT '',
  treatment_notes TEXT NOT NULL DEFAULT '',
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
);

-- Vaccinations
CREATE TABLE vaccinations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  vaccine_name TEXT NOT NULL DEFAULT '',
  date_given TEXT NOT NULL,
  next_due_date TEXT,
  notes TEXT NOT NULL DEFAULT '',
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
);

-- Free-Text Notes
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  content TEXT NOT NULL,
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
);

-- Multi-Photo Gallery
CREATE TABLE images (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  path TEXT NOT NULL,
  uploaded_at TEXT NOT NULL,
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
);
```

### In-Memory Cache & Threading
- On app launch, the database loads all records and embedding vectors into memory (`Map<String, CattleRecord>` and `List<MilkRecord>`).
- Similarity matching runs across in-memory vector arrays for sub-millisecond response times.
- Writes and updates synchronize simultaneously to memory and SQLite within database transactions.

### Media Management & Integrity
- Captured photos are copied into an isolated `cattle_images/` directory in the app documents storage.
- Startup integrity routine (`_repairImagePaths`, `_purgeEmbeddingsForMissingPhotos`, `_removeOrphanEmbeddings`) purges dangling references and reconciles photo-embedding links.

---

## Project Structure

```
herd-ai/
├── assets/
│   ├── logo.png                                # App launcher icon
│   └── models/
│       ├── cow_identifier.tflite               # Facial embedding TFLite model (128-dim)
│       ├── efficientnet_breed_classifier.tflite# Breed classification TFLite model (34 classes)
│       └── class_names.json                    # Class labels for breed model
├── lib/
│   ├── main.dart                               # Entry point, theme, App navigation, Identify & Herd tabs
│   ├── l10n/                                   # ARB files & generated localization delegates
│   │   ├── app_en.arb                          # English
│   │   ├── app_hi.arb                          # Hindi
│   │   ├── app_bn.arb                          # Bengali
│   │   ├── app_gu.arb                          # Gujarati
│   │   ├── app_kn.arb                          # Kannada
│   │   ├── app_mr.arb                          # Marathi
│   │   ├── app_or.arb                          # Odia
│   │   ├── app_ta.arb                          # Tamil
│   │   ├── app_te.arb                          # Telugu
│   │   └── app_ur.arb                          # Urdu
│   ├── models/
│   │   ├── breed_prediction.dart               # BreedPrediction model
│   │   ├── cattle_filter.dart                  # CattleFilterCriteria & multi-sort model
│   │   ├── cattle_image.dart                   # CattleImage metadata model
│   │   ├── cattle_record.dart                  # CattleRecord, HealthRecord, VaccinationRecord
│   │   ├── embedding_reference.dart            # EmbeddingReference vector container
│   │   ├── identification_result.dart          # IdentificationResult scoring model
│   │   └── milk_record.dart                    # MilkRecord daily yield model
│   ├── services/
│   │   ├── app_auth_service.dart               # PIN (SHA-256) & Biometric auth service
│   │   ├── app_language_service.dart           # Locale management & persistence
│   │   ├── app_lock_controller.dart            # Background lock suspend/resume coordinator
│   │   ├── embedding_database.dart             # SQLite persistence, cache & cosine matching engine
│   │   ├── milk_analytics_service.dart         # Herd milk summaries, stats & smart alerts engine
│   │   ├── milk_report_service.dart            # Daily/Weekly/Monthly reports & CSV generator
│   │   ├── tflite_breed_service.dart           # EfficientNet breed inference service
│   │   └── tflite_embedding_service.dart       # MobileNetV2 embedding inference service
│   ├── utils/
│   │   ├── localized_alerts.dart               # Localized string formatters for notification alerts
│   │   ├── localized_labels.dart               # Localized status & enum label helpers
│   │   └── math_utils.dart                     # L2 normalization & vector cosine similarity
│   └── widgets/
│       ├── auth_gate.dart                      # Lock screen, PIN pad, & lifecycle observer
│       ├── cattle_detail_page.dart             # Comprehensive cattle management profile
│       ├── cattle_filter_sheet.dart            # Multi-parameter bottom sheet filter
│       ├── milk_chart_widgets.dart             # Custom paint milk yield trend & distribution charts
│       ├── milk_entry_dialog.dart              # Morning/Evening milk entry logging dialog
│       ├── milk_reports_sheet.dart             # Periodic milk reports & CSV export sheet
│       ├── milk_yield_management_page.dart     # Dedicated Milk Yield tab & lactation dashboard
│       └── notifications_sheet.dart            # Proactive smart farm alerts drawer
├── identification_model.py                     # Python training script (MobileNetV2 feature extractor)
├── export_embedding_tflite.py                  # Python TFLite export & quantization script
├── pubspec.yaml                                # Dependencies & asset declarations
└── l10n.yaml                                   # Flutter localization generator configuration
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `tflite_flutter` | `^0.12.1` | High-performance on-device TensorFlow Lite neural inference |
| `sqflite` | `^2.4.2` | Local SQLite relational database persistence |
| `image` | `^4.5.4` | Image decoding, bilinear resizing, and pixel tensor extraction |
| `image_picker` | `^1.1.2` | Camera capture and gallery image selection |
| `local_auth` | `^2.3.0` | Biometric authentication (Fingerprint, Touch ID, Face ID) |
| `flutter_secure_storage` | `^9.2.4` | Keychain/Keystore encrypted PIN storage |
| `shared_preferences` | `^2.5.5` | Persistent language selection and dismissed alert settings |
| `crypto` | `^3.0.6` | Cryptographic SHA-256 PIN hashing |
| `intl` | `0.20.2` | Date formatting and localization utilities |
| `flutter_localizations` | SDK | Multi-language localization delegates |
| `path_provider` | `^2.1.5` | File system location provider for local database and images |
| `path` | `^1.9.1` | Cross-platform file path manipulation |
| `flutter_launcher_icons` | `^0.13.1` | Generates Android/iOS platform launcher icons |

---

## Setup & Getting Started

### Prerequisites
- **Flutter SDK:** `>= 3.9.2` (Channel stable)
- **Dart SDK:** `>= 3.9.2`
- **Platform Toolchains:** Android Studio (SDK 21+) / Xcode (iOS 13+)

### Installation & Launch

1. **Clone the repository:**
   ```bash
   git clone https://github.com/shiman-tech/herd-ai.git
   cd herd-ai
   ```

2. **Ensure TFLite models are placed in `assets/models/`:**
   - `assets/models/cow_identifier.tflite`
   - `assets/models/efficientnet_breed_classifier.tflite`
   - `assets/models/class_names.json`

3. **Install dependencies and generate localization delegates:**
   ```bash
   flutter pub get
   flutter gen-l10n
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

> **Note on hot reload:** After modifying assets, TFLite binaries, or localization ARB files, perform a full app restart (`R` in terminal or stop and rerun).

---

## Platform Notes

### Android
- Permissions for Camera and Storage are handled at runtime.
- Minimum SDK: `minSdkVersion 21`.

### iOS
Ensure the following permission strings are present in `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Used to photograph cattle for biometric identification and gallery records.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to select cattle photos from your photo library.</string>
<key>NSFaceIDUsageDescription</key>
<string>Used to authenticate and unlock your farm herd records.</string>
```

### Desktop (Windows / macOS / Linux)
- **Windows:** Requires TensorFlow Lite C library `blobs/libtensorflowlite_c-win.dll` bundled or in the system PATH.
- **macOS / Linux:** Requires respective `.dylib` or `.so` libraries configured according to `tflite_flutter` guidelines.

---

## Tuning & Configuration

Key configuration variables can be customized in the codebase:

| Parameter | Location | Default | Description |
|-----------|----------|---------|-------------|
| Identification Threshold | `EmbeddingDatabase(similarityThreshold:)` | `0.75` | Minimum cosine similarity required to identify a registered animal |
| Borderline Warning | `IdentificationResult.borderlineThreshold` | `0.65` | Similarity threshold that prompts potential duplicate warnings |
| Breed Top-N Results | `TfliteBreedService.topN` | `5` | Number of candidate breed predictions returned |
| Background Lock Timeout | `AuthGateState._lockTimeout` | `2500 ms` | Inactivity threshold before prompting PIN/biometric re-lock |
| Image Capture Quality | `main.dart` `_pickImage()` | `95%` | JPEG compression quality |
| Max Image Resolution | `main.dart` `_pickImage()` | `1600 px` | Max dimension downscaling for captured photos |
| Gestation Duration | `CattleRecord.expectedCalvingDate` | `283 days` | Standard bovine gestation period |
| Target Dry-Off Period | `CattleRecord.targetDryOffDate` | `220 days` | Days post-insemination (~60 days pre-calving) for dry-off |

---

## Troubleshooting

### "Model not loaded" or buttons disabled
1. Confirm both `.tflite` files and `class_names.json` exist in `assets/models/`.
2. Verify `pubspec.yaml` contains:
   ```yaml
   flutter:
     assets:
       - assets/models/
   ```
3. Run `flutter pub get` and do a full restart.

### Biometric unlock does not trigger
- Ensure at least one fingerprint or Face ID profile is enrolled on the physical test device.
- Emulators without biometric enrollment will default to the 4-digit PIN screen.
- Tap **Try fingerprint/face** on the PIN screen to retry.

### CSV Export or Reports Sheet not opening
- Ensure at least one milk record exists in the database.
- Generated CSV text can be previewed directly in the sheet or shared to other applications.

---

## License
Private and Proprietary. All rights reserved.
