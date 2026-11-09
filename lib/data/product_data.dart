import '../models/product_model.dart';

class ProductData {
  ProductData._();

  static const List<Product> products = [
    Product(
      id: '1',
      name: 'Dreamy Pearl Beads',
      category: 'Beaded Bracelets',
      description: 'Gelang manik-manik mutiara dengan sentuhan warna pastel yang lembut.',
      longDescription:
          'Gelang manik-manik mutiara pilihan dengan kombinasi warna pastel soft blue dan soft pink. '
          'Setiap butir mutiara dipilih secara handmade untuk menghasilkan kesan elegan dan aesthetic. '
          'Cocok untuk sehari-hari maupun acara spesial.',
      price: 35000,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400&h=400&fit=crop',
      isNew: true,
      rating: 4.8,
    ),
    Product(
      id: '2',
      name: 'Butterfly Charm Set',
      category: 'Charm Bracelets',
      description: 'Set gelang charm kupu-kupu dengan detail emas rose gold.',
      longDescription:
          'Set gelang charm dengan motif kupu-kupu cantik berlapis emas rose gold. '
          'Dilengkapi 5 charm yang bisa dilepas-pasang sesuai selera. '
          'Bahan stainless steel anti karat dan hypoallergenic.',
      price: 55000,
      imageUrl: 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=400&h=400&fit=crop',
      isNew: true,
      rating: 4.9,
    ),
    Product(
      id: '3',
      name: 'Simple Thread Blue',
      category: 'Minimalist Thread',
      description: 'Gelang tali minimalis warna soft blue untuk tampilan simple.',
      longDescription:
          'Gelang tali waxed cord premium warna soft blue dengan kunci adjustable. '
          'Desain minimalis yang cocok untuk layering atau dipakai sendirian. '
          'Tahan air dan cocok untuk daily wear.',
      price: 15000,
      imageUrl: 'https://images.unsplash.com/photo-1601821765780-754fa98637c1?w=400&h=400&fit=crop',
      rating: 4.5,
    ),
    Product(
      id: '4',
      name: 'Custom Letter "LOVE"',
      category: 'Custom Letter Bracelets',
      description: 'Gelang custom huruf dengan pilihan kata "LOVE" warna pink.',
      longDescription:
          'Gelang custom dengan huruf akrilik premium yang bisa dipersonalisasi. '
          'Default kata "LOVE" dengan warna soft pink. '
          'Bisa request kata lain (maks. 8 huruf). Cocok untuk hadiah spesial.',
      price: 45000,
      imageUrl: 'https://images.unsplash.com/photo-1602173574767-37ac01994b2a?w=400&h=400&fit=crop',
      isNew: true,
      rating: 4.7,
    ),
    Product(
      id: '5',
      name: 'Couple Heart Set',
      category: 'Couples Set',
      description: 'Set gelang couple dengan liontin hati yang saling melengkapi.',
      longDescription:
          'Set 2 gelang untuk pasangan dengan desain liontin hati puzzle yang saling melengkapi. '
          'Satu berwarna soft blue, satu berwarna soft pink. '
          'Bahan titanium steel anti luntur. Packaging eksklusif siap kado.',
      price: 85000,
      imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400&h=400&fit=crop',
      rating: 4.9,
    ),
    Product(
      id: '6',
      name: 'Crystal Aurora Beads',
      category: 'Beaded Bracelets',
      description: 'Gelang kristal aurora dengan efek kilau pelangi yang memukau.',
      longDescription:
          'Gelang dengan manik-manik kristal aurora premium yang menghasilkan efek kilau pelangi saat terkena cahaya. '
          'Sangat cocok untuk acara pesta atau tampilan glamour sehari-hari.',
      price: 65000,
      imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=400&h=400&fit=crop',
      rating: 4.6,
    ),
    Product(
      id: '7',
      name: 'Pastel Stack Set',
      category: 'Beaded Bracelets',
      description: 'Set 3 gelang beads pastel yang bisa di-mix and match.',
      longDescription:
          'Set 3 gelang beads dengan warna pastel berbeda: soft blue, lavender, dan soft pink. '
          'Elastis dan nyaman dipakai. Cocok untuk stacking style yang sedang tren.',
      price: 48000,
      imageUrl: 'https://images.unsplash.com/photo-1608042314453-ae338d80c427?w=400&h=400&fit=crop',
      isNew: true,
      rating: 4.8,
    ),
    Product(
      id: '8',
      name: 'Moon & Star Charm',
      category: 'Charm Bracelets',
      description: 'Gelang charm bulan dan bintang dengan nuansa celestial.',
      longDescription:
          'Gelang rantai halus dengan charm bulan sabit dan bintang berlapis silver. '
          'Desain celestial yang aesthetic dan cocok untuk pecinta tema langit malam.',
      price: 42000,
      imageUrl: 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?w=400&h=400&fit=crop',
      rating: 4.7,
    ),
  ];

  static List<String> get categories =>
      products.map((p) => p.category).toSet().toList();
}
