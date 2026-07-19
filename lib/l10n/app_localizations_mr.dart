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
  String get cowsNotebook => 'गुरांची नोंदवही';

  @override
  String get noCows => 'अजून कोणतीही गाय नोंदणीकृत नाही.';

  @override
  String get searchHint => 'तुमचा कळप शोधा...';

  @override
  String cowIdLabel(String id) {
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
  String get checkingCow => 'गाय तपासत आहे...';

  @override
  String get cowIdentified => 'गाय ओळखली गेली.';

  @override
  String get borderlineMatch =>
      'ही तुमच्याकडे आधीपासून असलेल्या गायीसारखी दिसत आहे — खाली पहा.';

  @override
  String get noMatchingCow => 'कोणतीही जुळणारी गाय आढळली नाही.';

  @override
  String get couldNotIdentify => 'या वेळी ही गाय ओळखता आली नाही.';

  @override
  String get addThisCow => 'ही गाय जोडा';

  @override
  String get cowId => 'गाय आयडी';

  @override
  String get optionalNote => 'नोंद (पर्यायी)';

  @override
  String get register => 'नोंदणी करा';

  @override
  String get addCow => 'गाय जोडा';

  @override
  String get cowAlreadyExists => 'गाय आयडी आधीपासूनच अस्तित्वात आहे';

  @override
  String get pleaseEnterId => 'कृपया एक आयडी प्रविष्ट करा';

  @override
  String get registering => 'नोंदणी होत आहे...';

  @override
  String get cowRegistered => 'गायीची नोंदणी झाली';

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
  String get deleteCowRecord => 'गायीची नोंद हटवा';

  @override
  String deleteCowRecordConfirm(String id) {
    return 'तुम्हाला $id आणि त्याच्याशी संबंधित सर्व नोंदी हटवायच्या आहेत का?';
  }

  @override
  String get cowRecordDeleted => 'गायीची नोंद हटवली गेली';

  @override
  String get cowDetails => 'गायीचा तपशील';

  @override
  String get cowNotFound => 'गायीची नोंद आढळली नाही.';

  @override
  String detailsHeader(String id) {
    return '$id चा तपशील';
  }

  @override
  String get identifyCow => 'गाय ओळखा';

  @override
  String get identifyTab => 'ओळखा';

  @override
  String get cowsTab => 'माझ्या गायी';

  @override
  String get tapIdentify => 'फोटो जोडला गेला. गाय ओळखा वर टॅप करा.';

  @override
  String get selectImageFirst => 'प्रथम एक प्रतिमा निवडा.';

  @override
  String get matchesHeading => 'जुळणारे पर्याय';

  @override
  String get details => 'तपशील';

  @override
  String get unknownCow => 'अज्ञात गाय';

  @override
  String get registerThisCow => 'या गायीची नोंदणी करा';

  @override
  String get backButton => 'मागे';

  @override
  String get noCowsFound => 'कोणतीही गाय आढळली नाही';

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
  String get dialogIdentifyNewCow => 'नाही, ही नवीन गाय आहे';

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
  String get createNewCow => 'नवीन गाय जोडा';

  @override
  String get savingPhoto => 'फोटो जतन करत आहे...';

  @override
  String photoAddedTo(String id) {
    return 'फोटो $id मध्ये जोडला गेला';
  }

  @override
  String get couldNotSavePhoto => 'हा फोटो जतन करता आला नाही.';

  @override
  String get savingCowDetails => 'गायीचा तपशील जतन करत आहे...';

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
  String get noCowsMessage =>
      'अजून कोणतीही गाय नाही.\nपहिली गाय जोडण्यासाठी \'ओळखा\' टॅब वापरा.';

  @override
  String get yourHerd => 'तुमचा कळप';

  @override
  String get welcomeNotebook => 'तुमच्या गुरे नोंदवहीत स्वागत आहे';

  @override
  String get notebookDescription =>
      'गाय ओळखण्यासाठी आणि साध्या नोंदी ठेवण्यासाठी फोटो घ्या किंवा अपलोड करा.';

  @override
  String registeredCowsCount(int count) {
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
  String get cowAlreadyInHerd => 'ही गाय आधीपासूनच तुमच्या कळपात आहे.';

  @override
  String get noMatchingCowRegisterHint =>
      'जुळणारी गाय आढळली नाही. तुम्ही ही नवीन गाय म्हणून जोडू शकता.';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'आरोग्य: $health • लसीकरण: $vaccines • टिपा: $notes';
  }

  @override
  String get diseaseNameLabel => 'आजाराचे नाव';

  @override
  String get ongoing => 'सक्रिय';

  @override
  String get recovered => 'बरी झालेली';

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
}
