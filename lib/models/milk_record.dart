class MilkRecord {
  const MilkRecord({
    required this.id,
    required this.cattleId,
    required this.date,
    required this.morningYield,
    required this.eveningYield,
    double? totalYield,
    this.notes,
    required this.createdAt,
  }) : totalYield = totalYield ?? (morningYield + eveningYield);

  final String id;
  final String cattleId;
  final DateTime date;
  final double morningYield;
  final double eveningYield;
  final double totalYield;
  final String? notes;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cattle_id': cattleId,
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'morning_yield': morningYield,
      'evening_yield': eveningYield,
      'total_yield': totalYield,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MilkRecord.fromMap(Map<String, dynamic> map) {
    final double m = (map['morning_yield'] as num?)?.toDouble() ?? 0.0;
    final double e = (map['evening_yield'] as num?)?.toDouble() ?? 0.0;
    final double? t = (map['total_yield'] as num?)?.toDouble();

    return MilkRecord(
      id: map['id'] as String,
      cattleId: map['cattle_id'] as String,
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      morningYield: m,
      eveningYield: e,
      totalYield: t ?? (m + e),
      notes: map['notes'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  MilkRecord copyWith({
    String? id,
    String? cattleId,
    DateTime? date,
    double? morningYield,
    double? eveningYield,
    double? totalYield,
    String? notes,
    DateTime? createdAt,
  }) {
    final double m = morningYield ?? this.morningYield;
    final double e = eveningYield ?? this.eveningYield;
    return MilkRecord(
      id: id ?? this.id,
      cattleId: cattleId ?? this.cattleId,
      date: date ?? this.date,
      morningYield: m,
      eveningYield: e,
      totalYield: totalYield ?? (m + e),
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
