import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/system_design/tc_radio_picker.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({
    super.key,
    required this.locale,
    required this.email,
    required this.onLocaleChanged,
    this.onSignOut,
  });

  final Locale locale;
  final String email;
  final ValueChanged<Locale> onLocaleChanged;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(strings.accountSettings)),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            minWidth: 300,
            maxHeight: 600,
            minHeight: 200,
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                strings.accountSettings,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                strings.languageToggle,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              TcRadioPicker<Locale>(
                value: locale,
                onChanged: onLocaleChanged,
                items: [
                  (const Locale('pl'), strings.languagePolish),
                  (const Locale('en'), strings.languageEnglish),
                ],
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  strings.signOut,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  //await context.read<SessionCubit>().signOut();
                  if (onSignOut != null) {
                    onSignOut!();
                  }
                  if (context.mounted) {
                    Navigator.of(context).maybePop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
