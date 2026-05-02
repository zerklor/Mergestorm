# Politique de Confidentialité - Mergestorm 2048

**Dernière mise à jour:** Avril 2026

## 1. Résumé Exécutif

Mergestorm 2048 ("Application") ne collecte **aucune donnée personnelle de l'utilisateur**. L'application stocke uniquement des données locales sur votre appareil (scores, paramètres). Aucun serveur n'est impliqué.

---

## 2. Données Collectées

### 2.1 Données Locales (Sur Votre Appareil)

L'application sauvegarde localement via SharedPreferences:
- **Score actuel** et **meilleur score**
- **Paramètres utilisateur** (volume, thème clair/sombre)
- **Données de la boutique** (pièces virtuelles, skins équipés)
- **Historique de jeu** (nombre de parties jouées)

**Important:** Ces données restent UNIQUEMENT sur votre appareil et ne sont jamais transmises à un serveur.

### 2.2 Données de Publicité (Google AdMob)

Pour afficher des publicités, Google AdMob collecte les données suivantes:
- **Identifiant publicitaire Google** (ID de publicité)
- **Informations de l'appareil** (modèle, système d'exploitation, langue)
- **Données de localisation approximatives** (basées sur l'adresse IP)
- **Données de comportement** (historique de clics publicitaires)

**Transparence:** Google utilise ces données pour personnaliser les publicités. Consultez la [Politique de Confidentialité de Google](https://policies.google.com/privacy) pour plus de détails.

### 2.3 Permissions Demandées

L'application demande les permissions suivantes:
- **INTERNET:** Pour afficher les publicités AdMob
- **ACCESS_NETWORK_STATE:** Pour vérifier la connexion Internet
- **VIBRATE:** Pour les vibrations haptiques de feedback

**Aucune permission d'accès à:**
- Contacts, photos, galerie
- Localisation GPS précise
- Microphone, appareil photo
- Calendrier, notes
- Historique d'appels, messages

---

## 3. Utilisation des Données

L'application utilise les données uniquement pour:
1. **Sauvegarde du jeu:** Votre progression et vos scores
2. **Personnalisation:** Vos préférences (thème, volume, skins)
3. **Publicités:** Afficher des annonces pertinentes (via Google AdMob)

---

## 4. Partage des Données

L'application **ne partage jamais vos données** avec:
- Développeurs tiers
- Réseaux sociaux
- Entreprises de marketing
- Autres applications

**Exception:** Google AdMob peut partager des données anonymes avec Google à des fins publicitaires.

---

## 5. Sécurité des Données

- **Chiffrement:** Les données locales sont stockées de façon sécurisée via SharedPreferences d'Android
- **Pas de transmission:** Aucune connexion à Internet (sauf pour les publicités)
- **Pas de serveur:** Aucun serveur backend ne stocke vos données

---

## 6. Cookies et Suivi

L'application **n'utilise pas de cookies** pour vous suivre. Google AdMob utilise des cookies/identifiants publicitaires standards du secteur.

Pour refuser le suivi publicitaire:
1. Allez dans **Paramètres > Google > Gérer votre compte Google**
2. Cliquez sur **Données et confidentialité**
3. Recherchez **Paramètres des annonces**
4. Désactivez la **Publicité personnalisée**

---

## 7. Consentement des Mineurs

L'application est destinée à tous les âges (4+ ans). Si vous avez moins de 13 ans:
- Demandez la permission d'un parent/tuteur avant de télécharger
- Aucune donnée personnelle n'est collectée
- Les données de jeu sont stockées localement sur l'appareil

---

## 8. Droits de l'Utilisateur

Vous avez le droit de:
- **Accéder** à vos données locales (via Paramètres du jeu)
- **Supprimer** vos données (Paramètres > Réinitialiser le jeu)
- **Porter** vos données (sauvegarde locale sur votre appareil)
- **Vous opposer** à la publicité personnalisée

Pour exercer ces droits, contactez: **support@benjaminaubry.com**

---

## 9. Données Mandataires (Partenaires)

### Google AdMob

Google AdMob collecte et traite les données à des fins publicitaires:

| Donnée | Usage | Rétention |
|--------|-------|-----------|
| Identifiant publicitaire | Ciblage d'annonces | Tant que l'app est installée |
| Infos de l'appareil | Pertinence des annonces | 24 mois |
| Localisation (IP) | Annonces géolocalisées | 24 mois |

**Politique AdMob:** https://support.google.com/admob/answer/6128543

---

## 10. Modifications de cette Politique

Nous pouvons mettre à jour cette politique de confidentialité à tout moment. Les modifications seront publiées sur cette page avec une nouvelle date.

**Votre utilisation continue de l'application après les modifications signifie votre acceptation des nouvelles conditions.**

---

## 11. Contact

Pour toute question concernant la confidentialité:

- **Email:** support@benjaminaubry.com
- **Développeur:** Benjamin Aubry
- **Application:** Mergestorm 2048

---

## 12. Conformité Légale

Cette politique de confidentialité est conforme à:
- **RGPD** (Règlement Général sur la Protection des Données) - UE
- **CCPA** (California Consumer Privacy Act) - USA
- **Google Play Store Requirements** - Play Store

---

## Annexe: Données Locales Stockées

Les données suivantes sont stockées localement sur votre appareil:

```
com.benjaminaubry.mergestorm2048.prefs
├── best_score (int)
├── current_score (int)
├── games_played (int)
├── total_score (int)
├── sound_enabled (boolean)
├── music_enabled (boolean)
├── dark_mode_enabled (boolean)
├── shop_coins (int)
├── shop_tile_skin (String)
├── shop_background_skin (String)
└── shop_inventory (JSON)
```

Ces données sont:
- ✅ Chiffrées par Android
- ✅ Stockées uniquement localement
- ✅ Jamais envoyées à distance
- ✅ Accessibles uniquement à l'application
