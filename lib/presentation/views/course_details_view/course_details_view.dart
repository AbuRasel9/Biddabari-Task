import 'package:biddabari_task/presentation/views/course_details_view/widget/curriculum_row.dart';
import 'package:flutter/material.dart';

import '../../../../data/services/api_service.dart';
import '../../../../di/service_locator.dart';
import '../../../models/course_list_model.dart';
import '../../widget/network_image_card.dart';

class CourseDetailsView extends StatefulWidget {
  const CourseDetailsView({super.key, required this.course});

  final Course course;

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  late Course _course;

  @override
  void initState() {
    super.initState();
    _course = widget.course;
    _fetchFullDetails();
  }

  Future<void> _fetchFullDetails() async {
    if (_course.id == null) return;
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('v1/app-course-details/${_course.id}');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['course'] != null) {
          final detailedCourse = Course.fromJson(data['course'] as Map<String, dynamic>);
          if (mounted) {
            setState(() {
              _course = detailedCourse;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching course details: $e');
    }
  }

  int get _discountPercentage {
    final price = _course.price;
    final discountAmount = _course.discountAmount;
    if (price == null || price == 0 || discountAmount == null || discountAmount == 0) {
      return 0;
    }
    return ((discountAmount / price) * 100).round();
  }

  int get _calculatedPrice {
    final price = _course.price ?? 0;
    final discountAmount = _course.discountAmount ?? 0;
    if (discountAmount > 0 && price >= discountAmount) {
      return price - discountAmount;
    }
    return price;
  }

  String get _timeLeftString {
    final endDateStr = _course.discountEndDate;
    if (endDateStr == null || endDateStr.isEmpty) {
      return '1 day, 9 hours, 43 mins left';
    }
    try {
      final endDate = DateTime.tryParse(endDateStr);
      if (endDate != null) {
        final diff = endDate.difference(DateTime.now());
        if (diff.isNegative) {
          return 'Offer expired';
        }
        final days = diff.inDays;
        final hours = diff.inHours % 24;
        final mins = diff.inMinutes % 60;
        return '$days day, $hours hours, $mins mins left';
      }
    } catch (_) {}
    return '1 day, 9 hours, 43 mins left';
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF044D52);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Course Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section with Floating Play Button
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: _course.bannerUrl != null &&
                          _course.bannerUrl!.isNotEmpty
                      ? NetworkImageCard(imageLink: _course.bannerUrl!)
                      : Container(color: Colors.grey[300]),
                ),
                Positioned(
                  right: 24,
                  bottom: -20,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Top Card Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subtitle & Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_course.subTitle != null &&
                          _course.subTitle!.isNotEmpty)
                        Text(
                          '👍 ${_course.subTitle}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    _course.title ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Info & Price Row
                  Row(
                    children: [
                      const Icon(Icons.videocam_outlined,
                          size: 18, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(
                        '${_course.totalClass ?? '0'} Class',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                      Text('|', style: TextStyle(color: Colors.grey[400])),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time_rounded,
                          size: 18, color: Colors.deepOrange),
                      const SizedBox(width: 4),
                      Text(
                        '${_course.totalExam ?? '0'} Exam',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '৳$_calculatedPrice',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (_discountPercentage > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0EC),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$_discountPercentage% off',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE56A55),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CurriculumRow(
                    icon: Icons.access_time_outlined,
                    title: 'Course Duration',
                    value: _course.durationInMonth ?? '0',
                  ),
                  CurriculumRow(
                    icon: Icons.desktop_windows_outlined,
                    title: 'Total Lecture',
                    value: _course.totalClass ?? '0',
                  ),
                  CurriculumRow(
                    icon: Icons.assignment_outlined,
                    title: 'Total Exam',
                    value: '${_course.totalExam ?? '0'}',
                  ),
                  CurriculumRow(
                    icon: Icons.videocam_outlined,
                    title: 'Live Class',
                    value: '${_course.totalLive ?? '0'}',
                  ),
                  CurriculumRow(
                    icon: Icons.people_outline,
                    title: 'Students Enrolled',
                    value: '0',
                  ),
                  CurriculumRow(
                    icon: Icons.subtitles_outlined,
                    title: 'Language',
                    value: 'Bangla',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Spacing for bottom bar
          ],
        ),
      ),

      // Bottom Bar
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left: Price details & Countdown
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '৳ $_calculatedPrice',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (_discountPercentage > 0 &&
                            _course.price != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '${_course.price}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0EC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '$_discountPercentage% off',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFE56A55),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _timeLeftString,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE56A55),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Get Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
