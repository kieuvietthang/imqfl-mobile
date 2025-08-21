class Advertisement {
  final int id;
  final String title;
  final String description;
  final String type;
  final String mediaUrl;
  final String linkUrl;
  final String targetPage;
  final int position;
  final int viewCount;
  final int clickCount;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.mediaUrl,
    required this.linkUrl,
    required this.targetPage,
    required this.position,
    required this.viewCount,
    required this.clickCount,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      mediaUrl: json['media_url'],
      linkUrl: json['link_url'],
      targetPage: json['target_page'],
      position: json['position'],
      viewCount: json['view_count'],
      clickCount: json['click_count'],
    );
  }
}

class AdvertisementResponse {
  final String status;
  final List<Advertisement> data;
  final int count;

  AdvertisementResponse({
    required this.status,
    required this.data,
    required this.count,
  });

  factory AdvertisementResponse.fromJson(Map<String, dynamic> json) {
    return AdvertisementResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => Advertisement.fromJson(item))
          .toList(),
      count: json['count'],
    );
  }
}
