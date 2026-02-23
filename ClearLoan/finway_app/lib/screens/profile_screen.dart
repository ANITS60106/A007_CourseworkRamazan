import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/credit_history_service.dart';
import '../services/i18n.dart';
import '../widgets/app_card.dart';
import '../widgets/lang_switcher.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.t('profile')),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LangSwitcher()),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.primary.withOpacity(0.14),
                    child: Text(
                      (user?.fullName.isNotEmpty == true) ? user!.fullName[0].toUpperCase() : 'U',
                      style: TextStyle(fontWeight: FontWeight.w900, color: cs.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Demo User',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.phone ?? '+996 ...',
                          style: TextStyle(color: Colors.black.withOpacity(0.55)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _RowField(title: I18n.t('passport_id'), value: user?.passportIdMasked ?? '—'),
                  const Divider(),
                  _RowField(title: I18n.t('workplace'), value: user?.workplace.isNotEmpty == true ? user!.workplace : '—'),
                  const Divider(),
                  _RowField(title: I18n.t('occupation'), value: user?.occupation.isNotEmpty == true ? user!.occupation : '—'),
                  const Divider(),
                  _RowField(title: I18n.t('income'), value: '${user?.monthlyIncome ?? 0} сом'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            AppCard(
              margin: EdgeInsets.zero,
              child: FutureBuilder(
                future: Future.wait([
                  CreditHistoryService.fetchSummary(),
                  CreditHistoryService.fetchEntries(),
                ]),
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final list = (snap.data?[1] as List?) ?? const [];
                  final summary = (snap.data?[0] as Map<String, dynamic>?) ?? const {};
                  final score = (summary['score'] ?? 0) as int;
                  final counts = (summary['counts'] as Map?) ?? const {};
                  final ontime = (counts['ontime'] ?? 0) as int;
                  final late = (counts['late'] ?? 0) as int;
                  final defaults = (counts['default'] ?? 0) as int;

                  if (list.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(I18n.t('credit_history'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text(
                          I18n.t('credit_history_empty'),
                          style: TextStyle(color: Colors.black.withOpacity(0.55)),
                        ),
                      ],
                    );
                  }

                  final maxCount = [ontime, late, defaults].fold<int>(1, (m, e) => e > m ? e : m);

                  Widget bar(String label, int v) => Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: TextStyle(color: Colors.black.withOpacity(0.55), fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: v / maxCount,
                                minHeight: 10,
                                backgroundColor: Colors.black.withOpacity(0.06),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  label == I18n.t('ontime')
                                      ? cs.primary
                                      : (label == I18n.t('late') ? Colors.orange : cs.error),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('$v', style: const TextStyle(fontWeight: FontWeight.w900)),
                          ],
                        ),
                      );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(I18n.t('credit_history'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              I18n.t('score_badge').replaceAll('{score}', score.toString()),
                              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          bar(I18n.t('ontime'), ontime),
                          const SizedBox(width: 10),
                          bar(I18n.t('late'), late),
                          const SizedBox(width: 10),
                          bar(I18n.t('default'), defaults),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        I18n.t('recent_records'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      ...list.take(3).map((e) {
                        final m = e as dynamic;
                        final provider = (m.providerName ?? '') as String;
                        final status = (m.status ?? 'ontime') as String;
                        final amount = (m.originalAmount ?? 0) as int;
                        final statusLabel = status == 'ontime'
                            ? I18n.t('ontime')
                            : (status == 'late' ? I18n.t('late') : I18n.t('default'));
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Icon(Icons.receipt_long, color: cs.primary),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(provider, style: const TextStyle(fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 2),
                                    Text('$amount сом • $statusLabel', style: TextStyle(color: Colors.black.withOpacity(0.55))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              icon: Icon(Icons.logout, color: cs.error),
              label: Text(I18n.t('logout')),
              onPressed: () {
                AuthService.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RowField extends StatelessWidget {
  final String title;
  final String value;

  const _RowField({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.black.withOpacity(0.55), fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
