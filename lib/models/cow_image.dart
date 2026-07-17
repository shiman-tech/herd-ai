class CowImage {
  CowImage({
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

  factory CowImage.fromJson(Map<String, dynamic> json) {
    return CowImage(
      id: json['id'] as int?,
      path: json['path'] as String,
      uploadedAt:
          DateTime.tryParse(json['uploadedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Legacy JSON stored image paths as plain strings.
  factory CowImage.fromLegacyPath(String path) {
    return CowImage(path: path, uploadedAt: DateTime.now());
  }
}
