enum IconType { none, external, emoji, file }

class NotionIcon {
  final IconType type;
  final String? url;
  final String? emoji;
  final DateTime? expiryTime;

  const NotionIcon({this.type = IconType.none, this.url, this.emoji, this.expiryTime});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type
        .toString()
        .split('.')
        .last;

    if (url != null) {
      data['external'] = {'url': url};
    }
    if (emoji != null) {
      data['emoji'] = emoji;
    }
    if (expiryTime != null) {
      data['file'] = {
        'url': url,
        'expiry_time': expiryTime!.toIso8601String(),
      };
    }

    return {'icon': data};
  }

  factory NotionIcon.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) return NotionIcon(type: IconType.none);

    IconType type = IconType.values.firstWhere((e) =>
    e
        .toString()
        .split('.')
        .last == json['type'],
      orElse: () => throw Exception('Invalid icon type'),
    );

    switch (type) {
      case IconType.external:
        return NotionIcon(type: type, url: json['external']['url']);
      case IconType.emoji:
        return NotionIcon(type: type, emoji: json['emoji']);
      case IconType.file:
        return NotionIcon(
          type: type,
          url: json['file']['url'],
          expiryTime: DateTime.parse(json['file']['expiry_time']),
        );
      default:
        return NotionIcon(type: IconType.none);
    }
  }
}