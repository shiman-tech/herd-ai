// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'हर्ड एआई (Herd AI)';

  @override
  String get appSubtitle => 'आपकी मवेशी डायरी';

  @override
  String get preparingSecureAccess => 'सुरक्षित पहुंच तैयार की जा रही है...';

  @override
  String get createPin => '4-अंकों का पिन बनाएं';

  @override
  String get enterPin => 'अपना पिन दर्ज करें';

  @override
  String get unlockApp => 'ऐप अनलॉक करें';

  @override
  String get confirmPin => 'पिन की पुष्टि करें';

  @override
  String get pinDidNotMatchTryAgain => 'पिन मेल नहीं खाया। पुनः प्रयास करें';

  @override
  String get pinDidNotMatch => 'पिन मेल नहीं खाया';

  @override
  String get pinCreated => 'पिन बनाया गया';

  @override
  String get unlocked => 'अनलॉक किया गया';

  @override
  String get wrongPinTryAgain => 'गलत पिन। पुनः प्रयास करें';

  @override
  String get wrongPin => 'गलत पिन';

  @override
  String get usePinToUnlock => 'अनलॉक करने के लिए पिन का उपयोग करें';

  @override
  String get tryFingerprintFace => 'फ़िंगरप्रिंट/फ़ेस आज़माएं';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get changePin => 'पिन बदलें';

  @override
  String get language => 'भाषा (Language)';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get currentPin => 'वर्तमान पिन';

  @override
  String get newPin => 'नया पिन';

  @override
  String get confirmNewPin => 'नए पिन की पुष्टि करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सेटिंग्स सहेजें';

  @override
  String get wrongCurrentPin => 'गलत वर्तमान पिन';

  @override
  String get pinChanged => 'पिन बदल दिया गया';

  @override
  String get pinsDoNotMatch => 'नए पिन मेल नहीं खाते';

  @override
  String get enterAllFields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get invalidPinLength => 'पिन 4 अंकों का होना चाहिए';

  @override
  String get cowsNotebook => 'मवेशी नोटबुक';

  @override
  String get noCows => 'अभी तक कोई गाय पंजीकृत नहीं है।';

  @override
  String get searchHint => 'गाय खोजें...';

  @override
  String cowIdLabel(String id) {
    return 'गाय आईडी: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'पंजीकृत: $date';
  }

  @override
  String get readyToIdentify =>
      'गायों की पहचान करने और रिकॉर्ड रखने के लिए तैयार।';

  @override
  String get initializingDb => 'आपकी मवेशी डायरी तैयार की जा रही है...';

  @override
  String get readyText => 'पहचान के लिए तैयार';

  @override
  String get notReady =>
      'ऐप सेटअप अभी पूरा नहीं हुआ है। कृपया पुनः प्रयास करें।';

  @override
  String get selectImage => 'मॉडल लोड होने के बाद एक छवि चुनें।';

  @override
  String get checkingCow => 'गाय की जाँच की जा रही है...';

  @override
  String get cowIdentified => 'गाय की पहचान हो गई।';

  @override
  String get borderlineMatch =>
      'यह आपके पास पहले से मौजूद गाय जैसी दिखती है — नीचे देखें।';

  @override
  String get noMatchingCow => 'कोई मेल खाती गाय नहीं मिली।';

  @override
  String get couldNotIdentify => 'इस समय इस गाय की पहचान नहीं की जा सकी।';

  @override
  String get addThisCow => 'इस गाय को जोड़ें';

  @override
  String get cowId => 'गाय आईडी';

  @override
  String get optionalNote => 'नोट (वैकल्पिक)';

  @override
  String get register => 'पंजीकृत करें';

  @override
  String get addCow => 'गाय जोड़ें';

  @override
  String get cowAlreadyExists => 'गाय आईडी पहले से मौजूद है';

  @override
  String get pleaseEnterId => 'कृपया एक आईडी दर्ज करें';

  @override
  String get registering => 'पंजीकरण किया जा रही है...';

  @override
  String get cowRegistered => 'गाय पंजीकृत हो गई';

  @override
  String get failedToRegister => 'गाय का पंजीकरण नहीं किया जा सका';

  @override
  String get basicInfo => 'बुनियादी जानकारी';

  @override
  String registeredOn(String date) {
    return 'पंजीकृत: $date';
  }

  @override
  String get breedClassification => 'नस्ल वर्गीकरण (Breed)';

  @override
  String get classifyBreed => 'नस्ल का वर्गीकरण करें';

  @override
  String get reClassify => 'पुनः वर्गीकृत करें';

  @override
  String get noBreedClassificationYet =>
      'अभी तक कोई नस्ल वर्गीकरण नहीं है। पूरी शारीरिक तस्वीर लें।';

  @override
  String confirmedBreed(String breed) {
    return 'पुष्टि की गई नस्ल: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'कम विश्वास — अधिक स्पष्ट पूरे शरीर की तस्वीर का प्रयास करें।';

  @override
  String get setManually => 'मैन्युअल रूप से सेट करें';

  @override
  String get unknownMixed => 'अज्ञात / मिश्रित';

  @override
  String get likelyBreedsVisual => 'संभावित नस्लें (दृश्य अनुमान):';

  @override
  String confirmBreed(String breed) {
    return '$breed की पुष्टि करें';
  }

  @override
  String get chooseDifferent => 'दूसरा चुनें';

  @override
  String get breedClassified => 'नस्ल का वर्गीकरण हो गया';

  @override
  String get couldNotClassify => 'नस्ल का वर्गीकरण नहीं किया जा सका';

  @override
  String get noBreedPredictions => 'कोई नस्ल अनुमान प्राप्त नहीं हुआ';

  @override
  String breedConfirmed(String breed) {
    return 'पुष्टि की गई नस्ल: $breed';
  }

  @override
  String get chooseBreed => 'नस्ल चुनें';

  @override
  String get orTypeBreedName => 'या नस्ल का नाम टाइप करें:';

  @override
  String get confirmCustomBreed => 'कस्टम नस्ल की पुष्टि करें';

  @override
  String get customBreedHint => 'जैसे: जर्सी क्रॉस';

  @override
  String get breedSetUnknown => 'नस्ल को अज्ञात/मिश्रित पर सेट किया गया';

  @override
  String get healthRecords => 'स्वास्थ्य रिकॉर्ड';

  @override
  String get addHealthRecord => 'स्वास्थ्य रिकॉर्ड जोड़ें';

  @override
  String get editHealthRecord => 'स्वास्थ्य रिकॉर्ड संपादित करें';

  @override
  String get noHealthRecords => 'अभी तक कोई स्वास्थ्य रिकॉर्ड नहीं है।';

  @override
  String get diseaseName => 'बीमारी का नाम';

  @override
  String get symptoms => 'लक्षण';

  @override
  String get status => 'स्थिति';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get deleteHealthRecord => 'स्वास्थ्य रिकॉर्ड हटाएं';

  @override
  String get deleteHealthRecordConfirm =>
      'क्या आप इस स्वास्थ्य रिकॉर्ड को हटाना चाहते हैं?';

  @override
  String get healthRecordDeleted => 'स्वास्थ्य रिकॉर्ड हटा दिया गया';

  @override
  String get healthRecordSaved => 'स्वास्थ्य रिकॉर्ड सहेज लिया गया';

  @override
  String get vaccinationRecords => 'टीकाकरण रिकॉर्ड';

  @override
  String get addVaccination => 'टीकाकरण जोड़ें';

  @override
  String get editVaccination => 'टीकाकरण संपादित करें';

  @override
  String get noVaccinationRecords => 'अभी तक कोई टीकाकरण रिकॉर्ड नहीं है।';

  @override
  String get vaccineName => 'टीके का नाम';

  @override
  String get dateGiven => 'टीकाकरण की तारीख';

  @override
  String get nextDueDate => 'अगली देय तिथि (वैकल्पिक)';

  @override
  String get deleteVaccination => 'टीकाकरण हटाएं';

  @override
  String get deleteVaccinationConfirm =>
      'क्या आप इस टीकाकरण रिकॉर्ड को हटाना चाहते हैं?';

  @override
  String get vaccinationDeleted => 'टीकाकरण हटा दिया गया';

  @override
  String get vaccinationSaved => 'टीकाकरण सहेज लिया गया';

  @override
  String get notes => 'टिप्पणियाँ (Notes)';

  @override
  String get addNote => 'टिप्पणी जोड़ें';

  @override
  String get editNote => 'टिप्पणी संपादित करें';

  @override
  String get noNotes => 'कोई टिप्पणी नहीं जोड़ी गई।';

  @override
  String get deleteNote => 'टिप्पणी हटाएं';

  @override
  String get deleteNoteConfirm => 'क्या आप इस टिप्पणी को हटाना चाहते हैं?';

  @override
  String get noteDeleted => 'टिप्पणी हटा दी गई';

  @override
  String get noteSaved => 'टिप्पणी सहेज ली गई';

  @override
  String get photos => 'तस्वीरें';

  @override
  String get addPhoto => 'तस्वीर जोड़ें';

  @override
  String get photoDesc =>
      'ट्रैक करें कि यह गाय समय के साथ कैसी दिखती है। नवीनतम तस्वीरें पहले दिखाई देती हैं।';

  @override
  String get noPhotos => 'अभी तक कोई तस्वीर नहीं है।';

  @override
  String get replace => 'बदलें';

  @override
  String get replacePhoto => 'इस तस्वीर को बदलें?';

  @override
  String get replacePhotoConfirm =>
      'पुरानी तस्वीर हटा दी जाएगी और उसकी जगह नई तस्वीर ले ली जाएगी।';

  @override
  String get photoUpdated => 'तस्वीर अपडेट कर दी गई';

  @override
  String get couldNotUpdatePhoto => 'तस्वीर अपडेट नहीं की जा सकी';

  @override
  String get deletePhoto => 'तस्वीर हटाएं';

  @override
  String get deletePhotoConfirm =>
      'इस तस्वीर को हटाएं? इसे गाय की पहचान से भी हटा दिया जाएगा।';

  @override
  String get photoDeleted => 'तस्वीर हटा दी गई';

  @override
  String addPhotoTo(String id) {
    return 'क्या $id में तस्वीर जोड़ें?';
  }

  @override
  String get addPhotoConfirm =>
      'यह तस्वीर आज की तारीख के साथ सहेजी जाएगी ताकि आप ट्रैक कर सकें कि यह गाय समय के साथ कैसी दिखती है। इससे भविष्य में इस गाय की पहचान करने में भी मदद मिलेगी।';

  @override
  String get photoAdded => 'तस्वीर जोड़ दी गई';

  @override
  String get couldNotAddPhoto => 'तस्वीर नहीं जोड़ी जा सकी';

  @override
  String get takePhoto => 'तस्वीर लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get takeOrChooseClear =>
      'इस गाय की एक स्पष्ट तस्वीर लें या गैलरी से चुनें।';

  @override
  String get classifyThisPhoto => 'इस तस्वीर का वर्गीकरण करें?';

  @override
  String get classifyThisPhotoConfirm =>
      'एक स्पष्ट, अच्छी रोशनी वाली पूरे शरीर की तस्वीर सबसे अच्छा नस्ल अनुमान देती है।';

  @override
  String get classify => 'वर्गीकरण करें';

  @override
  String get takeOrChooseFullBody =>
      'इस गाय की एक स्पष्ट पूरे शरीर की तस्वीर लें या गैलरी से चुनें।';

  @override
  String get deleteCowRecord => 'गाय का रिकॉर्ड हटाएं';

  @override
  String deleteCowRecordConfirm(String id) {
    return 'क्या आप $id और उससे संबंधित सभी रिकॉर्ड हटाना चाहते हैं?';
  }

  @override
  String get cowRecordDeleted => 'गाय का रिकॉर्ड हटा दिया गया';

  @override
  String get cowDetails => 'गाय का विवरण';

  @override
  String get cowNotFound => 'गाय का रिकॉर्ड नहीं मिला।';

  @override
  String detailsHeader(String id) {
    return '$id का विवरण';
  }

  @override
  String get identifyCow => 'गाय की पहचान करें';

  @override
  String get identifyTab => 'पहचान';

  @override
  String get cowsTab => 'मवेशी';

  @override
  String get tapIdentify => 'तस्वीर जोड़ दी गई। गाय की पहचान करें पर टैप करें।';

  @override
  String get selectImageFirst => 'पहले एक छवि चुनें।';

  @override
  String get matchesHeading => 'संभावित मिलान (Matches)';

  @override
  String get details => 'विवरण';

  @override
  String get unknownCow => 'अज्ञात गाय';

  @override
  String get registerThisCow => 'इस गाय को पंजीकृत करें';

  @override
  String get backButton => 'पीछे';

  @override
  String get noCowsFound => 'कोई गाय नहीं मिली';

  @override
  String get activeLabel => 'सक्रिय';

  @override
  String get recoveredLabel => 'ठीक हो चुका';

  @override
  String givenLabel(String date) {
    return 'दिया गया: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'अगली देय तिथि: $date';
  }

  @override
  String get tabOverview => 'अवलोकन';

  @override
  String get tabMedical => 'चिकित्सा';

  @override
  String get tabGalleryNotes => 'गैलरी और नोट्स';

  @override
  String dialogIdentifyAs(String id) {
    return 'क्या $id के रूप में पहचान करें?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'यह गाय $id से काफी मिलती-जुलती है (विश्वास: $confidence%)। क्या आप इस तस्वीर को एक नई गाय पंजीकृत करने के बजाय $id के इतिहास में सहेजना चाहते हैं?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id में तस्वीर सहेजें';
  }

  @override
  String get dialogIdentifyNewCow => 'नहीं, यह एक नई गाय है';

  @override
  String get checkingPhotoBeforeReg =>
      'पंजीकरण से पहले तस्वीर की जांच की जा रही है...';

  @override
  String alreadyInHerd(String id) {
    return '$id आपकी मवेशी नोटबुक में पहले से मौजूद है';
  }

  @override
  String get no => 'नहीं';

  @override
  String get yes => 'हाँ';

  @override
  String yesAddTo(String id) {
    return 'हाँ, $id में जोड़ें';
  }

  @override
  String looksLike(String id) {
    return 'यह $id जैसा लग रहा है';
  }

  @override
  String get addPhotoToThat => 'क्या इस तस्वीर को उस गाय में जोड़ें?';

  @override
  String get createNewCow => 'नई गाय जोड़ें';

  @override
  String get savingPhoto => 'तस्वीर सहेजी जा रही है...';

  @override
  String photoAddedTo(String id) {
    return 'तस्वीर को $id में जोड़ दिया गया';
  }

  @override
  String get couldNotSavePhoto => 'यह तस्वीर सहेजी नहीं जा सकी।';

  @override
  String get savingCowDetails => 'गाय का विवरण सहेजा जा रहा है...';

  @override
  String addedToHerd(String id) {
    return '$id को मवेशी नोटबुक में जोड़ा गया।';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id सफलतापूर्वक जोड़ दिया गया';
  }

  @override
  String get exitApp => 'ऐप बंद करें';

  @override
  String get exitAppConfirm => 'क्या आप ऐप बंद करना चाहते हैं?';

  @override
  String get cancelled => 'रद्द कर दिया गया।';

  @override
  String get couldNotCheckPhoto =>
      'पंजीकरण से पहले इस तस्वीर की जांच नहीं की जा सकी।';

  @override
  String get couldNotPrepareReg => 'पंजीकरण की तैयारी नहीं की जा सकी';

  @override
  String get captureImage => 'तस्वीर खींचें';

  @override
  String get uploadImage => 'तस्वीर अपलोड करें';

  @override
  String get identificationResult => 'पहचान का परिणाम';

  @override
  String get noCowsMessage =>
      'कोई गाय नहीं मिली।\nगाय जोड़ने के लिए पहले \'पहचान\' का उपयोग करें।';

  @override
  String get yourHerd => 'आपका झुंड';

  @override
  String get welcomeNotebook => 'मवेशी डायरी में आपका स्वागत है';

  @override
  String get notebookDescription =>
      'गाय की पहचान करने और रिकॉर्ड रखने के लिए तस्वीर लें या अपलोड करें।';

  @override
  String registeredCowsCount(int count) {
    return 'पंजीकृत गायें: $count';
  }

  @override
  String get initErrorOccurred => 'ऐप शुरू करते समय कुछ गलत हुआ।';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get noPhotoSelected => 'कोई तस्वीर नहीं चुनी गई';

  @override
  String get identifyResultPlaceholder =>
      'पहचान देखने के लिए पहले गाय की तस्वीर जांचें।';

  @override
  String matchConfidence(String confidence) {
    return 'मिलान विश्वास: $confidence%';
  }

  @override
  String get cowAlreadyInHerd => 'यह गाय आपकी नोटबुक में पहले से मौजूद है।';

  @override
  String get noMatchingCowRegisterHint =>
      'कोई मेल खाती गाय नहीं मिली। आप इसे नई गाय के रूप में जोड़ सकते हैं।';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'स्वास्थ्य: $health • टीकाकरण: $vaccines • टिप्पणियाँ: $notes';
  }

  @override
  String get diseaseNameLabel => 'बीमारी का नाम';

  @override
  String get ongoing => 'सक्रिय';

  @override
  String get recovered => 'ठीक हो चुका';

  @override
  String get symptomsOptional => 'लक्षण (वैकल्पिक)';

  @override
  String get treatmentNotesOptional => 'उपचार नोट्स (वैकल्पिक)';

  @override
  String get saveHealthRecord => 'स्वास्थ्य रिकॉर्ड सहेजें';

  @override
  String get updateHealthRecord => 'स्वास्थ्य रिकॉर्ड अपडेट करें';

  @override
  String get healthRecordAdded => 'स्वास्थ्य रिकॉर्ड जोड़ दिया गया';

  @override
  String get healthRecordUpdated => 'स्वास्थ्य रिकॉर्ड अपडेट कर दिया गया';

  @override
  String get vaccineNameLabel => 'टीके का नाम';

  @override
  String get pickDate => 'तारीख चुनें';

  @override
  String get nextDueNotSet => 'अगली तारीख: सेट नहीं है';

  @override
  String get setNextDue => 'अगली देय तिथि तय करें';

  @override
  String get notesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get saveVaccination => 'टीकाकरण सहेजें';

  @override
  String get updateVaccination => 'टीकाकरण अपडेट करें';

  @override
  String get vaccinationAdded => 'टीकाकरण जोड़ दिया गया';

  @override
  String get vaccinationUpdated => 'टीकाकरण अपडेट कर दिया गया';

  @override
  String get addNoteDialogTitle => 'टिप्पणी जोड़ें';

  @override
  String get noteAdded => 'टिप्पणी जोड़ दी गई';

  @override
  String get noteUpdated => 'टिप्पणी अपडेट कर दी गई';

  @override
  String dateLabel2(String date) {
    return 'तारीख: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'दिया गया: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'अगली तारीख: $date';
  }

  @override
  String get noSymptomsNoted => 'कोई लक्षण दर्ज नहीं';
}
