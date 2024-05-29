import 'package:json_annotation/json_annotation.dart';

part 'products.g.dart';

@JsonSerializable()
class ProductModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final Rating? rating;
  bool isFavorite;
  int count;
  List<CommentModel> comments;

  ProductModel({
    this.isFavorite = false,
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
    this.count = 1,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return _$ProductModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(this);
  }

    static List<ProductModel> fromList(List<dynamic> data) =>
      data.map((e) => ProductModel.fromJson(e)).toList();

  void addComment(CommentModel comment) {
    comments.add(comment);
  }
}

@JsonSerializable()
class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return _$RatingFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RatingToJson(this);
  }
}

@JsonSerializable()
class CommentModel {
  final String user;
  final String comment;

  CommentModel({required this.user, required this.comment});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return _$CommentModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CommentModelToJson(this);
  }
}

