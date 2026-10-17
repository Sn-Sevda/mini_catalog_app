import 'package:flutter/material.dart';
import '../models/product.dart';

// Sepetteki bir ürün ve adedini tutan model
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(Product) onIncrement;
  final Function(Product) onDecrement;
  final Function(Product) onRemoveItem;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemoveItem,
    required this.onClearCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Ara Toplam
  double get _subtotal {
    return widget.cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // 100$ üzeri kargo bedava, altı 5$
  double get _shippingCost {
    if (_subtotal == 0 || _subtotal >= 100.0) {
      return 0.0;
    }
    return 5.00;
  }

  // %10 Hoş Geldin Barista İndirimi
  double get _discount {
    if (_subtotal == 0) return 0.0;
    return _subtotal * 0.10;
  }

  // Ödenecek Net Tutar
  double get _finalTotal {
    if (_subtotal == 0) return 0.0;
    return _subtotal - _discount + _shippingCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D231E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sepetim',
          style: TextStyle(
            color: Color(0xFF2D231E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (widget.cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              onPressed: () {
                setState(() {
                  widget.onClearCart();
                });
              },
            ),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7A17A).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Color(0xFF8B5A2B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sepetiniz Boş',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D231E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Henüz kahve ekipmanı eklemediniz.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF8C7E75)),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                final product = cartItem.product;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5A3E2B).withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.coffee, size: 30, color: Color(0xFFC7A17A)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF2D231E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8C7E75),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF8B5A2B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16, color: Color(0xFF2D231E)),
                              onPressed: () {
                                setState(() {
                                  widget.onDecrement(product);
                                });
                              },
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF2D231E),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16, color: Color(0xFF2D231E)),
                              onPressed: () {
                                setState(() {
                                  widget.onIncrement(product);
                                });
                              },
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      // Genişletilmiş Sipariş Özeti Kartı
      bottomNavigationBar: widget.cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ara Toplam
                    _buildSummaryRow(
                      'Ara Toplam',
                      '\$${_subtotal.toStringAsFixed(2)}',
                      isBold: false,
                    ),
                    const SizedBox(height: 6),
                    // İndirim
                    _buildSummaryRow(
                      'Barista İndirimi (%10)',
                      '-\$${_discount.toStringAsFixed(2)}',
                      textColor: Colors.green.shade700,
                    ),
                    const SizedBox(height: 6),
                    // Kargo
                    _buildSummaryRow(
                      'Kargo',
                      _shippingCost == 0 ? 'ÜCRETSİZ' : '\$${_shippingCost.toStringAsFixed(2)}',
                      textColor: _shippingCost == 0 ? Colors.green.shade700 : const Color(0xFF2D231E),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(thickness: 1, color: Color(0xFFEDE8E3)),
                    ),
                    // Net Toplam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ödenecek Tutar:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D231E),
                          ),
                        ),
                        Text(
                          '\$${_finalTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF8B5A2B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Satın Al Butonu
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D231E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Siparişiniz başarıyla alındı! Afiyet olsun.'),
                              backgroundColor: Color(0xFF5A3E2B),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Siparişi Tamamla (Checkout)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Sipariş satırı yardımcı bileşeni
  Widget _buildSummaryRow(String title, String value,
      {bool isBold = false, Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF8C7E75),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: textColor ?? const Color(0xFF2D231E),
          ),
        ),
      ],
    );
  }
}