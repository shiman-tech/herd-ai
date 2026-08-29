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
  String get cattleNotebook => 'मवेशी नोटबुक';

  @override
  String get noCattles => 'अभी तक कोई गाय पंजीकृत नहीं है।';

  @override
  String get searchHint => 'गाय खोजें...';

  @override
  String cattleIdLabel(String id) {
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
  String get checkingCattle => 'गाय की जाँच की जा रही है...';

  @override
  String get cattleIdentified => 'गाय की पहचान हो गई।';

  @override
  String get borderlineMatch =>
      'यह आपके पास पहले से मौजूद गाय जैसी दिखती है — नीचे देखें।';

  @override
  String get noMatchingCattle => 'कोई मेल खाती गाय नहीं मिली।';

  @override
  String get couldNotIdentify => 'इस समय इस गाय की पहचान नहीं की जा सकी।';

  @override
  String get addThisCattle => 'इस गाय को जोड़ें';

  @override
  String get cattleId => 'गाय आईडी';

  @override
  String get optionalNote => 'नोट (वैकल्पिक)';

  @override
  String get register => 'पंजीकृत करें';

  @override
  String get addCattle => 'गाय जोड़ें';

  @override
  String get cattleAlreadyExists => 'गाय आईडी पहले से मौजूद है';

  @override
  String get pleaseEnterId => 'कृपया एक आईडी दर्ज करें';

  @override
  String get registering => 'पंजीकरण किया जा रही है...';

  @override
  String get cattleRegistered => 'गाय पंजीकृत हो गई';

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
  String get cattleIdentification => 'पशु पहचान';

  @override
  String get cattleIdentificationDesc =>
      'इस पशु को पहचानने के लिए चेहरे की तस्वीरें जोड़ें।';

  @override
  String get noIdentityPhotos => 'अभी तक कोई चेहरे की तस्वीर नहीं जोड़ी गई है।';

  @override
  String get addFacialPhoto => 'फ़ोटो जोड़ें';

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
  String get galleryPhotoConfirm =>
      'यह तस्वीर इस पशु की बनावट व विकास को समय के साथ ट्रैक करने के लिए सहेजी जाएगी।';

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
  String get deleteCattleRecord => 'गाय का रिकॉर्ड हटाएं';

  @override
  String deleteCattleRecordConfirm(String id) {
    return 'क्या आप $id और उससे संबंधित सभी रिकॉर्ड हटाना चाहते हैं?';
  }

  @override
  String get cattleRecordDeleted => 'गाय का रिकॉर्ड हटा दिया गया';

  @override
  String get cattleDetails => 'गाय का विवरण';

  @override
  String get cattleNotFound => 'गाय का रिकॉर्ड नहीं मिला।';

  @override
  String detailsHeader(String id) {
    return '$id का विवरण';
  }

  @override
  String get identifyCattle => 'गाय की पहचान करें';

  @override
  String get identifyTab => 'पहचान';

  @override
  String get cattleTab => 'मवेशी';

  @override
  String get tapIdentify => 'तस्वीर जोड़ दी गई। गाय की पहचान करें पर टैप करें।';

  @override
  String get selectImageFirst => 'पहले एक छवि चुनें।';

  @override
  String get matchesHeading => 'संभावित मिलान (Matches)';

  @override
  String get details => 'विवरण';

  @override
  String get unknownCattle => 'अज्ञात गाय';

  @override
  String get registerThisCattle => 'इस गाय को पंजीकृत करें';

  @override
  String get backButton => 'पीछे';

  @override
  String get noCattlesFound => 'कोई गाय नहीं मिली';

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
  String get dialogIdentifyNewCattle => 'नहीं, यह एक नई गाय है';

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
  String get createNewCattle => 'नई गाय जोड़ें';

  @override
  String get savingPhoto => 'तस्वीर सहेजी जा रही है...';

  @override
  String photoAddedTo(String id) {
    return 'तस्वीर को $id में जोड़ दिया गया';
  }

  @override
  String get couldNotSavePhoto => 'यह तस्वीर सहेजी नहीं जा सकी।';

  @override
  String get savingCattleDetails => 'गाय का विवरण सहेजा जा रहा है...';

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
  String get noCattlesMessage =>
      'कोई गाय नहीं मिली।\nगाय जोड़ने के लिए पहले \'पहचान\' का उपयोग करें।';

  @override
  String get yourHerd => 'आपका झुंड';

  @override
  String get welcomeNotebook => 'मवेशी डायरी में आपका स्वागत है';

  @override
  String get notebookDescription =>
      'गाय की पहचान करने और रिकॉर्ड रखने के लिए तस्वीर लें या अपलोड करें।';

  @override
  String registeredCattlesCount(int count) {
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
  String get cattleAlreadyInHerd => 'यह गाय आपकी नोटबुक में पहले से मौजूद है।';

  @override
  String get noMatchingCattleRegisterHint =>
      'कोई मेल खाती गाय नहीं मिली। आप इसे नई गाय के रूप में जोड़ सकते हैं।';

  @override
  String cattleSummarySubtitle(int health, int vaccines, int notes) {
    return 'स्वास्थ्य: $health • टीकाकरण: $vaccines • टिप्पणियाँ: $notes';
  }

  @override
  String get diseaseNameLabel => 'बीमारी का नाम';

  @override
  String get ongoing => 'सक्रिय';

  @override
  String get recovered => 'ठीक हो गया';

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

  @override
  String get milkYieldTab => 'दूध उत्पादन';

  @override
  String get milkAndLactationTitle => 'दूध एवं दुग्धकाल';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get filterButton => 'फ़िल्टर';

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String showingCattleCount(int filtered, int total) {
    return '$total में से $filtered पशु दिखाए जा रहे हैं';
  }

  @override
  String get noCattleMatchFilter => 'चुने गए फ़िल्टर से कोई पशु मेल नहीं खाता।';

  @override
  String get resetSearchAndFilters => 'खोज और फ़िल्टर रीसेट करें';

  @override
  String get filterAndSortCattle => 'पशु फ़िल्टर और क्रमबद्ध करें';

  @override
  String get sortOrder => 'क्रम';

  @override
  String get resetAll => 'सब रीसेट करें';

  @override
  String showMatchingCattle(int count) {
    return '$count पशु दिखाएं';
  }

  @override
  String get sexLabel => 'लिंग';

  @override
  String get lifeStageLabel => 'जीवन चरण';

  @override
  String get healthStatusLabel => 'स्वास्थ्य स्थिति';

  @override
  String get reproductiveStatusLabel => 'प्रजनन स्थिति';

  @override
  String get vaccinationStatusLabel => 'टीकाकरण';

  @override
  String get milkAndLactation => 'दूध एवं दुग्धकाल';

  @override
  String get breedCategory => 'नस्ल';

  @override
  String get female => 'मादा';

  @override
  String get male => 'नर';

  @override
  String get calf => 'बछड़ा/बछड़ी';

  @override
  String get heifer => 'बछिया (हीफ़र)';

  @override
  String get cow => 'गाय';

  @override
  String get bull => 'सांड';

  @override
  String get steer => 'बैल';

  @override
  String get healthy => 'स्वस्थ';

  @override
  String get underObservation => 'निगरानी में';

  @override
  String get diseased => 'बीमार';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get pregnant => 'गर्भवती';

  @override
  String get notPregnant => 'गर्भवती नहीं';

  @override
  String get upToDate => 'अद्यतन';

  @override
  String get dueSoon => 'शीघ्र देय';

  @override
  String get overdue => 'अतिदेय';

  @override
  String get noRecord => 'कोई रिकॉर्ड नहीं';

  @override
  String get milkingCows => 'दुधारू गायें';

  @override
  String get dryCows => 'सूखी गायें';

  @override
  String get highProducers => 'उच्च उत्पादक (>15 ली/दिन)';

  @override
  String get mediumProducers => 'मध्यम उत्पादक (8–15 ली/दिन)';

  @override
  String get lowProducers => 'कम उत्पादक (<8 ली/दिन)';

  @override
  String get recentlyCalved => 'हाल ही में ब्याही';

  @override
  String get sortRecentlyAdded => 'हाल ही में जोड़े गए';

  @override
  String get sortOldestAdded => 'सबसे पुराने';

  @override
  String get sortNameAsc => 'आईडी (A → Z)';

  @override
  String get sortNameDesc => 'आईडी (Z → A)';

  @override
  String get sortAgeAsc => 'उम्र (छोटे से बड़े)';

  @override
  String get sortAgeDesc => 'उम्र (बड़े से छोटे)';

  @override
  String get todaysMilkProduction => 'आज का दूध उत्पादन';

  @override
  String cowsMilked(int count) {
    return '$count गायों का दूध निकाला गया';
  }

  @override
  String get liters => 'लीटर';

  @override
  String get averagePerCow => 'औसत / गाय';

  @override
  String topProducer(String id, String yield) {
    return 'शीर्ष: #$id ($yield ली)';
  }

  @override
  String get topProducerNone => 'शीर्ष उत्पादक: अभी कोई नहीं';

  @override
  String lowestProducer(String id, String yield) {
    return 'न्यूनतम: #$id ($yield ली)';
  }

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get milkingHerd => 'दुधारू समूह';

  @override
  String cowsCount(int count) {
    return '$count गायें';
  }

  @override
  String get recordMilk => 'दूध दर्ज करें';

  @override
  String get reports => 'रिपोर्ट्स';

  @override
  String get productionAnalytics => 'उत्पादन विश्लेषण';

  @override
  String get milkHistory => 'दूध का इतिहास';

  @override
  String daysLogged(int count) {
    return '$count दिन दर्ज';
  }

  @override
  String get noMilkRecordsSavedYet =>
      'अभी कोई दूध रिकॉर्ड नहीं है। शुरू करने के लिए \'दूध दर्ज करें\' पर टैप करें।';

  @override
  String get breedAnalyticsFilter => 'नस्ल विश्लेषण फ़िल्टर:';

  @override
  String get allBreeds => 'सभी नस्लें';

  @override
  String cowsRecordedCount(int count, String plural) {
    return '$count गाय दर्ज';
  }

  @override
  String get morningShort => 'सुबह';

  @override
  String get eveningShort => 'शाम';

  @override
  String get editMilkRecord => 'दूध रिकॉर्ड संपादित करें';

  @override
  String get recordMilkYield => 'दूध की मात्रा दर्ज करें';

  @override
  String get recordExistsWarning =>
      'इस गाय के लिए इस तारीख का रिकॉर्ड पहले से मौजूद है। सहेजने पर यह अपडेट हो जाएगा।';

  @override
  String get cattleLabel => 'पशु';

  @override
  String get selectCow => 'गाय चुनें';

  @override
  String get milkingBadge => 'दुधारू';

  @override
  String get recordDate => 'रिकॉर्ड की तारीख';

  @override
  String get morningLiters => 'सुबह (लीटर)';

  @override
  String get eveningLiters => 'शाम (लीटर)';

  @override
  String get totalDailyYield => 'कुल दैनिक उत्पादन';

  @override
  String get notesOptionalMilk => 'टिप्पणी (वैकल्पिक)';

  @override
  String get notesHintMilk => 'उदा. हरा चारा दिया, सामान्य भूख';

  @override
  String get updateRecord => 'रिकॉर्ड अपडेट करें';

  @override
  String get saveRecordButton => 'रिकॉर्ड सहेजें';

  @override
  String get pleaseSelectCattle => 'कृपया एक पशु चुनें';

  @override
  String get milkProductionReports => 'दूध उत्पादन रिपोर्ट';

  @override
  String breedFilterBadge(String breed) {
    return 'नस्ल फ़िल्टर: $breed';
  }

  @override
  String get dailyTab => 'दैनिक';

  @override
  String get weeklyTab => 'साप्ताहिक';

  @override
  String get monthlyTab => 'मासिक';

  @override
  String get reportDateLabel => 'रिपोर्ट दिनांक: ';

  @override
  String get weekStartLabel => 'सप्ताह प्रारंभ: ';

  @override
  String downloadCsvReport(String type) {
    return '$type CSV रिपोर्ट डाउनलोड करें';
  }

  @override
  String reportSaved(String fileName) {
    return 'रिपोर्ट सहेजी गई: $fileName';
  }

  @override
  String get reportCopied => 'रिपोर्ट क्लिपबोर्ड पर कॉपी हो गई!';

  @override
  String get dailyAvg => 'दैनिक औसत';

  @override
  String get totalYieldLabel => 'कुल उत्पादन';

  @override
  String get bestLabel => 'सर्वोत्तम';

  @override
  String get worstLabel => 'न्यूनतम';

  @override
  String get orderLabel => 'क्रम:';

  @override
  String get bestToWorst => 'सर्वोत्तम → न्यूनतम';

  @override
  String get worstToBest => 'न्यूनतम → सर्वोत्तम';

  @override
  String noMilkRecordsForPeriod(String breedText) {
    return 'इस अवधि के लिए कोई दूध रिकॉर्ड नहीं मिला$breedText।';
  }

  @override
  String recordedOutOfDays(int recorded, int total) {
    return 'दर्ज: $recorded/$total दिन';
  }

  @override
  String recordedEntriesCount(int count) {
    return 'दर्ज: $count प्रविष्टियां';
  }

  @override
  String morningEveningBreakdown(String morning, String evening) {
    return 'सुबह: $morning ली  •  शाम: $evening ली';
  }

  @override
  String get notificationsAndSmartAlerts => 'सूचनाएं एवं स्मार्ट अलर्ट';

  @override
  String get allClear => 'सब साफ़ है!';

  @override
  String get noPendingAlerts => 'कोई लंबित सूचना या अलर्ट नहीं है।';

  @override
  String get viewAction => 'देखें';

  @override
  String get recordMilkAction => 'दूध दर्ज करें';

  @override
  String get logCalvingAction => 'प्रसव दर्ज करें';

  @override
  String get vaccinateAction => 'टीका लगाएं';

  @override
  String get editCattleDetails => 'पशु विवरण संपादित करें';

  @override
  String get dateOfBirthAge => 'जन्म तिथि (उम्र)';

  @override
  String get notSet => 'सेट नहीं है';

  @override
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural) {
    return '$years वर्ष $months महीने';
  }

  @override
  String yearsAge(int years, String yPlural) {
    return '$years वर्ष';
  }

  @override
  String monthsAge(int months, String mPlural) {
    return '$months महीने';
  }

  @override
  String get unknownAge => 'अज्ञात उम्र';

  @override
  String get milkAndLactationProfile => 'दूध एवं दुग्धकाल प्रोफ़ाइल';

  @override
  String get currentlyMilking => 'वर्तमान में दुधारू';

  @override
  String get lastCalvingDate => 'अंतिम प्रसव तिथि';

  @override
  String get inseminationDate => 'गर्भाधान तिथि';

  @override
  String get expectedDailyYieldBenchmark => 'अपेक्षित दैनिक उपज (मानक)';

  @override
  String get benchmarkHint => 'उदा. 15.0';

  @override
  String get symptomsHint => 'उदा. ठीक से चारा नहीं खा रही';

  @override
  String get cattleDetailsUpdated => 'पशु विवरण अपडेट हो गया';

  @override
  String get milkProductionTab => 'दूध उत्पादन';

  @override
  String get lactationStatus => 'दुग्धकाल स्थिति';

  @override
  String get daysInMilk => 'दूध देने के दिन (DIM)';

  @override
  String daysUnit(int count) {
    return '$count दिन';
  }

  @override
  String get lastCalving => 'अंतिम प्रसव';

  @override
  String get estNextCalving => 'अनुमानित अगला प्रसव';

  @override
  String get thirtyDayAverage => '30-दिन का औसत';

  @override
  String get totalThisMonth => 'इस महीने का कुल';

  @override
  String get recentMilkYieldTrend => 'हालिया दूध उत्पादन रुझान';

  @override
  String get dailyMilkRecords => 'दैनिक दूध रिकॉर्ड';

  @override
  String get noDailyMilkRecords =>
      'इस गाय के लिए अभी तक कोई दैनिक दूध रिकॉर्ड दर्ज नहीं है।';

  @override
  String litersPerDay(String yield) {
    return '$yield ली/दिन';
  }

  @override
  String get freshStage => 'ताज़ा (Fresh)';

  @override
  String get earlyStage => 'शुरुआती (Early)';

  @override
  String get midStage => 'मध्य (Mid)';

  @override
  String get lateStage => 'अंतिम (Late)';

  @override
  String get extendedStage => 'विस्तारित दुग्धकाल';

  @override
  String get dryStage => 'सूखा काल (Dry)';

  @override
  String stageSuffix(String stage) {
    return '$stage चरण';
  }

  @override
  String get calvingDateOverdue => 'प्रसव तिथि अतिदेय';

  @override
  String calvingOverdueMessage(String date) {
    return 'अपेक्षित प्रसव तिथि ($date) बीत चुकी है। प्रसव जानकारी या गर्भावस्था की स्थिति अपडेट करें।';
  }

  @override
  String get logCalving => 'प्रसव दर्ज करें';

  @override
  String get predictedBreed => 'अनुमानित नस्ल';

  @override
  String get noMilkChartRecords =>
      'अभी कोई दूध रिकॉर्ड नहीं है।\nउत्पादन रुझान देखने के लिए रिकॉर्डिंग शुरू करें।';

  @override
  String get setAsUnknown => 'अज्ञात के रूप में सेट करें';

  @override
  String breedPredictionItem(String name, int percent) {
    return '• $name — $percent%';
  }

  @override
  String get sexRequired => 'लिंग *';

  @override
  String get optionalNoteHint => 'उदा. गर्भवती';

  @override
  String get missingMilkEntryToday => 'आज दूध दर्ज नहीं हुआ';

  @override
  String missingMilkEntryTitle(String date) {
    return 'दूध दर्ज नहीं ($date)';
  }

  @override
  String noMilkRecordEntered(String dateLabel, String id) {
    return '$dateLabel को #$id के लिए कोई दूध दर्ज नहीं किया गया।';
  }

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String onDate(String date) {
    return '$date को';
  }

  @override
  String get lowYieldAlertTitle => 'कम उत्पादन अलर्ट';

  @override
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  ) {
    return '#$id का दूध उत्पादन $percent% घटा ($latest ली बनाम $avg ली औसत)।';
  }

  @override
  String get dryOffReminderTitle => 'दूध सुखाने का अलर्ट';

  @override
  String dryOffReminderMessage(String id, int days) {
    return '#$id के $days दिनों में ब्याने की उम्मीद है। गाय को शुष्क काल के लिए तैयार करें।';
  }

  @override
  String get calvingDateOverdueTitle => 'प्रसव तिथि अतिदेय';

  @override
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  ) {
    return '#$id की अपेक्षित प्रसव तिथि $days दिन पहले थी ($date)। प्रसव जानकारी अपडेट करें।';
  }

  @override
  String get calvingReminderTitle => 'प्रसव स्मरणपत्र';

  @override
  String calvingReminderMessage(String id, int days, String plural) {
    return '#$id का प्रसव $days दिनों में होने वाला है। बाड़े को तैयार करें।';
  }

  @override
  String get vaccinationOverdueTitle => 'टीकाकरण अतिदेय';

  @override
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days दिन पहले लगाया जाना था ($date)।';
  }

  @override
  String get vaccinationDueSoonTitle => 'टीकाकरण देय';

  @override
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days दिनों में देय है ($date)।';
  }
}
