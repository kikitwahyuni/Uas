import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

/// =====================
/// SPLASH SCREEN
/// =====================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   Future.delayed(const Duration(seconds: 2), () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff6A11CB), Color(0xff2575FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: Color(0xff6A11CB),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Kikit Shop",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your Premium Shopping Destination",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =====================
/// MAIN PAGE
/// =====================
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _cartItems = [];
  final List<Map<String, dynamic>> _wishlistItems = [];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
        onAddToCart: _addToCart,
        onAddToWishlist: _addToWishlist,
      ),
      CategoriesPage(
        onAddToCart: _addToCart,
        onAddToWishlist: _addToWishlist,
      ),
      CartPage(cartItems: _cartItems, onRemove: _removeFromCart),
      WishlistPage(
        wishlistItems: _wishlistItems,
        onRemove: _removeFromWishlist,
        onAddToCart: _addToCart,
      ),
      ProfilePage(),
    ];
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item['name'] == product['name'],
      );
      if (existingIndex != -1) {
        _cartItems[existingIndex]['quantity'] += 1;
      } else {
        _cartItems.add({...product, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product['name']} ditambahkan ke keranjang"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _addToWishlist(Map<String, dynamic> product) {
    setState(() {
      final exists = _wishlistItems.any((item) => item['name'] == product['name']);
      if (!exists) {
        _wishlistItems.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${product['name']} ditambahkan ke wishlist"),
            backgroundColor: Colors.pink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  void _removeFromWishlist(int index) {
    setState(() {
      _wishlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff2575FC), Color(0xff6A11CB)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            onTap: (i) => setState(() => _selectedIndex = i),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: "Kategori",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart_rounded),
                    if (_cartItems.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${_cartItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Keranjang",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.favorite_rounded),
                    if (_wishlistItems.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${_wishlistItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: "Wishlist",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Profil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =====================
/// HOME PAGE
/// =====================
class HomePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  final Function(Map<String, dynamic>) onAddToWishlist;

  const HomePage({
    super.key,
    required this.onAddToCart,
    required this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Selamat Datang di",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "Kikit Shop",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Cari produk...",
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildPromoSection(),
              const SizedBox(height: 25),
              _buildCategorySection(context),
              const SizedBox(height: 25),
              _buildFeaturedProducts(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          final colors = [
            [const Color(0xffFF6B6B), const Color(0xffFF8E53)],
            [const Color(0xff4FACFE), const Color(0xff00F2FE)],
            [const Color(0xff43E97B), const Color(0xff38F9D7)],
          ];
          final titles = ["Flash Sale 50%", "New Arrival", "Free Shipping"];
          final subtitles = ["Diskon hingga 50%", "Koleksi Terbaru", "Min. Belanja 100k"];

          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors[index],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colors[index][0].withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.local_offer,
                    size: 150,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "PROMO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final categories = [
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': 'Elektronik', 'icon': Icons.devices, 'color': Colors.blue},
      {'name': 'Makanan', 'icon': Icons.restaurant, 'color': Colors.orange},
      {'name': 'Kecantikan', 'icon': Icons.face, 'color': Colors.purple},
      {'name': 'Olahraga', 'icon': Icons.sports_soccer, 'color': Colors.green},
      {'name': 'Lainnya', 'icon': Icons.apps, 'color': Colors.grey},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Kategori",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 15),
                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: category['color'] as Color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    final products = _getProducts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Produk Unggulan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Lihat Semua"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: min(products.length, 5),
            itemBuilder: (context, index) {
              return _buildProductCard(context, products[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                  onAddToCart: onAddToCart,
                  onAddToWishlist: onAddToWishlist,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: (product['color'] as Color).withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Icon(
                        product['image'] as IconData,
                        size: 70,
                        color: product['color'] as Color,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  if (product['discount'] != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "-${product['discount']}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "${product['rating']}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(${product['sold']})",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['price'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff6A11CB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getProducts() {
    return [
      {
        'name': 'Sepatu Nike Air Max Premium',
        'price': 'Rp 1.500.000',
        'priceNum': 1500000,
        'category': 'Fashion',
        'stock': '15',
        'rating': '4.8',
        'sold': '234',
        'image': Icons.directions_run,
        'color': Colors.blue,
        'discount': 20,
        'description': 'Sepatu olahraga premium dengan teknologi Air Max untuk kenyamanan maksimal saat berlari atau berolahraga.',
      },
      {
        'name': 'Tas Ransel Premium Laptop',
        'price': 'Rp 450.000',
        'priceNum': 450000,
        'category': 'Fashion',
        'stock': '23',
        'rating': '4.7',
        'sold': '567',
        'image': Icons.backpack,
        'color': Colors.orange,
        'description': 'Tas ransel dengan desain modern, cocok untuk membawa laptop hingga 15 inci dengan banyak kantong penyimpanan.',
      },
      {
        'name': 'Jaket Hoodie Winter',
        'price': 'Rp 350.000',
        'priceNum': 350000,
        'category': 'Fashion',
        'stock': '30',
        'rating': '4.9',
        'sold': '892',
        'image': Icons.checkroom,
        'color': Colors.purple,
        'discount': 15,
        'description': 'Jaket hoodie hangat dengan bahan berkualitas tinggi, sempurna untuk musim dingin atau cuaca dingin.',
      },
      {
        'name': 'Smart Watch Pro Max',
        'price': 'Rp 2.200.000',
        'priceNum': 2200000,
        'category': 'Elektronik',
        'stock': '8',
        'rating': '4.6',
        'sold': '145',
        'image': Icons.watch,
        'color': Colors.teal,
        'discount': 10,
        'description': 'Jam tangan pintar dengan fitur lengkap: heart rate monitor, GPS, dan notifikasi smartphone.',
      },
      {
        'name': 'Wireless Headphone Bass',
        'price': 'Rp 850.000',
        'priceNum': 850000,
        'category': 'Elektronik',
        'stock': '12',
        'rating': '4.8',
        'sold': '423',
        'image': Icons.headphones,
        'color': Colors.red,
        'description': 'Headphone wireless dengan kualitas bass yang powerful dan battery life hingga 30 jam.',
      },
      {
        'name': 'Kamera DSLR Professional',
        'price': 'Rp 8.500.000',
        'priceNum': 8500000,
        'category': 'Elektronik',
        'stock': '5',
        'rating': '4.9',
        'sold': '78',
        'image': Icons.camera_alt,
        'color': Colors.black,
        'discount': 25,
        'description': 'Kamera DSLR profesional dengan sensor 24MP dan video 4K untuk hasil foto dan video berkualitas tinggi.',
      },
    ];
  }
}

/// =====================
/// CATEGORIES PAGE
/// =====================
class CategoriesPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onAddToCart;
  final Function(Map<String, dynamic>) onAddToWishlist;

  const CategoriesPage({
    super.key,
    required this.onAddToCart,
    required this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final products = _getProducts();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              "Semua Produk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildGridProductCard(context, products[index]);
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  product: product,
                  onAddToCart: onAddToCart,
                  onAddToWishlist: onAddToWishlist,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: (product['color'] as Color).withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Icon(
                        product['image'] as IconData,
                        size: 70,
                        color: product['color'] as Color,
                      ),
                    ),
                  ),
                  if (product['discount'] != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "-${product['discount']}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            "${product['rating']}",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product['price'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xff6A11CB),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getProducts() {
    return [
      {'name': 'Sepatu Nike Air Max Premium', 'price': 'Rp 1.500.000', 'priceNum': 1500000, 'category': 'Fashion', 'stock': '15', 'rating': '4.8', 'sold': '234', 'image': Icons.directions_run, 'color': Colors.blue, 'discount': 20, 'description': 'Sepatu olahraga premium dengan teknologi Air Max untuk kenyamanan maksimal saat berlari atau berolahraga.'},
      {'name': 'Tas Ransel Premium Laptop', 'price': 'Rp 450.000', 'priceNum': 450000, 'category': 'Fashion', 'stock': '23', 'rating': '4.7', 'sold': '567', 'image': Icons.backpack, 'color': Colors.orange, 'description': 'Tas ransel dengan desain modern, cocok untuk membawa laptop hingga 15 inci dengan banyak kantong penyimpanan.'},
      {'name': 'Jaket Hoodie Winter', 'price': 'Rp 350.000', 'priceNum': 350000, 'category': 'Fashion', 'stock': '30', 'rating': '4.9', 'sold': '892', 'image': Icons.checkroom, 'color': Colors.purple, 'discount': 15, 'description': 'Jaket hoodie hangat dengan bahan berkualitas tinggi, sempurna untuk musim dingin atau cuaca dingin.'},
      {'name': 'Smart Watch Pro Max', 'price': 'Rp 2.200.000', 'priceNum': 2200000, 'category': 'Elektronik', 'stock': '8', 'rating': '4.6', 'sold': '145', 'image': Icons.watch, 'color': Colors.teal, 'discount': 10, 'description': 'Jam tangan pintar dengan fitur lengkap: heart rate monitor, GPS, dan notifikasi smartphone.'},
      {'name': 'Wireless Headphone Bass', 'price': 'Rp 850.000', 'priceNum': 850000, 'category': 'Elektronik', 'stock': '12', 'rating': '4.8', 'sold': '423', 'image': Icons.headphones, 'color': Colors.red, 'description': 'Headphone wireless dengan kualitas bass yang powerful dan battery life hingga 30 jam.'},
      {'name': 'Kamera DSLR Professional', 'price': 'Rp 8.500.000', 'priceNum': 8500000, 'category': 'Elektronik', 'stock': '5', 'rating': '4.9', 'sold': '78', 'image': Icons.camera_alt, 'color': Colors.black, 'discount': 25, 'description': 'Kamera DSLR profesional dengan sensor 24MP dan video 4K untuk hasil foto dan video berkualitas tinggi.'},
      {'name': 'Laptop Gaming RGB', 'price': 'Rp 15.000.000', 'priceNum': 15000000, 'category': 'Elektronik', 'stock': '3', 'rating': '4.9', 'sold': '56', 'image': Icons.laptop, 'color': Colors.indigo, 'discount': 15, 'description': 'Laptop gaming dengan spesifikasi tinggi, RGB keyboard, dan performa maksimal untuk gaming.'},
      {'name': 'Smartphone Flagship', 'price': 'Rp 12.000.000', 'priceNum': 12000000, 'category': 'Elektronik', 'stock': '10', 'rating': '4.8', 'sold': '189', 'image': Icons.phone_android, 'color': Colors.cyan, 'description': 'Smartphone flagship dengan kamera 108MP, layar AMOLED, dan performa processor terbaik.'},
      {'name': 'Kemeja Formal Premium', 'price': 'Rp 320.000', 'priceNum': 320000, 'category': 'Fashion', 'stock': '18', 'rating': '4.5', 'sold': '345', 'image': Icons.shopping_bag, 'color': Colors.brown, 'description': 'Kemeja formal dengan bahan katun premium, nyaman dipakai untuk acara formal maupun kerja.'},
      {'name': 'Celana Jeans Denim', 'price': 'Rp 280.000', 'priceNum': 280000, 'category': 'Fashion', 'stock': '25', 'rating': '4.7', 'sold': '678', 'image': Icons.dry_cleaning, 'color': Colors.blueGrey, 'description': 'Celana jeans denim berkualitas dengan potongan slim fit yang stylish dan nyaman.'},
      {'name': 'Dompet Kulit Asli', 'price': 'Rp 180.000', 'priceNum': 180000, 'category': 'Fashion', 'stock': '40', 'rating': '4.6', 'sold': '456', 'image': Icons.wallet, 'color': Colors.deepOrange, 'description': 'Dompet dari kulit asli dengan desain elegan dan banyak slot kartu.'},
      {'name': 'Sepatu Sneakers Putih', 'price': 'Rp 650.000', 'priceNum': 650000, 'category': 'Fashion', 'stock': '20', 'rating': '4.7', 'sold': '234', 'image': Icons.fitness_center, 'color': Colors.grey, 'discount': 10, 'description': 'Sneakers putih minimalis yang cocok untuk gaya casual sehari-hari.'},
    ];
  }
}

/// =====================
/// PRODUCT DETAIL PAGE
/// =====================
class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAddToCart;
  final Function(Map<String, dynamic>) onAddToWishlist;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onAddToWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: (product['color'] as Color).withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    product['image'] as IconData,
                    size: 150,
                    color: product['color'] as Color,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur berbagi produk")),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['category'] as String,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${product['rating']} (${product['sold']} terjual)",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product['name'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (product['discount'] != null) ...[
                        Text(
                          product['price'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        product['discount'] != null
                            ? 'Rp ${(product['priceNum'] * (1 - product['discount'] / 100)).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'
                            : product['price'] as String,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6A11CB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    "Deskripsi Produk",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product['description'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoBox(Icons.inventory_2, "Stok", "${product['stock']} unit"),
                      const SizedBox(width: 12),
                      _buildInfoBox(Icons.local_shipping, "Pengiriman", "2-3 hari"),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  onAddToWishlist(product);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    onAddToCart(product);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Tambah ke Keranjang",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xff6A11CB)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// CART PAGE
/// =====================
class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) onRemove;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemove,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    int total = 0;
    for (var item in widget.cartItems) {
      total += (item['priceNum'] as int) * (item['quantity'] as int);
    }

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
            ),
          ),
        ),
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Keranjang Kosong",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Yuk, mulai belanja sekarang!",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item['image'] as IconData,
                                  size: 40,
                                  color: item['color'] as Color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['price'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xff6A11CB),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove, size: 16),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (item['quantity'] > 1) {
                                                      item['quantity']--;
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                "${item['quantity']}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add, size: 16),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                  minWidth: 32,
                                                  minHeight: 32,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    item['quantity']++;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          onPressed: () {
                                            widget.onRemove(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Pembayaran",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6A11CB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text("Konfirmasi Pembayaran"),
                                content: const Text("Lanjutkan ke pembayaran?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Pesanan berhasil! Terima kasih"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff6A11CB),
                                    ),
                                    child: const Text("Ya"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff6A11CB), Color(0xff2575FC)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Checkout Sekarang",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// =====================
/// WISHLIST PAGE
/// =====================
class WishlistPage extends StatelessWidget {
  final List<Map<String, dynamic>> wishlistItems;
  final Function(int) onRemove;
  final Function(Map<String, dynamic>) onAddToCart;

  const WishlistPage({
    super.key,
    required this.wishlistItems,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Wishlist Saya",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A11CB), Color(0xff2575FC)],
            ),
          ),
        ),
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Wishlist Kosong",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tambahkan produk favoritmu!",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: Center(
                              child: Icon(
                                item['image'] as IconData,
                                size: 70,
                                color: item['color'] as Color,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.red),
                              onPressed: () => onRemove(index),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Text(
                                item['price'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xff6A11CB),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => onAddToCart(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff6A11CB),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Beli",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// =====================
/// PROFILE PAGE
/// =====================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Kikit Wahyuni";
  String userEmail = "kikit@example.com";

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6A11CB),],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://randomuser.me/api/portraits/women/44.jpg', // contoh foto profil
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Menu Profil
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: "Edit Profil",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Edit Profil (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: "Alamat Pengiriman",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Alamat Pengiriman (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: "Riwayat Pesanan",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Riwayat Pesanan (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.payment,
                  title: "Metode Pembayaran",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Metode Pembayaran (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: "Notifikasi",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Notifikasi (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: "Bantuan & Pusat Bantuan",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Bantuan (belum diimplementasikan)")),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Kikit Shop',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Color(0xff6A11CB),
                      ),
                      children: const [
                        Text(
                          'Kikit Shop adalah destinasi belanja premium Anda dengan berbagai produk berkualitas tinggi.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                // Tombol Logout
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text("Keluar dari Akun"),
                          content: const Text("Apakah Anda yakin ingin keluar?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Berhasil keluar dari akun"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                // Di sini bisa ditambahkan navigasi ke login jika ada
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Keluar"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Keluar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xff6A11CB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xff6A11CB),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              /// Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Password
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // sementara langsung login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
