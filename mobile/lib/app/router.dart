import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/catalog/presentation/catalog_screen.dart';
import '../features/catalog/presentation/product_details_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/checkout/presentation/map_address_picker.dart';
import '../features/checkout/presentation/order_success_screen.dart';
import '../features/dealer/presentation/dealer_portal_screen.dart';
import '../features/dealer/presentation/dealer_register_screen.dart';
import '../features/orders/models/order_model.dart';
import '../features/orders/presentation/order_details_screen.dart';
import '../features/orders/presentation/orders_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/saved_addresses_screen.dart';
import '../features/services/presentation/book_service_screen.dart';
import '../features/services/presentation/services_screen.dart';
import '../core/constants.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/catalog',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/catalog',
          pageBuilder: (context, state) => const NoTransitionPage(child: CatalogScreen()),
        ),
        GoRoute(
          path: '/orders',
          pageBuilder: (context, state) => const NoTransitionPage(child: OrdersScreen()),
        ),
        GoRoute(
          path: '/services',
          pageBuilder: (context, state) => const NoTransitionPage(child: ServicesScreen()),
        ),
        GoRoute(
          path: '/dealer-portal',
          pageBuilder: (context, state) => const NoTransitionPage(child: DealerPortalScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/order-success',
      builder: (context, state) {
        final order = state.extra as OrderModel;
        return OrderSuccessScreen(order: order);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/order-details',
      builder: (context, state) {
        final order = state.extra as OrderModel;
        return OrderDetailsScreen(order: order);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/book-service',
      builder: (context, state) {
        final model = state.extra as String?;
        return BookServiceScreen(initialPurifierModel: model);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/dealer-register',
      builder: (context, state) => const DealerRegisterScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/saved-addresses',
      builder: (context, state) => const SavedAddressesScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/map-picker',
      builder: (context, state) {
        final initialPos = state.extra as LatLng? ?? const LatLng(12.9716, 77.5946);
        return MapAddressPickerScreen(initialPosition: initialPos);
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/orders')) return 1;
    if (location.startsWith('/services')) return 2;
    if (location.startsWith('/dealer-portal')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // /catalog
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/catalog');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.go('/services');
        break;
      case 3:
        context.go('/dealer-portal');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int idx) => _onItemTapped(idx, context),
        selectedItemColor: AppColors.accentTeal,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop_outlined),
            activeIcon: Icon(Icons.water_drop),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            activeIcon: Icon(Icons.handyman),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Wholesale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
