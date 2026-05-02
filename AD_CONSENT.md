# Ad Consent Implementation - RGPD & CCPA Compliance

> Document expliquant l'implémentation du consentement publicitaire pour Mergestorm 2048

**Package:** com.benjaminaubry.mergestorm2048  
**Ads SDK:** google_mobile_ads 5.2.0 avec Google UMP (User Messaging Platform)

---

## 🌍 Pourquoi le Consentement?

Depuis 2021-2022, les régulations suivantes exigent un consentement explicite avant de collecter des données publicitaires:

| Région | Loi | Année | Exigence |
|--------|-----|------|----------|
| 🇪🇺 Union Européenne | RGPD | 2018 | Consentement explicite pour pubs personnalisées |
| 🇬🇧 Royaume-Uni | UK GDPR | 2021 | Consentement explicite pour pubs personnalisées |
| 🇨🇦 Californie | CCPA | 2020 | Opt-out pour publicités ciblées |
| 🇬🇧 Royaume-Uni | PECR | 2021 | Consentement pour tracking électronique |
| 🇳🇴 Norvège/Suisse | LGPD | 2024 | Consentement pour données de localisation |

**Conséquence:** Google Play Store **rejette les apps** qui ne respectent pas ces régulations.

---

## ✅ Implémentation Actuelle

### Google UMP (User Messaging Platform)

L'implémentation utilise le **User Messaging Platform SDK** de Google inclus dans `google_mobile_ads 5.2.0+`.

**Fonctionnement:**
1. **Détection automatique:** UMP détecte la localisation de l'utilisateur via l'adresse IP
2. **Affichage conditionnel:** Affiche un banneau de consentement SEULEMENT si l'utilisateur est en UE, UK, Californie, ou autres régions concernées
3. **Enregistrement:** Enregistre le choix de l'utilisateur (consentement, refus, ou non défini)
4. **Configuration automatique:** Envoie les informations de consentement à Google AdMob

### Code Implémenté

**Fichier:** `lib/services/ad_manager.dart`

```dart
/// Initialise le consentement RGPD/CCPA via Google UMP
static Future<void> _initializeConsent() async {
  if (_consentInfoInitialized) return;

  try {
    // Mettre à jour les informations de consentement
    final consentInfo = ConsentInfo.instance;
    await consentInfo.requestConsentInfoUpdate();

    // Afficher le formulaire de consentement si nécessaire
    if (await consentInfo.isConsentFormAvailable()) {
      await consentInfo.showConsentForm();
    }

    _consentInfoInitialized = true;
  } catch (e) {
    print('⚠️ Error initializing consent: $e');
    _consentInfoInitialized = true; // Continue quand même
  }
}

static Future<void> preloadAds() async {
  if (_isTestAdIds) return;
  
  // Initialiser le consentement en premier
  await _initializeConsent();
  
  await Future.wait([
    loadInterstitialAd(),
    loadRewardedAd(),
  ]);
}
```

---

## 🌐 Régions Affectées par UMP

Le SDK UMP affiche un formulaire de consentement pour:

### 🟢 Régions avec UMP Automatique

| Région | Loi | Impact |
|--------|-----|--------|
| 🇪🇺 UE | RGPD | Demande consentement **avant** toute pub personnalisée |
| 🇬🇧 Royaume-Uni | UK GDPR | Demande consentement **avant** toute pub personnalisée |
| 🇪🇪 EEE (Islande, Liechtenstein, Norvège) | RGPD | Demande consentement **avant** toute pub personnalisée |
| 🇨🇦 Californie | CCPA | Offre option "Refuser le ciblage" ("Opt-out") |
| 🇦🇺 Australie | ACL | Pubs non-ciblées prioritaires |
| 🇧🇷 Brésil | LGPD | Consentement pour tracking |

### 🟠 Régions Sans UMP Automatique (Pas de Popup)

| Région | Status |
|--------|--------|
| 🇺🇸 États-Unis (autres états) | Pubs personnalisées autorisées |
| 🇨🇦 Canada (autres provinces) | Pubs personnalisées autorisées |
| 🇯🇵 Japon | Pubs personnalisées autorisées |
| 🇮🇳 Inde | Pubs personnalisées autorisées |
| 🇧🇷 Brésil (hors LGPD) | Pubs personnalisées autorisées |
| 🌍 Reste du monde | Pubs personnalisées autorisées |

---

## 📋 Workflow de Consentement

```
Utilisateur lance l'app
    ↓
AdManager.preloadAds() appelé
    ↓
ConsentInfo.requestConsentInfoUpdate()
    ↓
    ├─ UMP détecte localisation via IP
    │
    ├─ Si UE/UK/CA/EEE → consentForm disponible
    │   └─ showConsentForm() affiche le popup
    │       ├─ Utilisateur clique "J'accepte"
    │       │   └─ Consentement enregistré ✅
    │       │
    │       ├─ Utilisateur clique "Je refuse"
    │       │   └─ Consentement refusé ❌
    │       │
    │       └─ Utilisateur clique "Plus d'infos"
    │           └─ Page détails s'ouvre
    │
    └─ Si autre région → pas de popup
        └─ Continue avec pubs personnalisées
    ↓
AdMob reçoit le consentement
    ↓
    ├─ Accepté → Pubs **personnalisées** (ciblées)
    ├─ Refusé → Pubs **non-personnalisées** (génériques)
    └─ Non défini → Pubs **non-personnalisées** (sûr)
    ↓
Bannière/Interstitielle/Rewarded affichés
```

---

