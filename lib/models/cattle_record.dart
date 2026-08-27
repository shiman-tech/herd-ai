import 'cattle_image.dart';
import 'embedding_reference.dart';

class CattleRecord {
  CattleRecord({
    required this.id,
    required this.registrationDate,
    this.profileImagePath,
    List<EmbeddingReference>? embeddings,
    List<HealthRecord>? healthRecords,
    List<VaccinationRecord>? vaccinations,
    List<String>? notes,
    List<CattleImage>? images,
    this.breedName,
    this.breedConfidence,
    this.breedAlternativesJson,
    this.confirmedBreed,
    this.breedConfirmedByUser = false,
    this.sex,
    this.dateOfBirth,
    this.lifeStage,
    this.healthStatus,
    this.reproductiveStatus,
    this.isMilking = false,
    this.isPregnant = false,
    this.calvingDate,
    this.inseminationDate,
    this.dryOffDate,
    this.expectedDailyYield,
  }) : embeddings = embeddings ?? <EmbeddingReference>[],
       healthRecords = healthRecords ?? <HealthRecord>[],
       vaccinations = vaccinations ?? <VaccinationRecord>[],
       notes = notes ?? <String>[],
       images = images ?? <CattleImage>[];

  final String id;
  final DateTime registrationDate;
  String? profileImagePath;
  final List<EmbeddingReference> embeddings;
  final List<HealthRecord> healthRecords;
  final List<VaccinationRecord> vaccinations;
  final List<String> notes;
  final List<CattleImage> images;

  // Breed classification fields (mutable — set by EmbeddingDatabase)
  String? breedName;
  double? breedConfidence;
  String? breedAlternativesJson;
  String? confirmedBreed;
  bool breedConfirmedByUser;

  // Additional Cattle Demographics & Status
  String? sex; // 'Male', 'Female', 'Unknown'
  DateTime? dateOfBirth;
  String? lifeStage; // 'Calf', 'Heifer', 'Cow', 'Bull', 'Steer'
  String? healthStatus; // 'Healthy', 'Under Observation', 'Diseased', 'Recovered'
  String? reproductiveStatus; // 'Pregnant', 'Not Pregnant', 'Unknown'

  // Milk & Lactation Management Fields
  bool isMilking;
  bool isPregnant;
  DateTime? calvingDate;       // Last calving date
  DateTime? inseminationDate;  // Successful insemination date
  DateTime? dryOffDate;        // Target or actual dry off date
  double? expectedDailyYield;  // Target daily yield benchmark in Liters

  String? get displayBreed => confirmedBreed ?? breedName;

  String get effectiveBreed {
    final String? breed = displayBreed;
    if (breed != null && breed.trim().isNotEmpty) {
      return breed.trim();
    }
    return 'Unknown';
  }

  String get effectiveSex => sex ?? 'Unknown';

  int? get ageInMonths {
    if (dateOfBirth == null) {
      return null;
    }
    final DateTime now = DateTime.now();
    int months = (now.year - dateOfBirth!.year) * 12 + (now.month - dateOfBirth!.month);
    if (now.day < dateOfBirth!.day) {
      months--;
    }
    return months >= 0 ? months : 0;
  }

  String get ageDisplay {
    final int? months = ageInMonths;
    if (months == null) {
      return 'Unknown age';
    }
    final int years = months ~/ 12;
    final int remMonths = months % 12;
    if (years > 0 && remMonths > 0) {
      return '$years yr${years > 1 ? 's' : ''} $remMonths mo${remMonths > 1 ? 's' : ''}';
    } else if (years > 0) {
      return '$years yr${years > 1 ? 's' : ''}';
    } else {
      return '$remMonths mo${remMonths > 1 ? 's' : ''}';
    }
  }

  String get effectiveLifeStage {
    // If age is known and under 1 year (< 12 months), automatically set to Calf
    final int? months = ageInMonths;
    if (months != null && months < 12) {
      return 'Calf';
    }
    if (lifeStage != null && lifeStage!.trim().isNotEmpty) {
      return lifeStage!.trim();
    }
    return 'Unknown';
  }

  String get effectiveHealthStatus {
    if (healthRecords.isEmpty) {
      if (healthStatus != null && healthStatus!.trim().isNotEmpty && healthStatus != 'Unknown') {
        return healthStatus!.trim();
      }
      return 'Unknown';
    }

    final List<HealthRecord> sorted = List<HealthRecord>.from(healthRecords)
      ..sort((HealthRecord a, HealthRecord b) => b.date.compareTo(a.date));
    final String latest = sorted.first.status.trim();
    final String lower = latest.toLowerCase();
    if (lower == 'ongoing' || lower == 'diseased') {
      return 'Diseased';
    }
    if (lower == 'under observation') {
      return 'Under Observation';
    }
    if (lower == 'recovered') {
      return 'Recovered';
    }
    if (lower == 'healthy') {
      return 'Healthy';
    }
    return latest.isNotEmpty ? latest : 'Unknown';
  }

  String get effectiveReproductiveStatus {
    if (isPregnant) {
      return 'Pregnant';
    }
    if (reproductiveStatus != null && reproductiveStatus!.trim().isNotEmpty) {
      return reproductiveStatus!.trim();
    }
    final bool noteMentionsPregnant = notes.any(
      (String n) => n.toLowerCase().contains('pregnant'),
    );
    if (noteMentionsPregnant) {
      return 'Pregnant';
    }
    if (sex == 'Male') {
      return 'Not Pregnant';
    }
    return 'Unknown';
  }

