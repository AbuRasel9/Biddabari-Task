import 'package:flutter/material.dart';

import '../../../../models/course_list_model.dart';
import '../../../widget/network_image_card.dart';
import '../../course_details_view/course_details_view.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = course.discountAmount != null &&
        course.discountAmount! > 0 &&
        course.price != null;

    final int calculatedPrice = hasDiscount
        ? (course.price! - course.discountAmount!)
        : (course.price ?? 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsView(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (course.bannerUrl != null && course.bannerUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: NetworkImageCard(imageLink: course.bannerUrl!),
                ),
              const SizedBox(height: 8),
              Text(
                course.title ?? '',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (course.subTitle != null &&
                  course.subTitle!.isNotEmpty &&
                  course.subTitle != 'null') ...[
                const SizedBox(height: 4),
                Text(
                  course.subTitle!,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          '৳${course.price}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (course.price != null)
                        Text(
                          '৳$calculatedPrice',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                    ],
                  ),


                    Chip(
                      label: Text('${course.totalClass ?? "95"} Classes'),
                      backgroundColor: Colors.blue[50],
                    ),
                    Chip(
                      label: Text('${course.totalExam ?? "93"} Exams'),
                      backgroundColor: Colors.blue[50],
                    ),
                    Chip(
                      label: Text('${course.totalLive ?? "95"} Live'),
                      backgroundColor: Colors.blue[50],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
