import 'dart:convert';

/// Fungsi untuk mengubah JSON menjadi `RecipeModel`.
RecipeModel recipeModelFromJson(String str) =>
    RecipeModel.fromJson(json.decode(str));

/// Fungsi untuk mengubah `RecipeModel` menjadi JSON.
String recipeModelToJson(RecipeModel data) => json.encode(data.toJson());

/// Model utama untuk data resep.
class RecipeModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String cookingMethod;
  final String ingredients;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final User user;

  RecipeModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.cookingMethod,
    required this.ingredients,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.user,
  });

  /// Factory untuk membuat instance `RecipeModel` dari JSON.
  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        cookingMethod: json["cooking_method"],
        ingredients: json["ingredients"],
        photoUrl: json["photo_url"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        likesCount: json["likes_count"] ?? 0,
        commentsCount: json["comments_count"] ?? 0,
        user: User.fromJson(json["user"]),
      );

  /// Mengubah instance `RecipeModel` menjadi JSON.
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "cooking_method": cookingMethod,
        "ingredients": ingredients,
        "photo_url": photoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "user": user.toJson(),
      };
}

/// Model untuk data pengguna.
class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt, // Nullable
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory untuk membuat instance `User` dari JSON.
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"], // Bisa null
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  /// Mengubah instance `User` menjadi JSON.
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

/// Model untuk detail resep (berbeda dari `RecipeModel`).
class RecipeDetailModel {
  final int id;
  final String title;
  final String img;
  final int likesCount;
  final int commentsCount;
  final String description;
  final String ingredients;
  final String steps;

  RecipeDetailModel({
    required this.id,
    required this.title,
    required this.img,
    required this.likesCount,
    required this.commentsCount,
    required this.description,
    required this.ingredients,
    required this.steps,
  });

  /// Factory untuk membuat instance `RecipeDetailModel` dari JSON.
  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      RecipeDetailModel(
        id: json["id"],
        title: json["title"],
        img: json["img"] ?? '',
        likesCount: json["likes_count"] ?? 0,
        commentsCount: json["comments_count"] ?? 0,
        description: json["description"] ?? '',
        ingredients: json["ingredients"] ?? '',
        steps: json["steps"] ?? '',
      );

  /// Mengubah instance `RecipeDetailModel` menjadi JSON.
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "img": img,
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "description": description,
        "ingredients": ingredients,
        "steps": steps,
      };
}
