class CowRecord {
  CowRecord({
    required this.id,
    required this.registrationDate,
    this.profileImagePath,
    List<List<double>>? embeddings,
    List<HealthRecord>? healthRecords,
    List<VaccinationRecord>? vaccinations,
    List<String>? notes,
    List<String>? images,
  }) : embeddings = embeddings ?? <List<double>>[],
       healthRecords = healthRecords ?? <HealthRecord>[],
       vaccinations = vaccinations ?? <VaccinationRecord>[],
       notes = notes ?? <String>[],
       images = images ?? <String>[];

  final String id;
  final DateTime registrationDate;
  String? profileImagePath;
  final List<List<double>> embeddings;
  final List<HealthRecord> healthRecords;
  final List<VaccinationRecord> vaccinations;
  final List<String> notes;
  final List<String> images;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'registrationDate': registrationDate.toIso8601String(),
      'profileImagePath': profileImagePath,
      'embeddings': embeddings,
      'healthRecords': healthRecords
          .map((HealthRecord item) => item.toJson())
          .toList(),
      'vaccinations': vaccinations
          .map((VaccinationRecord item) => item.toJson())
          .toList(),
      'notes': notes,
      'images': images,
    };
  }

  factory CowRecord.fromJson(Map<String, dynamic> json) {
    return CowRecord(
      id: json['id'] as String,
      registrationDate:
          DateTime.tryParse(json['registrationDate'] as String? ?? '') ??
          DateTime.now(),
      profileImagePath: json['profileImagePath'] as String?,
      embeddings: ((json['embeddings'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic row) => (row as List<dynamic>)
                .map((dynamic value) => (value as num).toDouble())
                .toList(),
          )
          .toList()),
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
      images: ((json['images'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList()),
    );
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
