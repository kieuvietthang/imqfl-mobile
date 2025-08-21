class Movie {
  final String id;
  final String title;
  final String slug;

  const Movie({
    required this.id,
    required this.title,
    required this.slug,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
    };
  }
}

class BannerItem {
  final int id;
  final String title;
  final String subtitle;
  final String bgImage;
  final String fgImage;
  final bool isFree;
  final Movie movie;
  final int sortOrder;

  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    required this.fgImage,
    required this.isFree,
    required this.movie,
    required this.sortOrder,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      bgImage: json['bgImage'] ?? '',
      fgImage: json['fgImage'] ?? '',
      isFree: json['isFree'] ?? true,
      movie: Movie.fromJson(json['movie'] ?? {}),
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'bgImage': bgImage,
      'fgImage': fgImage,
      'isFree': isFree,
      'movie': movie.toJson(),
      'sortOrder': sortOrder,
    };
  }
}

class BannerCarouselResponse {
  final bool success;
  final String message;
  final List<BannerItem> data;

  const BannerCarouselResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BannerCarouselResponse.fromJson(Map<String, dynamic> json) {
    return BannerCarouselResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => BannerItem.fromJson(item))
          .toList() ?? [],
    );
  }
}
