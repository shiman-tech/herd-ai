class EmbeddingReference {
  EmbeddingReference({
    this.id,
    this.imageId,
    required this.vector,
    this.sourceImagePath,
  });

  final int? id;
  final int? imageId;
  final List<double> vector;
  final String? sourceImagePath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      if (imageId != null) 'imageId': imageId,
      'vector': vector,
      'sourceImagePath': sourceImagePath,
    };
  }

  factory EmbeddingReference.fromJson(Map<String, dynamic> json) {
    return EmbeddingReference(
      id: json['id'] as int?,
      imageId: json['imageId'] as int?,
      vector: (json['vector'] as List<dynamic>? ??
              json['embedding'] as List<dynamic>? ??
              <dynamic>[])
          .map((dynamic value) => (value as num).toDouble())
          .toList(),
      sourceImagePath: json['sourceImagePath'] as String?,
    );
  }

  /// Parses legacy JSON where embeddings were stored as bare vector lists.
  factory EmbeddingReference.fromLegacyVector(List<double> vector) {
    return EmbeddingReference(vector: vector);
  }

  EmbeddingReference copyWith({
    int? id,
    int? imageId,
    List<double>? vector,
    String? sourceImagePath,
  }) {
    return EmbeddingReference(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      vector: vector ?? this.vector,
      sourceImagePath: sourceImagePath ?? this.sourceImagePath,
    );
  }
}

class SimilarityMatch {
  const SimilarityMatch({
    required this.cowId,
    required this.similarity,
  });

  final String cowId;
  final double similarity;
}
