import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../../models/course_list_model.dart';


class CourseController extends ChangeNotifier {
  final ApiService _apiService;

  CourseController({required ApiService apiService}) : _apiService = apiService;

  bool _isLoading = false;
  String? _errorMessage;
  List<Course> _courses = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Course> get courses => _courses;

  Future<void> fetchCourseList({String endpoint = 'v1/app-home-courses'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? response.data
            : {'courses': response.data};
        print("-----------------------row data ${data}");

        final courseListModel = CourseListModel.fromJson(data);
        _courses = courseListModel.courses ?? [];
      } else {
        _errorMessage = 'Failed to load course data';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
