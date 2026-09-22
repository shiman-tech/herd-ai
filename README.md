# Herd AI

A fully offline, production-grade Flutter application for AI-powered livestock identification, indigenous breed recognition, and end-to-end dairy herd management. Point your camera at a cow or buffalo to identify it from your registered herd using on-device machine learning, detect its breed across 34 classes, track daily milk yield & lactation cycles, manage health and vaccination schedules, and receive proactive alerts — 100% offline with zero cloud dependency.

---

## Table of Contents

- [Overview](#overview)
- [How It Works](#how-it-works)
- [On-Device ML Architecture & TFLite Inference](#on-device-ml-architecture--tflite-inference)
  - [1. Facial Identification Model (Python Training)](#1-facial-identification-model-python-training)
  - [2. Exporting Embedding Model to TFLite (Python)](#2-exporting-embedding-model-to-tflite-python)
  - [3. On-Device Embedding Inference Engine (Flutter)](#3-on-device-embedding-inference-engine-flutter)
  - [4. On-Device Breed Classification Engine (Flutter)](#4-on-device-breed-classification-engine-flutter)
  - [5. Cosine Similarity Matching Engine & Multi-Embeddings](#5-cosine-similarity-matching-engine--multi-embeddings)
  - [6. Parallel Pipeline Execution](#6-parallel-pipeline-execution)
- [App Features & Workflows](#app-features--workflows)
  - [Identify Tab & Dual ML Inference](#identify-tab--dual-ml-inference)
  - [My Cattle & Multi-Faceted Registry](#my-cattle--multi-faceted-registry)
  - [Cattle Profile & Complete Life History](#cattle-profile--complete-life-history)
  - [Milk Yield Management & Lactation Dashboard](#milk-yield-management--lactation-dashboard)
  - [Smart Notifications & Proactive Farm Alerts](#smart-notifications--proactive-farm-alerts)
  - [Multi-Language Support (10 Indian Languages)](#multi-language-support-10-indian-languages)
- [Authentication & Security](#authentication--security)
- [Database Architecture & SQLite Schema](#database-architecture--sqlite-schema)
  - [SQLite Schema (v8)](#sqlite-schema-v8)
  - [In-Memory Cache & Media Integrity](#in-memory-cache--media-integrity)
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

Herd AI is engineered for dairy farmers, livestock cooperatives, veterinarians, and cattle breeders operating in rural and remote regions without internet or cellular connectivity. By running optimized TensorFlow Lite models directly on standard smartphones, Herd AI turns mobile devices into intelligent biometric scanners and automated farm ledger systems.

### Core Highlights
- **Biometric Face Identification:** Replaces unreliable ear tags, RFID chips, and barcodes with 128-dimensional facial embedding vectors.
- **Indigenous Breed Classification:** Identifies 34 prominent cattle and buffalo breeds (e.g., Gir, Sahiwal, Red Sindhi, Tharparkar, Ongole, Kankrej) with confidence ranking.
- **Lactation & Milk Yield Tracking:** Daily morning/evening logs, Days in Milk (DIM), lactation stage classification, gestation calculators, and target dry-off alerts.
- **Preventative Health & Care:** Diagnostic histories, disease statuses, and automated vaccination status indicators (Up to Date, Due Soon, Overdue).
- **Proactive Farm Alerts:** Missing milk entry detection, sudden yield drops, upcoming dry-off, and calving reminders.
- **100% Offline & Private:** All neural network inference and data persistence run entirely locally using SQLite, `flutter_secure_storage`, and on-device TFLite runtimes.

---

## How It Works

```
                                      Captured / Uploaded Image
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
                         │                                       (e.g., Gir 94.2%, Sahiwal 3.8%)
                         ▼
          Cosine Similarity Matching Engine
           (vs. In-Memory SQLite Vectors)
                         │
         ┌───────────────┴───────────────┐
         ▼                               ▼
  Score ≥ 0.75                     Score < 0.75
  Identified Cattle ID             Unknown (Prompt Registration)
```

1. The farmer captures or selects an image of the cattle's face.
2. The image is preprocessed (decoded, resized to $224 \times 224$, and normalized to $[0, 1]$).
3. Two independent on-device TFLite models execute inference:
   - **Embedding Model:** Outputs a 128-dimensional float32 vector, which is L2-normalized onto a unit hypersphere.
   - **Breed Model:** Outputs a 34-class softmax probability distribution mapped against `class_names.json`.
4. The normalized embedding is matched against all stored vectors in the local SQLite database using Cosine Similarity.
5. If the maximum similarity score exceeds the threshold ($0.75$), the animal is identified. Otherwise, it is flagged as `Unknown` and can be registered in one tap.

---

## On-Device ML Architecture & TFLite Inference

Herd AI employs a dual on-device neural network pipeline optimized for low-latency mobile inference.

### 1. Facial Identification Model (Python Training)

**Source File:** [`identification_model.py`](identification_model.py)

The reference training pipeline uses transfer learning with MobileNetV2 on bovine facial images:

| Parameter | Specification |
|-----------|---------------|
| **Dataset** | Cattely Cattle Face Images Dataset (~50 cows, ~2,500 frontal images) |
| **Augmentation** | Horizontal flip, 30% zoom, $\pm 20^\circ$ rotation, brightness $[0.8, 1.2]$ |
| **Base Architecture** | `MobileNetV2(input_shape=(224, 224, 3), weights='imagenet', include_top=False)` |
| **Fine-Tuning** | Base layers frozen except the final 20 layers |
| **Classifier Head** | `GlobalAveragePooling2D` $\rightarrow$ `Dense(128, activation='relu')` $\rightarrow$ `Dropout(0.5)` $\rightarrow$ `Dense(num_classes, softmax)` |
| **Optimizer & Loss** | Adam ($\text{lr} = 10^{-4}$), Categorical Cross-Entropy |
| **Embedding Extractor** | Penultimate layer (`Dense(128)`) extracted as the standalone embedding model |

```python
# Extraction of the 128-dim embedding branch
embedding_model = tf.keras.Model(
    inputs=model.input,
    outputs=model.layers[-2].output  # Penultimate Dense(128) layer
)
```

### 2. Exporting Embedding Model to TFLite (Python)

**Source File:** [`export_embedding_tflite.py`](export_embedding_tflite.py)

Converts the trained Keras embedding branch into a lightweight `.tflite` model with dynamic-range quantization:

```bash
python export_embedding_tflite.py
```

```python
converter = tf.lite.TFLiteConverter.from_keras_model(embedding_model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # Dynamic-range quantization
tflite_model = converter.convert()

Path("assets/models/cow_identifier.tflite").write_bytes(tflite_model)
```

| Property | Value |
|----------|-------|
| **Input Tensor Shape** | `[1, 224, 224, 3]` — `float32` |
| **Output Tensor Shape** | `[1, 128]` — `float32` |
| **Asset Location** | `assets/models/cow_identifier.tflite` |

---

### 3. On-Device Embedding Inference Engine (Flutter)

**Source File:** [`lib/services/tflite_embedding_service.dart`](lib/services/tflite_embedding_service.dart)

`TfliteEmbeddingService` manages the native TensorFlow Lite C-API runtime lifecycle:

#### Model Loading & Tensor Shape Validation
```dart
Future<void> loadModel() async {
  _interpreter = await Interpreter.fromAsset('assets/models/cow_identifier.tflite');
  _inputShape = _interpreter!.getInputTensor(0).shape;   // Expects [1, 224, 224, 3]
  _outputShape = _interpreter!.getOutputTensor(0).shape; // Expects [1, 128]
  _validateModelTensors();
}
```

#### Preprocessing & Inference Pipeline (`getEmbedding`)
1. **Raw Byte Decoding:** Reads the image file and decodes it using the pure-Dart `image` package.
2. **Bilinear Resizing:** Resizes to $224 \times 224$ pixels via `img.copyResize(decoded, width: 224, height: 224, interpolation: img.Interpolation.linear)`.
3. **RGB Normalization Tensor:** Constructs a 4D nested list `[1, 224, 224, 3]` dividing each RGB channel by $255.0$:
   ```dart
   final List<List<List<List<double>>>> input = [
     List.generate(224, (y) => List.generate(224, (x) {
       final pixel = resized.getPixel(x, y);
       return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
     }))
   ];
   ```
4. **Interpreter Execution:** Runs inference into a pre-allocated `[1, 128]` output buffer:
   ```dart
   final List<List<double>> output = [List<double>.filled(128, 0)];
   interpreter.run(input, output);
   ```
5. **L2 Unit Normalization:** Projects the raw embedding onto the unit hypersphere:
   ```dart
   return normalizeEmbedding(output.first);
   ```

---

### 4. On-Device Breed Classification Engine (Flutter)

**Source File:** [`lib/services/tflite_breed_service.dart`](lib/services/tflite_breed_service.dart)

`TfliteBreedService` handles indigenous breed classification using an EfficientNet model:

- **Model Asset:** `assets/models/efficientnet_breed_classifier.tflite`
- **Classes Asset:** `assets/models/class_names.json` (34 indigenous & cross breeds)
- **Input Tensor:** `[1, 224, 224, 3]` (`float32`, normalized $[0, 1]$)
- **Output Tensor:** `[1, 34]` (`float32` softmax probabilities)

#### Breed Inference & Top-N Ranking (`classifyBreed`)
```dart
Future<List<BreedPrediction>> classifyBreed(File imageFile) async {
  // Preprocess image (224x224, RGB normalized [0, 1])
  ...
  final List<List<double>> output = [List<double>.filled(numClasses, 0)];
  _interpreter!.run(input, output);
  
  final List<double> probs = output.first;
  final List<BreedPrediction> predictions = [];
  for (int i = 0; i < probs.length && i < _classNames.length; i++) {
    predictions.add(BreedPrediction(name: _classNames[i], confidence: probs[i]));
  }
  // Sort descending by confidence and return top 5
  predictions.sort((a, b) => b.confidence.compareTo(a.confidence));
  return predictions.take(5).toList();
}
```

**Supported Breeds (34 Classes):**  
*Amritmahal, Ayrshire, Bargur, Dangi, Deoni, Gir, Hallikar, Hariana, Kangayam, Kankrej, Kenkatha, Kosali, Ladakhi, Lakhimi, Mewati, Nari, Ongole, Poda Thirupu, Pulikulam, Punganur, Purnea, Rathi, Red Kandhari, Red Sindhi, Sahiwal, Tharparkar, Vechur, Bachaur, Gaolao, Motu, Nagori, Ponwar, Siri, Thutho.*

---

### 5. Cosine Similarity Matching Engine & Multi-Embeddings

**Source Files:** [`lib/utils/math_utils.dart`](lib/utils/math_utils.dart), [`lib/services/embedding_database.dart`](lib/services/embedding_database.dart)

#### Mathematical Formulation
Because all stored vectors $\mathbf{s}$ and query vectors $\mathbf{q}$ are pre-normalized to unit length ($\|\mathbf{q}\|_2 = 1, \|\mathbf{s}\|_2 = 1$), the cosine similarity reduces to a dot product:

$$\text{Similarity}(\mathbf{q}, \mathbf{s}) = \mathbf{q} \cdot \mathbf{s} = \sum_{i=1}^{128} q_i s_i$$

```dart
List<double> normalizeEmbedding(List<double> embedding) {
  final double norm = sqrt(embedding.fold(0.0, (sum, val) => sum + val * val));
  if (norm == 0.0) return embedding;
  return embedding.map((val) => val / norm).toList();
}

double cosineSimilarity(List<double> a, List<double> b) {
  double dot = 0.0;
  for (int i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
  }
  return dot;
}
```

#### Multi-Embedding Evaluation Algorithm
Each registered cattle profile can hold **multiple reference embeddings** (one per photo). The database searches across every stored embedding:

```
for each CattleRecord in database:
  for each EmbeddingReference in cattle.embeddings:
    score = cosineSimilarity(queryEmbedding, embedding.vector)
    if score > highestGlobalScore:
      highestGlobalScore = score
      predictedCattleId = cattle.id

if highestGlobalScore >= similarityThreshold (0.75):
  Result: Identified (known cattle)
else if highestGlobalScore >= borderlineThreshold (0.65):
  Result: Unknown + Borderline Warning (possible duplicate)
else:
  Result: Unknown (new registration)
```

---

### 6. Parallel Pipeline Execution

To deliver instantaneous UI response on app start and during identification:
- **Parallel Startup:** `AppLanguageService`, `EmbeddingDatabase`, and `MilkAnalyticsService` load in parallel during splash initialization.
- **Parallel Model Initialization:** `Future.wait([_embeddingService.loadModel(), _breedService.loadModel(), _database.load()])` initializes both TFLite interpreters concurrently.
- **Parallel Inference on Image Selection:** In `_identifyCattle()`, embedding extraction and breed classification run concurrently via `Future.wait`.

---

## App Features & Workflows

### Identify Tab & Dual ML Inference
- **Capture / Upload:** Camera integration with memory optimization and orientation handling.
- **Prediction Cards:** Displays predicted cattle ID, identification confidence percentage, and top AI-predicted breed with confidence progress bar.
- **One-Tap Registration:** If result is `Unknown`, tap **Add this Cattle** to open pre-filled registration dialog.

### My Cattle & Multi-Faceted Registry
- **Search:** Real-time search across ID, notes, and breed tags.
- **Advanced Filtering Sheet (`CattleFilterSheet`):**
  - Sex (Male / Female / Unknown)
  - Life Stage (Calf, Heifer, Cow, Bull, Steer)
  - Health Status (Healthy, Under Observation, Diseased, Recovered)
  - Reproductive Status (Pregnant, Not Pregnant, Unknown)
  - Vaccination Status (Up to Date, Due Soon, Overdue, No Record)
  - Breed selector
- **Multi-Sort:** Sort by newest, oldest, alphabetical ID, age, or milk yield.

### Cattle Profile & Complete Life History
- **Demographics:** Auto-calculated age display, life stage, sex, and breeding records.
- **Breed Verification:** User can confirm the top AI-predicted breed or select from alternative suggestions.
- **Gallery & Embedding Management:** Add/replace photos; delete individual photos with automated cascading cleanup of their linked embedding vectors.
- **Health Records:** Full diagnostic logs, disease history, and symptom notes.
- **Vaccinations:** Schedule dates, track administered doses, and view auto-calculated overdue alerts.
- **Relational Integrity:** Edit cattle ID with cascading updates across all child tables.

### Milk Yield Management & Lactation Dashboard
- **Dashboard Metrics:** Today's Total Herd Yield, Active Milking Count, Herd Average per Cow, Top/Lowest Producers.
- **Lactation Tracking:**
  - **Days in Milk (DIM):** Today $-$ Calving Date.
  - **Stages:** Fresh (0–30 d), Early (31–100 d), Mid (101–200 d), Late (201–305 d), Extended (>305 d), Dry.
  - **Gestation & Dry-Off:** Calving date (~283 d post-insemination) and recommended dry-off date (~220 d post-insemination).
- **Interactive Visualizations:** 7-day milk yield trends, lactation stage distribution, and herd performance curves.
- **Reports & CSV Export:** Daily, Weekly, and Monthly milk reports with individual cow rankings and standard CSV export.

### Smart Notifications & Proactive Farm Alerts
- **Missing Daily Entry:** Alerts if an active milking cow hasn't had yield logged today.
- **Low Yield Warning:** Triggers when yield drops $>20\%$ below 30-day average.
- **Upcoming Dry-Off:** Notifies when cows are within 14 days of target dry-off.
- **Calving Reminders:** Alerts within 14 days of expected calving date.
- **Vaccination Overdue / Due Soon:** Proactive alerts for preventative vaccinations.

### Multi-Language Support (10 Indian Languages)
Real-time in-app switching across 10 languages:
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

---

## Authentication & Security

- **Two-Factor Local Authentication:** Protects sensitive farm and herd data.
- **Biometric Unlock:** System-level Fingerprint / Face ID via `local_auth`.
- **4-Digit Secure PIN:** First-launch PIN setup with SHA-256 cryptographic hashing.
- **Hardware Keystore Storage:** Hashed PIN stored in iOS Keychain / Android Keystore using `flutter_secure_storage`.
- **Background Auto-Lock:** Re-locks after 2.5 seconds of background inactivity, while `AppLockController` safely suspends locking during native camera/gallery pickers.

---

## Database Architecture & SQLite Schema

All records are stored locally in `herd_ai.db` via `sqflite`.

### SQLite Schema (v8)

```sql
-- Cattle Master Table
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

-- Daily Milk Records
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

-- Health Diagnostics
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

-- Photo Gallery
CREATE TABLE images (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cattle_id TEXT NOT NULL,
  path TEXT NOT NULL,
  uploaded_at TEXT NOT NULL,
  FOREIGN KEY (cattle_id) REFERENCES cattle(id) ON DELETE CASCADE
);
```

### In-Memory Cache & Media Integrity
- All records and vectors load into RAM at startup (`Map<String, CattleRecord>`) for instantaneous vector search.
- Photos are saved permanently to `cattle_images/` in the app documents directory.
- Startup integrity cleaners (`_repairImagePaths`, `_purgeEmbeddingsForMissingPhotos`, `_removeOrphanEmbeddings`) reconcile media links and remove dangling vectors.

---

## Project Structure

```
herd-ai/
├── assets/
│   ├── logo.png                                # App launcher icon
│   └── models/
│       ├── cow_identifier.tflite               # 128-dim facial embedding model
│       ├── efficientnet_breed_classifier.tflite# 34-class breed classifier model
│       └── class_names.json                    # 34 breed label mapping
├── lib/
│   ├── main.dart                               # Entry point, Theme, Navigation, Identify & Herd tabs
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
│   │   ├── breed_prediction.dart               # Breed prediction class
│   │   ├── cattle_filter.dart                  # Multi-attribute filter & sort model
│   │   ├── cattle_image.dart                   # Photo record model
│   │   ├── cattle_record.dart                  # CattleRecord, HealthRecord, VaccinationRecord
│   │   ├── embedding_reference.dart            # Embedding container & legacy parser
│   │   ├── identification_result.dart          # Identification scoring model
│   │   └── milk_record.dart                    # Daily milk entry model
│   ├── services/
│   │   ├── app_auth_service.dart               # PIN (SHA-256) & Biometric auth
│   │   ├── app_language_service.dart           # Locale persistence & management
│   │   ├── app_lock_controller.dart            # Background lock suspend/resume logic
│   │   ├── embedding_database.dart             # SQLite persistence & Cosine matching engine
│   │   ├── milk_analytics_service.dart         # Herd summary, lactation stats & alerts engine
│   │   ├── milk_report_service.dart            # Periodic reports & CSV generator
│   │   ├── tflite_breed_service.dart           # EfficientNet on-device inference service
│   │   └── tflite_embedding_service.dart       # MobileNetV2 on-device embedding service
│   ├── utils/
│   │   ├── localized_alerts.dart               # Alert string formatters
│   │   ├── localized_labels.dart               # Label translation helpers
│   │   └── math_utils.dart                     # L2 normalization & Cosine similarity
│   └── widgets/
│       ├── auth_gate.dart                      # PIN pad, biometric prompt & lifecycle observer
│       ├── cattle_detail_page.dart             # Cattle profile & lifecycle manager
│       ├── cattle_filter_sheet.dart            # Multi-parameter filter sheet
│       ├── milk_chart_widgets.dart             # Custom paint milk yield charts
│       ├── milk_entry_dialog.dart              # Morning/evening milk log dialog
│       ├── milk_reports_sheet.dart             # Periodic report viewer & CSV exporter
│       ├── milk_yield_management_page.dart     # Dedicated Milk Yield tab
│       └── notifications_sheet.dart            # Proactive smart farm alerts drawer
├── identification_model.py                     # Python Keras MobileNetV2 training script
├── export_embedding_tflite.py                  # Python TFLite export & quantization script
├── pubspec.yaml                                # Dependencies & asset declarations
└── l10n.yaml                                   # Flutter localization generator configuration
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `tflite_flutter` | `^0.12.1` | Native TensorFlow Lite runtime for on-device inference |
| `sqflite` | `^2.4.2` | Local SQLite relational database persistence |
| `image` | `^4.5.4` | Image decoding, resizing, and pixel extraction |
| `image_picker` | `^1.1.2` | Native camera capture and photo gallery picker |
| `local_auth` | `^2.3.0` | Biometric unlock (Fingerprint, Touch ID, Face ID) |
| `flutter_secure_storage` | `^9.2.4` | Hardware Keystore/Keychain secure PIN storage |
| `shared_preferences` | `^2.5.5` | Persistent language and dismissed alert settings |
| `crypto` | `^3.0.6` | SHA-256 PIN hashing |
| `intl` | `0.20.2` | Date/time formatting and localization |
| `flutter_localizations` | SDK | Multi-language localization support |
| `path_provider` | `^2.1.5` | Access to local filesystem storage |
| `path` | `^1.9.1` | Cross-platform file path manipulation |
| `flutter_launcher_icons` | `^0.13.1` | App launcher icon generation |

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

2. **Verify TFLite model assets in `assets/models/`:**
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

> **Important:** Always do a full restart (not hot reload) after replacing `.tflite` model files or updating asset configurations.

---

## Platform Notes

### Android
- Permissions for Camera and Storage are requested automatically at runtime.
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
- **Windows:** Requires `blobs/libtensorflowlite_c-win.dll` in the executable path.
- **macOS / Linux:** Requires respective `.dylib` or `.so` native libraries configured per `tflite_flutter` requirements.

---

## Tuning & Configuration

| Parameter | Location | Default | Description |
|-----------|----------|---------|-------------|
| Similarity Threshold | `EmbeddingDatabase(similarityThreshold:)` | `0.75` | Minimum cosine similarity required to match a registered animal |
| Borderline Warning | `IdentificationResult.borderlineThreshold` | `0.65` | Threshold triggering potential duplicate warning |
| Breed Top-N Results | `TfliteBreedService.topN` | `5` | Number of candidate breed predictions returned |
| Background Lock Timeout | `AuthGateState._lockTimeout` | `2500 ms` | Inactivity threshold before requiring PIN/biometrics |
| Image Quality | `main.dart` `_pickImage()` | `95%` | JPEG compression quality |
| Max Image Dimension | `main.dart` `_pickImage()` | `1600 px` | Downscales large photos to optimize memory |
| Gestation Period | `CattleRecord.expectedCalvingDate` | `283 days` | Standard bovine gestation duration |
| Target Dry-Off Period | `CattleRecord.targetDryOffDate` | `220 days` | Days post-insemination (~60 days pre-calving) for dry-off |

---

## Troubleshooting

### "Model not loaded" error
1. Confirm both `.tflite` files and `class_names.json` exist in `assets/models/`.
2. Ensure `pubspec.yaml` lists:
   ```yaml
   flutter:
     assets:
       - assets/models/
   ```
3. Run `flutter pub get` and perform a full application restart.

### Wrong tensor shape error
Verify exported models match expected dimensions:
- **Embedding Model:** Input `[1, 224, 224, 3]`, Output `[1, 128]`
- **Breed Model:** Input `[1, 224, 224, 3]`, Output `[1, 34]`

### Biometric prompt not showing
- Ensure at least one fingerprint or Face ID profile is enrolled in the device OS settings.
- Emulators without enrolled biometrics automatically default to the PIN screen. Tap **Try fingerprint/face** to retry.

---

## License
Private and Proprietary. All rights reserved.
