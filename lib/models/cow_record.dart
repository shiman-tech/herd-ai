import 'breed_prediction.dart';
import 'cow_image.dart';
import 'embedding_reference.dart';

class CowRecord {
  CowRecord({
    required this.id,
    required this.registrationDate,
    this.profileImagePath,
    List<EmbeddingReference>? embeddings,
    List<HealthRecord>? healthRecords,
    List<VaccinationRecord>? vaccinations,
    List<String>? notes,
    List<CowImage>? images,
    this.breedName,
    this.breedConfidence,
    this.breedAlternativesJson,
    this.confirmedBreed,
    this.breedConfirmedByUser = false,
  }) : embeddings = embeddings ?? <EmbeddingReference>[],
       healthRecords = healthRecords ?? <HealthRecord>[],
       vaccinations = vaccinations ?? <VaccinationRecord>[],
       notes = notes ?? <String>[],
       images = images ?? <CowImage>[];

  final String id;
  final DateTime registrationDate;
  String? profileImagePath;
  final List<EmbeddingReference> embeddings;
  final List<HealthRecord> healthRecords;
  final List<VaccinationRecord> vaccinations;
  final List<String> notes;
  final List<CowImage> images;

  // ---------------------------------------------------------------------------
  // Breed classification fields (mutable — set by EmbeddingDatabase)
  // ---------------------------------------------------------------------------

  /// Top-1 breed name from the classifier (e.g. "Gir").
  String? breedName;

  /// Top-1 confidence in [0.0, 1.0].
  double? breedConfidence;

  /// JSON-encoded list of top-N [BreedPrediction] alternatives.
  /// Use [breedAlternatives] getter for the decoded list.
  String? breedAlternativesJson;

  /// Breed set explicitly by the user, overriding the model prediction.
  String? confirmedBreed;

  /// True when the user has actively confirmed or manually set the breed.
  bool breedConfirmedByUser;

  /// The effective breed to display: user-confirmed takes precedence.
  String? get displayBreed => confirmedBreed ?? breedName;

  List<CowImage> get imagesNewestFirst {
    final List<CowImage> sorted = List<CowImage>.from(images);
    sorted.sort(
      (CowImage a, CowImage b) => b.uploadedAt.compareTo(a.uploadedAt),
    );
    return sorted;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'registrationDate': registrationDate.toIso8601String(),
      'profileImagePath': profileImagePath,
      'embeddings': embeddings
          .map((EmbeddingReference item) => item.toJson())
          .toList(),
      'healthRecords': healthRecords
          .map((HealthRecord item) => item.toJson())
          .toList(),
      'vaccinations': vaccinations
          .map((VaccinationRecord item) => item.toJson())
          .toList(),
      'notes': notes,
      'images': images.map((CowImage item) => item.toJson()).toList(),
      'breedName': breedName,
      'breedConfidence': breedConfidence,
      'breedAlternativesJson': breedAlternativesJson,
      'confirmedBreed': confirmedBreed,
      'breedConfirmedByUser': breedConfirmedByUser,
    };
  }

  factory CowRecord.fromJson(Map<String, dynamic> json) {
    return CowRecord(
      id: json['id'] as String,
      registrationDate:
          DateTime.tryParse(json['registrationDate'] as String? ?? '') ??
          DateTime.now(),
      profileImagePath: json['profileImagePath'] as String?,
      embeddings: _parseEmbeddings(json['embeddings']),
      healthRecords: (json['healthRecords'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                HealthRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      vaccinations: (json['vaccinations'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                VaccinationRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      notes: ((json['notes'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList()),
      images: _parseImages(json['images']),
      breedName: json['breedName'] as String?,
      breedConfidence: (json['breedConfidence'] as num?)?.toDouble(),
      breedAlternativesJson: json['breedAlternativesJson'] as String?,
      confirmedBreed: json['confirmedBreed'] as String?,
      breedConfirmedByUser: (json['breedConfirmedByUser'] as bool?) ?? false,
    );
  }

  static List<CowImage> _parseImages(dynamic raw) {
    if (raw is! List<dynamic>) {
      return <CowImage>[];
    }
    if (raw.isEmpty) {
      return <CowImage>[];
    }
    if (raw.first is String) {
      return raw
          .map(
            (dynamic item) => CowImage.fromLegacyPath(item as String),
          )
          .toList();
    }
    return raw
        .map((dynamic item) => CowImage.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<EmbeddingReference> _parseEmbeddings(dynamic raw) {
    if (raw is! List<dynamic>) {
      return <EmbeddingReference>[];
    }
    if (raw.isEmpty) {
      return <EmbeddingReference>[];
    }
    if (raw.first is List<dynamic>) {
      return raw
          .map(
            (dynamic row) => EmbeddingReference.fromLegacyVector(
              (row as List<dynamic>)
                  .map((dynamic value) => (value as num).toDouble())
                  .toList(),
            ),
          )
          .toList();
    }
    return raw
        .map(
          (dynamic item) =>
              EmbeddingReference.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}

class HealthRecord {
  HealthRecord({
    required this.diseaseName,
    required this.date,
    required this.status,
    this.symptoms = '',
    this.treatmentNotes = '',
  });

  final String diseaseName;
  final DateTime date;
  final String status;
  final String symptoms;
  final String treatmentNotes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'diseaseName': diseaseName,
      'date': date.toIso8601String(),
      'status': status,
      'symptoms': symptoms,
      'treatmentNotes': treatmentNotes,
    };
  }

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      diseaseName: json['diseaseName'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'Ongoing',
      symptoms: json['symptoms'] as String? ?? '',
      treatmentNotes: json['treatmentNotes'] as String? ?? '',
    );
  }
}

class VaccinationRecord {
  VaccinationRecord({
    required this.vaccineName,
    required this.dateGiven,
    this.nextDueDate,
    this.notes = '',
  });

  final String vaccineName;
  final DateTime dateGiven;
  final DateTime? nextDueDate;
  final String notes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'vaccineName': vaccineName,
      'dateGiven': dateGiven.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'notes': notes,
    };
  }

  factory VaccinationRecord.fromJson(Map<String, dynamic> json) {
    return VaccinationRecord(
      vaccineName: json['vaccineName'] as String? ?? '',
      dateGiven:
          DateTime.tryParse(json['dateGiven'] as String? ?? '') ??
          DateTime.now(),
      nextDueDate: DateTime.tryParse(json['nextDueDate'] as String? ?? ''),
      notes: json['notes'] as String? ?? '',
    );
  }
}
