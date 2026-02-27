import 'package:flutter/material.dart';
import '../services/options_service.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';
import '../services/options_service.dart' show BankOption;

class LoanConfirmScreen extends StatefulWidget {
  final BankOption option;
  final int amount;
  final int months;
  final String purpose;

  const LoanConfirmScreen({
    super.key,
    required this.option,
    required this.amount,
    required this.months,
    required this.purpose,
  });

  @override
  State<LoanConfirmScreen> createState() => _LoanConfirmScreenState();
}

class _LoanConfirmScreenState extends State<LoanConfirmScreen> {
  bool _loading = false;
  Map<String, dynamic>? _result;

  String _bankName() {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return widget.option.bankNameRu;
    if (lang == 'ky') return widget.option.bankNameKy;
    return widget.option.bankNameEn;
  }

  String _productTitle() {
    final lang = AppSettings.language.value;
    if (lang == 'ru') return widget.option.productTitleRu;
    if (lang == 'ky') return widget.option.productTitleKy;
    return widget.option.productTitleEn;
  }

  Future<void> _apply() async {
    setState(() => _loading = true);
    try {
      final res = await OptionsService.apply(
        productId: widget.option.productId,
        amount: widget.amount,
        months: widget.months,
      );
      if (!mounted) return;
      setState(() {
        _result = res;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to apply. Check backend/auth token.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(I18n.t('confirm'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_bankName(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 6),
                Text(_productTitle(), style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w700)),
                const Divider(height: 22),
                _row(I18n.t('loan_amount'), '${widget.amount} KGS'),
                _row(I18n.t('loan_term'), '${widget.months}'),
                _row(I18n.t('monthly_payment'), '${widget.option.estimatedPayment} KGS'),
                _row(I18n.t('approval_probability'), '${(widget.option.approvalProbability * 100).toStringAsFixed(0)}%'),
                if (widget.purpose.isNotEmpty) _row(I18n.t('purpose'), widget.purpose),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _loading ? null : _apply,
            child: _loading
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(I18n.t('apply')),
          ),
          if (_result != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.primary.withOpacity(0.22)),
              ),
              child: Text(
                'Result: ${_result!['decision_status']}  •  id=${_result!['id']}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(k, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65), fontWeight: FontWeight.w700))),
          const SizedBox(width: 10),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
