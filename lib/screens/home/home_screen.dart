import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../data/database_helper.dart';
import '../../data/product_data.dart';
import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  List<Product> _allProducts = [];
  bool _isLoading = true;

  final List<Map<String, String>> _banners = const [
    {
      'title': '✨ New Collection',
      'subtitle': 'Koleksi gelang terbaru sudah hadir!',
    },
    {
      'title': '🎀 Promo 20% Off',
      'subtitle': 'Diskon spesial untuk gelang couple set',
    },
    {
      'title': '💎 Free Shipping',
      'subtitle': 'Gratis ongkir untuk pembelian di atas Rp 100.000',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
  }

  List<Product> get _filteredProducts {
    var products = _allProducts.isNotEmpty ? _allProducts : ProductData.products;
    if (_selectedCategory != 'Semua') {
      products =
          products.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }
    return products;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProviderScope.of(context);
    final cart = CartProviderScope.of(context);
    final user = auth.currentUser;
    final categories = ['Semua', ...ProductData.categories];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat koleksi gelang...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  // ── Greeting Header ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, ${user?.fullName ?? 'Bestie'}! ✨',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Temukan gelang favoritmu hari ini!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Search Bar ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Cari gelang favoritmu...',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded,
                              color: AppColors.primaryBlue),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close,
                                      size: 20, color: AppColors.textHint),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Hero Banner Carousel ──
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.88),
                        itemCount: _banners.length,
                        itemBuilder: (context, index) {
                          final banner = _banners[index];
                          final gradients = [
                            const LinearGradient(
                              colors: [Color(0xFFBAE6FD), Color(0xFFFED7E2)],
                            ),
                            const LinearGradient(
                              colors: [Color(0xFFFED7E2), Color(0xFFFBB6CE)],
                            ),
                            const LinearGradient(
                              colors: [Color(0xFF99C1F1), Color(0xFFBAE6FD)],
                            ),
                          ];
                          return Container(
                            margin:
                                const EdgeInsets.fromLTRB(8, 14, 8, 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: gradients[index % gradients.length],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppShadows.card,
                            ),
                            child: SingleChildScrollView(
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    banner['title']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    banner['subtitle']!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textPrimary
                                          .withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withValues(alpha: 0.8),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Lihat Sekarang →',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Category Chips ──
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isActive = cat == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat),
                              selected: isActive,
                              onSelected: (_) => setState(
                                  () => _selectedCategory = cat),
                              backgroundColor: Colors.white,
                              selectedColor: AppColors.primaryBlue
                                  .withValues(alpha: 0.2),
                              labelStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isActive
                                    ? AppColors.primaryBlueDark
                                    : AppColors.textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isActive
                                      ? AppColors.primaryBlue
                                      : AppColors.primaryBlue
                                          .withValues(alpha: 0.15),
                                ),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Section Title ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategory == 'Semua'
                                ? 'Semua Koleksi'
                                : _selectedCategory,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${_filteredProducts.length} produk',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Product Grid ──
                  _filteredProducts.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off_rounded,
                                    size: 60,
                                    color: AppColors.textHint
                                        .withValues(alpha: 0.4)),
                                const SizedBox(height: 12),
                                Text(
                                  'Produk tidak ditemukan 😢',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.62,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product =
                                    _filteredProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => _showDetail(product),
                                  onAddToCart: () {
                                    cart.addToCart(product);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.name} ditambahkan ke keranjang 🛒',
                                          style: GoogleFonts.poppins(
                                              fontSize: 13),
                                        ),
                                        backgroundColor:
                                            AppColors.primaryBlueDark,
                                        behavior:
                                            SnackBarBehavior.floating,
                                        duration:
                                            const Duration(seconds: 1),
                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: _filteredProducts.length,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  void _showDetail(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductDetailSheet(product: product),
    );
  }
}
