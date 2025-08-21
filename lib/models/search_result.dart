class TmdbInfo {
  final String? type;
  final String? id;
  final int? season;
  final double voteAverage;
  final int voteCount;

  const TmdbInfo({
    this.type,
    this.id,
    this.season,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TmdbInfo.fromJson(Map<String, dynamic> json) {
    return TmdbInfo(
      type: json['type']?.toString(),
      id: json['id']?.toString(),
      season: json['season'] is int ? json['season'] : 
               (json['season'] is String ? int.tryParse(json['season']) : null),
      voteAverage: _parseToDouble(json['vote_average']),
      voteCount: _parseToInt(json['vote_count']),
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class ImdbInfo {
  final String? id;

  const ImdbInfo({this.id});

  factory ImdbInfo.fromJson(Map<String, dynamic> json) {
    return ImdbInfo(
      id: json['id']?.toString(),
    );
  }
}

class ModifiedInfo {
  final String time;

  const ModifiedInfo({required this.time});

  factory ModifiedInfo.fromJson(Map<String, dynamic> json) {
    return ModifiedInfo(
      time: json['time']?.toString() ?? '',
    );
  }
}

class SearchResult {
  final TmdbInfo tmdb;
  final ImdbInfo imdb;
  final ModifiedInfo modified;
  final String id;
  final String name;
  final String slug;
  final String originName;
  final String posterUrl;
  final String thumbUrl;
  final int year;

  const SearchResult({
    required this.tmdb,
    required this.imdb,
    required this.modified,
    required this.id,
    required this.name,
    required this.slug,
    required this.originName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.year,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      tmdb: TmdbInfo.fromJson(json['tmdb'] ?? {}),
      imdb: ImdbInfo.fromJson(json['imdb'] ?? {}),
      modified: ModifiedInfo.fromJson(json['modified'] ?? {}),
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      originName: json['origin_name']?.toString() ?? '',
      posterUrl: json['poster_url']?.toString() ?? '',
      thumbUrl: json['thumb_url']?.toString() ?? '',
      year: _parseToInt(json['year']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class SearchPagination {
  final int totalItems;
  final int totalItemsPerPage;
  final int currentPage;
  final int totalPages;

  const SearchPagination({
    required this.totalItems,
    required this.totalItemsPerPage,
    required this.currentPage,
    required this.totalPages,
  });

  factory SearchPagination.fromJson(Map<String, dynamic> json) {
    return SearchPagination(
      totalItems: _parseToInt(json['totalItems']),
      totalItemsPerPage: _parseToInt(json['totalItemsPerPage']),
      currentPage: _parseToInt(json['currentPage']),
      totalPages: _parseToInt(json['totalPages']),
    );
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class SearchResponse {
  final bool status;
  final String message;
  final List<SearchResult> items;
  final SearchPagination pagination;

  const SearchResponse({
    required this.status,
    required this.message,
    required this.items,
    required this.pagination,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      status: json['status'] == true,
      message: json['msg']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      pagination: SearchPagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
