import 'dart:async';

import 'package:biddabari_task/data/services/network_info_service.dart';
import 'package:biddabari_task/di/service_locator.dart';
import 'package:biddabari_task/presentation/views/home_view/widget/course_card.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domen/controllers/course_controller.dart';

class CourseListView extends StatefulWidget {
  const CourseListView({super.key});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseController>().fetchCourseList();
    });

    // Automatically retry fetching when internet connection is restored
    _connectivitySubscription = sl<NetworkInfoService>()
        .onConnectivityChanged
        .listen((connectivityResults) {
      if (!connectivityResults.contains(ConnectivityResult.none)) {
        if (mounted) {
          final controller = context.read<CourseController>();
          if (controller.courses.isEmpty || controller.errorMessage != null) {
            controller.fetchCourseList();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Course List'),
        backgroundColor:Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CourseController>().fetchCourseList(),
          ),
        ],
      ),
      body: Consumer<CourseController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage != null) {
            final isNoInternet = controller.errorMessage!
                    .toLowerCase()
                    .contains('internet') ||
                controller.errorMessage!.toLowerCase().contains('connection');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isNoInternet ? Icons.wifi_off_rounded : Icons.error_outline,
                      size: 64,
                      color: isNoInternet ? Colors.orange : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isNoInternet
                          ? 'No Internet Connection'
                          : 'Something Went Wrong',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => controller.fetchCourseList(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (controller.courses.isEmpty) {
            return const Center(
              child: Text('No courses found.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchCourseList(),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.courses.length,
              itemBuilder: (context, index) {
                final course = controller.courses[index];
                return CourseCard(course: course);
              },
            ),
          );
        },
      ),
    );
  }
}
