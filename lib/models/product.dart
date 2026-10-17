class Product {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> specs;

  const Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.specs,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      specs: List<String>.from(map['specs'] as List),
    );
  }
}