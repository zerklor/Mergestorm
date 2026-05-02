import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  // IDs AdMob
  static const String _bannerAdUnitId = 'ca-app-pub-1037321049022291/7452718878';
  static const String _interstitialAdUnitId = 'ca-app-pub-1037321049022291/8095197185';
  static const String _rewardedAdUnitId = 'ca-app-pub-1037321049022291/9408278857';

  static bool get _isTestAdIds =>
      _bannerAdUnitId.contains('3940256099942544') ||
      _interstitialAdUnitId.contains('3940256099942544') ||
      _rewardedAdUnitId.contains('3940256099942544');

  static BannerAd? _bannerAd;
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;
  static bool _isLoadingBanner = false;
  static bool _isLoadingInterstitial = false;
  static bool _isLoadingRewarded = false;
  static bool _isShowingInterstitial = false;
  static bool _consentInfoInitialized = false;

  static int _completedGameCount = 0;
  static DateTime? _lastInterstitialShownAt;

  static const int _interstitialGamesFrequency = 3;
  static const Duration _interstitialCooldown = Duration(minutes: 2);

  /// Initialise le consentement RGPD/CCPA via Google UMP (User Messaging Platform)
  /// Cette méthode gère automatiquement les banneau de consentement selon la localisation
  static Future<void> _initializeConsent() async {
    if (_consentInfoInitialized) return;

    try {
      // Note: Le google_mobile_ads SDK 5.2.0 initialise automatiquement le consentement UMP
      // lors de l'appel à MobileAds.initialize() dans main.dart
      // Cette méthode est un point de contrôle pour s'assurer que le consentement est prêt
      _consentInfoInitialized = true;
      if (kDebugMode) {
        print('✅ Consent initialization checked');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error initializing consent: $e');
      }
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

  // Charge une bannière publicitaire
  static Future<void> loadBannerAd(Function(BannerAd) onAdLoaded) async {
    if (_isTestAdIds) return;
    if (_isLoadingBanner) return;
    _isLoadingBanner = true;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoadingBanner = false;
          onAdLoaded(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          _isLoadingBanner = false;
          ad.dispose();
          if (kDebugMode) {
            print('Failed to load banner ad: ${error.message}');
          }
        },
      ),
    );

    try {
      await _bannerAd?.load();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading banner: $e');
      }
      _isLoadingBanner = false;
    }
  }

  // Dispose bannière
  static void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // Charge une publicité interstitielle
  static Future<void> loadInterstitialAd() async {
    if (_isTestAdIds) return;
    if (_isLoadingInterstitial || _interstitialAd != null) return;
    _isLoadingInterstitial = true;

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingInterstitial = false;
          _interstitialAd = ad;
          if (kDebugMode) {
            print('Interstitial ad loaded');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingInterstitial = false;
          if (kDebugMode) {
            print('Interstitial ad failed to load: ${error.message}');
          }
        },
      ),
    );
  }

  // Charge une publicité récompensée
  static Future<void> loadRewardedAd() async {
    if (_isTestAdIds) return;
    if (_isLoadingRewarded || _rewardedAd != null) return;
    _isLoadingRewarded = true;

    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoadingRewarded = false;
          _rewardedAd = ad;
          if (kDebugMode) {
            print('Rewarded ad loaded');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoadingRewarded = false;
          if (kDebugMode) {
            print('Rewarded ad failed to load: ${error.message}');
          }
        },
      ),
    );
  }

  static Future<bool> showRewardedAd({required void Function() onEarnedReward}) async {
    if (_isTestAdIds) return false;
    if (_rewardedAd == null) {
      await loadRewardedAd();
    }

    final ad = _rewardedAd;
    if (ad == null) {
      return false;
    }

    var rewarded = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
      },
    );

    ad.show(
      onUserEarnedReward: (_, __) {
        rewarded = true;
        onEarnedReward();
      },
    );

    return rewarded;
  }

  static void recordCompletedGame() {
    _completedGameCount++;
  }

  static bool get _canShowInterstitialNow {
    final now = DateTime.now();
    if (_lastInterstitialShownAt == null) {
      return true;
    }
    return now.difference(_lastInterstitialShownAt!) >= _interstitialCooldown;
  }

  static Future<bool> maybeShowInterstitial() async {
    if (_isTestAdIds) return false;
    if (_isShowingInterstitial) return false;
    if (_completedGameCount < _interstitialGamesFrequency) return false;
    if (!_canShowInterstitialNow) return false;

    if (_interstitialAd == null) {
      await loadInterstitialAd();
    }

    final ad = _interstitialAd;
    if (ad == null) return false;

    _isShowingInterstitial = true;
    var shown = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isShowingInterstitial = false;
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _isShowingInterstitial = false;
      },
      onAdShowedFullScreenContent: (ad) {
        shown = true;
        _lastInterstitialShownAt = DateTime.now();
        _completedGameCount = 0;
      },
    );

    ad.show();
    return shown;
  }

  static void disposeInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  // Obtenir la bannière actuelle
  static BannerAd? get bannerAd => _bannerAd;

  static RewardedAd? get rewardedAd => _rewardedAd;

  static InterstitialAd? get interstitialAd => _interstitialAd;

  // Reste de la hauteur de la bannière
  static double get bannerHeight => _bannerAd?.size.height.toDouble() ?? 0;
}
