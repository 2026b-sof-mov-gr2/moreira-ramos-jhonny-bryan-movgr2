import 'package:flutter/material.dart';

import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/verify_code_screen.dart';
import 'screens/main_shell.dart';
import 'screens/menu/dish_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/order/cart_screen.dart';
import 'screens/order/order_success_screen.dart';
import 'screens/order/order_tracking_screen.dart';
import 'screens/order/payment_screen.dart';
import 'screens/order/rate_order_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/splash_screen.dart';

/// Rutas con nombre de todas las pantallas de FilaCero.
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/registro';
  static const verify = '/verificar';
  static const forgot = '/recuperar';
  static const home = '/inicio';
  static const dishDetail = '/plato';
  static const cart = '/carrito';
  static const payment = '/pago';
  static const success = '/pedido-confirmado';
  static const tracking = '/seguimiento';
  static const rate = '/calificar';
  static const notifications = '/notificaciones';
  static const editProfile = '/editar-perfil';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        onboarding: (_) => const OnboardingScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        verify: (_) => const VerifyCodeScreen(),
        forgot: (_) => const ForgotPasswordScreen(),
        home: (_) => const MainShell(),
        dishDetail: (_) => const DishDetailScreen(),
        cart: (_) => const CartScreen(),
        payment: (_) => const PaymentScreen(),
        success: (_) => const OrderSuccessScreen(),
        tracking: (_) => const OrderTrackingScreen(),
        rate: (_) => const RateOrderScreen(),
        notifications: (_) => const NotificationsScreen(),
        editProfile: (_) => const EditProfileScreen(),
      };
}
