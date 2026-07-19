// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appName => 'ಹರ್ಡ್ ಎಐ (Herd AI)';

  @override
  String get appSubtitle => 'ನಿಮ್ಮ ಜಾನುವಾರು ಡೈರಿ';

  @override
  String get preparingSecureAccess =>
      'ಸುರಕ್ಷಿತ ಪ್ರವೇಶವನ್ನು ಸಿದ್ಧಪಡಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get createPin => '4-ಅಂಕಿಯ ಪಿನ್ ರಚಿಸಿ';

  @override
  String get enterPin => 'ನಿಮ್ಮ ಪಿನ್ ನಮೂದಿಸಿ';

  @override
  String get unlockApp => 'ಅಪ್ಲಿಕೇಶನ್ ಅನ್‌ಲಾಕ್ ಮಾಡಿ';

  @override
  String get confirmPin => 'ಪಿನ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get pinDidNotMatchTryAgain => 'ಪಿನ್ ಹೊಂದಿಕೆಯಾಗಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get pinDidNotMatch => 'ಪಿನ್ ಹೊಂದಿಕೆಯಾಗಿಲ್ಲ';

  @override
  String get pinCreated => 'ಪಿನ್ ರಚಿಸಲಾಗಿದೆ';

  @override
  String get unlocked => 'ಅನ್‌ಲಾಕ್ ಮಾಡಲಾಗಿದೆ';

  @override
  String get wrongPinTryAgain => 'ತಪ್ಪು ಪಿನ್. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get wrongPin => 'ತಪ್ಪು ಪಿನ್';

  @override
  String get usePinToUnlock => 'ಅನ್‌ಲಾಕ್ ಮಾಡಲು ಪಿನ್ ಬಳಸಿ';

  @override
  String get tryFingerprintFace => 'ಫಿಂಗರ್‌ಪ್ರಿಂಟ್/ಫೇಸ್ ಐಡಿ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get changePin => 'ಪಿನ್ ಬದಲಾಯಿಸಿ';

  @override
  String get language => 'ಭಾಷೆ (Language)';

  @override
  String get selectLanguage => 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get currentPin => 'ಪ್ರಸ್ತುತ ಪಿನ್';

  @override
  String get newPin => 'ಹೊಸ ಪಿನ್';

  @override
  String get confirmNewPin => 'ಹೊಸ ಪಿನ್ ದೃಢೀಕರಿಸಿ';

  @override
  String get cancel => 'ರದ್ದುಮಾಡು';

  @override
  String get save => 'ಉಳಿಸು';

  @override
  String get wrongCurrentPin => 'ತಪ್ಪು ಪ್ರಸ್ತುತ ಪಿನ್';

  @override
  String get pinChanged => 'ಪಿನ್ ಬದಲಾಯಿಸಲಾಗಿದೆ';

  @override
  String get pinsDoNotMatch => 'ಹೊಸ ಪಿನ್‌ಗಳು ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ';

  @override
  String get enterAllFields => 'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಕ್ಷೇತ್ರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ';

  @override
  String get invalidPinLength => 'ಪಿನ್ ಕಡ್ಡಾಯವಾಗಿ 4 ಅಂಕಿಗಳಿರಬೇಕು';

  @override
  String get cowsNotebook => 'ಜಾನುವಾರು ನೋಟ್‌ಬುಕ್';

  @override
  String get noCows => 'ಇನ್ನೂ ಯಾವುದೇ ಹಸುವನ್ನು ನೋಂದಾಯಿಸಲಾಗಿಲ್ಲ.';

  @override
  String get searchHint => 'ನಿಮ್ಮ ಹಿಂಡನ್ನು ಹುಡುಕಿ...';

  @override
  String cowIdLabel(String id) {
    return 'ಹಸುವಿನ ಐಡಿ: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'ನೋಂದಾಯಿಸಲಾಗಿದೆ: $date';
  }

  @override
  String get readyToIdentify =>
      'ಹಸುವನ್ನು ಗುರುತಿಸಲು ಮತ್ತು ದಾಖಲೆಗಳನ್ನು ಇಡಲು ಸಿದ್ಧವಾಗಿದೆ.';

  @override
  String get initializingDb => 'ನಿಮ್ಮ ಜಾನುವಾರು ಡೈರಿ ಸಿದ್ಧವಾಗುತ್ತಿದೆ...';

  @override
  String get readyText => 'ಗುರುತಿಸಲು ಸಿದ್ಧವಾಗಿದೆ';

  @override
  String get notReady =>
      'ಅಪ್ಲಿಕೇಶನ್ ಸೆಟಪ್ ಇನ್ನೂ ಪೂರ್ಣಗೊಂಡಿಲ್ಲ. ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get selectImage => 'ಮಾದರಿ ಲೋಡ್ ಆದ ನಂತರ ಚಿತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get checkingCow => 'ಹಸುವನ್ನು ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get cowIdentified => 'ಹಸುವನ್ನು ಗುರುತಿಸಲಾಗಿದೆ.';

  @override
  String get borderlineMatch =>
      'ಇದು ನಿಮ್ಮ ಬಳಿ ಈಗಾಗಲೇ ಇರುವ ಹಸುವಿನಂತೆ ಕಾಣುತ್ತಿದೆ — ಕೆಳಗೆ ನೋಡಿ.';

  @override
  String get noMatchingCow => 'ಯಾವುದೇ ಹೊಂದಿಕೆಯಾಗುವ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get couldNotIdentify =>
      'ಈ ಸಮಯದಲ್ಲಿ ಈ ಹಸುವನ್ನು ಗುರುತಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get addThisCow => 'ಈ ಹಸುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get cowId => 'ಹಸುವಿನ ಐಡಿ';

  @override
  String get optionalNote => 'ಟಿಪ್ಪಣಿ (ಐಚ್ಛಿಕ)';

  @override
  String get register => 'ನೋಂದಾಯಿಸಿ';

  @override
  String get addCow => 'ಹಸುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get cowAlreadyExists => 'ಹಸುವಿನ ಐಡಿ ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ';

  @override
  String get pleaseEnterId => 'ದಯವಿಟ್ಟು ಐಡಿ ನಮೂದಿಸಿ';

  @override
  String get registering => 'ನೋಂದಾಯಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get cowRegistered => 'ಹಸು ನೋಂದಾಯಿಸಲಾಗಿದೆ';

  @override
  String get failedToRegister => 'ಹಸುವನ್ನು ನೋಂದಾಯಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get basicInfo => 'ಮೂಲಭೂತ ಮಾಹಿತಿ';

  @override
  String registeredOn(String date) {
    return 'ನೋಂದಾಯಿಸಲಾಗಿದೆ: $date';
  }

  @override
  String get breedClassification => 'ತಳಿ ವರ್ಗೀಕರಣ';

  @override
  String get classifyBreed => 'ತಳಿ ಗುರುತಿಸಿ';

  @override
  String get reClassify => 'ಮತ್ತೆ ಗುರುತಿಸಿ';

  @override
  String get noBreedClassificationYet =>
      'ಇನ್ನೂ ಯಾವುದೇ ತಳಿ ವರ್ಗೀಕರಣ ಮಾಡಲಾಗಿಲ್ಲ. ಪೂರ್ಣ ದೇಹದ ಫೋಟೋ ತೆಗೆದುಕೊಳ್ಳಿ.';

  @override
  String confirmedBreed(String breed) {
    return 'ದೃಢಪಡಿಸಿದ ತಳಿ: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'ಕಡಿಮೆ ವಿಶ್ವಾಸಾರ್ಹತೆ — ಹೆಚ್ಚು ಸ್ಪಷ್ಟವಾದ ಪೂರ್ಣ ದೇಹದ ಫೋಟೋವನ್ನು ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get setManually => 'ಹಸ್ತಚಾಲಿತವಾಗಿ ಹೊಂದಿಸಿ';

  @override
  String get unknownMixed => 'ತಿಳಿದಿಲ್ಲ / ಮಿಶ್ರ ತಳಿ';

  @override
  String get likelyBreedsVisual => 'ಸಾಧ್ಯವಿರುವ ತಳಿಗಳು (ದೃಶ್ಯ ಅಂದಾಜು):';

  @override
  String confirmBreed(String breed) {
    return '$breed ದೃಢೀಕರಿಸಿ';
  }

  @override
  String get chooseDifferent => 'ಬೇರೆಯದನ್ನು ಆರಿಸಿ';

  @override
  String get breedClassified => 'ತಳಿ ವರ್ಗೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get couldNotClassify => 'ತಳಿಯನ್ನು ವರ್ಗೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get noBreedPredictions => 'ಯಾವುದೇ ತಳಿ ಅಂದಾಜುಗಳು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String breedConfirmed(String breed) {
    return 'ತಳಿಯನ್ನು ದೃಢೀಕರಿಸಲಾಗಿದೆ: $breed';
  }

  @override
  String get chooseBreed => 'ತಳಿಯನ್ನು ಆರಿಸಿ';

  @override
  String get orTypeBreedName => 'ಅಥವಾ ತಳಿಯ ಹೆಸರನ್ನು ಟೈಪ್ ಮಾಡಿ:';

  @override
  String get confirmCustomBreed => 'ಕಸ್ಟಮ್ ತಳಿಯನ್ನು ದೃಢೀಕರಿಸಿ';

  @override
  String get customBreedHint => 'ಉದಾ. ಜರ್ಸಿ ಕ್ರಾಸ್';

  @override
  String get breedSetUnknown =>
      'ತಳಿಯನ್ನು ತಿಳಿದಿಲ್ಲ / ಮಿಶ್ರ ತಳಿ ಎಂದು ಹೊಂದಿಸಲಾಗಿದೆ';

  @override
  String get healthRecords => 'ಆರೋಗ್ಯ ದಾಖಲೆಗಳು';

  @override
  String get addHealthRecord => 'ಆರೋಗ್ಯ ದಾಖಲೆ ಸೇರಿಸಿ';

  @override
  String get editHealthRecord => 'ಆರೋಗ್ಯ ದಾಖಲೆ ಸಂಪಾದಿಸಿ';

  @override
  String get noHealthRecords => 'ಇನ್ನೂ ಯಾವುದೇ ಆರೋಗ್ಯ ದಾಖಲೆಗಳಿಲ್ಲ.';

  @override
  String get diseaseName => 'ರೋಗದ ಹೆಸರು';

  @override
  String get symptoms => 'ಲಕ್ಷಣಗಳು';

  @override
  String get status => 'ಸ್ಥಿತಿ';

  @override
  String get dateLabel => 'ದಿನಾಂಕ';

  @override
  String get delete => 'ಅಳಿಸು';

  @override
  String get edit => 'ಸಂಪಾದಿಸು';

  @override
  String get deleteHealthRecord => 'ಆರೋಗ್ಯ ದಾಖಲೆ ಅಳಿಸಿ';

  @override
  String get deleteHealthRecordConfirm =>
      'ಈ ಆರೋಗ್ಯ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';

  @override
  String get healthRecordDeleted => 'ಆರೋಗ್ಯ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get healthRecordSaved => 'ಆರೋಗ್ಯ ದಾಖಲೆಯನ್ನು ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get vaccinationRecords => 'ಲಸಿಕೆ ದಾಖಲೆಗಳು';

  @override
  String get addVaccination => 'ಲಸಿಕೆ ಸೇರಿಸಿ';

  @override
  String get editVaccination => 'ಲಸಿಕೆ ದಾಖಲೆ ಸಂಪಾದಿಸಿ';

  @override
  String get noVaccinationRecords => 'ಇನ್ನೂ ಯಾವುದೇ ಲಸಿಕೆ ದಾಖಲೆಗಳಿಲ್ಲ.';

  @override
  String get vaccineName => 'ಲಸಿಕೆಯ ಹೆಸರು';

  @override
  String get dateGiven => 'ಲಸಿಕೆ ನೀಡಿದ ದಿನಾಂಕ';

  @override
  String get nextDueDate => 'ಮುಂದಿನ ಗಡುವು ದಿನಾಂಕ (ಐಚ್ಛಿಕ)';

  @override
  String get deleteVaccination => 'ಲಸಿಕೆ ದಾಖಲೆ ಅಳಿಸಿ';

  @override
  String get deleteVaccinationConfirm => 'ಈ ಲಸಿಕೆ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';

  @override
  String get vaccinationDeleted => 'ಲಸಿಕೆ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get vaccinationSaved => 'ಲಸಿಕೆ ದಾಖಲೆಯನ್ನು ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get notes => 'ಟಿಪ್ಪಣಿಗಳು';

  @override
  String get addNote => 'ಟಿಪ್ಪಣಿ ಸೇರಿಸಿ';

  @override
  String get editNote => 'ಟಿಪ್ಪಣಿ ಸಂಪಾದಿಸಿ';

  @override
  String get noNotes => 'ಯಾವುದೇ ಟಿಪ್ಪಣಿಗಳನ್ನು ಸೇರಿಸಲಾಗಿಲ್ಲ.';

  @override
  String get deleteNote => 'ಟಿಪ್ಪಣಿ ಅಳಿಸಿ';

  @override
  String get deleteNoteConfirm => 'ಈ ಟಿಪ್ಪಣಿಯನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';

  @override
  String get noteDeleted => 'ಟಿಪ್ಪಣಿಯನ್ನು ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get noteSaved => 'ಟಿಪ್ಪಣಿಯನ್ನು ಉಳಿಸಲಾಗಿದೆ';

  @override
  String get photos => 'ಫೋಟೋಗಳು';

  @override
  String get addPhoto => 'ಫೋಟೋ ಸೇರಿಸಿ';

  @override
  String get photoDesc =>
      'ಕಾಲಕ್ರಮೇಣ ಈ ಹಸು ಹೇಗೆ ಕಾಣುತ್ತದೆ ಎಂಬುದನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ. ಹೊಸ ಫೋಟೋಗಳು ಮೊದಲು ಕಾಣಿಸಿಕೊಳ್ಳುತ್ತವೆ.';

  @override
  String get noPhotos => 'ಇನ್ನೂ ಯಾವುದೇ ಫೋಟೋಗಳಿಲ್ಲ.';

  @override
  String get replace => 'ಬದಲಾಯಿಸು';

  @override
  String get replacePhoto => 'ಈ ಫೋಟೋವನ್ನು ಬದಲಾಯಿಸಬೇಕೇ?';

  @override
  String get replacePhotoConfirm =>
      'ಹಳೆಯ ಫೋಟೋವನ್ನು ತೆಗೆದುಹಾಕಲಾಗುತ್ತದೆ ಮತ್ತು ಅದರ ಸ್ಥಾನದಲ್ಲಿ ಹೊಸ ಫೋಟೋವನ್ನು ಇರಿಸಲಾಗುತ್ತದೆ.';

  @override
  String get photoUpdated => 'ಫೋಟೋ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get couldNotUpdatePhoto => 'ಫೋಟೋವನ್ನು ನವೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get deletePhoto => 'ಫೋಟೋ ಅಳಿಸಿ';

  @override
  String get deletePhotoConfirm =>
      'ಈ ಫೋಟೋವನ್ನು ಅಳಿಸಬೇಕೇ? ಇದನ್ನು ಹಸುವಿನ ಗುರುತಿಸುವಿಕೆಯಿಂದಲೂ ತೆಗೆದುಹಾಕಲಾಗುತ್ತದೆ.';

  @override
  String get photoDeleted => 'ಫೋಟೋ ಅಳಿಸಲಾಗಿದೆ';

  @override
  String addPhotoTo(String id) {
    return '$id ಗೆ ಫೋಟೋ ಸೇರಿಸಬೇಕೇ?';
  }

  @override
  String get addPhotoConfirm =>
      'ಕಾಲಕ್ರಮೇಣ ಈ ಹಸು ಹೇಗೆ ಕಾಣುತ್ತದೆ ಎಂಬುದನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಈ ಫೋಟೋವನ್ನು ಇಂದಿನ ದಿನಾಂಕದೊಂದಿಗೆ ಉಳಿಸಲಾಗುತ್ತದೆ. ಇದು ಭವಿಷ್ಯದಲ್ಲಿ ಹಸುವನ್ನು ಗುರುತಿಸಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ.';

  @override
  String get photoAdded => 'ಫೋಟೋ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get couldNotAddPhoto => 'ಫೋಟೋವನ್ನು ಸೇರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get takePhoto => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get chooseFromGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ';

  @override
  String get takeOrChooseClear =>
      'ಈ ಹಸುವಿನ ಸ್ಪಷ್ಟವಾದ ಫೋಟೋ ತೆಗೆದುಕೊಳ್ಳಿ ಅಥವಾ ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ.';

  @override
  String get classifyThisPhoto => 'ಈ ಫೋಟೋವನ್ನು ವರ್ಗೀಕರಿಸಬೇಕೇ?';

  @override
  String get classifyThisPhotoConfirm =>
      'ಸ್ಪಷ್ಟವಾದ, ಉತ್ತಮ ಬೆಳಕಿರುವ ಪೂರ್ಣ ದೇಹದ ಫೋಟೋ ಉತ್ತಮ ತಳಿ ಅಂದಾಜನ್ನು ನೀಡುತ್ತದೆ.';

  @override
  String get classify => 'ವರ್ಗೀಕರಿಸಿ';

  @override
  String get takeOrChooseFullBody =>
      'ಈ ಹಸುವಿನ ಸ್ಪಷ್ಟವಾದ ಪೂರ್ಣ ದೇಹದ ಫೋಟೋ ತೆಗೆದುಕೊಳ್ಳಿ ಅಥವಾ ಗ್ಯಾಲರಿಯಿಂದ ಆರಿಸಿ.';

  @override
  String get deleteCowRecord => 'ಹಸುವಿನ ದಾಖಲೆ ಅಳಿಸಿ';

  @override
  String deleteCowRecordConfirm(String id) {
    return 'ನೀವು $id ಮತ್ತು ಅದಕ್ಕೆ ಸಂಬಂಧಿಸಿದ ಎಲ್ಲಾ ದಾಖಲೆಗಳನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';
  }

  @override
  String get cowRecordDeleted => 'ಹಸುವಿನ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get cowDetails => 'ಹಸುವಿನ ವಿವರಗಳು';

  @override
  String get cowNotFound => 'ಹಸುವಿನ ದಾಖಲೆ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String detailsHeader(String id) {
    return '$id ವಿವರಗಳು';
  }

  @override
  String get identifyCow => 'ಹಸುವನ್ನು ಗುರುತಿಸಿ';

  @override
  String get identifyTab => 'ಗುರುತಿಸಿ';

  @override
  String get cowsTab => 'ನನ್ನ ಹಸುಗಳು';

  @override
  String get tapIdentify =>
      'ಫೋಟೋ ಸೇರಿಸಲಾಗಿದೆ. ಹಸುವನ್ನು ಗುರುತಿಸಿ ಎಂಬುದನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ.';

  @override
  String get selectImageFirst => 'ಮೊದಲು ಚಿತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ.';

  @override
  String get matchesHeading => 'ಹೊಂದಾಣಿಕೆಗಳು';

  @override
  String get details => 'ವಿವರಗಳು';

  @override
  String get unknownCow => 'ಅಪರಿಚಿತ ಹಸು';

  @override
  String get registerThisCow => 'ಈ ಹಸುವನ್ನು ನೋಂದಾಯಿಸಿ';

  @override
  String get backButton => 'ಹಿಂದಕ್ಕೆ';

  @override
  String get noCowsFound => 'ಯಾವುದೇ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ';

  @override
  String get activeLabel => 'ಸಕ್ರಿಯವಾಗಿದೆ';

  @override
  String get recoveredLabel => 'ಗುಣಮುಖವಾಗಿದೆ';

  @override
  String givenLabel(String date) {
    return 'ನೀಡಿದ ದಿನಾಂಕ: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'ಮುಂದಿನ ಗಡುವು: $date';
  }

  @override
  String get tabOverview => 'ಅವಲೋಕನ';

  @override
  String get tabMedical => 'ವೈದ್ಯಕೀಯ ಮಾಹಿತಿ';

  @override
  String get tabGalleryNotes => 'ಗ್ಯಾಲರಿ & ಟಿಪ್ಪಣಿಗಳು';

  @override
  String dialogIdentifyAs(String id) {
    return '$id ಎಂದು ಗುರುತಿಸಬೇಕೇ?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'ಈ ಹಸು ನೋಡಲು $id ತರಹ ಕಾಣಿಸುತ್ತಿದೆ (ವಿಶ್ವಾಸಾರ್ಹತೆ: $confidence%). ನೀವು ಹೊಸ ಹಸುವನ್ನು ನೋಂದಾಯಿಸುವ ಬದಲಿಗೆ ಈ ಫೋಟೋವನ್ನು $id ಇತಿಹಾಸದಲ್ಲಿ ಉಳಿಸಲು ಬಯಸುವಿರಾ?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id ನಲ್ಲಿ ಫೋಟೋ ಉಳಿಸಿ';
  }

  @override
  String get dialogIdentifyNewCow => 'ಇಲ್ಲ, ಇದು ಹೊಸ ಹಸು';

  @override
  String get checkingPhotoBeforeReg =>
      'ನೋಂದಣಿಗೆ ಮುನ್ನ ಫೋಟೋ ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String alreadyInHerd(String id) {
    return '$id ಈಗಾಗಲೇ ನಿಮ್ಮ ಹಿಂಡಿನಲ್ಲಿದೆ';
  }

  @override
  String get no => 'ಇಲ್ಲ';

  @override
  String get yes => 'ಹೌದು';

  @override
  String yesAddTo(String id) {
    return 'ಹೌದು, $id ಗೆ ಸೇರಿಸಿ';
  }

  @override
  String looksLike(String id) {
    return 'ಇದು $id ರಂತೆ ಕಾಣುತ್ತಿದೆ';
  }

  @override
  String get addPhotoToThat => 'ಈ ಫೋಟೋವನ್ನು ಆ ಹಸುವಿಗೆ ಸೇರಿಸಬೇಕೇ?';

  @override
  String get createNewCow => 'ಹೊಸ ಹಸು ರಚಿಸಿ';

  @override
  String get savingPhoto => 'ಫೋಟೋ ಉಳಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String photoAddedTo(String id) {
    return 'ಫೋಟೋವನ್ನು $id ಗೆ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get couldNotSavePhoto => 'ಈ ಫೋಟೋವನ್ನು ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get savingCowDetails => 'ಹಸುವಿನ ವಿವರಗಳನ್ನು ಉಳಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String addedToHerd(String id) {
    return '$id ಅನ್ನು ನಿಮ್ಮ ಹಿಂಡಿಗೆ ಸೇರಿಸಲಾಗಿದೆ.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id ಅನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get exitApp => 'ಅಪ್ಲಿಕೇಶನ್‌ನಿಂದ ನಿರ್ಗಮಿಸಿ';

  @override
  String get exitAppConfirm => 'ನೀವು ಅಪ್ಲಿಕೇಶನ್ ಮುಚ್ಚಲು ಬಯಸುವಿರಾ?';

  @override
  String get cancelled => 'ರದ್ದುಗೊಳಿಸಲಾಗಿದೆ.';

  @override
  String get couldNotCheckPhoto =>
      'ನೋಂದಣಿಗೆ ಮುನ್ನ ಈ ಫೋಟೋವನ್ನು ಪರಿಶೀಲಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get couldNotPrepareReg => 'ನೋಂದಣಿಯನ್ನು ಸಿದ್ಧಪಡಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ';

  @override
  String get captureImage => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get uploadImage => 'ಫೋಟೋ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get identificationResult => 'ಗುರುತಿಸುವಿಕೆಯ ಫಲಿತಾಂಶ';

  @override
  String get noCowsMessage =>
      'ಇನ್ನೂ ಯಾವುದೇ ಹಸುಗಳಿಲ್ಲ.\nಮೊದಲ ಹಸುವನ್ನು ಸೇರಿಸಲು \'ಗುರುತಿಸಿ\' ಟ್ಯಾಬ್ ಬಳಸಿ.';

  @override
  String get yourHerd => 'ನಿಮ್ಮ ಹಿಂಡು';

  @override
  String get welcomeNotebook => 'ನಿಮ್ಮ ಜಾನುವಾರು ಡೈರಿಗೆ ಸುಸ್ವಾಗತ';

  @override
  String get notebookDescription =>
      'ಹಸುವನ್ನು ಗುರುತಿಸಲು ಮತ್ತು ಸರಳ ದಾಖಲೆಗಳನ್ನು ಇಡಲು ಫೋಟೋ ತೆಗೆಯಿರಿ ಅಥವಾ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.';

  @override
  String registeredCowsCount(int count) {
    return 'ನೋಂದಾಯಿತ ಹಸುಗಳು: $count';
  }

  @override
  String get initErrorOccurred => 'ಅಪ್ಲಿಕೇಶನ್ ತೆರೆಯುವಾಗ ಏನೋ ದೋಷ ಸಂಭವಿಸಿದೆ.';

  @override
  String get tryAgain => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get noPhotoSelected => 'ಯಾವುದೇ ಫೋಟೋ ಆಯ್ಕೆ ಮಾಡಲಾಗಿಲ್ಲ';

  @override
  String get identifyResultPlaceholder =>
      'ಫಲಿತಾಂಶವನ್ನು ನೋಡಲು ಹಸುವನ್ನು ಗುರುತಿಸಿ.';

  @override
  String matchConfidence(String confidence) {
    return 'ಹೊಂದಾಣಿಕೆಯ ವಿಶ್ವಾಸಾರ್ಹತೆ: $confidence%';
  }

  @override
  String get cowAlreadyInHerd => 'ಈ ಹಸು ಈಗಾಗಲೇ ನಿಮ್ಮ ಹಿಂಡಿನಲ್ಲಿದೆ.';

  @override
  String get noMatchingCowRegisterHint =>
      'ಹೊಂದಿಕೆಯಾಗುವ ಯಾವುದೇ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ. ನೀವು ಇದನ್ನು ಹೊಸ ಹಸುವಾಗಿ ಸೇರಿಸಬಹುದು.';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'ಆರೋಗ್ಯ: $health • ಲಸಿಕೆಗಳು: $vaccines • ಟಿಪ್ಪಣಿಗಳು: $notes';
  }

  @override
  String get diseaseNameLabel => 'ರೋಗದ ಹೆಸರು';

  @override
  String get ongoing => 'ಸಕ್ರಿಯವಾಗಿದೆ';

  @override
  String get recovered => 'ಗುಣಮುಖವಾಗಿದೆ';

  @override
  String get symptomsOptional => 'ಲಕ್ಷಣಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get treatmentNotesOptional => 'ಚಿಕಿತ್ಸೆಯ ಟಿಪ್ಪಣಿಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get saveHealthRecord => 'ಆರೋಗ್ಯ ದಾಖಲೆ ಉಳಿಸಿ';

  @override
  String get updateHealthRecord => 'ಆರೋಗ್ಯ ದಾಖಲೆ ನವೀಕರಿಸಿ';

  @override
  String get healthRecordAdded => 'ಆರೋಗ್ಯ ದಾಖಲೆ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get healthRecordUpdated => 'ಆರೋಗ್ಯ ದಾಖಲೆ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get vaccineNameLabel => 'ಲಸಿಕೆಯ ಹೆಸರು';

  @override
  String get pickDate => 'ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get nextDueNotSet => 'ಮುಂದಿನ ಗಡುವು: ಹೊಂದಿಸಿಲ್ಲ';

  @override
  String get setNextDue => 'ಮುಂದಿನ ಗಡುವು ಹೊಂದಿಸಿ';

  @override
  String get notesOptional => 'ಟಿಪ್ಪಣಿಗಳು (ಐಚ್ಛಿಕ)';

  @override
  String get saveVaccination => 'ಲಸಿಕೆ ದಾಖಲೆ ಉಳಿಸಿ';

  @override
  String get updateVaccination => 'ಲಸಿಕೆ ದಾಖಲೆ ನವೀಕರಿಸಿ';

  @override
  String get vaccinationAdded => 'ಲಸಿಕೆ ದಾಖಲೆ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get vaccinationUpdated => 'ಲಸಿಕೆ ದಾಖಲೆ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get addNoteDialogTitle => 'ಟಿಪ್ಪಣಿ ಸೇರಿಸಿ';

  @override
  String get noteAdded => 'ಟಿಪ್ಪಣಿ ಸೇರಿಸಲಾಗಿದೆ';

  @override
  String get noteUpdated => 'ಟಿಪ್ಪಣಿ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String dateLabel2(String date) {
    return 'ದಿನಾಂಕ: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'ನೀಡಿದ ದಿನಾಂಕ: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'ಮುಂದಿನ ಗಡುವು: $date';
  }

  @override
  String get noSymptomsNoted => 'ಯಾವುದೇ ಲಕ್ಷಣಗಳನ್ನು ನಮೂದಿಸಿಲ್ಲ';
}
