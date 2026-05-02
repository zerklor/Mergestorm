# Data Safety Form - Mergestorm 2048

> Ce document prépare les réponses pour la section "Data Safety" dans Google Play Console

**Package Name:** com.benjaminaubry.mergestorm2048  
**Application:** Mergestorm 2048  
**Developer:** Benjamin Aubry

---

## 📊 Data Safety Summary

Cette section résume les données collectées par l'application selon les standards de Google Play Store.

---

## 1. Data Collection & Security

### ✅ Données Collectées par l'Application

| Catégorie | Données | Collecté | Raison | Chiffré | Supprimable |
|-----------|---------|----------|--------|---------|------------|
| **Gameplay** | Score, High Score | ✅ Oui | Sauvegarde du jeu | ✅ Oui | ✅ Oui |
| **Gameplay** | Nombre de parties | ✅ Oui | Statistiques | ✅ Oui | ✅ Oui |
| **Préférences** | Thème (clair/sombre) | ✅ Oui | Paramètres utilisateur | ✅ Oui | ✅ Oui |
| **Audio** | Réglage du volume | ✅ Oui | Préférences audio | ✅ Oui | ✅ Oui |
| **Shop** | Pièces virtuelles | ✅ Oui | Économie du jeu | ✅ Oui | ✅ Oui |
| **Shop** | Skins équipés | ✅ Oui | Préférences d'apparence | ✅ Oui | ✅ Oui |
| **Appareil** | Identifiant publicitaire* | ✅ Oui | Google AdMob | ✅ Oui | ❌ Non** |
| **Appareil** | Localisation (IP)* | ✅ Oui | Google AdMob | ✅ Oui | ❌ Non** |

*Collecté par Google AdMob, pas directement par l'application  
**Géré par Google, pas supprimable par l'utilisateur dans l'application

---

## 2. Data Pratices Questionnaire

### Q: Est-ce que l'application collecte des données personnelles?

**Réponse:** Partiellement

- **Données de l'application (locales):** Scores, paramètres → Stocké localement, pas de collecte de données personnelles
- **Données publicitaires:** Google AdMob collecte l'ID publicitaire et la localisation approximée
- **Pas de collecte:** Nom, email, numéro de téléphone, localisation GPS précise

---

### Q: Comment l'application utilise les données?

**Réponse:**
1. **Sauvegarde du jeu:** Conserver la progression et les scores localement
2. **Paramètres utilisateur:** Mémoriser les préférences (thème, volume)
3. **Publicités ciblées:** Google AdMob utilise les données pour afficher des annonces pertinentes

---

### Q: L'application partage-t-elle les données avec des tiers?

**Réponse:** Non, sauf Google AdMob

- ❌ Pas de partage avec réseaux sociaux
- ❌ Pas de partage avec analystes tiers
- ❌ Pas de partage avec équipes de marketing
- ✅ Partage UNIQUEMENT avec Google AdMob pour les publicités

---

### Q: Les données sont-elles chiffrées en transit?

**Réponse:** Oui

- Données locales: Chiffrées par Android SharedPreferences
- Données AdMob: Transmises via HTTPS (chiffré)
- Pas de transmission de données sensibles

---

### Q: L'utilisateur peut-il demander la suppression?

**Réponse:** Oui, partiellement

- ✅ Réinitialiser le jeu → Supprime tous les scores et paramètres locaux
- ✅ Gérer les paramètres Google → Réinitialiser l'ID publicitaire
- ❌ Impossible de supprimer les données AdMob existantes (rétention Google = 24 mois)

---

### Q: Y a-t-il une politique de confidentialité?

**Réponse:** Oui

- 📄 [PRIVACY_POLICY.md](PRIVACY_POLICY.md) (disponible dans le projet)
- 🔗 À publier sur: https://benjaminaubry.com/mergestorm/privacy (ou domaine similaire)
- **Important:** URL doit être accessible et en français/anglais

---

## 3. Données Collectées par Catégorie

### Données Sensibles ❌

**L'application N'ACCÈDE PAS à:**
- ❌ Contacts
- ❌ Photos/Galerie
- ❌ Localisation GPS précise
- ❌ Microphone/Appareil photo
- ❌ Calendrier
- ❌ SMS/Messages
- ❌ Historique d'appels

### Données Non-Sensibles ✅

**L'application STOCKE:**
- ✅ Score (localement)
- ✅ Paramètres utilisateur (localement)
- ✅ Pièces virtuelles (localement)
- ✅ Préférences de thème (localement)

### Données Publicitaires ℹ️

**Google AdMob COLLECTE:**
- ℹ️ Identifiant publicitaire (ID Google Ad)
- ℹ️ Localisation approximative (via IP)
- ℹ️ Type d'appareil, OS, langue
- ℹ️ Historique de clics publicitaires

---

## 4. Formulaire Play Store - Réponses Rapides

### Data Types Collected

**Checkboxes à COCHER dans Play Console:**

