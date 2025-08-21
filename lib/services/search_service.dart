import 'dart:developer';
import '../models/search_result.dart';
import 'api_client.dart';

class SearchService {
  final ApiClient _apiClient = ApiClient();

  Future<SearchResponse> searchMovies({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _apiClient.get(
        '/public/search',
        queryParameters: {'keyword': query, 'page': page, 'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        return SearchResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      log('Error searching movies: $e');
      rethrow;
    }
  }
}
