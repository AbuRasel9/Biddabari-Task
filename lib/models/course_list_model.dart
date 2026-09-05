class CourseListModel {
  List<Course>? courses;

  CourseListModel({
    this.courses,
  });

  factory CourseListModel.fromJson(Map<String, dynamic> json) {
    return CourseListModel(
      courses: json['courses'] != null && json['courses'] is List
          ? (json['courses'] as List)
              .map((e) => Course.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'courses': courses?.map((e) => e.toJson()).toList(),
      };
}

class Course {
  int? id;
  String? title;
  String? subTitle;
  int? price;
  String? banner;
  int? discountType;
  int? discountAmount;
  String? discountStartDate;
  String? discountEndDate;
  String? altText;
  String? bannerTitle;
  String? durationInMonth;
  String? totalClass;
  int? totalExam;
  int? totalLive;
  String? orderStatus;

  Course({
    this.id,
    this.title,
    this.subTitle,
    this.price,
    this.banner,
    this.discountType,
    this.discountAmount,
    this.discountStartDate,
    this.discountEndDate,
    this.altText,
    this.bannerTitle,
    this.durationInMonth,
    this.totalClass,
    this.totalExam,
    this.totalLive,
    this.orderStatus,
  });

  String? get bannerUrl {
    if (banner == null || banner!.isEmpty) return null;
    const String baseUrl = 'https://storage.biddabari.online/biddabari-bucket';
    if (banner!.contains('backend')) {
      final String path = banner!.substring(banner!.indexOf('backend'));
      return '$baseUrl/$path';
    }
    if (banner!.startsWith('http://') || banner!.startsWith('https://')) {
      return banner;
    }
    return banner!.startsWith('/') ? '$baseUrl$banner' : '$baseUrl/$banner';
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: _toInt(json['id']),
      title: json['title']?.toString(),
      subTitle: json['sub_title']?.toString(),
      price: _toInt(json['price']),
      banner: json['banner']?.toString(),
      discountType: _toInt(json['discount_type']),
      discountAmount: _toInt(json['discount_amount']),
      discountStartDate: json['discount_start_date']?.toString(),
      discountEndDate: json['discount_end_date']?.toString(),
      altText: json['alt_text']?.toString(),
      bannerTitle: json['banner_title']?.toString(),
      durationInMonth: json['duration_in_month']?.toString(),
      totalClass: (json['total_class'] ?? json['total_video'])?.toString(),
      totalExam: _toInt(json['total_exam']),
      totalLive: _toInt(json['total_live'] ?? json['total_video']),
      orderStatus: json['order_status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'sub_title': subTitle,
        'price': price,
        'banner': banner,
        'discount_type': discountType,
        'discount_amount': discountAmount,
        'discount_start_date': discountStartDate,
        'discount_end_date': discountEndDate,
        'alt_text': altText,
        'banner_title': bannerTitle,
        'duration_in_month': durationInMonth,
        'total_class': totalClass,
        'total_exam': totalExam,
        'total_live': totalLive,
        'order_status': orderStatus,
      };

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }


}
