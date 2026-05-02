import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

const String appVersion = '1.0.0';
const String appName = '2048 Game';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          if (!settings.initialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ===== AUDIO SECTION =====
                _SectionTitle('🔊 Audio'),
                _ToggleSetting(
                  icon: Icons.volume_up,
                  title: 'Sons de Mouvement',
                  value: settings.soundEnabled,
                  onChanged: (value) {
                    settings.setSoundEnabled(value);
                  },
                ),
                const SizedBox(height: 12),
                _ToggleSetting(
                  icon: Icons.music_note,
                  title: 'Musique de Fond',
                  value: settings.musicEnabled,
                  onChanged: (value) {
                    settings.setMusicEnabled(value);
                  },
                ),
                const SizedBox(height: 12),
                _ToggleSetting(
                  icon: Icons.merge,
                  title: 'Son de Fusion',
                  value: settings.mergeSoundEnabled,
                  onChanged: (value) {
                    settings.setMergeSoundEnabled(value);
                  },
                ),

                const SizedBox(height: 24),

                // ===== GAMEPLAY SECTION =====
                _SectionTitle('🎮 Gameplay'),
                _SettingCard(
                  title: 'Vitesse d\'Animation',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SpeedButton(
                        label: 'Lent',
                        isSelected: settings.animationSpeed == 0,
                        onTap: () => settings.setAnimationSpeed(0),
                      ),
                      _SpeedButton(
                        label: 'Normal',
                        isSelected: settings.animationSpeed == 1,
                        onTap: () => settings.setAnimationSpeed(1),
                      ),
                      _SpeedButton(
                        label: 'Rapide',
                        isSelected: settings.animationSpeed == 2,
                        onTap: () => settings.setAnimationSpeed(2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ===== ABOUT & FEEDBACK SECTION =====
                _SectionTitle('ℹ️ À Propos'),
                _SettingCard(
                  title: 'Version',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('$appName'),
                      Text(
                        appVersion,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.star,
                  label: 'Noter l\'app',
                  onTap: () {
                    _openUrl('https://play.google.com/store/apps/details?id=com.benjaminaubry.mergestorm2048');
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.email,
                  label: 'Envoyer des Commentaires',
                  onTap: () {
                    _openUrl('mailto:support@example.com');
                  },
                ),
                const SizedBox(height: 12),
                _SettingCard(
                  title: 'Crédits',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Développé avec Flutter'),
                      SizedBox(height: 8),
                      Text('Icons: Material Design'),
                      SizedBox(height: 8),
                      Text('© 2024 - 2025'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ) ??
                const TextStyle(),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSetting({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.amber.shade400,
          ),
        ],
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SpeedButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber.shade400 : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.amber.shade600 : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

