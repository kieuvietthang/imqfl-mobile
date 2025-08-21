import 'dart:developer';
import '../models/category.dart';
import 'api_client.dart';

class CategoryService {
  final ApiClient _apiClient = ApiClient();

  // Lấy danh sách tất cả categories
  Future<List<Category>> getCategories() async {
    log('[CategoryService.getCategories] Bắt đầu lấy danh sách thể loại');
    
    try {
      const endpoint = '/categories';
      
      log('[CategoryService.getCategories] Endpoint: $endpoint');

      final response = await _apiClient.get(endpoint);

      log('[CategoryService.getCategories] Raw response data: ${response.data}');
      
      final data = response.data;
      if (data != null && data['data'] != null) {
        final categoriesData = data['data'] as List<dynamic>;
        log('[CategoryService.getCategories] Categories count: ${categoriesData.length}');

        final categories = categoriesData
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList();
        
        log('[CategoryService.getCategories] Kết quả trả về: '
            'categoriesCount: ${categories.length}, '
            'firstCategory: ${categories.isNotEmpty ? categories[0].name : "N/A"}');

        return categories;
      } else {
        log('[CategoryService.getCategories] No data field in response');
        return [];
      }
    } catch (error) {
      log('[CategoryService.getCategories] Lỗi khi lấy danh sách thể loại: $error');
      // Trả về mảng rỗng nếu có lỗi
      return [];
    }
  }

  // Tìm category theo slug
  Future<Category?> getCategoryBySlug(String slug) async {
    log('[CategoryService.getCategoryBySlug] Tìm thể loại với slug: $slug');
    
    try {
      final categories = await getCategories();
      final category = categories.where((cat) => cat.slug == slug).firstOrNull;
      
      log('[CategoryService.getCategoryBySlug] Kết quả tìm thấy: ${category?.name ?? "Không tìm thấy"}');
      
      return category;
    } catch (error) {
      log('[CategoryService.getCategoryBySlug] Lỗi khi tìm thể loại: $error');
      return null;
    }
  }

  // Lấy danh sách categories theo tên (search)
  Future<List<Category>> searchCategories(String searchTerm) async {
    log('[CategoryService.searchCategories] Tìm kiếm thể loại với từ khóa: $searchTerm');
    
    try {
      final categories = await getCategories();
      final filteredCategories = categories.where((cat) => 
        cat.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
        cat.slug.toLowerCase().contains(searchTerm.toLowerCase())
      ).toList();
      
      log('[CategoryService.searchCategories] Kết quả tìm kiếm: '
          'searchTerm: $searchTerm, foundCount: ${filteredCategories.length}');
      
      return filteredCategories;
    } catch (error) {
      log('[CategoryService.searchCategories] Lỗi khi tìm kiếm thể loại: $error');
      return [];
    }
  }

  // Lấy các thể loại phổ biến (có thể sắp xếp theo tên)
  Future<List<Category>> getPopularCategories({int? limit}) async {
    log('[CategoryService.getPopularCategories] Lấy thể loại phổ biến, limit: $limit');
    
    try {
      final categories = await getCategories();
      
      // Sắp xếp theo tên và giới hạn số lượng nếu có
      final sortedCategories = categories
        ..sort((a, b) => a.name.compareTo(b.name));
      final result = limit != null ? sortedCategories.take(limit).toList() : sortedCategories;
      
      log('[CategoryService.getPopularCategories] Kết quả: '
          'totalCategories: ${categories.length}, returnedCount: ${result.length}');
      
      return result;
    } catch (error) {
      log('[CategoryService.getPopularCategories] Lỗi khi lấy thể loại phổ biến: $error');
      return [];
    }
  }
}
