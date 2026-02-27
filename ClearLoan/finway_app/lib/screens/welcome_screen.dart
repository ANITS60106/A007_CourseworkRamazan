import 'package:flutter/material.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _HeroCard(cs: cs),
              const SizedBox(height: 16),
              _RolePicker(cs: cs),
              const SizedBox(height: 14),
              _ThemePicker(cs: cs),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Text(I18n.t('start')),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '${I18n.t('sponsored_by')}: Айыл Банк',
                  style: TextStyle(color: cs.onBackground.withOpacity(0.55), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final ColorScheme cs;
  const _HeroCard({required this.cs});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.18),
            cs.primary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.primary.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.stacked_line_chart, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  I18n.t('welcome_title'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            I18n.t('welcome_sub'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onBackground.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _RolePicker extends StatelessWidget {
  final ColorScheme cs;
  const _RolePicker({required this.cs});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppSettings.userType,
      builder: (_, value, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(I18n.t('choose_role'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _pill(
                    context,
                    active: value == 'individual',
                    label: I18n.t('individual'),
                    icon: Icons.person,
                    onTap: () => AppSettings.setUserType('individual'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _pill(
                    context,
                    active: value == 'legal',
                    label: I18n.t('legal_entity'),
                    icon: Icons.apartment,
                    onTap: () => AppSettings.setUserType('legal'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _pill(BuildContext context,
      {required bool active, required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.14) : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? cs.primary.withOpacity(0.4) : cs.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? cs.primary : cs.onSurface.withOpacity(0.55)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w800, color: active ? cs.primary : cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  final ColorScheme cs;
  const _ThemePicker({required this.cs});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettings.themeMode,
      builder: (_, mode, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(I18n.t('choose_theme'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _pill(
                    context,
                    active: mode == ThemeMode.light,
                    label: I18n.t('light'),
                    icon: Icons.light_mode,
                    onTap: () => AppSettings.setThemeMode(ThemeMode.light),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _pill(
                    context,
                    active: mode == ThemeMode.dark,
                    label: I18n.t('dark'),
                    icon: Icons.dark_mode,
                    onTap: () => AppSettings.setThemeMode(ThemeMode.dark),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _pill(BuildContext context,
      {required bool active, required String label, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: active ? cs.primary.withOpacity(0.14) : cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? cs.primary.withOpacity(0.4) : cs.outlineVariant.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? cs.primary : cs.onSurface.withOpacity(0.55)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w800, color: active ? cs.primary : cs.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
