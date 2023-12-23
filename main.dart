import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Item {
  final String itemName;
  final double price;

  Item(this.itemName, this.price);
}

enum Page { START, VEGETABLE, FRUIT, BILL }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingCart(),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  Page currentPage = Page.START;
  List<Item> cartItems = [];

  List<Item> startItems = [];

  List<Item> vegetableItems = [
    Item("Carrot", 5.0),
    Item("Broccoli", 8.0),
    Item("Spinach", 4.0),
    Item("Bell Pepper", 3.0),
    // Add more vegetable items as needed
  ];

  List<Item> fruitItems = [
    Item("Apple", 2.0),
    Item("Banana", 1.5),
    Item("Orange", 3.0),
    Item("Grapes", 4.0),
    // Add more fruit items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
      ),
      body: _buildPage(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  String _getPageTitle() {
    switch (currentPage) {
      case Page.START:
        return 'Start Shopping';
      case Page.VEGETABLE:
        return 'Vegetables';
      case Page.FRUIT:
        return 'Fruits';
      case Page.BILL:
        return 'Bill';
    }
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        if (currentPage == Page.BILL) {
          _resetCart();
        }
        if (currentPage != Page.START) {
          _navigateToPreviousPage();
        }
      },
      child: Icon(Icons.arrow_back),
    );
  }

  ElevatedButton _buildNextButton() {
    return ElevatedButton(
      onPressed: () => _navigateToNextPage(),
      child: Text('Next'),
    );
  }

  Widget _buildPage() {
    switch (currentPage) {
      case Page.START:
        return Center(
          child: ElevatedButton(
            onPressed: () => _navigateToNextPage(),
            child: Text('Start Shopping'),
          ),
        );
      case Page.VEGETABLE:
        return _buildItemList(vegetableItems);
      case Page.FRUIT:
        return _buildItemList(fruitItems);
      case Page.BILL:
        return _buildBill();
    }
  }

  Widget _buildItemList(List<Item> items) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].itemName),
                subtitle: Text('\$${items[index].price.toStringAsFixed(2)}'),
                onTap: () => _addToCart(items[index]),
              );
            },
          ),
        ),
        _buildNextButton(),
      ],
    );
  }

  Widget _buildBill() {
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Items Bought:'),
        for (var item in cartItems)
          ListTile(
            title: Text(item.itemName),
            subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
          ),
        SizedBox(height: 16.0),
        Text('Total: \$${total.toStringAsFixed(2)}'),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            _resetCart();
            _navigateToNextPage();
          },
          child: Text('Submit'),
        ),
      ],
    );
  }

  void _navigateToNextPage() {
    setState(() {
      switch (currentPage) {
        case Page.START:
          currentPage = Page.VEGETABLE;
          break;
        case Page.VEGETABLE:
          currentPage = Page.FRUIT;
          break;
        case Page.FRUIT:
          currentPage = Page.BILL;
          break;
        case Page.BILL:
          _resetCart();
          currentPage = Page.START;
          break;
      }
    });
  }

  void _navigateToPreviousPage() {
    setState(() {
      switch (currentPage) {
        case Page.VEGETABLE:
          currentPage = Page.START;
          break;
        case Page.FRUIT:
          currentPage = Page.VEGETABLE;
          break;
        case Page.BILL:
          currentPage = Page.FRUIT;
          break;
        default:
          currentPage = Page.START;
          break; // Handle the case when currentPage is Page.START
      }
    });
  }

  void _resetCart() {
    setState(() {
      cartItems.clear();
    });
  }

  void _addToCart(Item item) {
    setState(() {
      cartItems.add(item);
    });
  }
}
