class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final String longDescription;
  final double price;
  final String imageUrl;
  final bool isNew;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.longDescription = '',
    required this.price,
    required this.imageUrl,
    this.isNew = false,
    this.rating = 4.5,
  });
}
