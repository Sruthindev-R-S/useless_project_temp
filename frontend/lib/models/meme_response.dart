/// Response model representing the analyzed switch count and resulting meme.
///
/// NOTE: The backend API schema will be finalized later.
/// Keep all JSON serialization/deserialization and property mappings inside this file
/// so that when the real API format is provided, the UI requires zero redesign.
class MemeResponse {
  final int onCount;
  final int offCount;
  final String memeUrl;
  final String? title;
  final String? caption;
  final String? personalityVerdict;

  const MemeResponse({
    required this.onCount,
    required this.offCount,
    required this.memeUrl,
    this.title,
    this.caption,
    this.personalityVerdict,
  });

  /// Total switches detected
  int get totalCount => onCount + offCount;

  /// Ratio of switches turned ON (0.0 to 1.0)
  double get onRatio => totalCount == 0 ? 0.0 : onCount / totalCount;

  /// Percentage of switches turned ON (0 to 100)
  int get onPercentage => (onRatio * 100).round();

  /// Default humorous verdict if not provided by backend
  String get effectiveVerdict {
    if (personalityVerdict != null && personalityVerdict!.isNotEmpty) {
      return personalityVerdict!;
    }
    if (totalCount == 0) {
      return 'Zero switches detected. Are you in a cave?';
    }
    if (onCount == 0) {
      return '0% ON • Creature of the Shadows';
    }
    if (offCount == 0) {
      return '100% ON • Moth to the Flame';
    }
    if (onCount == offCount) {
      return '50/50 • Perfectly Balanced Neutral';
    }
    if (onCount > offCount) {
      return '$onPercentage% ON • High Energy Radiator';
    }
    return '${100 - onPercentage}% OFF • Energy Conservation Specialist';
  }

  /// Factory constructor for parsing API JSON
  /// Update this parser when the final backend API payload is provided.
  factory MemeResponse.fromJson(Map<String, dynamic> json) {
    return MemeResponse(
      onCount: (json['on'] ?? json['onCount'] ?? json['on_count'] ?? 0) as int,
      offCount: (json['off'] ?? json['offCount'] ?? json['off_count'] ?? 0) as int,
      memeUrl: (json['meme'] ?? json['memeUrl'] ?? json['meme_url'] ?? '') as String,
      title: json['title'] as String?,
      caption: json['caption'] as String?,
      personalityVerdict: json['verdict'] ?? json['personality'] as String?,
    );
  }

  /// Serialization method
  Map<String, dynamic> toJson() {
    return {
      'on': onCount,
      'off': offCount,
      'meme': memeUrl,
      'title': title,
      'caption': caption,
      'verdict': personalityVerdict,
    };
  }

  MemeResponse copyWith({
    int? onCount,
    int? offCount,
    String? memeUrl,
    String? title,
    String? caption,
    String? personalityVerdict,
  }) {
    return MemeResponse(
      onCount: onCount ?? this.onCount,
      offCount: offCount ?? this.offCount,
      memeUrl: memeUrl ?? this.memeUrl,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      personalityVerdict: personalityVerdict ?? this.personalityVerdict,
    );
  }
}