  // ---------------------------------------------------------------------------
  // Lactation & Gestation Calculations
  // ---------------------------------------------------------------------------

  /// Days in Milk (DIM) = Today - Calving Date
  int? get daysInMilk {
    if (calvingDate == null) {
      return null;
    }
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime calv = DateTime(calvingDate!.year, calvingDate!.month, calvingDate!.day);
    final int diff = today.difference(calv).inDays;
    return diff >= 0 ? diff : 0;
  }

  /// Estimated Days in Gestation from Insemination Date
  int? get daysInGestation {
    if (!isPregnant || inseminationDate == null) {
      return null;
    }
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime insem = DateTime(inseminationDate!.year, inseminationDate!.month, inseminationDate!.day);
    final int diff = today.difference(insem).inDays;
    return diff >= 0 ? diff : 0;
  }

  /// Expected Calving Date (approx 283 days post-insemination when pregnant)
  DateTime? get expectedCalvingDate {
    if (!isPregnant || inseminationDate == null) {
      return null;
    }
    return inseminationDate!.add(const Duration(days: 283));
  }

  /// Recommended Dry-Off Date (approx 220 days post-insemination, ~60 days before calving)
  DateTime? get targetDryOffDate {
    if (dryOffDate != null) {
      return dryOffDate;
    }
    if (inseminationDate != null) {
      return inseminationDate!.add(const Duration(days: 220));
    }
    if (calvingDate != null) {
      // Standard 305 day lactation target
      return calvingDate!.add(const Duration(days: 305));
    }
    return null;
  }

  /// Automatic Lactation Stage Classification
  /// Fresh: 0–30 days
  /// Early: 31–100 days
  /// Mid: 101–200 days
  /// Late: 201–305 days
  /// Extended Lactation: >305 days (when isMilking == true)
  /// Dry: isMilking == false
  String get lactationStage {
    if (!isMilking) {
      return 'Dry';
    }
    final int? dim = daysInMilk;
    if (dim == null) {
      return 'Early';
    }
    if (dim <= 30) {
      return 'Fresh';
    } else if (dim <= 100) {
      return 'Early';
    } else if (dim <= 200) {
      return 'Mid';
    } else if (dim <= 305) {
      return 'Late';
    } else {
      return 'Extended Lactation';
    }
  }

  String get calculatedVaccinationStatus {
    if (vaccinations.isEmpty) {
      return 'No Record';
    }
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime thirtyDaysFromNow = today.add(const Duration(days: 30));

    bool hasDueSoon = false;
    for (final VaccinationRecord record in vaccinations) {
      if (record.nextDueDate != null) {
        final DateTime due = DateTime(
          record.nextDueDate!.year,
          record.nextDueDate!.month,
          record.nextDueDate!.day,
        );
        if (due.isBefore(today)) {
          return 'Overdue';
        }
        if (!due.isAfter(thirtyDaysFromNow)) {
          hasDueSoon = true;
        }
      }
    }
    if (hasDueSoon) {
      return 'Due Soon';
    }
    return 'Up to Date';
  }

  List<CattleImage> get imagesNewestFirst {
    final List<CattleImage> sorted = List<CattleImage>.from(images);
    sorted.sort(
      (CattleImage a, CattleImage b) => b.uploadedAt.compareTo(a.uploadedAt),
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
      'images': images.map((CattleImage item) => item.toJson()).toList(),
      'breedName': breedName,
      'breedConfidence': breedConfidence,
      'breedAlternativesJson': breedAlternativesJson,
      'confirmedBreed': confirmedBreed,
      'breedConfirmedByUser': breedConfirmedByUser,
      'sex': sex,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'lifeStage': lifeStage,
      'healthStatus': healthStatus,
      'reproductiveStatus': reproductiveStatus,
      'isMilking': isMilking,
      'isPregnant': isPregnant,
      'calvingDate': calvingDate?.toIso8601String(),
      'inseminationDate': inseminationDate?.toIso8601String(),
      'dryOffDate': dryOffDate?.toIso8601String(),
      'expectedDailyYield': expectedDailyYield,
    };
  }

  factory CattleRecord.fromJson(Map<String, dynamic> json) {
    final bool isPreg = (json['isPregnant'] as bool?) ??
        ((json['reproductiveStatus'] as String?)?.toLowerCase() == 'pregnant');

    return CattleRecord(
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
      sex: json['sex'] as String?,
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] as String? ?? ''),
      lifeStage: json['lifeStage'] as String?,
      healthStatus: json['healthStatus'] as String?,
      reproductiveStatus: json['reproductiveStatus'] as String?,
      isMilking: (json['isMilking'] as bool?) ?? false,
      isPregnant: isPreg,
      calvingDate: DateTime.tryParse(json['calvingDate'] as String? ?? ''),
      inseminationDate: DateTime.tryParse(json['inseminationDate'] as String? ?? ''),
      dryOffDate: DateTime.tryParse(json['dryOffDate'] as String? ?? ''),
      expectedDailyYield: (json['expectedDailyYield'] as num?)?.toDouble(),
    );
  }

  static List<CattleImage> _parseImages(dynamic raw) {
    if (raw is! List<dynamic>) {
      return <CattleImage>[];
    }
    if (raw.isEmpty) {
      return <CattleImage>[];
    }
    if (raw.first is String) {
      return raw
          .map(
            (dynamic item) => CattleImage.fromLegacyPath(item as String),
          )
          .toList();
    }
    return raw
        .map((dynamic item) => CattleImage.fromJson(item as Map<String, dynamic>))
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
    this.status = 'Ongoing',
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
