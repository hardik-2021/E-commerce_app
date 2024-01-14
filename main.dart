// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'product_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        home: LaunchScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 119, 112, 111),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
    );
  }
}

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
        ],
      ),
      body: ProductList(),
    );
  }
}

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(image: 'assets/airpods.jpg', name: 'Airpods', price: 19999),
      Product(
          image: 'assets/bag.jpg',
          name: 'American Tourister bckpack(Blue)',
          price: 1299),
      Product(image: 'assets/chair.jpg', name: 'Gaming Chair', price: 19999),
      Product(
          image: 'assets/extension.jpg',
          name: 'Syska Extension Board',
          price: 499),
      Product(
          image: 'assets/facewash.jpg',
          name: 'Garnier Men Facewash',
          price: 199),
      Product(
          image: 'assets/goggles.jpg', name: 'Sunglasses (Black)', price: 1199),
      Product(
          image: 'assets/hometheatre.jpg',
          name: 'Bose Home-Theatre',
          price: 19590),
      Product(
          image: 'assets/macbook.jpg',
          name:
              'Apple 2023 MacBook Air Laptop with M2 chip: 38.91 cm (15.3 inch)',
          price: 154900),
      Product(
          image: 'assets/r10.jpg',
          name: 'Canon EOS R10 24.2MP Mirrorless Digital Camera',
          price: 81399),
      Product(
          image: 'assets/rolex.jpg', name: 'Rolex Daytona', price: 11524300),
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                'Try our new products!',
                style: TextStyle(
                  color: Color.fromARGB(255, 252, 250, 250),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        product.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('\₹${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: product.addedToCart
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        CartProvider cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        if (product.addedToCart) {
                          cartProvider.removeFromCart(product);
                        } else {
                          cartProvider.addToCart(product);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    List<Product> cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          Product product = cartItems[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Image.asset(
                product.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('\₹${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(Icons.remove_shopping_cart),
                onPressed: () {
                  cartProvider.removeFromCart(product);
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Total Price: \₹${cartProvider.totalCartPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 243, 227, 239),
              ),
              child: Text(
                'BUY',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
