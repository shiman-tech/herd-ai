class CattleImage {
  CattleImage({
    required this.path,
    required this.uploadedAt,
    this.id,
  });

  final int? id;
  final String path;
  final DateTime uploadedAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'path': path,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory CattleImage.fromJson(Map<String, dynamic> json) {
    return CattleImage(
      id: json['id'] as int?,
      path: json['path'] as String,
      uploadedAt:
          DateTime.tryParse(json['uploadedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Legacy JSON stored image paths as plain strings.
  factory CattleImage.fromLegacyPath(String path) {
    return CattleImage(path: path, uploadedAt: DateTime.now());
  }
}
