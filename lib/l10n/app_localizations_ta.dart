// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'ஹெர்ட் ஏஐ (Herd AI)';

  @override
  String get appSubtitle => 'உங்கள் கால்நடை குறிப்பேடு';

  @override
  String get preparingSecureAccess =>
      'பாதுகாப்பான அணுகல் தயார் செய்யப்படுகிறது...';

  @override
  String get createPin => '4-இலக்க பின்னை உருவாக்கவும்';

  @override
  String get enterPin => 'உங்கள் பின்னை உள்ளிடவும்';

  @override
  String get unlockApp => 'செயலியைத் திறக்கவும்';

  @override
  String get confirmPin => 'பின்னை உறுதிப்படுத்தவும்';

  @override
  String get pinDidNotMatchTryAgain => 'பின் பொருந்தவில்லை. மீண்டும் முயலவும்';

  @override
  String get pinDidNotMatch => 'பின் பொருந்தவில்லை';

  @override
  String get pinCreated => 'பின் உருவாக்கப்பட்டது';

  @override
  String get unlocked => 'திறக்கப்பட்டது';

  @override
  String get wrongPinTryAgain => 'தவறான பின். மீண்டும் முயலவும்';

  @override
  String get wrongPin => 'தவறான பின்';

  @override
  String get usePinToUnlock => 'திறக்க பின்னைப் பயன்படுத்தவும்';

  @override
  String get tryFingerprintFace => 'கைரேகை/முக அடையாளத்தை முயற்சிக்கவும்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get changePin => 'பின்னை மாற்றவும்';

  @override
  String get language => 'மொழி (Language)';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get currentPin => 'தற்போதைய பின்';

  @override
  String get newPin => 'புதிய பின்';

  @override
  String get confirmNewPin => 'புதிய பின்னை உறுதிப்படுத்தவும்';

  @override
  String get cancel => 'ரத்துசெய்';

  @override
  String get save => 'சேமி';

  @override
  String get wrongCurrentPin => 'தவறான தற்போதைய பின்';

  @override
  String get pinChanged => 'பின் மாற்றப்பட்டது';

  @override
  String get pinsDoNotMatch => 'புதிய பின்ன்கள் பொருந்தவில்லை';

  @override
  String get enterAllFields => 'தயவுசெய்து அனைத்து விவரங்களையும் நிரப்பவும்';

  @override
  String get invalidPinLength => 'பின் கண்டிப்பாக 4 இலக்கங்கள் இருக்க வேண்டும்';

  @override
  String get cowsNotebook => 'கால்நடை நோட்புக்';

  @override
  String get noCows => 'இன்னும் எந்த மாடும் பதிவு செய்யப்படவில்லை.';

  @override
  String get searchHint => 'உங்கள் மந்தையைத் தேடுங்கள்...';

  @override
  String cowIdLabel(String id) {
    return 'மாடு ஐடி: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'பதிவு செய்யப்பட்டது: $date';
  }

  @override
  String get readyToIdentify =>
      'மாட்டை அடையாளம் காணவும் குறிப்புகள் வைக்கவும் தயார்.';

  @override
  String get initializingDb =>
      'உங்கள் கால்நடை குறிப்பேடு தயார் செய்யப்படுகிறது...';

  @override
  String get readyText => 'அடையாளம் காண தயார்';

  @override
  String get notReady =>
      'செயலி அமைப்பு இன்னும் முழுமையடையவில்லை. மீண்டும் முயலவும்.';

  @override
  String get selectImage => 'மாதிரி ஏற்றிய பின் படத்தை தேர்ந்தெடுக்கவும்.';

  @override
  String get checkingCow => 'மாடு சரிபார்க்கப்படுகிறது...';

  @override
  String get cowIdentified => 'மாடு அடையாளம் காணப்பட்டது.';

  @override
  String get borderlineMatch =>
      'இது உங்களிடம் ஏற்கனவே உள்ள மாடு போல தெரிகிறது — கீழே பார்க்கவும்.';

  @override
  String get noMatchingCow => 'பொருந்தும் மாடு எதுவும் காணப்படவில்லை.';

  @override
  String get couldNotIdentify =>
      'இந்த நேரத்தில் இந்த மாட்டை அடையாளம் காண முடியவில்லை.';

  @override
  String get addThisCow => 'இந்த மாட்டைச் சேர்க்கவும்';

  @override
  String get cowId => 'மாடு ஐடி';

  @override
  String get optionalNote => 'குறிப்பு (விரும்பினால்)';

  @override
  String get register => 'பதிவுசெய்';

  @override
  String get addCow => 'மாட்டைச் சேர்க்கவும்';

  @override
  String get cowAlreadyExists => 'மாடு ஐடி ஏற்கனவே உள்ளது';

  @override
  String get pleaseEnterId => 'தயவுசெய்து ஒரு ஐடியை உள்ளிடவும்';

  @override
  String get registering => 'பதிவு செய்யப்படுகிறது...';

  @override
  String get cowRegistered => 'மாடு பதிவு செய்யப்பட்டது';

  @override
  String get failedToRegister => 'மாட்டை பதிவு செய்ய முடியவில்லை';

  @override
  String get basicInfo => 'அடிப்படை தகவல்';

  @override
  String registeredOn(String date) {
    return 'பதிவு செய்யப்பட்டது: $date';
  }

  @override
  String get breedClassification => 'இன வகைப்பாடு';

  @override
  String get classifyBreed => 'இனத்தை அடையாளம் காண்க';

  @override
  String get reClassify => 'மீண்டும் அடையாளம் காண்க';

  @override
  String get noBreedClassificationYet =>
      'இன்னும் இன வகைப்பாடு செய்யப்படவில்லை. முழு உடல் புகைப்படம் எடுக்கவும்.';

  @override
  String confirmedBreed(String breed) {
    return 'உறுதி செய்யப்பட்ட இனம்: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'குறைந்த நம்பிக்கை — தெளிவான முழு உடல் புகைப்படத்தை முயற்சிக்கவும்.';

  @override
  String get setManually => 'கைமுறையாக அமைக்கவும்';

  @override
  String get unknownMixed => 'தெரியவில்லை / கலப்பு இனம்';

  @override
  String get likelyBreedsVisual => 'சாத்தியமான இனங்கள் (காட்சி மதிப்பீடு):';

  @override
  String confirmBreed(String breed) {
    return '$breed உறுதி செய்';
  }

  @override
  String get chooseDifferent => 'வேறொன்றைத் தேர்ந்தெடு';

  @override
  String get breedClassified => 'இனம் வகைப்படுத்தப்பட்டது';

  @override
  String get couldNotClassify => 'இனத்தை வகைப்படுத்த முடியவில்லை';

  @override
  String get noBreedPredictions => 'இன கணிப்புகள் எதுவும் வரவில்லை';

  @override
  String breedConfirmed(String breed) {
    return 'இனம் உறுதி செய்யப்பட்டது: $breed';
  }

  @override
  String get chooseBreed => 'இனத்தைத் தேர்ந்தெடு';

  @override
  String get orTypeBreedName => 'அல்லது இனத்தின் பெயரை தட்டச்சு செய்க:';

  @override
  String get confirmCustomBreed => 'தனிப்பயன் இனத்தை உறுதிப்படுத்துக';

  @override
  String get customBreedHint => 'உதாரணம்: ஜெர்சி கிராஸ்';

  @override
  String get breedSetUnknown => 'இனம் தெரியவில்லை / கலப்பு என அமைக்கப்பட்டது';

  @override
  String get healthRecords => 'சுகாதார பதிவுகள்';

  @override
  String get addHealthRecord => 'சுகாதார பதிவைச் சேர்';

  @override
  String get editHealthRecord => 'சுகாதார பதிவை திருத்து';

  @override
  String get noHealthRecords => 'இன்னும் சுகாதார பதிவுகள் எதுவும் இல்லை.';

  @override
  String get diseaseName => 'நோயின் பெயர்';

  @override
  String get symptoms => 'அறிகுறிகள்';

  @override
  String get status => 'நிலை';

  @override
  String get dateLabel => 'தேதி';

  @override
  String get delete => 'அழி';

  @override
  String get edit => 'திருத்து';

  @override
  String get deleteHealthRecord => 'சுகாதார பதிவை அழி';

  @override
  String get deleteHealthRecordConfirm =>
      'இந்த சுகாதார பதிவை அழிக்க விரும்புகிறீர்களா?';

  @override
  String get healthRecordDeleted => 'சுகாதார பதிவு அழிக்கப்பட்டது';

  @override
  String get healthRecordSaved => 'சுகாதார பதிவு சேமிக்கப்பட்டது';

  @override
  String get vaccinationRecords => 'தடுப்பூசி பதிவுகள்';

  @override
  String get addVaccination => 'தடுப்பூசி சேர்';

  @override
  String get editVaccination => 'தடுப்பூசியை திருத்து';

  @override
  String get noVaccinationRecords =>
      'இன்னும் தடுப்பூசி பதிவுகள் எதுவும் இல்லை.';

  @override
  String get vaccineName => 'தடுப்பூசி பெயர்';

  @override
  String get dateGiven => 'தடுப்பூசி போடப்பட்ட தேதி';

  @override
  String get nextDueDate => 'அடுத்த தடுப்பூசி தேதி (விரும்பினால்)';

  @override
  String get deleteVaccination => 'தடுப்பூசி பதிவை அழி';

  @override
  String get deleteVaccinationConfirm =>
      'இந்த தடுப்பூசி பதிவை அழிக்க விரும்புகிறீர்களா?';

  @override
  String get vaccinationDeleted => 'தடுப்பூசி பதிவு அழிக்கப்பட்டது';

  @override
  String get vaccinationSaved => 'தடுப்பூசி பதிவு சேமிக்கப்பட்டது';

  @override
  String get notes => 'குறிப்புகள்';

  @override
  String get addNote => 'குறிப்பு சேர்';

  @override
  String get editNote => 'குறிப்பை திருத்து';

  @override
  String get noNotes => 'குறிப்புகள் எதுவும் சேர்க்கப்படவில்லை.';

  @override
  String get deleteNote => 'குறிப்பை அழி';

  @override
  String get deleteNoteConfirm => 'இந்த குறிப்பை அழிக்க விரும்புகிறீர்களா?';

  @override
  String get noteDeleted => 'குறிப்பு அழிக்கப்பட்டது';

  @override
  String get noteSaved => 'குறிப்பு சேமிக்கப்பட்டது';

  @override
  String get photos => 'புகைப்படங்கள்';

  @override
  String get addPhoto => 'புகைப்படம் சேர்';

  @override
  String get photoDesc =>
      'காலப்போக்கில் இந்த மாடு எப்படி மாறுகிறது என்பதைக் கண்காணிக்கவும். புதிய புகைப்படங்கள் முதலில் தோன்றும்.';

  @override
  String get noPhotos => 'இன்னும் புகைப்படங்கள் எதுவும் இல்லை.';

  @override
  String get replace => 'மாற்று';

  @override
  String get replacePhoto => 'இந்த புகைப்படத்தை மாற்றலாமா?';

  @override
  String get replacePhotoConfirm =>
      'பழைய புகைப்படம் நீக்கப்பட்டு அதற்குப் பதிலாக புதிய புகைப்படம் வைக்கப்படும்.';

  @override
  String get photoUpdated => 'புகைப்படம் புதுப்பிக்கப்பட்டது';

  @override
  String get couldNotUpdatePhoto => 'புகைப்படத்தை புதுப்பிக்க முடியவில்லை';

  @override
  String get deletePhoto => 'புகைப்படத்தை நீக்கு';

  @override
  String get deletePhotoConfirm =>
      'இந்த புகைப்படத்தை நீக்கலாமா? இது மாடு அடையாள அமைப்பிலிருந்தும் நீக்கப்படும்.';

  @override
  String get photoDeleted => 'புகைப்படம் நீக்கப்பட்டது';

  @override
  String addPhotoTo(String id) {
    return '$id இல் புகைப்படம் சேர்க்கலாமா?';
  }

  @override
  String get addPhotoConfirm =>
      'காலப்போக்கில் இந்த மாடு எப்படி மாறுகிறது என்பதைக் கண்காணிக்க இந்த புகைப்படம் இன்றைய தேதியுடன் சேமிக்கப்படும். இது எதிர்காலத்தில் மாட்டை அடையாளம் காணவும் உதவும்.';

  @override
  String get photoAdded => 'புகைப்படம் சேர்க்கப்பட்டது';

  @override
  String get couldNotAddPhoto => 'புகைப்படத்தை சேர்க்க முடியவில்லை';

  @override
  String get takePhoto => 'புகைப்படம் எடு';

  @override
  String get chooseFromGallery => 'கேலரியில் இருந்து தேர்ந்தெடு';

  @override
  String get takeOrChooseClear =>
      'இந்த மாட்டிற்கு ஒரு தெளிவான புகைப்படம் எடுக்கவும் அல்லது கேலரியில் இருந்து தேர்ந்தெடுக்கவும்.';

  @override
  String get classifyThisPhoto => 'இந்த புகைப்படத்தை வகைப்படுத்தலாமா?';

  @override
  String get classifyThisPhotoConfirm =>
      'தெளிவான, நல்ல வெளிச்சம் உள்ள முழு உடல் புகைப்படம் சிறந்த இன கணிப்பைத் தரும்.';

  @override
  String get classify => 'வகைப்படுத்து';

  @override
  String get takeOrChooseFullBody =>
      'இந்த மாட்டிற்கு ஒரு தெளிவான முழு உடல் புகைப்படம் எடுக்கவும் அல்லது கேலரியில் இருந்து தேர்ந்தெடுக்கவும்.';

  @override
  String get deleteCowRecord => 'மாடு பதிவை நீக்கு';

  @override
  String deleteCowRecordConfirm(String id) {
    return '$id மற்றும் அதன் தொடர்புடைய அனைத்து பதிவுகளையும் நீக்க விரும்புகிறீர்களா?';
  }

  @override
  String get cowRecordDeleted => 'மாடு பதிவு நீக்கப்பட்டது';

  @override
  String get cowDetails => 'மாடு விவரங்கள்';

  @override
  String get cowNotFound => 'மாடு பதிவு காணப்படவில்லை.';

  @override
  String detailsHeader(String id) {
    return '$id விவரங்கள்';
  }

  @override
  String get identifyCow => 'மாட்டை அடையாளம் காண்க';

  @override
  String get identifyTab => 'அடையாளம் காண்க';

  @override
  String get cowsTab => 'என் மாடுகள்';

  @override
  String get tapIdentify =>
      'புகைப்படம் சேர்க்கப்பட்டது. மாட்டை அடையாளம் காண்க என்பதைத் தட்டவும்.';

  @override
  String get selectImageFirst => 'முதலில் ஒரு படத்தை தேர்ந்தெடுக்கவும்.';

  @override
  String get matchesHeading => 'பொருத்தங்கள்';

  @override
  String get details => 'விவரங்கள்';

  @override
  String get unknownCow => 'அறியப்படாத மாடு';

  @override
  String get registerThisCow => 'இந்த மாட்டைப் பதிவு செய்';

  @override
  String get backButton => 'பின்னால்';

  @override
  String get noCowsFound => 'மாடுகள் எதுவும் காணப்படவில்லை';

  @override
  String get activeLabel => 'செயலில் உள்ளது';

  @override
  String get recoveredLabel => 'குணமடைந்தது';

  @override
  String givenLabel(String date) {
    return 'போடப்பட்ட தேதி: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'அடுத்த தேதி: $date';
  }

  @override
  String get tabOverview => 'கண்ணோட்டம்';

  @override
  String get tabMedical => 'மருத்துவம்';

  @override
  String get tabGalleryNotes => 'கேலரி & குறிப்புகள்';

  @override
  String dialogIdentifyAs(String id) {
    return '$id என அடையாளம் காணலாமா?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'இந்த மாடு பார்ப்பதற்கு $id போல உள்ளது (நம்பிக்கை: $confidence%). புதிய மாட்டைப் பதிவு செய்வதற்குப் பதிலாக இந்தப் புகைப்படத்தை $id இன் வரலாற்றில் சேமிக்க விரும்புகிறீர்களா?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id இல் புகைப்படத்தைச் சேமி';
  }

  @override
  String get dialogIdentifyNewCow => 'இல்லை, இது புதிய மாடு';

  @override
  String get checkingPhotoBeforeReg =>
      'பதிவு செய்வதற்கு முன் புகைப்படம் சரிபார்க்கப்படுகிறது...';

  @override
  String alreadyInHerd(String id) {
    return '$id ஏற்கனவே உங்கள் மந்தையில் உள்ளது';
  }

  @override
  String get no => 'இல்லை';

  @override
  String get yes => 'ஆம்';

  @override
  String yesAddTo(String id) {
    return 'ஆம், $id இல் சேர்';
  }

  @override
  String looksLike(String id) {
    return 'இது $id போல உள்ளது';
  }

  @override
  String get addPhotoToThat =>
      'இந்தப் புகைப்படத்தை அந்த மாட்டிற்குச் சேர்க்கலாமா?';

  @override
  String get createNewCow => 'புதிய மாட்டை உருவாக்கு';

  @override
  String get savingPhoto => 'புகைப்படம் சேமிக்கப்படுகிறது...';

  @override
  String photoAddedTo(String id) {
    return 'புகைப்படம் $id இல் சேர்க்கப்பட்டது';
  }

  @override
  String get couldNotSavePhoto => 'இந்த புகைப்படத்தை சேமிக்க முடியவில்லை.';

  @override
  String get savingCowDetails => 'மாடு விவரங்கள் சேமிக்கப்படுகின்றன...';

  @override
  String addedToHerd(String id) {
    return '$id உங்கள் மந்தையில் சேர்க்கப்பட்டது.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id வெற்றிகரமாக சேர்க்கப்பட்டது';
  }

  @override
  String get exitApp => 'செயலியில் இருந்து வெளியேறு';

  @override
  String get exitAppConfirm => 'செயலியை மூட விரும்புகிறீர்களா?';

  @override
  String get cancelled => 'ரத்து செய்யப்பட்டது.';

  @override
  String get couldNotCheckPhoto =>
      'பதிவு செய்வதற்கு முன் இந்தப் புகைப்படத்தை சரிபார்க்க முடியவில்லை.';

  @override
  String get couldNotPrepareReg => 'பதிவை தயார் செய்ய முடியவில்லை';

  @override
  String get captureImage => 'புகைப்படம் எடு';

  @override
  String get uploadImage => 'புகைப்படம் ஏற்று';

  @override
  String get identificationResult => 'அடையாளம் கண்ட முடிவு';

  @override
  String get noCowsMessage =>
      'இன்னும் மாடுகள் இல்லை.\nமுதல் மாட்டைச் சேர்க்க \'அடையாளம் காண்க\' என்பதைப் பயன்படுத்தவும்.';

  @override
  String get yourHerd => 'உங்கள் மந்தை';

  @override
  String get welcomeNotebook => 'உங்கள் கால்நடை குறிப்பேட்டிற்கு வரவேற்கிறோம்';

  @override
  String get notebookDescription =>
      'மாட்டை அடையாளம் காணவும் எளிய பதிவுகளை வைத்திருக்கவும் புகைப்படம் எடுக்கவும் அல்லது பதிவேற்றவும்.';

  @override
  String registeredCowsCount(int count) {
    return 'பதிவு செய்யப்பட்ட மாடுகள்: $count';
  }

  @override
  String get initErrorOccurred =>
      'செயலியைத் திறக்கும்போது ஏதோ தவறு நிகழ்ந்தது.';

  @override
  String get tryAgain => 'மீண்டும் முயலவும்';

  @override
  String get noPhotoSelected => 'புகைப்படம் எதுவும் தேர்ந்தெடுக்கப்படவில்லை';

  @override
  String get identifyResultPlaceholder =>
      'முடிவைக் காண மாட்டை அடையாளம் காணவும்.';

  @override
  String matchConfidence(String confidence) {
    return 'பொருத்த நம்பிக்கை: $confidence%';
  }

  @override
  String get cowAlreadyInHerd => 'இந்த மாடு ஏற்கனவே உங்கள் மந்தையில் உள்ளது.';

  @override
  String get noMatchingCowRegisterHint =>
      'பொருந்தும் மாடு எதுவும் காணப்படவில்லை. இதை நீங்கள் புதிய மாடாகச் சேர்க்கலாம்.';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'சுகாதாரம்: $health • தடுப்பூசிகள்: $vaccines • குறிப்புகள்: $notes';
  }

  @override
  String get diseaseNameLabel => 'நோயின் பெயர்';

  @override
  String get ongoing => 'செயலில் உள்ளது';

  @override
  String get recovered => 'குணமடைந்தது';

  @override
  String get symptomsOptional => 'அறிகுறிகள் (விரும்பினால்)';

  @override
  String get treatmentNotesOptional => 'சிகிச்சை குறிப்புகள் (விரும்பினால்)';

  @override
  String get saveHealthRecord => 'சுகாதார பதிவை சேமிக்கவும்';

  @override
  String get updateHealthRecord => 'சுகாதார பதிவை புதுப்பிக்கவும்';

  @override
  String get healthRecordAdded => 'சுகாதார பதிவு சேர்க்கப்பட்டது';

  @override
  String get healthRecordUpdated => 'சுகாதார பதிவு புதுப்பிக்கப்பட்டது';

  @override
  String get vaccineNameLabel => 'தடுப்பூசி பெயர்';

  @override
  String get pickDate => 'தேதியைத் தேர்ந்தெடு';

  @override
  String get nextDueNotSet => 'அடுத்த தேதி: அமைக்கப்படவில்லை';

  @override
  String get setNextDue => 'அடுத்த தேதியை அமை';

  @override
  String get notesOptional => 'குறிப்புகள் (விரும்பினால்)';

  @override
  String get saveVaccination => 'தடுப்பூசி பதிவை சேமிக்கவும்';

  @override
  String get updateVaccination => 'தடுப்பூசி பதிவை புதுப்பிக்கவும்';

  @override
  String get vaccinationAdded => 'தடுப்பூசி பதிவு சேர்க்கப்பட்டது';

  @override
  String get vaccinationUpdated => 'தடுப்பூசி பதிவு புதுப்பிக்கப்பட்டது';

  @override
  String get addNoteDialogTitle => 'குறிப்பு சேர்';

  @override
  String get noteAdded => 'குறிப்பு சேர்க்கப்பட்டது';

  @override
  String get noteUpdated => 'குறிப்பு புதுப்பிக்கப்பட்டது';

  @override
  String dateLabel2(String date) {
    return 'தேதி: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'போடப்பட்ட தேதி: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'அடுத்த தேதி: $date';
  }

  @override
  String get noSymptomsNoted => 'அறிகுறிகள் எதுவும் குறிக்கப்படவில்லை';
}
