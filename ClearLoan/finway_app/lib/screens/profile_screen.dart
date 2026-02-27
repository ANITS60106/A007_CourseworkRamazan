import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../services/i18n.dart';
import '../services/pin_service.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _summary;
  List<dynamic> _entries = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    try {
      final summary = await ApiClient.get('/api/loans/credit-history/summary/');
      final entries = await ApiClient.get('/api/loans/credit-history/');
      if (!mounted) return;
      setState(() {
        _summary = summary as Map<String, dynamic>;
        _entries = (entries as List);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    await PinService.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(I18n.t('profile'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.fullName ?? '-', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 6),
                Text('${I18n.t('phone')}: ${user?.phone ?? '-'}', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${I18n.t('passport_id')}: ${user?.passportIdMasked ?? '-'}', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${I18n.t('occupation')}: ${user?.occupation ?? '-'}', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${I18n.t('monthly_income')}: ${user?.monthlyIncome ?? 0}', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600)),
                if ((user?.userType ?? 'individual') == 'legal') ...[
                  const SizedBox(height: 8),
                  Text('${I18n.t('company_name')}: ${user?.companyName ?? '-'}', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w700)),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text(I18n.t('credit_history'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))),
              if (!_loading)
                IconButton(
                  onPressed: _loadHistory,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (_loading) const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator())),
          if (!_loading && _entries.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
              ),
              child: Text(I18n.t('no_history'), style: const TextStyle(fontWeight: FontWeight.w800)),
            ),

          if (_summary != null && _entries.isNotEmpty) ...[
            _ScoreCard(summary: _summary!),
            const SizedBox(height: 10),
            ..._entries.take(6).map((e) => _HistoryItem(entry: e)),
          ],

          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: Text(I18n.t('logout')),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final Map<String, dynamic> summary;
  const _ScoreCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final score = (summary['score'] ?? 0).toString();
    final counts = (summary['counts'] ?? {}) as Map<String, dynamic>;

    int ontime = (counts['ontime'] ?? 0) as int;
    int late = (counts['late'] ?? 0) as int;
    int def = (counts['default'] ?? 0) as int;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stacked_line_chart, color: cs.primary),
              const SizedBox(width: 10),
              Text('${I18n.t('score')}: $score', style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _pill(context, 'On-time', ontime, cs.primary),
              const SizedBox(width: 8),
              _pill(context, 'Late', late, Colors.orange),
              const SizedBox(width: 8),
              _pill(context, 'Default', def, cs.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, int value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$value', style: TextStyle(fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75), fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final dynamic entry;
  const _HistoryItem({required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = (entry['provider_name'] ?? '-') as String;
    final status = (entry['status'] ?? '-') as String;
    final amt = (entry['original_amount'] ?? 0).toString();
    final late = (entry['late_payments'] ?? 0).toString();

    Color color() => switch (status) {
          'ontime' => cs.primary,
          'late' => Colors.orange,
          _ => cs.error,
        };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color().withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.receipt_long, color: color()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$amt KGS • late: $late', style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
          Text(status.toUpperCase(), style: TextStyle(color: color(), fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
