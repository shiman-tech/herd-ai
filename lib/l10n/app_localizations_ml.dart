// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'ഹെർഡ് എഐ (Herd AI)';

  @override
  String get appSubtitle => 'നിങ്ങളുടെ കന്നുകാലി നോട്ട്ബുക്ക്';

  @override
  String get preparingSecureAccess => 'സുരക്ഷിത പ്രവേശനം ഒരുക്കുന്നു...';

  @override
  String get createPin => '4 അക്ക പിൻ നൽകുക';

  @override
  String get enterPin => 'നിങ്ങളുടെ പിൻ നൽകുക';

  @override
  String get unlockApp => 'ആപ്പ് അൺലോക്ക് ചെയ്യുക';

  @override
  String get confirmPin => 'പിൻ സ്ഥിരീകരിക്കുക';

  @override
  String get pinDidNotMatchTryAgain =>
      'പിൻ പൊരുത്തപ്പെടുന്നില്ല. വീണ്ടും ശ്രമിക്കുക';

  @override
  String get pinDidNotMatch => 'പിൻ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get pinCreated => 'പിൻ സൃഷ്ടിച്ചു';

  @override
  String get unlocked => 'അൺലോക്ക് ചെയ്തു';

  @override
  String get wrongPinTryAgain => 'തെറ്റായ പിൻ. വീണ്ടും ശ്രമിക്കുക';

  @override
  String get wrongPin => 'തെറ്റായ പിൻ';

  @override
  String get usePinToUnlock => 'അൺലോക്ക് ചെയ്യാൻ പിൻ ഉപയോഗിക്കുക';

  @override
  String get tryFingerprintFace => 'ഫിംഗർപ്രിന്റ്/ഫേസ് ഐഡി ഉപയോഗിക്കുക';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get changePin => 'പിൻ മാറ്റുക';

  @override
  String get language => 'ഭാഷ (Language)';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get currentPin => 'നിലവിലെ പിൻ';

  @override
  String get newPin => 'പുതിയ പിൻ';

  @override
  String get confirmNewPin => 'പുതിയ പിൻ സ്ഥിരീകരിക്കുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get save => 'സംരക്ഷിക്കുക';

  @override
  String get wrongCurrentPin => 'നിലവിലെ പിൻ തെറ്റാണ്';

  @override
  String get pinChanged => 'പിൻ മാറ്റി';

  @override
  String get pinsDoNotMatch => 'പുതിയ പിന്നുകൾ പൊരുത്തപ്പെടുന്നില്ല';

  @override
  String get enterAllFields => 'എല്ലാ വിവരങ്ങളും നൽകുക';

  @override
  String get invalidPinLength => 'പിൻ കൃത്യം 4 അക്കങ്ങൾ ആയിരിക്കണം';

  @override
  String get cattleNotebook => 'കന്നുകാലി നോട്ട്ബുക്ക്';

  @override
  String get noCattles => 'കന്നുകാലികളൊന്നും ഇതുവരെ രജിസ്റ്റർ ചെയ്തിട്ടില്ല.';

  @override
  String get searchHint => 'കന്നുകാലികളെ തിരയുക...';

  @override
  String cattleIdLabel(String id) {
    return 'കന്നുകാലി ഐഡി: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'രജിസ്റ്റർ ചെയ്തത്: $date';
  }

  @override
  String get readyToIdentify =>
      'കന്നുകാലികളെ തിരിച്ചറിയാനും വിവരങ്ങൾ സൂക്ഷിക്കാനും തയാറാണ്.';

  @override
  String get initializingDb => 'കന്നുകാലി നോട്ട്ബുക്ക് തയാറാക്കുന്നു...';

  @override
  String get readyText => 'തിരിച്ചറിയാൻ തയാറാണ്';

  @override
  String get notReady =>
      'ആപ്പ് സജ്ജീകരണം പൂർത്തിയായിട്ടില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get selectImage => 'മോഡൽ ലോഡുചെയ്‌ത ശേഷം ചിത്രം തിരഞ്ഞെടുക്കുക.';

  @override
  String get checkingCattle => 'കന്നുകാലിയെ പരിശോധിക്കുന്നു...';

  @override
  String get cattleIdentified => 'കന്നുകാലിയെ തിരിച്ചറിഞ്ഞു.';

  @override
  String get borderlineMatch =>
      'ഇത് നിങ്ങളുടെ പക്കലുള്ള ഒരു കന്നുകാലിയുമായി സാമ്യമുള്ളതായി കാണപ്പെടുന്നു — താഴെ കാണുക.';

  @override
  String get noMatchingCattle =>
      'പൊരുത്തപ്പെടുന്ന കന്നുകാലികളെ കണ്ടെത്തിയില്ല.';

  @override
  String get couldNotIdentify =>
      'ഇപ്പോൾ ഈ കന്നുകാലിയെ തിരിച്ചറിയാൻ കഴിഞ്ഞില്ല.';

  @override
  String get addThisCattle => 'ഈ കന്നുകാലിയെ ചേർക്കുക';

  @override
  String get cattleId => 'കന്നുകാലി ഐഡി';

  @override
  String get optionalNote => 'കുറിപ്പ് (ഓപ്ഷണൽ)';

  @override
  String get register => 'രജിസ്റ്റർ ചെയ്യുക';

  @override
  String get addCattle => 'കന്നുകാലിയെ ചേർക്കുക';

  @override
  String get cattleAlreadyExists => 'കന്നുകാലി ഐഡി നിലവിലുണ്ട്';

  @override
  String get pleaseEnterId => 'ദയവായി ഒരു ഐഡി നൽകുക';

  @override
  String get registering => 'രജിസ്റ്റർ ചെയ്യുന്നു...';

  @override
  String get cattleRegistered => 'കന്നുകാലിയെ രജിസ്റ്റർ ചെയ്തു';

  @override
  String get failedToRegister => 'കന്നുകാലിയെ രജിസ്റ്റർ ചെയ്യാൻ കഴിഞ്ഞില്ല';

  @override
  String get basicInfo => 'അടിസ്ഥാന വിവരങ്ങൾ';

  @override
  String registeredOn(String date) {
    return 'രജിസ്റ്റർ ചെയ്തത്: $date';
  }

  @override
  String get breedClassification => 'ഇനം തിരിച്ചറിയൽ';

  @override
  String get classifyBreed => 'ഇനം കണ്ടെത്തുക';

  @override
  String get reClassify => 'വീണ്ടും കണ്ടെത്തുക';

  @override
  String get noBreedClassificationYet =>
      'ഇനം ഇതുവരെ തിരിച്ചറിഞ്ഞിട്ടില്ല. പൂർണ്ണ ശരീര ചിത്രം എടുക്കുക.';

  @override
  String confirmedBreed(String breed) {
    return 'സ്ഥിരീകരിച്ച ഇനം: $breed';
  }

  @override
  String get lowConfidenceWarning => 'കുറഞ്ഞ കൃത്യത';

  @override
  String get setManually => 'സ്വമേധയാ സജ്ജീകരിക്കുക';

  @override
  String get unknownMixed => 'അജ്ഞാതം / സങ്കരയിനം';

  @override
  String get likelyBreedsVisual => 'സാധ്യമായ ഇനങ്ങൾ (കാഴ്ചയിൽ):';

  @override
  String confirmBreed(String breed) {
    return '$breed സ്ഥിരീകരിക്കുക';
  }

  @override
  String get chooseDifferent => 'മറ്റൊന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get breedClassified => 'ഇനം കണ്ടെത്തി';

  @override
  String get couldNotClassify => 'ഇനം കണ്ടെത്താൻ കഴിഞ്ഞില്ല';

  @override
  String get noBreedPredictions => 'ഇന വിവരങ്ങൾ ഒന്നും ലഭ്യമല്ല';

  @override
  String breedConfirmed(String breed) {
    return 'ഇനം സ്ഥിരീകരിച്ചു: $breed';
  }

  @override
  String get chooseBreed => 'ഇനം തിരഞ്ഞെടുക്കുക';

  @override
  String get orTypeBreedName => 'അല്ലെങ്കിൽ ഇനത്തിന്റെ പേര് നൽകുക:';

  @override
  String get confirmCustomBreed => 'ഇനം സ്ഥിരീകരിക്കുക';

  @override
  String get customBreedHint => 'ഉദാ. ജേഴ്‌സി ക്രോസ്';

  @override
  String get breedSetUnknown => 'ഇനം അജ്ഞാതം / സങ്കരയിനം ആയി നിശ്ചയിച്ചു';

  @override
  String get healthRecords => 'ആരോഗ്യ വിവരങ്ങൾ';

  @override
  String get addHealthRecord => 'ആരോഗ്യ വിവരം ചേർക്കുക';

  @override
  String get editHealthRecord => 'ആരോഗ്യ വിവരം തിരുത്തുക';

  @override
  String get noHealthRecords => 'ആരോഗ്യ വിവരങ്ങൾ ഒന്നും ഇതുവരെ ചേർത്തിട്ടില്ല.';

  @override
  String get diseaseName => 'രോഗത്തിന്റെ പേര്';

  @override
  String get symptoms => 'രോഗലക്ഷണങ്ങൾ';

  @override
  String get status => 'നില';

  @override
  String get dateLabel => 'തീയതി';

  @override
  String get delete => 'ഡിലീറ്റ് ചെയ്യുക';

  @override
  String get edit => 'തിരുത്തുക';

  @override
  String get deleteHealthRecord => 'ആരോഗ്യ വിവരം നീക്കം ചെയ്യുക';

  @override
  String get deleteHealthRecordConfirm =>
      'ഈ ആരോഗ്യ വിവരം നീക്കം ചെയ്യണമെന്നുറപ്പാണോ?';

  @override
  String get healthRecordDeleted => 'ആരോഗ്യ വിവരം നീക്കം ചെയ്തു';

  @override
  String get healthRecordSaved => 'ആരോഗ്യ വിവരം സംരക്ഷിച്ചു';

  @override
  String get vaccinationRecords => 'പ്രതിരോധ കുത്തിവയ്പ്പ് വിവരങ്ങൾ';

  @override
  String get addVaccination => 'കുത്തിവയ്പ്പ് ചേർക്കുക';

  @override
  String get editVaccination => 'കുത്തിവയ്പ്പ് തിരുത്തുക';

  @override
  String get noVaccinationRecords =>
      'കുത്തിവയ്പ്പ് വിവരങ്ങൾ ഒന്നും ഇതുവരെ ചേർത്തിട്ടില്ല.';

  @override
  String get vaccineName => 'വാക്സിന്റെ പേര്';

  @override
  String get dateGiven => 'നൽകിയ തീയതി';

  @override
  String get nextDueDate => 'അടുത്ത തീയതി (ഓപ്ഷണൽ)';

  @override
  String get deleteVaccination => 'കുത്തിവയ്പ്പ് നീക്കം ചെയ്യുക';

  @override
  String get deleteVaccinationConfirm =>
      'ഈ കുത്തിവയ്പ്പ് വിവരം നീക്കം ചെയ്യണമെന്നുറപ്പാണോ?';

  @override
  String get vaccinationDeleted => 'കുത്തിവയ്പ്പ് വിവരം നീക്കം ചെയ്തു';

  @override
  String get vaccinationSaved => 'കുത്തിവയ്പ്പ് വിവരം സംരക്ഷിച്ചു';

  @override
  String get notes => 'കുറിപ്പുകൾ';

  @override
  String get addNote => 'കുറിപ്പ് ചേർക്കുക';

  @override
  String get editNote => 'കുറിപ്പ് തിരുത്തുക';

  @override
  String get noNotes => 'കുറിപ്പുകളൊന്നും ചേർത്തിട്ടില്ല.';

  @override
  String get deleteNote => 'കുറിപ്പ് നീക്കം ചെയ്യുക';

  @override
  String get deleteNoteConfirm => 'ഈ കുറിപ്പ് നീക്കം ചെയ്യണമെന്നുറപ്പാണോ?';

  @override
  String get noteDeleted => 'കുറിപ്പ് നീക്കം ചെയ്തു';

  @override
  String get noteSaved => 'കുറിപ്പ് സംരക്ഷിച്ചു';

  @override
  String get cattleIdentification => 'കന്നുകാലി തിരിച്ചറിയൽ';

  @override
  String get cattleIdentificationDesc =>
      'ഈ കന്നുകാലിയെ തിരിച്ചറിയാൻ മുഖത്തിന്റെ ചിത്രങ്ങൾ ചേർക്കുക.';

  @override
  String get noIdentityPhotos => 'മുഖത്തിന്റെ ചിത്രങ്ങൾ ഇതുവരെ ചേർത്തിട്ടില്ല.';

  @override
  String get addFacialPhoto => 'ചിത്രം ചേർക്കുക';

  @override
  String get photos => 'ഫോട്ടോ ഗാലറി';

  @override
  String get addPhoto => 'ഫോട്ടോ ചേർക്കുക';

  @override
  String get photoDesc =>
      'കാലക്രമേണ കന്നുകാലിയുടെ മാറ്റങ്ങൾ നിരീക്ഷിക്കാൻ ഫോട്ടോകൾ ചേർക്കുക.';

  @override
  String get noPhotos => 'ഫോട്ടോകൾ ലഭ്യമല്ല.';

  @override
  String get replace => 'മാറ്റിസ്ഥാപിക്കുക';

  @override
  String get replacePhoto => 'ഈ ഫോട്ടോ മാറ്റണോ?';

  @override
  String get replacePhotoConfirm =>
      'പഴയ ഫോട്ടോ നീക്കം ചെയ്ത് പുതിയ ഫോട്ടോ ചേർക്കും.';

  @override
  String get photoUpdated => 'ഫോട്ടോ പുതുക്കി';

  @override
  String get couldNotUpdatePhoto => 'ഫോട്ടോ പുതുക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get deletePhoto => 'ഫോട്ടോ നീക്കം ചെയ്യുക';

  @override
  String get deletePhotoConfirm =>
      'ഈ ഫോട്ടോ നീക്കം ചെയ്യണമെന്നുറപ്പാണോ? ഇത് തിരിച്ചറിയൽ പട്ടികയിൽ നിന്നും നീക്കം ചെയ്യപ്പെടും.';

  @override
  String get photoDeleted => 'ഫോട്ടോ നീക്കം ചെയ്തു';

  @override
  String addPhotoTo(String id) {
    return '$id-ലേക്ക് ഫോട്ടോ ചേർക്കണോ?';
  }

  @override
  String get addPhotoConfirm =>
      'ഈ ഫോട്ടോ സംരക്ഷിക്കപ്പെടും, ഭാവിയിൽ കന്നുകാലിയെ തിരിച്ചറിയാൻ ഉപയോഗിക്കാം.';

  @override
  String get galleryPhotoConfirm =>
      'കാലക്രമേണ കന്നുകാലിയുടെ വളർച്ച നിരീക്ഷിക്കാൻ ഈ ഫോട്ടോ സംരക്ഷിക്കപ്പെടും.';

  @override
  String get photoAdded => 'ഫോട്ടോ ചേർത്തു';

  @override
  String get couldNotAddPhoto => 'ഫോട്ടോ ചേർക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get takePhoto => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get chooseFromGallery => 'ഗാലറിയിൽ നിന്ന് തിരഞ്ഞെടുക്കുക';

  @override
  String get takeOrChooseClear =>
      'ഈ കന്നുകാലിയുടെ വ്യക്തമായ ഒരു ഫോട്ടോ എടുക്കുകയോ തിരഞ്ഞെടുക്കുകയോ ചെയ്യുക.';

  @override
  String get classifyThisPhoto => 'ഈ ഫോട്ടോയിലെ ഇനം കണ്ടെത്തണോ?';

  @override
  String get classifyThisPhotoConfirm =>
      'വ്യക്തവും വെളിച്ചമുള്ളതുമായ പൂർണ്ണ ശരീര ഫോട്ടോ മികച്ച ഫലം നൽകുന്നു.';

  @override
  String get classify => 'തിരിച്ചറിയുക';

  @override
  String get takeOrChooseFullBody =>
      'കന്നുകാലിയുടെ വ്യക്തമായ പൂർണ്ണ ശരീര ഫോട്ടോ എടുക്കുകയോ തിരഞ്ഞെടുക്കുകയോ ചെയ്യുക.';

  @override
  String get deleteCattleRecord => 'കന്നുകാലി വിവരങ്ങൾ നീക്കം ചെയ്യുക';

  @override
  String deleteCattleRecordConfirm(String id) {
    return '$id-ഉം ബന്ധപ്പെട്ട എല്ലാ വിവരങ്ങളും നീക്കം ചെയ്യണമെന്നുറപ്പാണോ?';
  }

  @override
  String get cattleRecordDeleted => 'കന്നുകാലി വിവരങ്ങൾ നീക്കം ചെയ്തു';

  @override
  String get cattleDetails => 'കന്നുകാലി വിവരങ്ങൾ';

  @override
  String get cattleNotFound => 'കന്നുകാലിയെ കണ്ടെത്തിയില്ല.';

  @override
  String detailsHeader(String id) {
    return '$id വിവരങ്ങൾ';
  }

  @override
  String get identifyCattle => 'കന്നുകാലിയെ തിരിച്ചറിയുക';

  @override
  String get identifyTab => 'തിരിച്ചറിയുക';

  @override
  String get cattleTab => 'എന്റെ കന്നുകാലികൾ';

  @override
  String get tapIdentify =>
      'ഫോട്ടോ ചേർത്തു. \'കന്നുകാലിയെ തിരിച്ചറിയുക\' അമർത്തുക.';

  @override
  String get selectImageFirst => 'ആദ്യം ഒരു ചിത്രം തിരഞ്ഞെടുക്കുക.';

  @override
  String get matchesHeading => 'സാമ്യമുള്ളവ';

  @override
  String get details => 'വിശദാംശങ്ങൾ';

  @override
  String get unknownCattle => 'തിരിച്ചറിയാത്ത കന്നുകാലി';

  @override
  String get registerThisCattle => 'ഈ കന്നുകാലിയെ രജിസ്റ്റർ ചെയ്യുക';

  @override
  String get backButton => 'തിരികെ';

  @override
  String get noCattlesFound => 'കന്നുകാലികളെ കണ്ടെത്തിയില്ല';

  @override
  String get activeLabel => 'സജീവം';

  @override
  String get recoveredLabel => 'രോഗവിമുക്തം';

  @override
  String givenLabel(String date) {
    return 'നൽകിയത്: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'അടുത്തത്: $date';
  }

  @override
  String get tabOverview => 'അവലോകനം';

  @override
  String get tabMedical => 'ചികിത്സ';

  @override
  String get tabGalleryNotes => 'ഗാലറിയും കുറിപ്പുകളും';

  @override
  String dialogIdentifyAs(String id) {
    return '$id ആയി തിരിച്ചറിയണോ?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'ഈ കന്നുകാലിക്ക് $id-മായി വളരെ സാമ്യമുണ്ട് (കൃത്യത: $confidence%). പുതിയതായി രജിസ്റ്റർ ചെയ്യുന്നതിന് പകരം ഈ ഫോട്ടോ $id-ന്റെ ചരിത്രത്തിലേക്ക് ചേർക്കണോ?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id-ലേക്ക് ഫോട്ടോ ചേർക്കുക';
  }

  @override
  String get dialogIdentifyNewCattle => 'അല്ല, ഇത് പുതിയ കന്നുകാലിയാണ്';

  @override
  String get checkingPhotoBeforeReg =>
      'രജിസ്ട്രേഷന് മുമ്പ് ഫോട്ടോ പരിശോധിക്കുന്നു...';

  @override
  String alreadyInHerd(String id) {
    return '$id നിലവിൽ നിങ്ങളുടെ പട്ടികയിലുണ്ട്';
  }

  @override
  String get no => 'അല്ല';

  @override
  String get yes => 'അതെ';

  @override
  String yesAddTo(String id) {
    return 'അതെ, $id-ലേക്ക് ചേർക്കുക';
  }

  @override
  String looksLike(String id) {
    return 'ഇത് $id പോലെ കാണപ്പെടുന്നു';
  }

  @override
  String get addPhotoToThat => 'ഈ ഫോട്ടോ ആ കന്നുകാലിയിലേക്ക് ചേർക്കണോ?';

  @override
  String get createNewCattle => 'പുതിയ കന്നുകാലിയെ ചേർക്കുക';

  @override
  String get savingPhoto => 'ഫോട്ടോ സംരക്ഷിക്കുന്നു...';

  @override
  String photoAddedTo(String id) {
    return '$id-ലേക്ക് ഫോട്ടോ ചേർത്തു';
  }

  @override
  String get couldNotSavePhoto => 'ഈ ഫോട്ടോ സംരക്ഷിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get savingCattleDetails => 'വിവരങ്ങൾ സംരക്ഷിക്കുന്നു...';

  @override
  String addedToHerd(String id) {
    return '$id നിങ്ങളുടെ പട്ടികയിലേക്ക് ചേർത്തു.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id വിജയകരമായി ചേർത്തു';
  }

  @override
  String get exitApp => 'പുറത്തുകടക്കുക';

  @override
  String get exitAppConfirm =>
      'നിങ്ങൾക്ക് ആപ്പിൽ നിന്ന് പുറത്തുകടക്കണമെന്നുണ്ടോ?';

  @override
  String get cancelled => 'റദ്ദാക്കി.';

  @override
  String get couldNotCheckPhoto =>
      'രജിസ്ട്രേഷന് മുമ്പ് ഈ ഫോട്ടോ പരിശോധിക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get couldNotPrepareReg => 'രജിസ്ട്രേഷൻ ഒരുക്കാൻ കഴിഞ്ഞില്ല';

  @override
  String get captureImage => 'ഫോട്ടോ എടുക്കുക';

  @override
  String get uploadImage => 'ചിത്രം അപ്‌ലോഡ് ചെയ്യുക';

  @override
  String get identificationResult => 'തിരിച്ചറിയൽ ഫലം';

  @override
  String get noCattlesMessage =>
      'കന്നുകാലികൾ ലഭ്യമല്ല.\nആദ്യത്തെ കന്നുകാലിയെ ചേർക്കാൻ \'തിരിച്ചറിയുക\' ഉപയോഗിക്കുക.';

  @override
  String get yourHerd => 'നിങ്ങളുടെ കന്നുകാലികൾ';

  @override
  String get welcomeNotebook => 'കന്നുകാലി നോട്ട്ബുക്കിലേക്ക് സ്വാഗതം';

  @override
  String get notebookDescription =>
      'കന്നുകാലികളെ തിരിച്ചറിയാനും വിവരങ്ങൾ രേഖപ്പെടുത്താനും ഫോട്ടോ എടുക്കുകയോ അപ്‌ലോഡ് ചെയ്യുകയോ ചെയ്യുക.';

  @override
  String registeredCattlesCount(int count) {
    return 'രജിസ്റ്റർ ചെയ്ത കന്നുകാലികൾ: $count';
  }

  @override
  String get initErrorOccurred => 'ആപ്പ് തുറക്കുമ്പോൾ ഒരു തകരാറുണ്ടായി.';

  @override
  String get tryAgain => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get noPhotoSelected => 'ഫോട്ടോ തിരഞ്ഞെടുത്തിട്ടില്ല';

  @override
  String get identifyResultPlaceholder =>
      'ഫലം ഇവിടെ കാണാൻ ഒരു കന്നുകാലിയെ തിരിച്ചറിയുക.';

  @override
  String matchConfidence(String confidence) {
    return 'പൊരുത്തപ്പെടൽ കൃത്യത: $confidence%';
  }

  @override
  String get cattleAlreadyInHerd => 'ഈ കന്നുകാലി നിലവിൽ നിങ്ങളുടെ പക്കലുണ്ട്.';

  @override
  String get noMatchingCattleRegisterHint =>
      'പൊരുത്തപ്പെടുന്ന കന്നുകാലികളെ കണ്ടെത്തിയില്ല. പുതിയ കന്നുകാലിയായി ചേർക്കാം.';

  @override
  String cattleSummarySubtitle(int health, int vaccines, int notes) {
    return 'ആരോഗ്യം: $health • വാക്സിൻ: $vaccines • കുറിപ്പുകൾ: $notes';
  }

  @override
  String get diseaseNameLabel => 'രോഗത്തിന്റെ പേര്';

  @override
  String get ongoing => 'തുടരുന്നു';

  @override
  String get recovered => 'രോഗവിമുക്തം';

  @override
  String get symptomsOptional => 'ലക്ഷണങ്ങൾ (ഓപ്ഷണൽ)';

  @override
  String get treatmentNotesOptional => 'ചികിത്സാ കുറിപ്പുകൾ (ഓപ്ഷണൽ)';

  @override
  String get saveHealthRecord => 'ആരോഗ്യ വിവരം സംരക്ഷിക്കുക';

  @override
  String get updateHealthRecord => 'ആരോഗ്യ വിവരം പുതുക്കുക';

  @override
  String get healthRecordAdded => 'ആരോഗ്യ വിവരം ചേർത്തു';

  @override
  String get healthRecordUpdated => 'ആരോഗ്യ വിവരം പുതുക്കി';

  @override
  String get vaccineNameLabel => 'വാക്സിന്റെ പേര്';

  @override
  String get pickDate => 'തീയതി തിരഞ്ഞെടുക്കുക';

  @override
  String get nextDueNotSet => 'അടുത്ത തീയതി: നിശ്ചയിച്ചിട്ടില്ല';

  @override
  String get setNextDue => 'അടുത്ത തീയതി നിശ്ചയിക്കുക';

  @override
  String get notesOptional => 'കുറിപ്പുകൾ (ഓപ്ഷണൽ)';

  @override
  String get saveVaccination => 'കുത്തിവയ്പ്പ് സംരക്ഷിക്കുക';

  @override
  String get updateVaccination => 'കുത്തിവയ്പ്പ് പുതുക്കുക';

  @override
  String get vaccinationAdded => 'കുത്തിവയ്പ്പ് ചേർത്തു';

  @override
  String get vaccinationUpdated => 'കുത്തിവയ്പ്പ് പുതുക്കി';

  @override
  String get addNoteDialogTitle => 'കുറിപ്പ് ചേർക്കുക';

  @override
  String get noteAdded => 'കുറിപ്പ് ചേർത്തു';

  @override
  String get noteUpdated => 'കുറിപ്പ് പുതുക്കി';

  @override
  String dateLabel2(String date) {
    return 'തീയതി: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'നൽകിയത്: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'അടുത്ത തീയതി: $date';
  }

  @override
  String get noSymptomsNoted => 'ലക്ഷണങ്ങൾ ഒന്നും രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String get milkYieldTab => 'പാൽ അളവ്';

  @override
  String get milkAndLactationTitle => 'പാലും കറവക്കാലവും';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get filterButton => 'ഫിൽട്ടർ';

  @override
  String get clearAll => 'എല്ലാം മായ്‌ക്കുക';

  @override
  String showingCattleCount(int filtered, int total) {
    return '$total-ൽ $filtered കന്നുകാലികളെ കാണിക്കുന്നു';
  }

  @override
  String get noCattleMatchFilter =>
      'ഫിൽട്ടറുകൾക്ക് അനുയോജ്യമായ കന്നുകാലികളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get resetSearchAndFilters => 'തിരയലും ഫിൽട്ടറുകളും പുനഃക്രമീകരിക്കുക';

  @override
  String get filterAndSortCattle =>
      'കന്നുകാലികളെ ഫിൽട്ടർ ചെയ്യുക & ക്രമീകരിക്കുക';

  @override
  String get sortOrder => 'ക്രമപ്പെടുത്തൽ';

  @override
  String get resetAll => 'എല്ലാം പുനഃക്രമീകരിക്കുക';

  @override
  String showMatchingCattle(int count) {
    return '$count കന്നുകാലികളെ കാണിക്കുക';
  }

  @override
  String get sexLabel => 'ലിംഗം';

  @override
  String get lifeStageLabel => 'ജീവിത ഘട്ടം';

  @override
  String get healthStatusLabel => 'ആരോഗ്യ നില';

  @override
  String get reproductiveStatusLabel => 'പ്രത്യുൽപാദന നില';

  @override
  String get vaccinationStatusLabel => 'വാക്സിനേഷൻ';

  @override
  String get milkAndLactation => 'പാലും കറവക്കാലവും';

  @override
  String get breedCategory => 'ഇനം';

  @override
  String get female => 'പെൺ';

  @override
  String get male => 'ആൺ';

  @override
  String get calf => 'കിടാവ്';

  @override
  String get heifer => 'കിടാരി';

  @override
  String get cow => 'പശു';

  @override
  String get bull => 'കാള';

  @override
  String get steer => 'മൂരി';

  @override
  String get healthy => 'ആരോഗ്യമുള്ളത്';

  @override
  String get underObservation => 'നിരീക്ഷണത്തിൽ';

  @override
  String get diseased => 'രോഗബാധിതം';

  @override
  String get unknown => 'അജ്ഞാതം';

  @override
  String get pregnant => 'ചനയുള്ളത്';

  @override
  String get notPregnant => 'ചനയില്ലാത്തത്';

  @override
  String get upToDate => 'കൃത്യസമയത്തുള്ളത്';

  @override
  String get dueSoon => 'ഉടൻ നൽകണം';

  @override
  String get overdue => 'കാലാവധി കഴിഞ്ഞു';

  @override
  String get noRecord => 'രേഖകളില്ല';

  @override
  String get milkingCows => 'കറവപ്പശുക്കൾ';

  @override
  String get dryCows => 'വറ്റിയ പശുക്കൾ';

  @override
  String get highProducers => 'കൂടുതൽ പാൽ നൽകുന്നവ (>15 ലി/ദിവസം)';

  @override
  String get mediumProducers => 'ഇടത്തരം പാൽ നൽകുന്നവ (8–15 ലി/ദിവസം)';

  @override
  String get lowProducers => 'കുറഞ്ഞ പാൽ നൽകുന്നവ (<8 ലി/ദിവസം)';

  @override
  String get recentlyCalved => 'അടുത്തിടെ പ്രസവിച്ചവ';

  @override
  String get sortRecentlyAdded => 'അടുത്തിടെ ചേർത്തവ';

  @override
  String get sortOldestAdded => 'ഏറ്റവും പഴയവ';

  @override
  String get sortNameAsc => 'ഐഡി (A → Z)';

  @override
  String get sortNameDesc => 'ഐഡി (Z → A)';

  @override
  String get sortAgeAsc => 'പ്രായം (കുറഞ്ഞത് ആദ്യം)';

  @override
  String get sortAgeDesc => 'പ്രായം (കൂടിയത് ആദ്യം)';

  @override
  String get todaysMilkProduction => 'ഇന്നത്തെ പാൽ ഉത്പാദനം';

  @override
  String cowsMilked(int count) {
    return '$count പശുക്കളെ കറന്നു';
  }

  @override
  String get liters => 'ലിറ്റർ';

  @override
  String get averagePerCow => 'ശരാശരി / പശുവിന്';

  @override
  String topProducer(String id, String yield) {
    return 'കൂടുതൽ: #$id ($yield ലി)';
  }

  @override
  String get topProducerNone => 'കൂടുതൽ പാൽ തന്നത്: ഒന്നുമില്ല';

  @override
  String lowestProducer(String id, String yield) {
    return 'കുറവ്: #$id ($yield ലി)';
  }

  @override
  String get thisWeek => 'ഈ ആഴ്ച';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get milkingHerd => 'കറവപ്പശുക്കളുടെ എണ്ണം';

  @override
  String cowsCount(int count) {
    return '$count പശുക്കൾ';
  }

  @override
  String get recordMilk => 'പാൽ രേഖപ്പെടുത്തുക';

  @override
  String get reports => 'റിപ്പോർട്ടുകൾ';

  @override
  String get productionAnalytics => 'ഉത്പാദന വിശകലനം';

  @override
  String get milkHistory => 'പാൽ അളവ് ചരിത്രം';

  @override
  String daysLogged(int count) {
    return '$count ദിവസങ്ങൾ രേഖപ്പെടുത്തി';
  }

  @override
  String get noMilkRecordsSavedYet =>
      'പാൽ രേഖകളൊന്നും ചേർത്തിട്ടില്ല. തുടങ്ങാൻ \'പാൽ രേഖപ്പെടുത്തുക\' അമർത്തുക.';

  @override
  String get breedAnalyticsFilter => 'ഇനം തിരിച്ചുള്ള വിശകലനം:';

  @override
  String get allBreeds => 'എല്ലാ ഇനങ്ങളും';

  @override
  String cowsRecordedCount(int count, String plural) {
    return '$count പശു$plural രേഖപ്പെടുത്തി';
  }

  @override
  String get morningShort => 'രാ';

  @override
  String get eveningShort => 'വൈ';

  @override
  String get editMilkRecord => 'പാൽ രേഖ തിരുത്തുക';

  @override
  String get recordMilkYield => 'പാൽ അളവ് രേഖപ്പെടുത്തുക';

  @override
  String get recordExistsWarning =>
      'ഈ തീയതിയിൽ ഈ പശുവിന്റെ രേഖ നിലവിലുണ്ട്. സംരക്ഷിച്ചാൽ പഴയത് തിരുത്തപ്പെടും.';

  @override
  String get cattleLabel => 'കന്നുകാലി';

  @override
  String get selectCow => 'പശുവിനെ തിരഞ്ഞെടുക്കുക';

  @override
  String get milkingBadge => 'കറവയിലുള്ളത്';

  @override
  String get recordDate => 'രേഖപ്പെടുത്തിയ തീയതി';

  @override
  String get morningLiters => 'രാവിലെ (ലിറ്റർ)';

  @override
  String get eveningLiters => 'വൈകുന്നേരം (ലിറ്റർ)';

  @override
  String get totalDailyYield => 'ആകെ പ്രതിദിന പാൽ';

  @override
  String get notesOptionalMilk => 'കുറിപ്പുകൾ (ഓപ്ഷണൽ)';

  @override
  String get notesHintMilk => 'ഉദാ. തീറ്റ നൽകി, സാധാരണ ആരോഗ്യം';

  @override
  String get updateRecord => 'വിവരം പുതുക്കുക';

  @override
  String get saveRecordButton => 'വിവരം സംരക്ഷിക്കുക';

  @override
  String get pleaseSelectCattle => 'ഒരു കന്നുകാലിയെ തിരഞ്ഞെടുക്കുക';

  @override
  String get milkProductionReports => 'പാൽ ഉത്പാദന റിപ്പോർട്ടുകൾ';

  @override
  String breedFilterBadge(String breed) {
    return 'ഇനം ഫിൽട്ടർ: $breed';
  }

  @override
  String get dailyTab => 'ദിവസേന';

  @override
  String get weeklyTab => 'പ്രതിവാരം';

  @override
  String get monthlyTab => 'പ്രതിമാസം';

  @override
  String get reportDateLabel => 'റിപ്പോർട്ട് തീയതി: ';

  @override
  String get weekStartLabel => 'ആഴ്ച ആരംഭം: ';

  @override
  String downloadCsvReport(String type) {
    return '$type CSV റിപ്പോർട്ട് ഡൗൺലോഡ് ചെയ്യുക';
  }

  @override
  String reportSaved(String fileName) {
    return 'റിപ്പോർട്ട് സംരക്ഷിച്ചു: $fileName';
  }

  @override
  String get reportCopied => 'റിപ്പോർട്ട് ക്ലിപ്പ്ബോർഡിലേക്ക് പകർത്തി!';

  @override
  String get dailyAvg => 'ദിവസേനയുള്ള ശരാശരി';

  @override
  String get totalYieldLabel => 'ആകെ ഉത്പാദനം';

  @override
  String get bestLabel => 'മികച്ചത്';

  @override
  String get worstLabel => 'കുറഞ്ഞത്';

  @override
  String get orderLabel => 'ക്രമം:';

  @override
  String get bestToWorst => 'കൂടിയതിൽ നിന്ന് കുറഞ്ഞതിലേക്ക്';

  @override
  String get worstToBest => 'കുറഞ്ഞതിൽ നിന്ന് കൂടിയതിലേക്ക്';

  @override
  String noMilkRecordsForPeriod(String breedText) {
    return 'ഈ കാലയളവിൽ പാൽ വിവരങ്ങൾ ലഭ്യമല്ല$breedText.';
  }

  @override
  String recordedOutOfDays(int recorded, int total) {
    return 'രേഖപ്പെടുത്തിയത്: $recorded/$total ദിവസങ്ങൾ';
  }

  @override
  String recordedEntriesCount(int count) {
    return 'രേഖപ്പെടുത്തിയത്: $count വിവരങ്ങൾ';
  }

  @override
  String morningEveningBreakdown(String morning, String evening) {
    return 'രാവിലെ: $morning ലി  •  വൈകുന്നേരം: $evening ലി';
  }

  @override
  String get notificationsAndSmartAlerts =>
      'അറിയിപ്പുകളും സ്മാർട്ട് അലേർട്ടുകളും';

  @override
  String get allClear => 'എല്ലാം ഭദ്രമാണ്!';

  @override
  String get noPendingAlerts => 'തീർപ്പാക്കാത്ത അറിയിപ്പുകളോ അലേർട്ടുകളോ ഇല്ല.';

  @override
  String get viewAction => 'കാണുക';

  @override
  String get recordMilkAction => 'പാൽ രേഖപ്പെടുത്തുക';

  @override
  String get logCalvingAction => 'പ്രസവം രേഖപ്പെടുത്തുക';

  @override
  String get vaccinateAction => 'വാക്സിൻ നൽകുക';

  @override
  String get editCattleDetails => 'കന്നുകാലി വിവരങ്ങൾ തിരുത്തുക';

  @override
  String get dateOfBirthAge => 'ജനനത്തീയതി (പ്രായം)';

  @override
  String get notSet => 'നിശ്ചയിച്ചിട്ടില്ല';

  @override
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural) {
    return '$years വർഷം$yPlural $months മാസം$mPlural';
  }

  @override
  String yearsAge(int years, String yPlural) {
    return '$years വർഷം$yPlural';
  }

  @override
  String monthsAge(int months, String mPlural) {
    return '$months മാസം$mPlural';
  }

  @override
  String get unknownAge => 'പ്രായം അറിയില്ല';

  @override
  String get milkAndLactationProfile => 'പാലും കറവക്കാല വിവരങ്ങളും';

  @override
  String get currentlyMilking => 'നിലവിൽ കറവയുള്ളത്';

  @override
  String get lastCalvingDate => 'അവസാന പ്രസവ തീയതി';

  @override
  String get inseminationDate => 'ബീജസങ്കലന തീയതി';

  @override
  String get expectedDailyYieldBenchmark =>
      'പ്രതീക്ഷിക്കുന്ന പ്രതിദിന ഉത്പാദനം (മാനദണ്ഡം)';

  @override
  String get benchmarkHint => 'ഉദാ. 15.0';

  @override
  String get symptomsHint => 'ഉദാ. ശരിയായി തീറ്റ എടുക്കുന്നില്ല';

  @override
  String get cattleDetailsUpdated => 'കന്നുകാലി വിവരങ്ങൾ പുതുക്കി';

  @override
  String get milkProductionTab => 'പാൽ ഉത്പാദനം';

  @override
  String get lactationStatus => 'കറവ നില';

  @override
  String get daysInMilk => 'കറവ ദിവസങ്ങൾ (DIM)';

  @override
  String daysUnit(int count) {
    return '$count ദിവസങ്ങൾ';
  }

  @override
  String get lastCalving => 'അവസാന പ്രസവം';

  @override
  String get estNextCalving => 'പ്രതീക്ഷിക്കുന്ന അടുത്ത പ്രസവം';

  @override
  String get thirtyDayAverage => '30 ദിവസത്തെ ശരാശരി';

  @override
  String get totalThisMonth => 'ഈ മാസത്തെ ആകെ';

  @override
  String get recentMilkYieldTrend => 'സമീപകാല പാൽ ഉത്പാദന ട്രെൻഡ്';

  @override
  String get dailyMilkRecords => 'പ്രതിദിന പാൽ വിവരങ്ങൾ';

  @override
  String get noDailyMilkRecords =>
      'ഈ പശുവിന് പ്രതിദിന പാൽ വിവരങ്ങൾ രേഖപ്പെടുത്തിയിട്ടില്ല.';

  @override
  String litersPerDay(String yield) {
    return '$yield ലി/ദിവസം';
  }

  @override
  String get freshStage => 'തുടക്ക ഘട്ടം';

  @override
  String get earlyStage => 'ആദ്യ ഘട്ടം';

  @override
  String get midStage => 'മധ്യ ഘട്ടം';

  @override
  String get lateStage => 'അന്ത്യ ഘട്ടം';

  @override
  String get extendedStage => 'ദീർഘിപ്പിച്ച കറവ';

  @override
  String get dryStage => 'വറ്റുകാലം';

  @override
  String stageSuffix(String stage) {
    return '$stage ഘട്ടം';
  }

  @override
  String get calvingDateOverdue => 'പ്രസവ തീയതി കഴിഞ്ഞു';

  @override
  String calvingOverdueMessage(String date) {
    return 'പ്രതീക്ഷിച്ച പ്രസവ തീയതി ($date) കഴിഞ്ഞിരിക്കുന്നു. പ്രസവ വിവരങ്ങളോ ഗർഭാവസ്ഥയോ അപ്‌ഡേറ്റ് ചെയ്യുക.';
  }

  @override
  String get logCalving => 'പ്രസവം രേഖപ്പെടുത്തുക';

  @override
  String get predictedBreed => 'പ്രതീക്ഷിക്കുന്ന ഇനം';

  @override
  String get noMilkChartRecords =>
      'പാൽ രേഖകൾ ഇതുവരെയില്ല.\nഉത്പാദന പ്രവണതകൾ കാണാൻ രേഖപ്പെടുത്താൻ ആരംഭിക്കുക.';

  @override
  String get setAsUnknown => 'അജ്ഞാതമായി സജ്ജീകരിക്കുക';

  @override
  String breedPredictionItem(String name, int percent) {
    return '• $name — $percent%';
  }

  @override
  String get sexRequired => 'ലിംഗം *';

  @override
  String get optionalNoteHint => 'ഉദാ. ചനയുള്ളത്';

  @override
  String get missingMilkEntryToday => 'ഇന്നത്തെ പാൽ രേഖപ്പെടുത്തിയിട്ടില്ല';

  @override
  String missingMilkEntryTitle(String date) {
    return 'പാൽ രേഖപ്പെടുത്തിയിട്ടില്ല ($date)';
  }

  @override
  String noMilkRecordEntered(String dateLabel, String id) {
    return '$dateLabel #$id-ന് പാൽ രേഖപ്പെടുത്തിയിട്ടില്ല.';
  }

  @override
  String get today => 'ഇന്ന്';

  @override
  String get yesterday => 'ഇന്നലെ';

  @override
  String onDate(String date) {
    return '$date-ൽ';
  }

  @override
  String get lowYieldAlertTitle => 'കുറഞ്ഞ ഉത്പാദന മുന്നറിയിപ്പ്';

  @override
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  ) {
    return '#$id-ന്റെ പാൽ ഉത്പാദനം $percent% കുറഞ്ഞു ($latest ലിറ്ററും ശരാശരി $avg ലിറ്ററും).';
  }

  @override
  String get dryOffReminderTitle => 'വറ്റുകാല ഓർമ്മപ്പെടുത്തൽ';

  @override
  String dryOffReminderMessage(String id, int days) {
    return '#$id $days ദിവസത്തിനുള്ളിൽ പ്രസവിക്കുമെന്ന് പ്രതീക്ഷിക്കുന്നു. പശുവിനെ വറ്റുകാലത്തിനായി തയാറാക്കുക.';
  }

  @override
  String get calvingDateOverdueTitle => 'പ്രസവ തീയതി കഴിഞ്ഞു';

  @override
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  ) {
    return '#$id-ന്റെ പ്രതീക്ഷിച്ച പ്രസവ തീയതി $days ദിവസം$plural മുമ്പായിരുന്നു ($date). വിവരങ്ങൾ അപ്‌ഡേറ്റ് ചെയ്യുക.';
  }

  @override
  String get calvingReminderTitle => 'പ്രസവ ഓർമ്മപ്പെടുത്തൽ';

  @override
  String calvingReminderMessage(String id, int days, String plural) {
    return '#$id $days ദിവസം$pluralക്കുള്ളിൽ പ്രസവിക്കും. പ്രസവക്കൂട് തയാറാക്കുക.';
  }

  @override
  String get vaccinationOverdueTitle => 'വാക്സിൻ കാലാവധി കഴിഞ്ഞു';

  @override
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName വാക്സിൻ നൽകേണ്ട തീയതി $days ദിവസം$plural മുമ്പായിരുന്നു ($date).';
  }

  @override
  String get vaccinationDueSoonTitle => 'വാക്സിൻ ഉടൻ നൽകണം';

  @override
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName വാക്സിൻ $days ദിവസം$pluralക്കുള്ളിൽ നൽകണം ($date).';
  }
}
