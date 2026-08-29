// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'हर्ड एआय (Herd AI)';

  @override
  String get appSubtitle => 'तुमची गुरे नोंदवही';

  @override
  String get preparingSecureAccess => 'सुरक्षित प्रवेश तयार केला जात आहे...';

  @override
  String get createPin => '৪-अंकी पिन तयार करा';

  @override
  String get enterPin => 'तुमचा पिन प्रविष्ट करा';

  @override
  String get unlockApp => 'अ‍ॅप अनलॉक करा';

  @override
  String get confirmPin => 'पिनची पुष्टी करा';

  @override
  String get pinDidNotMatchTryAgain => 'पिन जुळला नाही. पुन्हा प्रयत्न करा';

  @override
  String get pinDidNotMatch => 'पिन जुळला नाही';

  @override
  String get pinCreated => 'पिन तयार केला';

  @override
  String get unlocked => 'अनलॉक केले';

  @override
  String get wrongPinTryAgain => 'चुकीचा पिन. पुन्हा प्रयत्न करा';

  @override
  String get wrongPin => 'चुकीचा पिन';

  @override
  String get usePinToUnlock => 'अनलॉक करण्यासाठी पिन वापरा';

  @override
  String get tryFingerprintFace => 'फिंगरप्रिंट/फेस आयडी वापरून पहा';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get changePin => 'पिन बदला';

  @override
  String get language => 'भाषा (Language)';

  @override
  String get selectLanguage => 'भाषा निवडा';

  @override
  String get currentPin => 'सध्याचा पिन';

  @override
  String get newPin => 'नवीन पिन';

  @override
  String get confirmNewPin => 'नवीन पिनची पुष्टी करा';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get wrongCurrentPin => 'चुकीचा सध्याचा पिन';

  @override
  String get pinChanged => 'पिन बदलला';

  @override
  String get pinsDoNotMatch => 'नवीन पिन जुळत नाहीत';

  @override
  String get enterAllFields => 'कृपया सर्व रकाने भरा';

  @override
  String get invalidPinLength => 'पिन ४ अंकी असणे आवश्यक आहे';

  @override
  String get cattleNotebook => 'गुरांची नोंदवही';

  @override
  String get noCattles => 'अजून कोणतीही गाय नोंदणीकृत नाही.';

  @override
  String get searchHint => 'तुमचा कळप शोधा...';

  @override
  String cattleIdLabel(String id) {
    return 'गाय आयडी: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'नोंदणीकृत: $date';
  }

  @override
  String get readyToIdentify => 'गाय ओळखण्यासाठी आणि नोंदी ठेवण्यासाठी तयार.';

  @override
  String get initializingDb => 'तुमची गुरे नोंदवही तयार केली जात आहे...';

  @override
  String get readyText => 'ओळखण्यासाठी तयार';

  @override
  String get notReady =>
      'अ‍ॅप सेटअप अजून पूर्ण झालेला नाही. पुन्हा प्रयत्न करा.';

  @override
  String get selectImage => 'मॉडेल लोड झाल्यावर प्रतिमा निवडा.';

  @override
  String get checkingCattle => 'गाय तपासत आहे...';

  @override
  String get cattleIdentified => 'गाय ओळखली गेली.';

  @override
  String get borderlineMatch =>
      'ही तुमच्याकडे आधीपासून असलेल्या गायीसारखी दिसत आहे — खाली पहा.';

  @override
  String get noMatchingCattle => 'कोणतीही जुळणारी गाय आढळली नाही.';

  @override
  String get couldNotIdentify => 'या वेळी ही गाय ओळखता आली नाही.';

  @override
  String get addThisCattle => 'ही गाय जोडा';

  @override
  String get cattleId => 'गाय आयडी';

  @override
  String get optionalNote => 'नोंद (पर्यायी)';

  @override
  String get register => 'नोंदणी करा';

  @override
  String get addCattle => 'गाय जोडा';

  @override
  String get cattleAlreadyExists => 'गाय आयडी आधीपासूनच अस्तित्वात आहे';

  @override
  String get pleaseEnterId => 'कृपया एक आयडी प्रविष्ट करा';

  @override
  String get registering => 'नोंदणी होत आहे...';

  @override
  String get cattleRegistered => 'गायीची नोंदणी झाली';

  @override
  String get failedToRegister => 'गायीची नोंदणी करता आली नाही';

  @override
  String get basicInfo => 'मूलभूत माहिती';

  @override
  String registeredOn(String date) {
    return 'नोंदणीकृत: $date';
  }

  @override
  String get breedClassification => 'नस्ल वर्गीकरण (जात)';

  @override
  String get classifyBreed => 'जात ओळखा';

  @override
  String get reClassify => 'पुन्हा ओळखा';

  @override
  String get noBreedClassificationYet =>
      'अजून कोणतेही जात वर्गीकरण नाही. पूर्ण शरीराचा फोटो घ्या.';

  @override
  String confirmedBreed(String breed) {
    return 'निश्चित जात: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'कमी आत्मविश्वास — अधिक स्पष्ट पूर्ण शरीराचा फोटो वापरून पहा.';

  @override
  String get setManually => 'मॅन्युअली सेट करा';

  @override
  String get unknownMixed => 'अज्ञात / मिश्रित';

  @override
  String get likelyBreedsVisual => 'संभाव्य जाती (दृश्य अंदाज):';

  @override
  String confirmBreed(String breed) {
    return '$breed ची पुष्टी करा';
  }

  @override
  String get chooseDifferent => 'दुसरी निवडा';

  @override
  String get breedClassified => 'जात ओळखली गेली';

  @override
  String get couldNotClassify => 'जात ओळखता आली नाही';

  @override
  String get noBreedPredictions => 'कोणतेही जातीचे अंदाज मिळाले नाहीत';

  @override
  String breedConfirmed(String breed) {
    return 'जातीची पुष्टी झाली: $breed';
  }

  @override
  String get chooseBreed => 'जात निवडा';

  @override
  String get orTypeBreedName => 'किंवा जातीचे नाव टाईप करा:';

  @override
  String get confirmCustomBreed => 'कस्टम जातीची पुष्टी करा';

  @override
  String get customBreedHint => 'उदा. जर्सी क्रॉस';

  @override
  String get breedSetUnknown => 'जात अज्ञात / मिश्रित वर सेट केली';

  @override
  String get healthRecords => 'आरोग्य नोंदी';

  @override
  String get addHealthRecord => 'आरोग्य नोंद जोडा';

  @override
  String get editHealthRecord => 'आरोग्य नोंद संपादित करा';

  @override
  String get noHealthRecords => 'अजून कोणतीही आरोग्य नोंद नाही.';

  @override
  String get diseaseName => 'आजाराचे नाव';

  @override
  String get symptoms => 'लक्षणे';

  @override
  String get status => 'स्थिती';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get delete => 'हटवा';

  @override
  String get edit => 'संपादन';

  @override
  String get deleteHealthRecord => 'आरोग्य नोंद हटवा';

  @override
  String get deleteHealthRecordConfirm => 'ही आरोग्य नोंद हटवायची आहे का?';

  @override
  String get healthRecordDeleted => 'आरोग्य नोंद हटवली गेली';

  @override
  String get healthRecordSaved => 'आरोग्य नोंद जतन केली';

  @override
  String get vaccinationRecords => 'लसीकरण नोंदी';

  @override
  String get addVaccination => 'लस जोडा';

  @override
  String get editVaccination => 'लसीकरण संपादित करा';

  @override
  String get noVaccinationRecords => 'अजून लसीकरणाची कोणतीही नोंद नाही.';

  @override
  String get vaccineName => 'लसीचे नाव';

  @override
  String get dateGiven => 'लस दिल्याचा दिनांक';

  @override
  String get nextDueDate => 'पुढील देय दिनांक (पर्यायी)';

  @override
  String get deleteVaccination => 'लसीकरण नोंद हटवा';

  @override
  String get deleteVaccinationConfirm => 'ही लसीकरण नोंद हटवायची आहे का?';

  @override
  String get vaccinationDeleted => 'लसीकरण नोंद हटवली गेली';

  @override
  String get vaccinationSaved => 'लसीकरण नोंद जतन केली';

  @override
  String get notes => 'टिपा (Notes)';

  @override
  String get addNote => 'टीप जोडा';

  @override
  String get editNote => 'टीप संपादित करा';

  @override
  String get noNotes => 'कोणतीही टीप जोडली नाही.';

  @override
  String get deleteNote => 'टीप हटवा';

  @override
  String get deleteNoteConfirm => 'ही टीप हटवायची आहे का?';

  @override
  String get noteDeleted => 'टीप हटवली गेली';

  @override
  String get noteSaved => 'टीप जतन केली';

  @override
  String get cattleIdentification => 'पशू ओळख';

  @override
  String get cattleIdentificationDesc =>
      'हा पशू ओळखण्यासाठी चेहऱ्याचे फोटो जोडा.';

  @override
  String get noIdentityPhotos => 'अद्याप चेहऱ्याचा कोणताही फोटो जोडलेला नाही.';

  @override
  String get addFacialPhoto => 'फोटो जोडा';

  @override
  String get photos => 'फोटो';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get photoDesc =>
      'वेळेनुसार ही गाय कशी दिसते याचा मागोवा घ्या. नवीन फोटो आधी दिसतील.';

  @override
  String get noPhotos => 'अजून कोणतेही फोटो नाहीत.';

  @override
  String get replace => 'बदला';

  @override
  String get replacePhoto => 'हा फोटो बदलायचा का?';

  @override
  String get replacePhotoConfirm =>
      'जुना फोटो काढून त्या जागी नवीन फोटो ठेवला जाईल.';

  @override
  String get photoUpdated => 'फोटो अपडेट केला';

  @override
  String get couldNotUpdatePhoto => 'फोटो अपडेट करता आला नाही';

  @override
  String get deletePhoto => 'फोटो हटवा';

  @override
  String get deletePhotoConfirm =>
      'हा फोटो हटवायचा का? हा फोटो गायीच्या ओळखीवरूनही काढून टाकला जाईल.';

  @override
  String get photoDeleted => 'फोटो हटवला गेला';

  @override
  String addPhotoTo(String id) {
    return '$id मध्ये फोटो जोडायचा का?';
  }

  @override
  String get addPhotoConfirm =>
      'ही गाय वेळेनुसार कशी दिसते याचा मागोवा घेण्यासाठी हा फोटो आजच्या तारखेसह जतन केला जाईल. भविष्यात गाय ओळखण्यासही याची मदत होईल.';

  @override
  String get galleryPhotoConfirm =>
      'काळाच्या ओघात या पशूची वाढ आणि स्वरूप ट्रॅक करण्यासाठी हा फोटो जतन केला जाईल.';

  @override
  String get photoAdded => 'फोटो जोडला गेला';

  @override
  String get couldNotAddPhoto => 'फोटो जोडता आला नाही';

  @override
  String get takePhoto => 'फोटो घ्या';

  @override
  String get chooseFromGallery => 'गॅलरीमधून निवडा';

  @override
  String get takeOrChooseClear =>
      'या गायीचा एक स्पष्ट फोटो घ्या किंवा गॅलरीमधून निवडा.';

  @override
  String get classifyThisPhoto => 'या फोटोचे वर्गीकरण करायचे का?';

  @override
  String get classifyThisPhotoConfirm =>
      'एक स्पष्ट आणि चांगला प्रकाश असलेला पूर्ण शरीराचा फोटो सर्वोत्तम जातीचा अंदाज देतो.';

  @override
  String get classify => 'वर्गीकरण करा';

  @override
  String get takeOrChooseFullBody =>
      'या गायीचा एक स्पष्ट पूर्ण शरीराचा फोटो घ्या किंवा गॅलरीमधून निवडा.';

  @override
  String get deleteCattleRecord => 'गायीची नोंद हटवा';

  @override
  String deleteCattleRecordConfirm(String id) {
    return 'तुम्हाला $id आणि त्याच्याशी संबंधित सर्व नोंदी हटवायच्या आहेत का?';
  }

  @override
  String get cattleRecordDeleted => 'गायीची नोंद हटवली गेली';

  @override
  String get cattleDetails => 'गायीचा तपशील';

  @override
  String get cattleNotFound => 'गायीची नोंद आढळली नाही.';

  @override
  String detailsHeader(String id) {
    return '$id चा तपशील';
  }

  @override
  String get identifyCattle => 'गाय ओळखा';

  @override
  String get identifyTab => 'ओळखा';

  @override
  String get cattleTab => 'माझ्या गायी';

  @override
  String get tapIdentify => 'फोटो जोडला गेला. गाय ओळखा वर टॅप करा.';

  @override
  String get selectImageFirst => 'प्रथम एक प्रतिमा निवडा.';

  @override
  String get matchesHeading => 'जुळणारे पर्याय';

  @override
  String get details => 'तपशील';

  @override
  String get unknownCattle => 'अज्ञात गाय';

  @override
  String get registerThisCattle => 'या गायीची नोंदणी करा';

  @override
  String get backButton => 'मागे';

  @override
  String get noCattlesFound => 'कोणतीही गाय आढळली नाही';

  @override
  String get activeLabel => 'सक्रिय';

  @override
  String get recoveredLabel => 'बरी झालेली';

  @override
  String givenLabel(String date) {
    return 'दिलेला दिनांक: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'पुढील देय दिनांक: $date';
  }

  @override
  String get tabOverview => 'आढावा';

  @override
  String get tabMedical => 'वैद्यकीय';

  @override
  String get tabGalleryNotes => 'गॅलरी आणि टिपा';

  @override
  String dialogIdentifyAs(String id) {
    return '$id म्हणून ओळखायचे का?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'ही गाय $id सारखीच दिसत आहे (विश्वासार्हता: $confidence%). तुम्हाला नवीन गाय नोंदवण्याऐवजी हा फोटो $id च्या इतिहासामध्ये जतन करायचा आहे का?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id मध्ये फोटो जतन करा';
  }

  @override
  String get dialogIdentifyNewCattle => 'नाही, ही नवीन गाय आहे';

  @override
  String get checkingPhotoBeforeReg => 'नोंदणी करण्यापूर्वी फोटो तपासत आहे...';

  @override
  String alreadyInHerd(String id) {
    return '$id आधीपासूनच तुमच्या कळपात आहे';
  }

  @override
  String get no => 'नाही';

  @override
  String get yes => 'होय';

  @override
  String yesAddTo(String id) {
    return 'होय, $id मध्ये जोडा';
  }

  @override
  String looksLike(String id) {
    return 'हे $id सारखे दिसत आहे';
  }

  @override
  String get addPhotoToThat => 'हा फोटो त्या गायीमध्ये जोडायचा का?';

  @override
  String get createNewCattle => 'नवीन गाय जोडा';

  @override
  String get savingPhoto => 'फोटो जतन करत आहे...';

  @override
  String photoAddedTo(String id) {
    return 'फोटो $id मध्ये जोडला गेला';
  }

  @override
  String get couldNotSavePhoto => 'हा फोटो जतन करता आला नाही.';

  @override
  String get savingCattleDetails => 'गायीचा तपशील जतन करत आहे...';

  @override
  String addedToHerd(String id) {
    return '$id तुमच्या कळपात जोडली गेली.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id यशस्वीरित्या जोडली गेली';
  }

  @override
  String get exitApp => 'अ‍ॅपमधून बाहेर पडा';

  @override
  String get exitAppConfirm => 'तुम्हाला अ‍ॅप बंद करायचे आहे का?';

  @override
  String get cancelled => 'रद्द केले.';

  @override
  String get couldNotCheckPhoto =>
      'नोंदणी करण्यापूर्वी या फोटोची तपासणी करता आली नाही.';

  @override
  String get couldNotPrepareReg => 'नोंदणीची तयारी करता आली नाही';

  @override
  String get captureImage => 'फोटो काढा';

  @override
  String get uploadImage => 'फोटो अपलोड करा';

  @override
  String get identificationResult => 'ओळखण्याचा परिणाम';

  @override
  String get noCattlesMessage =>
      'अजून कोणतीही गाय नाही.\nपहिली गाय जोडण्यासाठी \'ओळखा\' टॅब वापरा.';

  @override
  String get yourHerd => 'तुमचा कळप';

  @override
  String get welcomeNotebook => 'तुमच्या गुरे नोंदवहीत स्वागत आहे';

  @override
  String get notebookDescription =>
      'गाय ओळखण्यासाठी आणि साध्या नोंदी ठेवण्यासाठी फोटो घ्या किंवा अपलोड करा.';

  @override
  String registeredCattlesCount(int count) {
    return 'नोंदणीकृत गायी: $count';
  }

  @override
  String get initErrorOccurred => 'अ‍ॅप सुरू करताना काहीतरी चुकले.';

  @override
  String get tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get noPhotoSelected => 'कोणताही फोटो निवडला नाही';

  @override
  String get identifyResultPlaceholder => 'परिणाम पाहण्यासाठी प्रथम गाय ओळखा.';

  @override
  String matchConfidence(String confidence) {
    return 'जुळण्याची टक्केवारी: $confidence%';
  }

  @override
  String get cattleAlreadyInHerd => 'ही गाय आधीपासूनच तुमच्या कळपात आहे.';

  @override
  String get noMatchingCattleRegisterHint =>
      'जुळणारी गाय आढळली नाही. तुम्ही ही नवीन गाय म्हणून जोडू शकता.';

  @override
  String cattleSummarySubtitle(int health, int vaccines, int notes) {
    return 'आरोग्य: $health • लसीकरण: $vaccines • टिपा: $notes';
  }

  @override
  String get diseaseNameLabel => 'आजाराचे नाव';

  @override
  String get ongoing => 'सक्रिय';

  @override
  String get recovered => 'बरे झाले';

  @override
  String get symptomsOptional => 'लक्षणे (पर्यायी)';

  @override
  String get treatmentNotesOptional => 'उपचार टिपा (पर्यायी)';

  @override
  String get saveHealthRecord => 'आरोग्य नोंद जतन करा';

  @override
  String get updateHealthRecord => 'आरोग्य नोंद अपडेट करा';

  @override
  String get healthRecordAdded => 'आरोग्य नोंद जोडली गेली';

  @override
  String get healthRecordUpdated => 'आरोग्य नोंद अपडेट केली';

  @override
  String get vaccineNameLabel => 'लसीचे नाव';

  @override
  String get pickDate => 'तारीख निवडा';

  @override
  String get nextDueNotSet => 'पुढील दिनांक: सेट नाही';

  @override
  String get setNextDue => 'पुढील देय दिनांक ठरवा';

  @override
  String get notesOptional => 'टिपा (पर्यायी)';

  @override
  String get saveVaccination => 'लसीकरण नोंद जतन करा';

  @override
  String get updateVaccination => 'लसीकरण नोंद अपडेट करा';

  @override
  String get vaccinationAdded => 'लसीकरण नोंद जोडली गेली';

  @override
  String get vaccinationUpdated => 'लसीकरण नोंद अपडेट केली';

  @override
  String get addNoteDialogTitle => 'टीप जोडा';

  @override
  String get noteAdded => 'टीप जोडली गेली';

  @override
  String get noteUpdated => 'टीप अपडेट केली';

  @override
  String dateLabel2(String date) {
    return 'तारीख: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'दिलेला दिनांक: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'पुढील देय दिनांक: $date';
  }

  @override
  String get noSymptomsNoted => 'कोणत्याही लक्षणांची नोंद नाही';

  @override
  String get milkYieldTab => 'दूध उत्पादन';

  @override
  String get milkAndLactationTitle => 'दूध व दुग्धकाळ';

  @override
  String get notifications => 'सूचना';

  @override
  String get filterButton => 'फिल्टर';

  @override
  String get clearAll => 'सर्व साफ करा';

  @override
  String showingCattleCount(int filtered, int total) {
    return '$total पैकी $filtered पशू दाखवत आहे';
  }

  @override
  String get noCattleMatchFilter =>
      'निवडलेल्या फिल्टरनुसार कोणताही पशू आढळला नाही.';

  @override
  String get resetSearchAndFilters => 'शोध आणि फिल्टर रीसेट करा';

  @override
  String get filterAndSortCattle => 'पशू फिल्टर व क्रमवारी';

  @override
  String get sortOrder => 'क्रमवारी';

  @override
  String get resetAll => 'सर्व रीसेट करा';

  @override
  String showMatchingCattle(int count) {
    return '$count पशू दाखवा';
  }

  @override
  String get sexLabel => 'लिंग';

  @override
  String get lifeStageLabel => 'जीवन टप्पा';

  @override
  String get healthStatusLabel => 'आरोग्य स्थिती';

  @override
  String get reproductiveStatusLabel => 'प्रजनन स्थिती';

  @override
  String get vaccinationStatusLabel => 'लसीकरण';

  @override
  String get milkAndLactation => 'दूध व दुग्धकाळ';

  @override
  String get breedCategory => 'जात';

  @override
  String get female => 'मादी';

  @override
  String get male => 'नर';

  @override
  String get calf => 'वासरू';

  @override
  String get heifer => 'कालवड';

  @override
  String get cow => 'गाय';

  @override
  String get bull => 'वळू';

  @override
  String get steer => 'बैल';

  @override
  String get healthy => 'निरोगी';

  @override
  String get underObservation => 'निरीक्षणाखाली';

  @override
  String get diseased => 'आजारी';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get pregnant => 'गाभण';

  @override
  String get notPregnant => 'गाभण नाही';

  @override
  String get upToDate => 'अद्ययावत';

  @override
  String get dueSoon => 'लवकरच देय';

  @override
  String get overdue => 'मुदत संपलेली';

  @override
  String get noRecord => 'नोंद नाही';

  @override
  String get milkingCows => 'दुभत्या गायी';

  @override
  String get dryCows => 'आटलेल्या गायी';

  @override
  String get highProducers => 'उच्च उत्पादक (>15 लि/दिवस)';

  @override
  String get mediumProducers => 'मध्यम उत्पादक (8–15 लि/दिवस)';

  @override
  String get lowProducers => 'कमी उत्पादक (<8 लि/दिवस)';

  @override
  String get recentlyCalved => 'नुकतीच व्यायलेली';

  @override
  String get sortRecentlyAdded => 'नुकतेच जोडलेले';

  @override
  String get sortOldestAdded => 'सर्वात जुने';

  @override
  String get sortNameAsc => 'आयडी (A → Z)';

  @override
  String get sortNameDesc => 'आयडी (Z → A)';

  @override
  String get sortAgeAsc => 'वय (लहानांपासून मोठे)';

  @override
  String get sortAgeDesc => 'वय (मोठ्यांपासून लहान)';

  @override
  String get todaysMilkProduction => 'आजचे दूध उत्पादन';

  @override
  String cowsMilked(int count) {
    return '$count गायींचे दूध काढले';
  }

  @override
  String get liters => 'लिटर';

  @override
  String get averagePerCow => 'सरासरी / गाय';

  @override
  String topProducer(String id, String yield) {
    return 'अव्वल: #$id ($yield लि)';
  }

  @override
  String get topProducerNone => 'अव्वल उत्पादक: अद्याप कोणी नाही';

  @override
  String lowestProducer(String id, String yield) {
    return 'किमान: #$id ($yield लि)';
  }

  @override
  String get thisWeek => 'या आठवड्यात';

  @override
  String get thisMonth => 'या महिन्यात';

  @override
  String get milkingHerd => 'दुभता कळप';

  @override
  String cowsCount(int count) {
    return '$count गायी';
  }

  @override
  String get recordMilk => 'दूध नोंदवा';

  @override
  String get reports => 'अहवाल';

  @override
  String get productionAnalytics => 'उत्पादन विश्लेषण';

  @override
  String get milkHistory => 'दुधाचा इतिहास';

  @override
  String daysLogged(int count) {
    return '$count दिवस नोंदवले';
  }

  @override
  String get noMilkRecordsSavedYet =>
      'अद्याप दुधाची कोणतीही नोंद नाही. सुरू करण्यासाठी \'दूध नोंदवा\' वर टॅप करा.';

  @override
  String get breedAnalyticsFilter => 'जात विश्लेषण फिल्टर:';

  @override
  String get allBreeds => 'सर्व जाती';

  @override
  String cowsRecordedCount(int count, String plural) {
    return '$count गाई नोंदवल्या';
  }

  @override
  String get morningShort => 'सकाळ';

  @override
  String get eveningShort => 'संध्याकाळ';

  @override
  String get editMilkRecord => 'दूध नोंद संपादित करा';

  @override
  String get recordMilkYield => 'दूध उत्पादन नोंदवा';

  @override
  String get recordExistsWarning =>
      'या गायीची या तारखेची नोंद आधीच अस्तित्वात आहे. जतन केल्यास ती अपडेट होईल.';

  @override
  String get cattleLabel => 'पशू';

  @override
  String get selectCow => 'गाय निवडा';

  @override
  String get milkingBadge => 'दुभती';

  @override
  String get recordDate => 'नोंदीची तारीख';

  @override
  String get morningLiters => 'सकाळ (लिटर)';

  @override
  String get eveningLiters => 'संध्याकाळ (लिटर)';

  @override
  String get totalDailyYield => 'एकूण दैनिक उत्पादन';

  @override
  String get notesOptionalMilk => 'टीप (पर्यायी)';

  @override
  String get notesHintMilk => 'उदा. हिरवा चारा दिला, सामान्य भूक';

  @override
  String get updateRecord => 'नोंद अपडेट करा';

  @override
  String get saveRecordButton => 'नोंद जतन करा';

  @override
  String get pleaseSelectCattle => 'कृपया एक पशू निवडा';

  @override
  String get milkProductionReports => 'दूध उत्पादन अहवाल';

  @override
  String breedFilterBadge(String breed) {
    return 'जात फिल्टर: $breed';
  }

  @override
  String get dailyTab => 'दैनिक';

  @override
  String get weeklyTab => 'साप्ताहिक';

  @override
  String get monthlyTab => 'मासिक';

  @override
  String get reportDateLabel => 'अहवाल तारीख: ';

  @override
  String get weekStartLabel => 'आठवडा सुरू: ';

  @override
  String downloadCsvReport(String type) {
    return '$type CSV अहवाल डाउनलोड करा';
  }

  @override
  String reportSaved(String fileName) {
    return 'अहवाल जतन केला: $fileName';
  }

  @override
  String get reportCopied => 'अहवाल क्लिपबोर्डवर कॉपी केला!';

  @override
  String get dailyAvg => 'दैनिक सरासरी';

  @override
  String get totalYieldLabel => 'एकूण उत्पादन';

  @override
  String get bestLabel => 'उत्कृष्ट';

  @override
  String get worstLabel => 'किमान';

  @override
  String get orderLabel => 'क्रम:';

  @override
  String get bestToWorst => 'उत्कृष्ट → किमान';

  @override
  String get worstToBest => 'किमान → उत्कृष्ट';

  @override
  String noMilkRecordsForPeriod(String breedText) {
    return 'या कालावधीसाठी कोणतीही दुधाची नोंद आढळली नाही$breedText.';
  }

  @override
  String recordedOutOfDays(int recorded, int total) {
    return 'नोंदवले: $recorded/$total दिवस';
  }

  @override
  String recordedEntriesCount(int count) {
    return 'नोंदवले: $count नोंदी';
  }

  @override
  String morningEveningBreakdown(String morning, String evening) {
    return 'सकाळ: $morning लि  •  संध्याकाळ: $evening लि';
  }

  @override
  String get notificationsAndSmartAlerts => 'सूचना आणि स्मार्ट अलर्ट';

  @override
  String get allClear => 'सर्व ठीक आहे!';

  @override
  String get noPendingAlerts => 'कोणतीही प्रलंबित सूचना किंवा अलर्ट नाही.';

  @override
  String get viewAction => 'पहा';

  @override
  String get recordMilkAction => 'दूध नोंदवा';

  @override
  String get logCalvingAction => 'प्रसूती नोंदवा';

  @override
  String get vaccinateAction => 'लस द्या';

  @override
  String get editCattleDetails => 'पशू तपशील संपादित करा';

  @override
  String get dateOfBirthAge => 'जन्म तारीख (वय)';

  @override
  String get notSet => 'सेट नाही';

  @override
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural) {
    return '$years वर्षे $months महिने';
  }

  @override
  String yearsAge(int years, String yPlural) {
    return '$years वर्षे';
  }

  @override
  String monthsAge(int months, String mPlural) {
    return '$months महिने';
  }

  @override
  String get unknownAge => 'अज्ञात वय';

  @override
  String get milkAndLactationProfile => 'दूध व दुग्धकाळ प्रोफाइल';

  @override
  String get currentlyMilking => 'सध्या दूध देत आहे';

  @override
  String get lastCalvingDate => 'शेवटची प्रसूती तारीख';

  @override
  String get inseminationDate => 'कृत्रिम रेतन/गाभण तारीख';

  @override
  String get expectedDailyYieldBenchmark => 'अपेक्षित दैनिक उत्पादन (मानक)';

  @override
  String get benchmarkHint => 'उदा. 15.0';

  @override
  String get symptomsHint => 'उदा. नीट चारा खात नाही';

  @override
  String get cattleDetailsUpdated => 'पशू तपशील अपडेट केले';

  @override
  String get milkProductionTab => 'दूध उत्पादन';

  @override
  String get lactationStatus => 'दुग्धकाळ स्थिती';

  @override
  String get daysInMilk => 'दूध देण्याचे दिवस (DIM)';

  @override
  String daysUnit(int count) {
    return '$count दिवस';
  }

  @override
  String get lastCalving => 'शेवटची प्रसूती';

  @override
  String get estNextCalving => 'अंदाजित पुढील प्रसूती';

  @override
  String get thirtyDayAverage => '30 दिवसांची सरासरी';

  @override
  String get totalThisMonth => 'या महिन्यातील एकूण';

  @override
  String get recentMilkYieldTrend => 'अलीकडील दूध उत्पादन कल';

  @override
  String get dailyMilkRecords => 'दैनिक दूध नोंदी';

  @override
  String get noDailyMilkRecords =>
      'या गायीसाठी अद्याप कोणतीही दैनिक दुधाची नोंद नाही.';

  @override
  String litersPerDay(String yield) {
    return '$yield लि/दिवस';
  }

  @override
  String get freshStage => 'ताजे (Fresh)';

  @override
  String get earlyStage => 'प्रारंभिक (Early)';

  @override
  String get midStage => 'मध्य (Mid)';

  @override
  String get lateStage => 'अंतिम (Late)';

  @override
  String get extendedStage => 'विस्तारित दुग्धकाळ';

  @override
  String get dryStage => 'आटलेला काळ (Dry)';

  @override
  String stageSuffix(String stage) {
    return '$stage टप्पा';
  }

  @override
  String get calvingDateOverdue => 'प्रसूती तारीख उलटून गेली';

  @override
  String calvingOverdueMessage(String date) {
    return 'अपेक्षित प्रसूती तारीख ($date) उलटून गेली आहे. प्रसूती तपशील किंवा गाभण स्थिती अपडेट करा.';
  }

  @override
  String get logCalving => 'प्रसूती नोंदवा';

  @override
  String get predictedBreed => 'अंदाजित जात';

  @override
  String get noMilkChartRecords =>
      'अद्याप दुधाची कोणतीही नोंद नाही.\nउत्पादन कल पाहण्यासाठी नोंदणी सुरू करा.';

  @override
  String get setAsUnknown => 'अज्ञात म्हणून सेट करा';

  @override
  String breedPredictionItem(String name, int percent) {
    return '• $name — $percent%';
  }

  @override
  String get sexRequired => 'लिंग *';

  @override
  String get optionalNoteHint => 'उदा. गाभण';

  @override
  String get missingMilkEntryToday => 'आजची दूध नोंद राहिली';

  @override
  String missingMilkEntryTitle(String date) {
    return 'दूध नोंद राहिली ($date)';
  }

  @override
  String noMilkRecordEntered(String dateLabel, String id) {
    return '$dateLabel #$id साठी कोणतीही दूध नोंद केलेली नाही.';
  }

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल';

  @override
  String onDate(String date) {
    return '$date रोजी';
  }

  @override
  String get lowYieldAlertTitle => 'कमी उत्पादनाचा इशारा';

  @override
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  ) {
    return '#$id चे दूध उत्पादन $percent% घटले ($latest ली विरूद्ध $avg ली सरासरी).';
  }

  @override
  String get dryOffReminderTitle => 'दूध सुकवण्याचा आठवण संदेश';

  @override
  String dryOffReminderMessage(String id, int days) {
    return '#$id कडून $days दिवसांत विण्याचे अपेक्षित आहे. ड्राय कालावधीसाठी तयार करा.';
  }

  @override
  String get calvingDateOverdueTitle => 'विण्याची तारीख उलटून गेली';

  @override
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  ) {
    return '#$id ची अपेक्षित विण्याची तारीख $days दिवसांपूर्वी होती ($date). माहिती अपडेट करा.';
  }

  @override
  String get calvingReminderTitle => 'विण्याचा आठवण संदेश';

  @override
  String calvingReminderMessage(String id, int days, String plural) {
    return '#$id कडून $days दिवसांत विणे अपेक्षित आहे. तयारी करा.';
  }

  @override
  String get vaccinationOverdueTitle => 'लसीकरण थकीत';

  @override
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days दिवसांपूर्वी देणे आवश्यक होते ($date).';
  }

  @override
  String get vaccinationDueSoonTitle => 'लसीकरण लवकरच देणे आहे';

  @override
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days दिवसांत देणे आहे ($date).';
  }
}
