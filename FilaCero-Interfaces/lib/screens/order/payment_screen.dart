import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

/// Pago en la app (solo interfaz; no procesa pagos reales).
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _method = 0;

  static const _methods = [
    (icon: Icons.account_balance_wallet_rounded, title: 'Saldo FilaCero', sub: 'Disponible: \$12.50'),
    (icon: Icons.credit_card_rounded, title: 'Tarjeta de débito/crédito', sub: 'Visa •••• 4417'),
    (icon: Icons.phone_iphone_rounded, title: 'DeUna / transferencia', sub: 'Pago con QR del banco'),
    (icon: Icons.payments_outlined, title: 'Efectivo en ventanilla', sub: 'Pagas al retirar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle('Método de pago'),
          ...List.generate(_methods.length, (i) {
            final m = _methods[i];
            final selected = i == _method;
            return GestureDetector(
              onTap: () => setState(() => _method = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          selected ? AppColors.primary : AppColors.background,
                      child: Icon(m.icon,
                          color: selected ? Colors.white : AppColors.dark),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15)),
                          Text(m.sub,
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_off_rounded,
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          const SectionTitle('Cupón'),
          Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Código de descuento',
                    prefixIcon: Icon(Icons.local_offer_outlined,
                        color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(90, 56)),
                  onPressed: () {},
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const SummaryRow(label: 'Almuerzo del día x1', value: '\$2.50'),
                const SummaryRow(label: 'Jugo natural x2', value: '\$1.50'),
                const SummaryRow(label: 'Servicio', value: '\$0.25'),
                const Divider(height: 24),
                SummaryRow(label: 'Total a pagar', value: money(4.25), bold: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.success,
              (r) => r.settings.name == AppRoutes.home,
            ),
            icon: const Icon(Icons.lock_rounded, size: 20),
            label: const Text('Pagar \$4.25'),
          ),
        ),
      ),
    );
  }
}
