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

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'long_description': longDescription,
        'price': price,
        'image_url': imageUrl,
        'is_new': isNew ? 1 : 0,
        'rating': rating,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'longDescription': longDescription,
        'price': price,
        'imageUrl': imageUrl,
        'isNew': isNew,
        'rating': rating,
      };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id']?.toString() ?? '',
        name: (map['name'] ?? map['nama'])?.toString() ?? '',
        category: (map['category'] ?? map['jenis'])?.toString() ?? '',
        description:
            (map['description'] ?? map['deskripsi'])?.toString() ?? '',
        longDescription: (map['long_description'] ??
                map['longDescription'] ??
                map['deskripsi_lengkap'])
            ?.toString() ??
            '',
        price: (map['price'] ?? map['harga'] as num?)?.toDouble() ?? 0.0,
        imageUrl: (map['image_url'] ??
                map['imageUrl'] ??
                map['gambar'])
            ?.toString() ??
            '',
        isNew: map['is_new'] == 1 ||
            map['is_new'] == true ||
            map['isNew'] == true ||
            map['status_new'] == 1 ||
            map['status'] == 'new',
        rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      );

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product.fromMap(json);

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? longDescription,
    double? price,
    String? imageUrl,
    bool? isNew,
    double? rating,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description ?? this.description,
        longDescription: longDescription ?? this.longDescription,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isNew: isNew ?? this.isNew,
        rating: rating ?? this.rating,
      );
}
