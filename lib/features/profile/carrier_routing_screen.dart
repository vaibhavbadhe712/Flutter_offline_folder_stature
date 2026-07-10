import 'package:enterprise_app/features/widgets/carrier_routing_shared.dart';
import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';

class CarrierRoutingScreen extends StatefulWidget {
  final List<Carrier> initialCarriers;
  final void Function(List<Carrier> updatedOrder)? onOrderChanged;
  final void Function(Carrier carrier, bool enabled)? onToggle;

  const CarrierRoutingScreen({
    super.key,
    this.initialCarriers = _demoCarriers,
    this.onOrderChanged,
    this.onToggle,
  });

  static const _demoCarriers = <Carrier>[
    Carrier(name: 'Jio Voice API', pricePerMin: 0.32, enabled: true),
    Carrier(name: 'Airtel IQ', pricePerMin: 0.38, enabled: true),
    Carrier(name: 'Vodafone Idea Cloud', pricePerMin: 0.41, enabled: false),
    Carrier(name: 'Twilio Global', pricePerMin: 0.62, enabled: true),
  ];

  @override
  State<CarrierRoutingScreen> createState() => _CarrierRoutingScreenState();
}

class _CarrierRoutingScreenState extends State<CarrierRoutingScreen> {
  late List<Carrier> _carriers;

  @override
  void initState() {
    super.initState();
    _carriers = List.of(widget.initialCarriers);
  }

  void _toggleCarrier(int index, bool value) {
    setState(() {
      _carriers[index] = _carriers[index].copyWith(enabled: value);
    });
    widget.onToggle?.call(_carriers[index], value);
  }

  void _moveUp(int index) {
    if (index == 0) return;
    setState(() {
      final item = _carriers.removeAt(index);
      _carriers.insert(index - 1, item);
    });
    widget.onOrderChanged?.call(_carriers);
  }

  void _moveDown(int index) {
    if (index == _carriers.length - 1) return;
    setState(() {
      final item = _carriers.removeAt(index);
      _carriers.insert(index + 1, item);
    });
    widget.onOrderChanged?.call(_carriers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.darkText, size: 26),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Carrier Routing',
          style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Calls route in priority order \u2014 reorder to change fallback preference.',
                style: TextStyle(fontSize: 13, color: AppColors.primaryBlue, height: 1.4),
              ),
            ),
            for (int i = 0; i < _carriers.length; i++)
              CarrierRow(
                priority: i + 1,
                carrier: _carriers[i],
                onToggle: (v) => _toggleCarrier(i, v),
                onMoveUp: i == 0 ? null : () => _moveUp(i),
                onMoveDown: i == _carriers.length - 1 ? null : () => _moveDown(i),
              ),
          ],
        ),
      ),
    );
  }
}