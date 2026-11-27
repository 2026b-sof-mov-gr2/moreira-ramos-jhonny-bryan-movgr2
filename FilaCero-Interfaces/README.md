# FilaCero — Interfaces (Flutter)

Pide en el comedor sin hacer fila. Solo interfaces (sin backend); los datos son de ejemplo (`lib/data/mock_data.dart`).

## Cómo correrlo
1. Abrir esta carpeta (`fila_cero`) en Android Studio con el plugin de Flutter.
2. `flutter pub get`
3. Elegir un emulador o celular y presionar ▶ Run (`flutter run`).

## Flujo de pantallas
Splash → Onboarding (3) → Login ⇄ Registro → Verificar código → Inicio
Login → Recuperar contraseña

Inicio (menú inferior: Inicio · Pedidos · Perfil)
- Inicio: Menú del día → Detalle del plato → Mi pedido (carrito) → Pago → Pedido confirmado → Tu pedido (QR) → Calificar
- Pedidos: activos / historial
- Perfil → Editar perfil, Notificaciones, Cerrar sesión

## Estructura
```
lib/
  main.dart            App + tema
  routes.dart          Rutas con nombre
  theme/app_theme.dart Colores del prototipo
  data/mock_data.dart  Platos y pedidos de ejemplo
  widgets/common.dart  DishCard, LabeledField, QuantitySelector...
  screens/
    splash_screen.dart, onboarding_screen.dart, notifications_screen.dart, main_shell.dart
    auth/   login, register, verify_code, forgot_password
    menu/   home (Pantalla 1), dish_detail
    order/  cart, payment, order_success, order_tracking (Pantalla 2), rate_order, orders_history
    profile/ profile, edit_profile
```
