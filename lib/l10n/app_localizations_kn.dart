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
  String get cattleNotebook => 'ಜಾನುವಾರು ನೋಟ್‌ಬುಕ್';

  @override
  String get noCattles => 'ಇನ್ನೂ ಯಾವುದೇ ಹಸುವನ್ನು ನೋಂದಾಯಿಸಲಾಗಿಲ್ಲ.';

  @override
  String get searchHint => 'ನಿಮ್ಮ ಹಿಂಡನ್ನು ಹುಡುಕಿ...';

  @override
  String cattleIdLabel(String id) {
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
  String get checkingCattle => 'ಹಸುವನ್ನು ಪರಿಶೀಲಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get cattleIdentified => 'ಹಸುವನ್ನು ಗುರುತಿಸಲಾಗಿದೆ.';

  @override
  String get borderlineMatch =>
      'ಇದು ನಿಮ್ಮ ಬಳಿ ಈಗಾಗಲೇ ಇರುವ ಹಸುವಿನಂತೆ ಕಾಣುತ್ತಿದೆ — ಕೆಳಗೆ ನೋಡಿ.';

  @override
  String get noMatchingCattle => 'ಯಾವುದೇ ಹೊಂದಿಕೆಯಾಗುವ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String get couldNotIdentify =>
      'ಈ ಸಮಯದಲ್ಲಿ ಈ ಹಸುವನ್ನು ಗುರುತಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get addThisCattle => 'ಈ ಹಸುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get cattleId => 'ಹಸುವಿನ ಐಡಿ';

  @override
  String get optionalNote => 'ಟಿಪ್ಪಣಿ (ಐಚ್ಛಿಕ)';

  @override
  String get register => 'ನೋಂದಾಯಿಸಿ';

  @override
  String get addCattle => 'ಹಸುವನ್ನು ಸೇರಿಸಿ';

  @override
  String get cattleAlreadyExists => 'ಹಸುವಿನ ಐಡಿ ಈಗಾಗಲೇ ಅಸ್ತಿತ್ವದಲ್ಲಿದೆ';

  @override
  String get pleaseEnterId => 'ದಯವಿಟ್ಟು ಐಡಿ ನಮೂದಿಸಿ';

  @override
  String get registering => 'ನೋಂದಾಯಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String get cattleRegistered => 'ಹಸು ನೋಂದಾಯಿಸಲಾಗಿದೆ';

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
  String get cattleIdentification => 'ಸಾಕುಪ್ರಾಖಿ ಗುರುತಿಸುವಿಕೆ';

  @override
  String get cattleIdentificationDesc =>
      'ಈ ದನವನ್ನು ಗುರುತಿಸಲು ಮುಖದ ಫೋಟೋಗಳನ್ನು ಸೇರಿಸಿ.';

  @override
  String get noIdentityPhotos => 'ಇನ್ನೂ ಮುಖದ ಫೋಟೋಗಳನ್ನು ಸೇರಿಸಲಾಗಿಲ್ಲ.';

  @override
  String get addFacialPhoto => 'ಫೋಟೋ ಸೇರಿಸಿ';

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
  String get galleryPhotoConfirm =>
      'ಸಮಯದೊಂದಿಗೆ ಈ ದನದ ನೋಟ ಮತ್ತು ಬೆಳವಣಿಗೆಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಲು ಈ ಫೋಟೋವನ್ನು ಉಳಿಸಲಾಗುತ್ತದೆ.';

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
  String get deleteCattleRecord => 'ಹಸುವಿನ ದಾಖಲೆ ಅಳಿಸಿ';

  @override
  String deleteCattleRecordConfirm(String id) {
    return 'ನೀವು $id ಮತ್ತು ಅದಕ್ಕೆ ಸಂಬಂಧಿಸಿದ ಎಲ್ಲಾ ದಾಖಲೆಗಳನ್ನು ಅಳಿಸಲು ಬಯಸುವಿರಾ?';
  }

  @override
  String get cattleRecordDeleted => 'ಹಸುವಿನ ದಾಖಲೆಯನ್ನು ಅಳಿಸಲಾಗಿದೆ';

  @override
  String get cattleDetails => 'ಹಸುವಿನ ವಿವರಗಳು';

  @override
  String get cattleNotFound => 'ಹಸುವಿನ ದಾಖಲೆ ಕಂಡುಬಂದಿಲ್ಲ.';

  @override
  String detailsHeader(String id) {
    return '$id ವಿವರಗಳು';
  }

  @override
  String get identifyCattle => 'ಹಸುವನ್ನು ಗುರುತಿಸಿ';

  @override
  String get identifyTab => 'ಗುರುತಿಸಿ';

  @override
  String get cattleTab => 'ನನ್ನ ಹಸುಗಳು';

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
  String get unknownCattle => 'ಅಪರಿಚಿತ ಹಸು';

  @override
  String get registerThisCattle => 'ಈ ಹಸುವನ್ನು ನೋಂದಾಯಿಸಿ';

  @override
  String get backButton => 'ಹಿಂದಕ್ಕೆ';

  @override
  String get noCattlesFound => 'ಯಾವುದೇ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ';

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
  String get dialogIdentifyNewCattle => 'ಇಲ್ಲ, ಇದು ಹೊಸ ಹಸು';

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
  String get createNewCattle => 'ಹೊಸ ಹಸು ರಚಿಸಿ';

  @override
  String get savingPhoto => 'ಫೋಟೋ ಉಳಿಸಲಾಗುತ್ತಿದೆ...';

  @override
  String photoAddedTo(String id) {
    return 'ಫೋಟೋವನ್ನು $id ಗೆ ಸೇರಿಸಲಾಗಿದೆ';
  }

  @override
  String get couldNotSavePhoto => 'ಈ ಫೋಟೋವನ್ನು ಉಳಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ.';

  @override
  String get savingCattleDetails => 'ಹಸುವಿನ ವಿವರಗಳನ್ನು ಉಳಿಸಲಾಗುತ್ತಿದೆ...';

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
  String get noCattlesMessage =>
      'ಇನ್ನೂ ಯಾವುದೇ ಹಸುಗಳಿಲ್ಲ.\nಮೊದಲ ಹಸುವನ್ನು ಸೇರಿಸಲು \'ಗುರುತಿಸಿ\' ಟ್ಯಾಬ್ ಬಳಸಿ.';

  @override
  String get yourHerd => 'ನಿಮ್ಮ ಹಿಂಡು';

  @override
  String get welcomeNotebook => 'ನಿಮ್ಮ ಜಾನುವಾರು ಡೈರಿಗೆ ಸುಸ್ವಾಗತ';

  @override
  String get notebookDescription =>
      'ಹಸುವನ್ನು ಗುರುತಿಸಲು ಮತ್ತು ಸರಳ ದಾಖಲೆಗಳನ್ನು ಇಡಲು ಫೋಟೋ ತೆಗೆಯಿರಿ ಅಥವಾ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.';

  @override
  String registeredCattlesCount(int count) {
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
  String get cattleAlreadyInHerd => 'ಈ ಹಸು ಈಗಾಗಲೇ ನಿಮ್ಮ ಹಿಂಡಿನಲ್ಲಿದೆ.';

  @override
  String get noMatchingCattleRegisterHint =>
      'ಹೊಂದಿಕೆಯಾಗುವ ಯಾವುದೇ ಹಸು ಕಂಡುಬಂದಿಲ್ಲ. ನೀವು ಇದನ್ನು ಹೊಸ ಹಸುವಾಗಿ ಸೇರಿಸಬಹುದು.';

  @override
  String cattleSummarySubtitle(int health, int vaccines, int notes) {
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

  @override
  String get milkYieldTab => 'ಹಾಲು ಇಳುವರಿ';

  @override
  String get milkAndLactationTitle => 'ಹಾಲು ಮತ್ತು ಹಾಲಿನ ಅವಧಿ';

  @override
  String get notifications => 'ಸೂಚನೆಗಳು';

  @override
  String get filterButton => 'ಫಿಲ್ಟರ್';

  @override
  String get clearAll => 'ಎಲ್ಲವನ್ನು ಅಳಿಸಿ';

  @override
  String showingCattleCount(int filtered, int total) {
    return '$total ರಲ್ಲಿ $filtered ದನಗಳನ್ನು ತೋರಿಸಲಾಗುತ್ತಿದೆ';
  }

  @override
  String get noCattleMatchFilter =>
      'ಆಯ್ಕೆಮಾಡಿದ ಫಿಲ್ಟರ್‌ಗೆ ಯಾವುದೇ ದನ ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ.';

  @override
  String get resetSearchAndFilters => 'ಹುಡುಕಾಟ ಮತ್ತು ಫಿಲ್ಟರ್ ಮರುಹೊಂದಿಸಿ';

  @override
  String get filterAndSortCattle => 'ದನಗಳನ್ನು ಫಿಲ್ಟರ್ ಮತ್ತು ವಿಂಗಡಿಸಿ';

  @override
  String get sortOrder => 'ವಿಂಗಡಣೆ ಕ್ರಮ';

  @override
  String get resetAll => 'ಎಲ್ಲ ಮರುಹೊಂದಿಸಿ';

  @override
  String showMatchingCattle(int count) {
    return '$count ದನಗಳನ್ನು ತೋರಿಸಿ';
  }

  @override
  String get sexLabel => 'ಲಿಂಗ';

  @override
  String get lifeStageLabel => 'ಜೀವನ ಹಂತ';

  @override
  String get healthStatusLabel => 'ಆರೋಗ್ಯ ಸ್ಥಿತಿ';

  @override
  String get reproductiveStatusLabel => 'ಸಂತಾನೋತ್ಪತ್ತಿ ಸ್ಥಿತಿ';

  @override
  String get vaccinationStatusLabel => 'ಲಸಿಕೆ';

  @override
  String get milkAndLactation => 'ಹಾಲು ಮತ್ತು ಹಾಲಿನ ಅವಧಿ';

  @override
  String get breedCategory => 'ತಳಿ';

  @override
  String get female => 'ಹೆಣ್ಣು';

  @override
  String get male => 'ಗಂಡು';

  @override
  String get calf => 'ಕರು';

  @override
  String get heifer => 'ಕಿನ್ನಾರಿ / ಹೆಣ್ಣು ಕರು';

  @override
  String get cow => 'ಹಸು';

  @override
  String get bull => 'ಗೂಳಿ';

  @override
  String get steer => 'ಎತ್ತು';

  @override
  String get healthy => 'ಆರೋಗ್ಯಕರ';

  @override
  String get underObservation => 'ಪರಿಶೀಲನೆಯಲ್ಲಿದೆ';

  @override
  String get diseased => 'ಅನಾರೋಗ್ಯಕರ';

  @override
  String get unknown => 'ತಿಳಿದಿಲ್ಲ';

  @override
  String get pregnant => 'ಗರ್ಭಿಣಿ';

  @override
  String get notPregnant => 'ಗರ್ಭಿಣಿಯಲ್ಲ';

  @override
  String get upToDate => 'ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get dueSoon => 'ಶೀಘ್ರದಲ್ಲೇ ನೀಡಬೇಕು';

  @override
  String get overdue => 'ಸಮಯ ಮೀರಿದೆ';

  @override
  String get noRecord => 'ದಾಖಲೆಯಿಲ್ಲ';

  @override
  String get milkingCows => 'ಹಾಲು ನೀಡುವ ಹಸುಗಳು';

  @override
  String get dryCows => 'ಹಾಲು ನಿಂತ ಹಸುಗಳು';

  @override
  String get highProducers => 'ಹೆಚ್ಚು ಹಾಲು ನೀಡುವವು (>15 ಲೀ/ದಿನ)';

  @override
  String get mediumProducers => 'ಮಧ್ಯಮ ಹಾಲು ನೀಡುವವು (8–15 ಲೀ/ದಿನ)';

  @override
  String get lowProducers => 'ಕಡಿಮೆ ಹಾಲು ನೀಡುವವು (<8 ಲೀ/ದಿನ)';

  @override
  String get recentlyCalved => 'ಇತ್ತೀಚೆಗೆ ಕರು ಹಾಕಿದವು';

  @override
  String get sortRecentlyAdded => 'ಇತ್ತೀಚೆಗೆ ಸೇರಿಸಲಾದವು';

  @override
  String get sortOldestAdded => 'ಹಳೆಯವು';

  @override
  String get sortNameAsc => 'ಐಡಿ (A → Z)';

  @override
  String get sortNameDesc => 'ಐಡಿ (Z → A)';

  @override
  String get sortAgeAsc => 'ವಯಸ್ಸು (ಚಿಕ್ಕವರಿಂದ ದೊಡ್ಡವರು)';

  @override
  String get sortAgeDesc => 'ವಯಸ್ಸು (ದೊಡ್ಡವರಿಂದ ಚಿಕ್ಕವರು)';

  @override
  String get todaysMilkProduction => 'ಇಂದಿನ ಹಾಲು ಉತ್ಪಾದನೆ';

  @override
  String cowsMilked(int count) {
    return '$count ಹಸುಗಳ ಹಾಲು ಕರೆಯಲಾಗಿದೆ';
  }

  @override
  String get liters => 'ಲೀಟರ್';

  @override
  String get averagePerCow => 'ಸರಾಸರಿ / ಹಸು';

  @override
  String topProducer(String id, String yield) {
    return 'ಅತ್ಯುತ್ತಮ: #$id ($yield ಲೀ)';
  }

  @override
  String get topProducerNone => 'ಅತ್ಯುತ್ತಮ: ಇನ್ನೂ ಯಾರೂ ಇಲ್ಲ';

  @override
  String lowestProducer(String id, String yield) {
    return 'ಕಡಿಮೆ: #$id ($yield ಲೀ)';
  }

  @override
  String get thisWeek => 'ಈ ವಾರ';

  @override
  String get thisMonth => 'ಈ ತಿಂಗಳು';

  @override
  String get milkingHerd => 'ಹಾಲು ನೀಡುವ ಹಿಂಡು';

  @override
  String cowsCount(int count) {
    return '$count ಹಸುಗಳು';
  }

  @override
  String get recordMilk => 'ಹಾಲು ದಾಖಲಿಸಿ';

  @override
  String get reports => 'ವರದಿಗಳು';

  @override
  String get productionAnalytics => 'ಉತ್ಪಾದನಾ ವಿಶ್ಲೇಷಣೆ';

  @override
  String get milkHistory => 'ಹಾಲಿನ ಇತಿಹಾಸ';

  @override
  String daysLogged(int count) {
    return '$count ದಿನಗಳ ದಾಖಲೆ';
  }

  @override
  String get noMilkRecordsSavedYet =>
      'ಇನ್ನೂ ಯಾವುದೇ ಹಾಲಿನ ದಾಖಲೆಗಳಿಲ್ಲ. ಪ್ರಾರಂಭಿಸಲು \'ಹಾಲು ದಾಖಲಿಸಿ\' ಸ್ಪರ್ಶಿಸಿ.';

  @override
  String get breedAnalyticsFilter => 'ತಳಿ ವಿಶ್ಲೇಷಣೆ ಫಿಲ್ಟರ್:';

  @override
  String get allBreeds => 'ಎಲ್ಲಾ ತಳಿಗಳು';

  @override
  String cowsRecordedCount(int count, String plural) {
    return '$count ಹಸುಗಳು ದಾಖಲಾಗಿವೆ';
  }

  @override
  String get morningShort => 'ಬೆಳಿಗ್ಗೆ';

  @override
  String get eveningShort => 'ಸಂಜೆ';

  @override
  String get editMilkRecord => 'ಹಾಲಿನ ದಾಖಲೆ ತಿದ್ದುಪಡಿ';

  @override
  String get recordMilkYield => 'ಹಾಲಿನ ಪ್ರಮಾಣ ದಾಖಲಿಸಿ';

  @override
  String get recordExistsWarning =>
      'ಈ ಹಸುವಿಗೆ ಈ ದಿನಾಂಕದ ದಾಖಲೆ ಈಗಾಗಲೇ ಇದೆ. ಉಳಿಸಿದರೆ ಅದು ನವೀಕರಣಗೊಳ್ಳುತ್ತದೆ.';

  @override
  String get cattleLabel => 'ದನ';

  @override
  String get selectCow => 'ಹಸು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get milkingBadge => 'ಹಾಲು ನೀಡುತ್ತಿದೆ';

  @override
  String get recordDate => 'ದಾಖಲೆಯ ದಿನಾಂಕ';

  @override
  String get morningLiters => 'ಬೆಳಿಗ್ಗೆ (ಲೀಟರ್)';

  @override
  String get eveningLiters => 'ಸಂಜೆ (ಲೀಟರ್)';

  @override
  String get totalDailyYield => 'ಒಟ್ಟು ದೈನಂದಿನ ಇಳುವರಿ';

  @override
  String get notesOptionalMilk => 'ಟಿಪ್ಪಣಿ (ಐಚ್ಛಿಕ)';

  @override
  String get notesHintMilk => 'ಉದಾ. ಹಸಿರು ಹುಲ್ಲು ನೀಡಲಾಗಿದೆ';

  @override
  String get updateRecord => 'ದಾಖಲೆ ನವೀಕರಿಸಿ';

  @override
  String get saveRecordButton => 'ದಾಖಲೆ ಉಳಿಸಿ';

  @override
  String get pleaseSelectCattle => 'ದಯವಿಟ್ಟು ದನವನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get milkProductionReports => 'ಹಾಲು ಉತ್ಪಾದನೆ ವರದಿಗಳು';

  @override
  String breedFilterBadge(String breed) {
    return 'ತಳಿ ಫಿಲ್ಟರ್: $breed';
  }

  @override
  String get dailyTab => 'ದೈನಂದಿನ';

  @override
  String get weeklyTab => 'ವಾರದ';

  @override
  String get monthlyTab => 'ತಿಂಗಳ';

  @override
  String get reportDateLabel => 'ವರದಿ ದಿನಾಂಕ: ';

  @override
  String get weekStartLabel => 'ವಾರದ ಪ್ರಾರಂಭ: ';

  @override
  String downloadCsvReport(String type) {
    return '$type CSV ವರದಿ ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ';
  }

  @override
  String reportSaved(String fileName) {
    return 'ವರದಿ ಉಳಿಸಲಾಗಿದೆ: $fileName';
  }

  @override
  String get reportCopied => 'ವರದಿಯನ್ನು ಕ್ಲಿಪ್‌ಬೋರ್ಡ್‌ಗೆ ನಕಲಿಸಲಾಗಿದೆ!';

  @override
  String get dailyAvg => 'ದೈನಂದಿನ ಸರಾಸರಿ';

  @override
  String get totalYieldLabel => 'ಒಟ್ಟು ಇಳುವರಿ';

  @override
  String get bestLabel => 'ಅತ್ಯುತ್ತಮ';

  @override
  String get worstLabel => 'ಕನಿಷ್ಠ';

  @override
  String get orderLabel => 'ಕ್ರಮ:';

  @override
  String get bestToWorst => 'ಅತ್ಯುತ್ತಮ → ಕನಿಷ್ಠ';

  @override
  String get worstToBest => 'ಕನಿಷ್ಠ → ಅತ್ಯುತ್ತಮ';

  @override
  String noMilkRecordsForPeriod(String breedText) {
    return 'ಈ ಅವಧಿಗೆ ಯಾವುದೇ ಹಾಲಿನ ದಾಖಲೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ$breedText.';
  }

  @override
  String recordedOutOfDays(int recorded, int total) {
    return 'ದಾಖಲಾಗಿರುವುದು: $recorded/$total ದಿನಗಳು';
  }

  @override
  String recordedEntriesCount(int count) {
    return 'ದಾಖಲಾಗಿರುವುದು: $count ನಮೂದುಗಳು';
  }

  @override
  String morningEveningBreakdown(String morning, String evening) {
    return 'ಬೆಳಿಗ್ಗೆ: $morning ಲೀ  •  ಸಂಜೆ: $evening ಲೀ';
  }

  @override
  String get notificationsAndSmartAlerts =>
      'ಸೂಚನೆಗಳು ಮತ್ತು ಸ್ಮಾರ್ಟ್ ಎಚ್ಚರಿಕೆಗಳು';

  @override
  String get allClear => 'ಎಲ್ಲವೂ ಸರಿ ಇದೆ!';

  @override
  String get noPendingAlerts => 'ಯಾವುದೇ ಬಾಕಿ ಇರುವ ಸೂಚನೆಗಳಿಲ್ಲ.';

  @override
  String get viewAction => 'ನೋಡಿ';

  @override
  String get recordMilkAction => 'ಹಾಲು ದಾಖಲಿಸಿ';

  @override
  String get logCalvingAction => 'ಕರು ಹಾಕಿದ್ದನ್ನು నమోదు ಮಾಡಿ';

  @override
  String get vaccinateAction => 'ಲಸಿಕೆ ಹಾಕಿ';

  @override
  String get editCattleDetails => 'ದನದ ವಿವರಗಳನ್ನು ತಿದ್ದುಪಡಿ ಮಾಡಿ';

  @override
  String get dateOfBirthAge => 'ಹುಟ್ಟಿದ ದಿನಾಂಕ (ವಯಸ್ಸು)';

  @override
  String get notSet => 'ಹೊಂದಿಸಲಾಗಿಲ್ಲ';

  @override
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural) {
    return '$years ವರ್ಷ $months ತಿಂಗಳು';
  }

  @override
  String yearsAge(int years, String yPlural) {
    return '$years ವರ್ಷ';
  }

  @override
  String monthsAge(int months, String mPlural) {
    return '$months ತಿಂಗಳು';
  }

  @override
  String get unknownAge => 'ತಿಳಿಯದ ವಯಸ್ಸು';

  @override
  String get milkAndLactationProfile => 'ಹಾಲು ಮತ್ತು ಹಾಲಿನ ಪ್ರೊಫೈಲ್';

  @override
  String get currentlyMilking => 'ಪ್ರಸ್ತುತ ಹಾಲು ನೀಡುತ್ತಿದೆ';

  @override
  String get lastCalvingDate => 'ಕೊನೆಯ ಕರು ಹಾಕಿದ ದಿನಾಂಕ';

  @override
  String get inseminationDate => 'ಗರ್ಭಧಾರಣೆ ದಿನಾಂಕ';

  @override
  String get expectedDailyYieldBenchmark => 'ನಿರೀಕ್ಷಿತ ದೈನಂದಿನ ಇಳುವರಿ';

  @override
  String get benchmarkHint => 'ಉದಾ. 15.0';

  @override
  String get symptomsHint => 'ಉದಾ. ಸರಿಯಾಗಿ ಮೇವು ತಿನ್ನುತ್ತಿಲ್ಲ';

  @override
  String get cattleDetailsUpdated => 'ದನದ ವಿವರಗಳನ್ನು ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get milkProductionTab => 'ಹಾಲು ಉತ್ಪಾದನೆ';

  @override
  String get lactationStatus => 'ಹಾಲಿನ ಅವಧಿಯ ಸ್ಥಿತಿ';

  @override
  String get daysInMilk => 'ಹಾಲು ನೀಡುತ್ತಿರುವ ದಿನಗಳು (DIM)';

  @override
  String daysUnit(int count) {
    return '$count ದಿನಗಳು';
  }

  @override
  String get lastCalving => 'ಕೊನೆಯ ಕರು ಹಾಕಿದ್ದು';

  @override
  String get estNextCalving => 'ಮುಂದಿನ ಕರು ಹಾಕುವ ಅಂದಾಜು';

  @override
  String get thirtyDayAverage => '30 ದಿನದ ಸರಾಸರಿ';

  @override
  String get totalThisMonth => 'ಈ ತಿಂಗಳ ಒಟ್ಟು';

  @override
  String get recentMilkYieldTrend => 'ಇತ್ತೀಚಿನ ಹಾಲಿನ ಇಳುವರಿ ಪ್ರವೃತ್ತಿ';

  @override
  String get dailyMilkRecords => 'ದೈನಂದಿನ ಹಾಲಿನ ದಾಖಲೆಗಳು';

  @override
  String get noDailyMilkRecords => 'ಈ ಹಸುವಿಗೆ ಇನ್ನೂ ದೈನಂದಿನ ಹಾಲಿನ ದಾಖಲೆಗಳಿಲ್ಲ.';

  @override
  String litersPerDay(String yield) {
    return '$yield ಲೀ/ದಿನ';
  }

  @override
  String get freshStage => 'ಹೊಸತು (Fresh)';

  @override
  String get earlyStage => 'ಆರಂಭಿಕ (Early)';

  @override
  String get midStage => 'ಮಧ್ಯಮ (Mid)';

  @override
  String get lateStage => 'ಕೊನೆಯ ಹಂತ (Late)';

  @override
  String get extendedStage => 'ವಿಸ್ತರಿಸಿದ ಹಾಲಿನ ಅವಧಿ';

  @override
  String get dryStage => 'ಹಾಲು ನಿಂತ ಹಂತ (Dry)';

  @override
  String stageSuffix(String stage) {
    return '$stage ಹಂತ';
  }

  @override
  String get calvingDateOverdue => 'ಕರು ಹಾಕುವ ದಿನಾಂಕ ಮೀರಿದೆ';

  @override
  String calvingOverdueMessage(String date) {
    return 'ನಿರೀಕ್ಷಿತ ಕರು ಹಾಕುವ ದಿನಾಂಕ ($date) ಮೀರಿದೆ. ವಿವರಗಳನ್ನು ನವೀಕರಿಸಿ.';
  }

  @override
  String get logCalving => 'ಕರು ಹಾಕಿದ್ದನ್ನು ನೋಂದಾಯಿಸಿ';

  @override
  String get predictedBreed => 'ಅಂದಾಜು ತಳಿ';

  @override
  String get noMilkChartRecords => 'ಇನ್ನೂ ಹಾಲಿನ ದಾಖಲೆಗಳಿಲ್ಲ.';

  @override
  String get setAsUnknown => 'ತಿಳಿದಿಲ್ಲ ಎಂದು ಹೊಂದಿಸಿ';

  @override
  String breedPredictionItem(String name, int percent) {
    return '• $name — $percent%';
  }

  @override
  String get sexRequired => 'ಲಿಂಗ *';

  @override
  String get optionalNoteHint => 'ಉದಾ. ಗರ್ಭಿಣಿ';

  @override
  String get missingMilkEntryToday => 'ಇಂದಿನ ಹಾಲು ದಾಖಲೆ ಇಲ್ಲ';

  @override
  String missingMilkEntryTitle(String date) {
    return 'ಹಾಲು ದಾಖಲೆ ಇಲ್ಲ ($date)';
  }

  @override
  String noMilkRecordEntered(String dateLabel, String id) {
    return '$dateLabel #$id ಗೆ ಯಾವುದೇ ಹಾಲು ದಾಖಲಾಗಿಲ್ಲ.';
  }

  @override
  String get today => 'ಇಂದು';

  @override
  String get yesterday => 'ನಿನ್ನೆ';

  @override
  String onDate(String date) {
    return '$date ರಂದು';
  }

  @override
  String get lowYieldAlertTitle => 'ಕಡಿಮೆ ಇಳುವರಿ ಎಚ್ಚರಿಕೆ';

  @override
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  ) {
    return '#$id ಹಾಲಿನ ಉತ್ಪಾದನೆ $percent% ಕಡಿಮೆಯಾಗಿದೆ ($latest ಲೀ vs $avg ಲೀ ಸರಾಸರಿ).';
  }

  @override
  String get dryOffReminderTitle => 'ಹಾಲು ಒಣಗಿಸುವ ನೆನಪೋಲೆ';

  @override
  String dryOffReminderMessage(String id, int days) {
    return '#$id $days ದಿನಗಳಲ್ಲಿ ಈಯ್ಯುವ ನಿರೀಕ್ಷೆಯಿದೆ. ಒಣ ಅವಧಿಗೆ ಸಿದ್ಧಗೊಳಿಸಿ.';
  }

  @override
  String get calvingDateOverdueTitle => 'ಈಯ್ಯುವ ದಿನಾಂಕ ಮೀರಿದೆ';

  @override
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  ) {
    return '#$id ಈಯ್ಯುವ ದಿನಾಂಕ $days ದಿನಗಳ ಹಿಂದೆ ಇತ್ತು ($date). ಮಾಹಿತಿ ನವೀಕರಿಸಿ.';
  }

  @override
  String get calvingReminderTitle => 'ಈಯ್ಯುವ ನೆನಪೋಲೆ';

  @override
  String calvingReminderMessage(String id, int days, String plural) {
    return '#$id $days ದಿನಗಳಲ್ಲಿ ಈಯ್ಯಲಿದೆ. ಸಿದ್ಧತೆ ಮಾಡಿ.';
  }

  @override
  String get vaccinationOverdueTitle => 'ಲಸಿಕೆ ದಿನಾಂಕ ಮೀರಿದೆ';

  @override
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days ದಿನಗಳ ಹಿಂದೆ ನೀಡಬೇಕಾಗಿತ್ತು ($date).';
  }

  @override
  String get vaccinationDueSoonTitle => 'ಲಸಿಕೆ ಶೀಘ್ರದಲ್ಲೇ ನೀಡಬೇಕು';

  @override
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days ದಿನಗಳಲ್ಲಿ ನೀಡಬೇಕು ($date).';
  }
}