## 🎨 Apparence du Formulaire de Consentement

### Format Banneaux (Par défaut)

**Banner (UE/UK/EEE):**
```
┌─────────────────────────────────────────┐
│ 🔒 Nous avons besoin de votre consentement │
│                                           │
│ Nous et nos partenaires utilisons des   │
│ cookies pour améliorer votre expérience │
│ et afficher des publicités pertinentes. │
│                                           │
│  [J'accepte]  [Je refuse]  [Paramètres] │
└─────────────────────────────────────────┘
```

**Banner (Californie - CCPA):**
```
┌─────────────────────────────────────────┐
│ 🔒 Votre droit à la vie privée          │
│                                           │
│ Vous pouvez refuser les publicités     │
│ ciblées basées sur vos données         │
│ personnelles.                           │
│                                           │
│  [Accepter]  [Refuser le ciblage]      │
└─────────────────────────────────────────┘
```

### Format Écran Complet (Paramètres avancés)

Si l'utilisateur clique sur "Paramètres", un écran détaillé s'affiche avec:
- ✅ Liste des partenaires publicitaires
- ✅ Objectifs de traitement des données
- ✅ Descriptions détaillées de chaque partenaire
- ✅ Options pour consentir/refuser chaque partenaire

---

## ⚙️ Configuration dans Play Console

Après que les utilisateurs consentent, Google Play Console montre:

1. **Nombre de consentements collectés** (par région)
2. **Taux de consentement** (%)
3. **Performance des pubs** (avec vs sans consentement)
4. **Rapport de conformité**

Pour vérifier dans Play Console:
1. Allez dans **App settings** → **App content**
2. Vérifiez **Data Safety** section
3. Confirmez "Ads" est déclaré

---

## 🔐 Déploiement & Testing

### Test sur Émulateur

Pour tester le consentement localement:

```bash
# 1. Build et run l'app en debug
flutter run

# 2. L'app affiche le consentement si:
#    - Vous êtes en UE/UK (même sur ému, selon IP virtuelle)
#    - Ou vous pouvez forcer un test via AdMob
```

### Forcer le Test de Consentement

Pour tester dans n'importe quelle région:

```dart
// Ajouter dans ad_manager.dart pour DEBUG uniquement:
if (kDebugMode) {
  final consentInfo = ConsentInfo.instance;
  await consentInfo.reset(); // Reset le consentement
}
```

### Tester Avec Un Appareil Réel

1. Connectez un appareil en Allemagne, Pays-Bas, ou autre pays UE
2. Lancez l'app
3. Le banneau de consentement devrait s'afficher
4. Testez les options: "J'accepte", "Je refuse", "Paramètres"

---

## 📊 Monitoring de la Conformité

### Dans Google Play Console

1. **Allez dans:** App settings → App content → Data safety
2. **Vérifiez:**
   - ✅ "Ads" est coché dans "Data you collect"
   - ✅ "Advertising" est coché dans "Data usage"
   - ✅ "Google - Ads" est listé dans "Data sharing"
   - ✅ Privacy Policy URL est valide

### Dans Google AdMob Console

1. **Allez dans:** Apps → [Votre App] → App settings
2. **Vérifiez:**
   - ✅ "Status" = "Active"
   - ✅ Aucun avertissement de compliance
   - ✅ Consentement UMP activé

---

## ❌ Erreurs Courantes & Solutions

| Erreur | Cause | Solution |
|--------|-------|----------|
| "Consent form not available" | Région non affectée par RGPD | Normal - continuez sans popup |
| "ConsentInfo not initialized" | _initializeConsent() pas appelé | Assurez-vous preloadAds() est appelé |
| Popup ne s'affiche pas en UE | VPN/Proxy confond la géolocalisation | Test avec un vrai appareil en UE |
| App rejetée Play Store | Pas de consentement UMP | Vérifiez ConsentInfo.instance.requestConsentInfoUpdate() |
| Pubs disparaissent après refus | Normal - pubs non-personnalisées limitées | Google limite les impressions sans consentement |

---

## 📚 Ressources Additionnelles

- [Google UMP Documentation](https://developers.google.com/admob/android/user-messaging-platform)
- [RGPD Documentation](https://ec.europa.eu/info/law/law-topic/data-protection_en)
- [CCPA Guide](https://oag.ca.gov/privacy/ccpa)
- [Google Play Policy Center](https://play.google.com/about/privacy-security/)

---

## ✅ Checklist de Déploiement

- [ ] google_mobile_ads 5.2.0+ installé (pubspec.yaml)
- [ ] ConsentInfo.instance.requestConsentInfoUpdate() appelé
- [ ] Formulaire de consentement testé en région UE (via device réel ou proxy)
- [ ] Consentement enregistré correctement après interaction
- [ ] Privacy Policy URL mise à jour dans Play Console
- [ ] Data Safety section remplie dans Play Console
- [ ] AdMob App ID déclaré dans Data Safety
- [ ] Pas d'erreurs de compilation (flutter pub get)
- [ ] Test sur device avec consentement accepté
- [ ] Test sur device avec consentement refusé
- [ ] Vérifiez dans Play Console que compliance warnings sont résolus

---

## 🚀 Publication

Le consentement UMP est **automatique et transparent**. Une fois déployé:

1. **Google détecte automatiquement** votre localisation
2. **Affiche le popup de consentement** aux utilisateurs en régions affectées
3. **Enregistre le choix** pour 12 mois
4. **Configure AdMob** pour respecter le consentement

**Aucune configuration manuelle requise après le déploiement!**

