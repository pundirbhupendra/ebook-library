// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebook_model_freezed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EbookModelFreezed _$EbookModelFreezedFromJson(Map<String, dynamic> json) =>
    _EbookModelFreezed(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      author: json['author'] as String,
      fileType: json['file_type'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      filename: json['filename'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      downloadUrl: json['download_url'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
    );

Map<String, dynamic> _$EbookModelFreezedToJson(_EbookModelFreezed instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'filename': instance.filename,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
      'download_url': instance.downloadUrl,
      'cover_image_url': instance.coverImageUrl,
    };
