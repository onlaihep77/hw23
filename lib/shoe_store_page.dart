import 'package:flutter/material.dart';

class Shoe {
  final String id;
  final String name;
  final double price;
  final String image; 
  const Shoe({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

class CartItem {
  final Shoe shoe;
  int quantity;
  CartItem({required this.shoe, this.quantity = 1});
  double get lineTotal => shoe.price * quantity;
}


const _shoes = <Shoe>[
  Shoe(
    id: 'airmax1',
    name: 'Nike Air Max',
    price: 120,
    image: 'assets/images/airmax1.jpg',
  ),
  Shoe(
    id: 'ultra',
    name: 'Adidas Ultraboost',
    price: 150,
    image: 'assets/images/ultra.jpg',
  ),
  Shoe(
    id: 'airmax2',
    name: 'Nike Air Max 2',
    price: 120,
    image: 'assets/images/airmax2.jpg',
  ),
  Shoe(
    id: 'airmax4',
    name: 'Nike Air Max 4',
    price: 120,
    image: 'assets/images/airmax4.jpg',
  ),
  Shoe(
    id: 'puma',
    name: 'Puma RS',
    price: 100,
    image: 'assets/images/puma.jpg',
  ),
];

class ShoeStorePage extends StatefulWidget {
  const ShoeStorePage({super.key});
  @override
  State<ShoeStorePage> createState() => _ShoeStorePageState();
}

class _ShoeStorePageState extends State<ShoeStorePage> {
  final List<CartItem> _cart = [];

  void _addToCart(Shoe s) {
    setState(() {
      final idx = _cart.indexWhere((c) => c.shoe.id == s.id);
      if (idx == -1) {
        _cart.add(CartItem(shoe: s));
      } else {
        _cart[idx].quantity++;
      }
    });
  }

  void _removeItem(String shoeId) =>
      setState(() => _cart.removeWhere((c) => c.shoe.id == shoeId));

  void _changeQty(String shoeId, int delta) {
    setState(() {
      final item = _cart.firstWhere((c) => c.shoe.id == shoeId);
      item.quantity += delta;
      if (item.quantity <= 0) _cart.remove(item);
    });
  }

  double get _total => _cart.fold(0.0, (sum, c) => sum + c.lineTotal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoe Store')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text('Giỏ hàng', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (_cart.isEmpty)
            _emptyCartCard()
          else
            ..._cart.map(
              (e) => _CartItemTile(
                item: e,
                onDelete: () => _removeItem(e.shoe.id),
                onInc: () => _changeQty(e.shoe.id, 1),
                onDec: () => _changeQty(e.shoe.id, -1),
              ),
            ),
          const SizedBox(height: 10),
          _totalRow(_total),
          const SizedBox(height: 16),
          Text('Danh sách giày', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.80,
            ),
            itemCount: _shoes.length,
            itemBuilder:
                (_, i) => _ProductCard(shoe: _shoes[i], onAdd: _addToCart),
          ),
        ],
      ),
    );
  }

  Widget _totalRow(double total) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tổng tiền:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
          '${total.toStringAsFixed(2)} \$',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );

  Widget _emptyCartCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: const Row(
      children: [
        Icon(Icons.shopping_cart_outlined),
        SizedBox(width: 8),
        Text('Chưa có sản phẩm'),
      ],
    ),
  );
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete, onInc, onDec;
  const _CartItemTile({
    required this.item,
    required this.onDelete,
    required this.onInc,
    required this.onDec,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.shoe.image,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.shoe.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giá: ${item.shoe.price.toStringAsFixed(1)} \$',
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('Số lượng: '),
                      IconButton(
                        onPressed: onDec,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: onInc,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Shoe shoe;
  final void Function(Shoe) onAdd;
  const _ProductCard({required this.shoe, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              shoe.image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shoe.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${shoe.price.toStringAsFixed(1)} \$',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => onAdd(shoe),
                    child: const Text('Thêm vào giỏ'),
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
