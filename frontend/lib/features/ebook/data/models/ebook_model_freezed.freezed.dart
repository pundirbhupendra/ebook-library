// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook_model_freezed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EbookModelFreezed {

 int get id; String get title; String get author;@JsonKey(name: 'file_type') String get fileType;@JsonKey(name: 'file_size') int get fileSize; String? get filename;@JsonKey(name: 'uploaded_at') DateTime get uploadedAt;@JsonKey(name: 'download_url') String? get downloadUrl;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;
/// Create a copy of EbookModelFreezed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookModelFreezedCopyWith<EbookModelFreezed> get copyWith => _$EbookModelFreezedCopyWithImpl<EbookModelFreezed>(this as EbookModelFreezed, _$identity);

  /// Serializes this EbookModelFreezed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookModelFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,fileType,fileSize,filename,uploadedAt,downloadUrl,coverImageUrl);

@override
String toString() {
  return 'EbookModelFreezed(id: $id, title: $title, author: $author, fileType: $fileType, fileSize: $fileSize, filename: $filename, uploadedAt: $uploadedAt, downloadUrl: $downloadUrl, coverImageUrl: $coverImageUrl)';
}


}

/// @nodoc
abstract mixin class $EbookModelFreezedCopyWith<$Res>  {
  factory $EbookModelFreezedCopyWith(EbookModelFreezed value, $Res Function(EbookModelFreezed) _then) = _$EbookModelFreezedCopyWithImpl;
@useResult
$Res call({
 int id, String title, String author,@JsonKey(name: 'file_type') String fileType,@JsonKey(name: 'file_size') int fileSize, String? filename,@JsonKey(name: 'uploaded_at') DateTime uploadedAt,@JsonKey(name: 'download_url') String? downloadUrl,@JsonKey(name: 'cover_image_url') String? coverImageUrl
});




}
/// @nodoc
class _$EbookModelFreezedCopyWithImpl<$Res>
    implements $EbookModelFreezedCopyWith<$Res> {
  _$EbookModelFreezedCopyWithImpl(this._self, this._then);

  final EbookModelFreezed _self;
  final $Res Function(EbookModelFreezed) _then;

/// Create a copy of EbookModelFreezed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? fileType = null,Object? fileSize = null,Object? filename = freezed,Object? uploadedAt = null,Object? downloadUrl = freezed,Object? coverImageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookModelFreezed].
extension EbookModelFreezedPatterns on EbookModelFreezed {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookModelFreezed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookModelFreezed() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookModelFreezed value)  $default,){
final _that = this;
switch (_that) {
case _EbookModelFreezed():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookModelFreezed value)?  $default,){
final _that = this;
switch (_that) {
case _EbookModelFreezed() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String author, @JsonKey(name: 'file_type')  String fileType, @JsonKey(name: 'file_size')  int fileSize,  String? filename, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'cover_image_url')  String? coverImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EbookModelFreezed() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.fileType,_that.fileSize,_that.filename,_that.uploadedAt,_that.downloadUrl,_that.coverImageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String author, @JsonKey(name: 'file_type')  String fileType, @JsonKey(name: 'file_size')  int fileSize,  String? filename, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'cover_image_url')  String? coverImageUrl)  $default,) {final _that = this;
switch (_that) {
case _EbookModelFreezed():
return $default(_that.id,_that.title,_that.author,_that.fileType,_that.fileSize,_that.filename,_that.uploadedAt,_that.downloadUrl,_that.coverImageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String author, @JsonKey(name: 'file_type')  String fileType, @JsonKey(name: 'file_size')  int fileSize,  String? filename, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt, @JsonKey(name: 'download_url')  String? downloadUrl, @JsonKey(name: 'cover_image_url')  String? coverImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _EbookModelFreezed() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.fileType,_that.fileSize,_that.filename,_that.uploadedAt,_that.downloadUrl,_that.coverImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EbookModelFreezed extends EbookModelFreezed {
  const _EbookModelFreezed({required this.id, required this.title, required this.author, @JsonKey(name: 'file_type') required this.fileType, @JsonKey(name: 'file_size') required this.fileSize, required this.filename, @JsonKey(name: 'uploaded_at') required this.uploadedAt, @JsonKey(name: 'download_url') required this.downloadUrl, @JsonKey(name: 'cover_image_url') required this.coverImageUrl}): super._();
  factory _EbookModelFreezed.fromJson(Map<String, dynamic> json) => _$EbookModelFreezedFromJson(json);

@override final  int id;
@override final  String title;
@override final  String author;
@override@JsonKey(name: 'file_type') final  String fileType;
@override@JsonKey(name: 'file_size') final  int fileSize;
@override final  String? filename;
@override@JsonKey(name: 'uploaded_at') final  DateTime uploadedAt;
@override@JsonKey(name: 'download_url') final  String? downloadUrl;
@override@JsonKey(name: 'cover_image_url') final  String? coverImageUrl;

/// Create a copy of EbookModelFreezed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookModelFreezedCopyWith<_EbookModelFreezed> get copyWith => __$EbookModelFreezedCopyWithImpl<_EbookModelFreezed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EbookModelFreezedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookModelFreezed&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,author,fileType,fileSize,filename,uploadedAt,downloadUrl,coverImageUrl);

@override
String toString() {
  return 'EbookModelFreezed(id: $id, title: $title, author: $author, fileType: $fileType, fileSize: $fileSize, filename: $filename, uploadedAt: $uploadedAt, downloadUrl: $downloadUrl, coverImageUrl: $coverImageUrl)';
}


}

/// @nodoc
abstract mixin class _$EbookModelFreezedCopyWith<$Res> implements $EbookModelFreezedCopyWith<$Res> {
  factory _$EbookModelFreezedCopyWith(_EbookModelFreezed value, $Res Function(_EbookModelFreezed) _then) = __$EbookModelFreezedCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String author,@JsonKey(name: 'file_type') String fileType,@JsonKey(name: 'file_size') int fileSize, String? filename,@JsonKey(name: 'uploaded_at') DateTime uploadedAt,@JsonKey(name: 'download_url') String? downloadUrl,@JsonKey(name: 'cover_image_url') String? coverImageUrl
});




}
/// @nodoc
class __$EbookModelFreezedCopyWithImpl<$Res>
    implements _$EbookModelFreezedCopyWith<$Res> {
  __$EbookModelFreezedCopyWithImpl(this._self, this._then);

  final _EbookModelFreezed _self;
  final $Res Function(_EbookModelFreezed) _then;

/// Create a copy of EbookModelFreezed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? fileType = null,Object? fileSize = null,Object? filename = freezed,Object? uploadedAt = null,Object? downloadUrl = freezed,Object? coverImageUrl = freezed,}) {
  return _then(_EbookModelFreezed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
