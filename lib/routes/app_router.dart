/// @widget: App Router
/// @created-date: 24-12-2024
/// @leysco-version: 1.0.0
/// @description: Application routing configuration

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/password_reset_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/inventory/product_detail_screen.dart';
import '../presentation/screens/sales/order_detail_screen.dart';
import '../presentation/screens/sales/invoice_screen.dart';
import '../presentation/screens/customers/customer_detail_screen.dart';
import '../presentation/controllers/auth_controller.dart';
import '../data/models/product_model.dart';
import '../data/models/order_model.dart';
import '../data/models/customer_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/password-reset',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/order-detail',
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderDetailScreen(order: order);
        },
      ),
      GoRoute(
        path: '/invoice',
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return InvoiceScreen(order: order);
        },
      ),
      GoRoute(
        path: '/customer-detail',
        builder: (context, state) {
          final customer = state.extra as CustomerModel;
          return CustomerDetailScreen(customer: customer);
        },
      ),
    ],
  );
});
