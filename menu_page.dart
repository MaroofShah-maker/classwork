import 'package:flutter/material.dart';

// This screen is stateful because its cart contents change as the user orders.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Each map represents one food or drink, with its name, price, category,
  // and icon. The cart uses these same records to display order details.
  final List<Map<String, dynamic>> allItems = const [
    {
      'name': 'Zinger Burger',
      'price': 450,
      'category': 'Fast Food',
      'icon': Icons.lunch_dining,
    },
    {
      'name': 'Chicken Pizza',
      'price': 900,
      'category': 'Fast Food',
      'icon': Icons.local_pizza,
    },
    {
      'name': 'Beef Burger',
      'price': 500,
      'category': 'Fast Food',
      'icon': Icons.lunch_dining,
    },
    {
      'name': 'Pasta',
      'price': 550,
      'category': 'Fast Food',
      'icon': Icons.ramen_dining,
    },
    {
      'name': 'French Fries',
      'price': 200,
      'category': 'Fast Food',
      'icon': Icons.fastfood,
    },
    {
      'name': 'Chicken Karahi',
      'price': 1200,
      'category': 'Desi',
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Biryani',
      'price': 350,
      'category': 'Desi',
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Nihari',
      'price': 600,
      'category': 'Desi',
      'icon': Icons.soup_kitchen,
    },
    {
      'name': 'Cold Drink',
      'price': 120,
      'category': 'Drinks',
      'icon': Icons.local_drink,
    },
    {
      'name': 'Fresh Juice',
      'price': 250,
      'category': 'Drinks',
      'icon': Icons.local_cafe,
    },
    {
      'name': 'Green Tea',
      'price': 100,
      'category': 'Drinks',
      'icon': Icons.emoji_food_beverage,
    },
    {
      'name': 'Ice Cream',
      'price': 250,
      'category': 'Dessert',
      'icon': Icons.icecream,
    },
    {
      'name': 'Chocolate Cake',
      'price': 400,
      'category': 'Dessert',
      'icon': Icons.cake,
    },
    {
      'name': 'Gulab Jamun',
      'price': 150,
      'category': 'Dessert',
      'icon': Icons.donut_large,
    },
  ];

  // Store item names with their quantities, such as {'Pasta': 2}.
  final Map<String, int> cart = {};

  // Tracks which item is currently "expanded" for the pop animation.
  String? _activeItem;

  // Put drinks in their own section and all other menu items under Food Items.
  Map<String, List<Map<String, dynamic>>> get itemSections {
    final foodItems = allItems
        .where((item) => item['category'] != 'Drinks')
        .toList();
    final drinks = allItems
        .where((item) => item['category'] == 'Drinks')
        .toList();
    return {
      if (foodItems.isNotEmpty) 'Food Items': foodItems,
      if (drinks.isNotEmpty) 'Drinks & Beverages': drinks,
    };
  }

  int get totalItems => cart.values.fold(0, (a, b) => a + b);

  double get totalPrice {
    double total = 0;
    cart.forEach((name, qty) {
      final item = allItems.firstWhere((i) => i['name'] == name);
      total += (item['price'] as int) * qty;
    });
    return total;
  }

  void _addToCart(String name) {
    setState(() {
      cart[name] = (cart[name] ?? 0) + 1;
      _activeItem = name; // triggers AnimatedContainer pop
    });
    // Revert the animation flag after 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _activeItem = null);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $name to cart'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeFromCart(String name) {
    setState(() {
      if (!cart.containsKey(name)) return;
      if (cart[name]! <= 1) {
        cart.remove(name);
      } else {
        cart[name] = cart[name]! - 1;
      }
    });
  }

  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: cart.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: Text('Cart is empty 🛒')),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Your Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        ...cart.entries.map((e) {
                          final item = allItems.firstWhere(
                            (i) => i['name'] == e.key,
                          );
                          return ListTile(
                            leading: Icon(item['icon'], color: Colors.orange),
                            title: Text(e.key),
                            subtitle: Text('Rs ${item['price']} × ${e.value}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _removeFromCart(e.key);
                                    setModalState(() {});
                                  },
                                ),
                                // Animated quantity counter
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                        scale: anim,
                                        child: FadeTransition(
                                          opacity: anim,
                                          child: child,
                                        ),
                                      ),
                                  child: Text(
                                    '${e.value}',
                                    key: ValueKey(e.value),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    _addToCart(e.key);
                                    setModalState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Animated total (rolls over)
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, anim) =>
                                    SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.5),
                                        end: Offset.zero,
                                      ).animate(anim),
                                      child: FadeTransition(
                                        opacity: anim,
                                        child: child,
                                      ),
                                    ),
                                child: Text(
                                  'Rs ${totalPrice.toStringAsFixed(0)}',
                                  key: ValueKey(totalPrice),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => cart.clear());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order placed successfully ✅'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text('Place Order'),
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Animated cart badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCart,
              ),
              if (totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.elasticOut,
                    scale: 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          '$totalItems',
                          key: ValueKey(totalItems),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF4F4F4),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                children: [
                  for (final section in itemSections.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        top: 2,
                        bottom: 8,
                      ),
                      child: Text(
                        section.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF303030),
                        ),
                      ),
                    ),
                    for (final item in section.value)
                      // ---- Animated Card: pops when added to cart ----
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.only(bottom: 8),
                        transform: Matrix4.identity()
                          ..scale(_activeItem == item['name'] ? 1.04 : 1.0),
                        transformAlignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0EC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _activeItem == item['name']
                                ? Colors.indigo
                                : const Color(0xFFF3E4E0),
                            width: _activeItem == item['name'] ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _activeItem == item['name']
                                  ? Colors.indigo.withOpacity(0.25)
                                  : Colors.black12,
                              blurRadius: _activeItem == item['name'] ? 14 : 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              // Animated icon container
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _activeItem == item['name']
                                      ? Colors.indigo.shade50
                                      : const Color(0xFFFFE6D6),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: _activeItem == item['name']
                                      ? Colors.indigo
                                      : Colors.orange.shade900,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item['name'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Rs ${item['price']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 36,
                                child: ElevatedButton(
                                  onPressed: () => _addToCart(item['name']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: const Text('Order'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),

            // Bottom summary bar with animated slide-in
            AnimatedSlide(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              offset: totalItems > 0 ? Offset.zero : const Offset(0, 1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: totalItems > 0 ? 1.0 : 0.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.indigo,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$totalItems item${totalItems > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total: Rs ${totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo,
                        ),
                        child: const Text('View Cart'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
