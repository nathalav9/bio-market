import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIndex(BuildContext context) {
  final GoRouter router = GoRouter.of(context);
  final String location = router.routerDelegate.currentConfiguration.fullPath; 
  
  switch (location) {
    case '/products':
      return 0;
    case '/create-product':
      return 1;
    case '/cart':
      return 2;
    case '/promotions':
      return 3;
    default:
      return 0;
  }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/products');
        break;
      case 1:
        context.go('/create-product');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/promotions');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Productos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create),
          label: 'Crear Producto',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Carrito',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Promociones',
        ),
      ],
    );
  }
}
