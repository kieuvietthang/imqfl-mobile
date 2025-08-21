class Episode {
  final String name;
  final String slug;
  final String filename;
  final String linkEmbed;
  final String linkM3u8;

  const Episode({
    required this.name,
    required this.slug,
    required this.filename,
    required this.linkEmbed,
    required this.linkM3u8,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      filename: json['filename']?.toString() ?? '',
      linkEmbed: json['link_embed']?.toString() ?? '',
      linkM3u8: json['link_m3u8']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'filename': filename,
      'link_embed': linkEmbed,
      'link_m3u8': linkM3u8,
    };
  }
}

class Movie {
  final String id;
  final String name;
  final String slug;
  final String originalName;
  final String poster;
  final String thumb;
  final String description;
  final int year;
  final String status;
  final String type;
  final String quality;
  final String lang;
  final int totalEpisodes;
  final int currentEpisode;
  final List<String> categories;
  final List<String> countries;
  final List<String> actors;
  final List<String> directors;
  final String created;
  final String modified;
  final List<Episode> episodes;

  const Movie({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.poster,
    required this.thumb,
    required this.description,
    required this.year,
    required this.status,
    required this.type,
    required this.quality,
    required this.lang,
    required this.totalEpisodes,
    required this.currentEpisode,
    required this.categories,
    required this.countries,
    required this.actors,
    required this.directors,
    required this.created,
    required this.modified,
    this.episodes = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Xử lý episodes từ cấu trúc mới
    List<Episode> episodes = [];
    if (json['episodes'] != null && json['episodes'] is List) {
      for (var serverData in json['episodes']) {
        if (serverData['server_data'] != null &&
            serverData['server_data'] is List) {
          for (var episodeData in serverData['server_data']) {
            episodes.add(Episode.fromJson(episodeData));
          }
        }
      }
    }

    return Movie(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      originalName: json['origin_name'] ?? '',
      poster: json['poster_url'] ?? '',
      thumb: json['thumb_url'] ?? '',
      description: json['content'] ?? '',
      year: _parseToInt(json['year']),
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      quality: json['quality'] ?? '',
      lang: json['lang'] ?? '',
      totalEpisodes: _parseEpisodeCount(json['episode_total']),
      currentEpisode: _parseEpisodeCount(json['episode_current']),
      categories:
          (json['category'] as List<dynamic>?)
              ?.map(
                (e) =>
                    (e is Map && e['name'] != null) ? e['name'].toString() : '',
              )
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
      countries:
          (json['country'] as List<dynamic>?)
              ?.map(
                (e) =>
                    (e is Map && e['name'] != null) ? e['name'].toString() : '',
              )
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
      actors:
          (json['actor'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
      directors:
          (json['director'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
      created: json['created']?['time'] ?? '',
      modified: json['modified']?['time'] ?? '',
      episodes: episodes,
    );
  }

  // Hàm để parse số tập từ string có thể chứa "Tập X"
  static int _parseEpisodeCount(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      // Xử lý trường hợp "Tập 9" -> 9
      final match = RegExp(r'(\d+)').firstMatch(value);
      if (match != null) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'origin_name': originalName,
      'poster_url': poster,
      'thumb_url': thumb,
      'content': description,
      'year': year,
      'status': status,
      'type': type,
      'quality': quality,
      'lang': lang,
      'episode_total': totalEpisodes,
      'episode_current': currentEpisode,
      'created': {'time': created},
      'modified': {'time': modified},
    };
  }
}

class MovieListResponse {
  final List<Movie> items;
  final Pagination pagination;

  const MovieListResponse({required this.items, required this.pagination});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    return MovieListResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int totalPages;
  final int currentPage;
  final int totalItems;

  const Pagination({
    required this.totalPages,
    required this.currentPage,
    required this.totalItems,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: _parseToInt(json['totalPages']),
      currentPage: _parseToInt(json['currentPage']),
      totalItems: _parseToInt(json['totalItems']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 1;
    }
    return 1;
  }
}