- ✅ **App activity** → Game scores, gameplay statistics
- ✅ **App interactions** → In-app advertising interaction
- ❌ **Approximate location** → NON (seulement via AdMob)
- ❌ **Precise location** → NON
- ❌ **Personal info** → NON
- ❌ **Contact info** → NON
- ❌ **Photos or videos** → NON
- ❌ **Audio files** → NON
- ❌ **Files and docs** → NON
- ❌ **Calendar events** → NON
- ✅ **Advertising ID** → Oui (Google AdMob)
- ✅ **Device or other IDs** → Oui (pour ads)
- ❌ **Purchase history** → NON (pièces virtuelles locales)
- ❌ **User IDs** → NON
- ❌ **Browsing history** → NON
- ❌ **Search history** → NON
- ❌ **Health and fitness** → NON
- ❌ **Financial info** → NON
- ❌ **Email address** → NON
- ❌ **SMS or call history** → NON

### Data Usage

**Sélectionner:**
- ✅ App functionality (sauvegarde du jeu)
- ❌ Analytics (pas de suivi analytics)
- ✅ Advertising (Google AdMob)
- ❌ Personalisation (pas de personnalisation basée sur les données utilisateur)
- ❌ Research (pas de recherche)

### Data Retention

**Pour chaque type de donnée sélectionné:**
- **App activity (scores):** Stocké jusqu'à la suppression par l'utilisateur
- **Advertising ID:** Retenu selon la politique Google (24 mois)
- **Device ID:** Retenu pour la durée d'installation

### Data Sharing

**Sélectionner:**
- ✅ Google - Annonces (Google AdMob)
- ❌ Pas d'autres tiers
- ❌ Pas de vente de données

### Security Practices

**Sélectionner:**
- ✅ Data is encrypted in transit (HTTPS pour AdMob)
- ✅ Data is encrypted at rest (Android KeyStore)
- ✅ You request permission before accessing certain data (permissions demandées)
- ✅ There's an option for users to request deletion (Paramètres > Réinitialiser le jeu)

### Content Rating

Pour la section "Content Rating":

- **Category:** Games > Puzzle
- **Content Rating:** 4+ (PEGI 3)
- **Contains ads:** ✅ Oui (Google AdMob)
- **In-app purchases:** ✅ Oui (pièces virtuelles, mais on peut dire non si c'est uniquement cosmétique)
- **Mature content:** ❌ Non

---

## 5. Compliance Checklist

- [ ] Politique de confidentialité rédigée ([PRIVACY_POLICY.md](PRIVACY_POLICY.md))
- [ ] Politique publiée sur un domaine accessible
- [ ] URL Privacy Policy dans Play Store: https://benjaminaubry.com/privacy
- [ ] Formulaire Data Safety rempli dans Play Console
- [ ] Toutes les permissions Android justifiées
- [ ] Google AdMob déclaré comme tiers
- [ ] Content Rating questionnaire complété
- [ ] Aucune donnée sensible accédée sans permission
- [ ] RGPD compliance: Pas de données EU sensibles collectées
- [ ] CCPA compliance: Pas de données californie sensibles collectées

---

## 6. URLs pour Play Console

Quand vous remplirez Play Console, vous aurez besoin de:

| Champ | Valeur |
|-------|--------|
| **Privacy Policy URL** | https://benjaminaubry.com/mergestorm/privacy |
| **Email Support** | support@benjaminaubry.com |
| **Website** | https://benjaminaubry.com |
| **Content Rating Questionnaire** | À remplir directement dans Play Console |
| **Data Safety Section** | À remplir directement dans Play Console |

---

## 7. Soumission du Formulaire

Après avoir rempli le formulaire Data Safety dans Play Console:

1. Allez dans **App settings** → **App content**
2. Cliquez sur **Data safety**
3. Répondez aux 4 sections:
   - Data you collect
   - Data usage
   - Data security
   - How long data is kept
4. Cliquez sur **Save**
5. Cliquez sur **Request review** (optionnel, Google peut demander des clarifications)

---

## 8. Autres Exigences Play Store

### Permissions à Déclarer

L'application utilise:
- ✅ INTERNET (pour AdMob)
- ✅ ACCESS_NETWORK_STATE (pour vérifier connexion)
- ✅ VIBRATE (pour feedback haptique)

### Contenu à Déclarer

- ✅ Publicités (bannière, interstitielle, rewarded ads)
- ❌ Pas de contenu réservé aux adultes
- ❌ Pas de violence excessive
- ❌ Pas de contenu offensant

### Age Rating

- **PEGI:** 3+ (Jeu de puzzle pour tous les âges)
- **ESRB:** E (Everyone)
- **USK:** 0+ (Sans restriction)

---

## Ressources Utiles

- [Google Play Console Data Safety](https://support.google.com/googleplay/android-developer/answer/13579931)
- [RGPD Guide](https://ec.europa.eu/info/law/law-topic/data-protection/eu-data-protection-rules_en)
- [Google AdMob Privacy](https://support.google.com/admob/answer/6128543)
- [Play Store Policy Center](https://play.google.com/about/policy/index.html)

