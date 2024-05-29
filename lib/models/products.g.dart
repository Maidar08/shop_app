// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      isFavorite: json['isFavorite'] as bool? ?? false,
      id: json['id'] as int?,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      image: json['image'] as String?,
      rating: json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      count: json['count'] as int? ?? 1,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'image': instance.image,
      // 'rating': instance.rating,
      'isFavorite': instance.isFavorite,
      'count': instance.count,
      'comments': instance.comments,
    };

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      rate: (json['rate'] as num?)?.toDouble(),
      count: json['count'] as int?,
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'rate': instance.rate,
      'count': instance.count,
    };

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      user: json['user'] as String,
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'comment': instance.comment,
    };
