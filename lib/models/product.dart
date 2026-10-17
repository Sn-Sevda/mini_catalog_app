class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final String imageUrl;
  final String description;
  final List<String> specs;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.specs,
  });
}