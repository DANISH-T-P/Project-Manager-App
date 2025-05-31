import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String status;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MediaFile> images;
  final List<MediaFile> videos;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.videos,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    String? address,
    double? latitude,
    double? longitude,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MediaFile>? images,
    List<MediaFile>? videos,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      videos: videos ?? this.videos,
    );
  }

  factory Project.fromMap(String id, Map<String, dynamic> data) {
    final geoPoint = data['location']['coordinates'] as GeoPoint;

    return Project(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? '',
      address: data['location']['address'] ?? '',
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      images: (data['images'] as List<dynamic>?)
          ?.map((e) => MediaFile.fromMap(e))
          .toList() ??
          [],
      videos: (data['videos'] as List<dynamic>?)
          ?.map((e) => MediaFile.fromMap(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'location': {
        'address': address,
        'coordinates': GeoPoint(latitude, longitude),
      },
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'images': images.map((e) => e.toMap()).toList(),
      'videos': videos.map((e) => e.toMap()).toList(),
    };
  }


  factory Project.fromDoc(DocumentSnapshot doc) {
    return Project.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

}

class MediaFile {
  final String filename;
  final String storagePath;
  final String downloadUrl;
  final String? thumbnailUrl;
  final DateTime uploadedAt;

  MediaFile({
    required this.filename,
    required this.storagePath,
    required this.downloadUrl,
    this.thumbnailUrl,
    required this.uploadedAt,
  });

  factory MediaFile.fromMap(Map<String, dynamic> data) {
    return MediaFile(
      filename: data['filename'] ?? '',
      storagePath: data['storagePath'] ?? '',
      downloadUrl: data['downloadUrl'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filename': filename,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'thumbnailUrl': thumbnailUrl,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
    };
  }
}
