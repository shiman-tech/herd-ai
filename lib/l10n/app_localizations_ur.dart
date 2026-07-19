// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'ہرڈ آئی (Herd AI)';

  @override
  String get appSubtitle => 'آپ کے مویشیوں کی ڈائری';

  @override
  String get preparingSecureAccess => 'محفوظ رسائی کی تیاری کی جا رہی ہے...';

  @override
  String get createPin => '4 ہندسوں کا پن بنائیں';

  @override
  String get enterPin => 'اپنا پن درج کریں';

  @override
  String get unlockApp => 'ایپ انلاک کریں';

  @override
  String get confirmPin => 'پن کی تصدیق کریں';

  @override
  String get pinDidNotMatchTryAgain => 'پن مطابقت نہیں رکھتا۔ دوبارہ کوشش کریں';

  @override
  String get pinDidNotMatch => 'پن مطابقت نہیں رکھتا';

  @override
  String get pinCreated => 'پن بن گیا';

  @override
  String get unlocked => 'انلاک ہو گیا';

  @override
  String get wrongPinTryAgain => 'غلط پن۔ دوبارہ کوشش کریں';

  @override
  String get wrongPin => 'غلط پن';

  @override
  String get usePinToUnlock => 'انلاک کرنے کے لیے پن کا استعمال کریں';

  @override
  String get tryFingerprintFace => 'فنگر پرنٹ/فیس آئی ڈی آزمائیں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get changePin => 'پن تبدیل کریں';

  @override
  String get language => 'زبان (Language)';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get currentPin => 'موجودہ پن';

  @override
  String get newPin => 'نیا پن';

  @override
  String get confirmNewPin => 'نئے پن کی تصدیق کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get wrongCurrentPin => 'غلط موجودہ پن';

  @override
  String get pinChanged => 'پن تبدیل ہو گیا';

  @override
  String get pinsDoNotMatch => 'نئے پن مطابقت نہیں رکھتے';

  @override
  String get enterAllFields => 'براہ کرم تمام خانے پُر کریں';

  @override
  String get invalidPinLength => 'پن 4 ہندسوں کا ہونا ضروری ہے';

  @override
  String get cowsNotebook => 'مویشیوں کی نوٹ بک';

  @override
  String get noCows => 'ابھی تک کوئی گائے رجسٹرڈ نہیں ہے۔';

  @override
  String get searchHint => 'اپنے ریوڑ میں تلاش کریں...';

  @override
  String cowIdLabel(String id) {
    return 'گائے کا شناختی کارڈ: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'رجسٹرڈ شدہ تاریخ: $date';
  }

  @override
  String get readyToIdentify =>
      'گائے کی شناخت اور ریکارڈ رکھنے کے لیے تیار ہے۔';

  @override
  String get initializingDb => 'آپ کے مویشیوں کی ڈائری تیار ہو رہی ہے...';

  @override
  String get readyText => 'شناخت کے لیے تیار';

  @override
  String get notReady => 'ایپ سیٹ اپ ابھی مکمل نہیں ہوا ہے۔ دوبارہ کوشش کریں۔';

  @override
  String get selectImage => 'ماڈل لوڈ ہونے کے بعد تصویر منتخب کریں۔';

  @override
  String get checkingCow => 'گائے کی جانچ ہو رہی ہے...';

  @override
  String get cowIdentified => 'گائے کی شناخت ہو گئی ہے۔';

  @override
  String get borderlineMatch =>
      'یہ آپ کی پہلے سے موجود کسی گائے جیسی دکھتی ہے — نیچے دیکھیں۔';

  @override
  String get noMatchingCow => 'کوئی مماثل گائے نہیں ملی۔';

  @override
  String get couldNotIdentify => 'اس وقت اس گائے کی شناخت نہیں ہو سکی۔';

  @override
  String get addThisCow => 'اس گائے کو شامل کریں';

  @override
  String get cowId => 'گائے کا شناختی کارڈ';

  @override
  String get optionalNote => 'نوٹ (اختیاری)';

  @override
  String get register => 'رجسٹر کریں';

  @override
  String get addCow => 'گائے شامل کریں';

  @override
  String get cowAlreadyExists => 'گائے کا شناختی کارڈ پہلے ہی موجود ہے';

  @override
  String get pleaseEnterId => 'براہ کرم شناختی کارڈ درج کریں';

  @override
  String get registering => 'رجسٹریشن ہو رہی ہے...';

  @override
  String get cowRegistered => 'گائے رجسٹرڈ ہو گئی';

  @override
  String get failedToRegister => 'گائے کو رجسٹر نہیں کیا جا سکا';

  @override
  String get basicInfo => 'بنیادی معلومات';

  @override
  String registeredOn(String date) {
    return 'رجسٹرڈ شدہ تاریخ: $date';
  }

  @override
  String get breedClassification => 'نسل کی درجہ بندی';

  @override
  String get classifyBreed => 'نسل کی شناخت کریں';

  @override
  String get reClassify => 'دوبارہ شناخت کریں';

  @override
  String get noBreedClassificationYet =>
      'ابھی تک نسل کی کوئی درجہ بندی نہیں ہے۔ پورے جسم کی تصویر لیں۔';

  @override
  String confirmedBreed(String breed) {
    return 'تصدیق شدہ نسل: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'کم اعتماد — پورے جسم کی زیادہ واضح تصویر آزمائیں۔';

  @override
  String get setManually => 'دستی طور پر سیٹ کریں';

  @override
  String get unknownMixed => 'نامعلوم / مخلوط نسل';

  @override
  String get likelyBreedsVisual => 'ممکنہ نسلیں (بصری اندازہ):';

  @override
  String confirmBreed(String breed) {
    return '$breed کی تصدیق کریں';
  }

  @override
  String get chooseDifferent => 'دوسری منتخب کریں';

  @override
  String get breedClassified => 'نسل کی شناخت ہو گئی';

  @override
  String get couldNotClassify => 'نسل کی شناخت نہیں ہو سکی';

  @override
  String get noBreedPredictions => 'نسل کی کوئی پیشن گوئی موصول نہیں ہوئی';

  @override
  String breedConfirmed(String breed) {
    return 'نسل کی تصدیق ہو گئی: $breed';
  }

  @override
  String get chooseBreed => 'نسل منتخب کریں';

  @override
  String get orTypeBreedName => 'یا نسل کا نام لکھیں:';

  @override
  String get confirmCustomBreed => 'اپنی مرضی کی نسل کی تصدیق کریں';

  @override
  String get customBreedHint => 'مثال کے طور پر: جرسی کراس';

  @override
  String get breedSetUnknown => 'نسل کو نامعلوم / مخلوط پر سیٹ کر دیا گیا ہے';

  @override
  String get healthRecords => 'طبی ریکارڈ';

  @override
  String get addHealthRecord => 'طبی ریکارڈ شامل کریں';

  @override
  String get editHealthRecord => 'طبی ریکارڈ میں ترمیم کریں';

  @override
  String get noHealthRecords => 'ابھی تک کوئی طبی ریکارڈ نہیں ہے۔';

  @override
  String get diseaseName => 'بیماری کا نام';

  @override
  String get symptoms => 'علامات';

  @override
  String get status => 'حالت';

  @override
  String get dateLabel => 'تاریخ';

  @override
  String get delete => 'حذف کریں';

  @override
  String get edit => 'ترمیم';

  @override
  String get deleteHealthRecord => 'طبی ریکارڈ حذف کریں';

  @override
  String get deleteHealthRecordConfirm =>
      'کیا آپ اس طبی ریکارڈ کو حذف کرنا چاہتے ہیں؟';

  @override
  String get healthRecordDeleted => 'طبی ریکارڈ حذف ہو گیا';

  @override
  String get healthRecordSaved => 'طبی ریکارڈ محفوظ ہو گیا';

  @override
  String get vaccinationRecords => 'ویکسینیشن ریکارڈ';

  @override
  String get addVaccination => 'ویکسین شامل کریں';

  @override
  String get editVaccination => 'ویکسینیشن میں ترمیم کریں';

  @override
  String get noVaccinationRecords =>
      'ابھی تک ویکسینیشن کا کوئی ریکارڈ نہیں ہے۔';

  @override
  String get vaccineName => 'ویکسین کا نام';

  @override
  String get dateGiven => 'ویکسین دینے کی تاریخ';

  @override
  String get nextDueDate => 'اگلی تاریخ (اختیاری)';

  @override
  String get deleteVaccination => 'ویکسینیشن ریکارڈ حذف کریں';

  @override
  String get deleteVaccinationConfirm =>
      'کیا آپ اس ویکسینیشن ریکارڈ کو حذف کرنا چاہتے ہیں؟';

  @override
  String get vaccinationDeleted => 'ویکسینیشن ریکارڈ حذف ہو گیا';

  @override
  String get vaccinationSaved => 'ویکسینیشن ریکارڈ محفوظ ہو گیا';

  @override
  String get notes => 'نوٹس (یادداشت)';

  @override
  String get addNote => 'نوٹ شامل کریں';

  @override
  String get editNote => 'نوٹ میں ترمیم کریں';

  @override
  String get noNotes => 'کوئی نوٹ شامل نہیں کیا گیا۔';

  @override
  String get deleteNote => 'نوٹ حذف کریں';

  @override
  String get deleteNoteConfirm => 'کیا آپ اس نوٹ کو حذف کرنا چاہتے ہیں؟';

  @override
  String get noteDeleted => 'نوٹ حذف ہو گیا';

  @override
  String get noteSaved => 'نوٹ محفوظ ہو گیا';

  @override
  String get photos => 'تصاویر';

  @override
  String get addPhoto => 'تصویر شامل کریں';

  @override
  String get photoDesc =>
      'وقت کے ساتھ ساتھ اس گائے کی ظاہری شکل پر نظر رکھیں۔ نئی تصاویر پہلے نظر آئیں گی۔';

  @override
  String get noPhotos => 'ابھی تک کوئی تصویر نہیں ہے۔';

  @override
  String get replace => 'تبدیل کریں';

  @override
  String get replacePhoto => 'اس تصویر کو تبدیل کریں؟';

  @override
  String get replacePhotoConfirm =>
      'پرانی تصویر کو ہٹا کر اس کی جگہ نئی تصویر رکھ دی جائے گی۔';

  @override
  String get photoUpdated => 'تصویر اپ ڈیٹ ہو گئی';

  @override
  String get couldNotUpdatePhoto => 'تصویر اپ ڈیٹ نہیں ہو سکی';

  @override
  String get deletePhoto => 'تصویر حذف کریں';

  @override
  String get deletePhotoConfirm =>
      'کیا اس تصویر کو حذف کرنا چاہتے ہیں؟ اسے گائے کی شناخت کی فہرست سے بھی ہٹا دیا جائے گا۔';

  @override
  String get photoDeleted => 'تصویر حذف ہو گئی';

  @override
  String addPhotoTo(String id) {
    return 'کیا $id میں تصویر شامل کریں؟';
  }

  @override
  String get addPhotoConfirm =>
      'وقت کے ساتھ ساتھ گائے کی ظاہری شکل پر نظر رکھنے کے لیے یہ تصویر آج کی تاریخ کے ساتھ محفوظ کی جائے گی۔ اس سے مستقبل میں گائے کی شناخت میں بھی مدد ملے گی۔';

  @override
  String get photoAdded => 'تصویر شامل ہو گئی';

  @override
  String get couldNotAddPhoto => 'تصویر شامل نہیں کی جا سکی';

  @override
  String get takePhoto => 'تصویر لیں';

  @override
  String get chooseFromGallery => 'گیلری سے منتخب کریں';

  @override
  String get takeOrChooseClear =>
      'اس گائے کی واضح تصویر لیں یا گیلری سے منتخب کریں۔';

  @override
  String get classifyThisPhoto => 'کیا اس تصویر کی درجہ بندی کریں؟';

  @override
  String get classifyThisPhotoConfirm =>
      'پورے جسم کی ایک واضح اور روشن تصویر نسل کی بہترین درجہ بندی فراہم کرتی ہے۔';

  @override
  String get classify => 'درجہ بندی کریں';

  @override
  String get takeOrChooseFullBody =>
      'اس گائے کے پورے جسم کی واضح تصویر لیں یا گیلری سے منتخب کریں۔';

  @override
  String get deleteCowRecord => 'گائے کا ریکارڈ حذف کریں';

  @override
  String deleteCowRecordConfirm(String id) {
    return 'کیا آپ $id اور اس سے متعلقہ تمام ریکارڈز حذف کرنا چاہتے ہیں؟';
  }

  @override
  String get cowRecordDeleted => 'گائے کا ریکارڈ حذف ہو گیا';

  @override
  String get cowDetails => 'گائے کی تفصیلات';

  @override
  String get cowNotFound => 'گائے کا ریکارڈ نہیں ملا۔';

  @override
  String detailsHeader(String id) {
    return '$id کی تفصیلات';
  }

  @override
  String get identifyCow => 'گائے کی شناخت کریں';

  @override
  String get identifyTab => 'شناخت کریں';

  @override
  String get cowsTab => 'میری گائیں';

  @override
  String get tapIdentify =>
      'تصویر شامل کر دی گئی۔ گائے کی شناخت کریں پر ٹیپ کریں۔';

  @override
  String get selectImageFirst => 'پہلے تصویر منتخب کریں۔';

  @override
  String get matchesHeading => 'مماثلت';

  @override
  String get details => 'تفصیلات';

  @override
  String get unknownCow => 'نامعلوم گائے';

  @override
  String get registerThisCow => 'اس گائے کو رجسٹر کریں';

  @override
  String get backButton => 'پیچھے';

  @override
  String get noCowsFound => 'کوئی گائے نہیں ملی';

  @override
  String get activeLabel => 'فعال';

  @override
  String get recoveredLabel => 'صحت یاب';

  @override
  String givenLabel(String date) {
    return 'دی گئی تاریخ: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'اگلی تاریخ: $date';
  }

  @override
  String get tabOverview => 'جائزہ';

  @override
  String get tabMedical => 'طبی معلومات';

  @override
  String get tabGalleryNotes => 'گیلری اور نوٹس';

  @override
  String dialogIdentifyAs(String id) {
    return 'کیا $id کے طور پر شناخت کریں؟';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'یہ گائے بالکل $id جیسی دکھتی ہے (اعتماد: $confidence%)۔ کیا آپ نئی گائے رجسٹر کرنے کے بجائے یہ تصویر $id کی تاریخ میں محفوظ کرنا چاہتے ہیں؟';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id میں تصویر محفوظ کریں';
  }

  @override
  String get dialogIdentifyNewCow => 'نہیں، یہ نئی گائے ہے';

  @override
  String get checkingPhotoBeforeReg =>
      'رجسٹریشن سے پہلے تصویر کی جانچ کی جا رہی ہے...';

  @override
  String alreadyInHerd(String id) {
    return '$id پہلے ہی آپ کے ریوڑ میں موجود ہے';
  }

  @override
  String get no => 'نہیں';

  @override
  String get yes => 'جی ہاں';

  @override
  String yesAddTo(String id) {
    return 'جی ہاں، $id میں شامل کریں';
  }

  @override
  String looksLike(String id) {
    return 'یہ $id جیسا لگتا ہے';
  }

  @override
  String get addPhotoToThat => 'کیا یہ تصویر اس گائے میں شامل کریں؟';

  @override
  String get createNewCow => 'نئی گائے شامل کریں';

  @override
  String get savingPhoto => 'تصویر محفوظ کی جا رہی ہے...';

  @override
  String photoAddedTo(String id) {
    return 'تصویر $id میں شامل ہو گئی';
  }

  @override
  String get couldNotSavePhoto => 'یہ تصویر محفوظ نہیں کی جا سکی۔';

  @override
  String get savingCowDetails => 'گائے کی تفصیلات محفوظ کی جا رہی ہیں...';

  @override
  String addedToHerd(String id) {
    return '$id آپ کے ریوڑ میں شامل ہو گئی۔';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id کامیابی سے شامل ہو گئی';
  }

  @override
  String get exitApp => 'ایپ بند کریں';

  @override
  String get exitAppConfirm => 'کیا آپ ایپ بند کرنا چاہتے ہیں؟';

  @override
  String get cancelled => 'منسوخ ہو گیا۔';

  @override
  String get couldNotCheckPhoto =>
      'رجسٹریشن سے پہلے تصویر کی جانچ نہیں کی جا سکی۔';

  @override
  String get couldNotPrepareReg => 'رجسٹریشن کی تیاری نہیں کی جا سکی';

  @override
  String get captureImage => 'تصویر کھینچیں';

  @override
  String get uploadImage => 'تصویر اپلوڈ کریں';

  @override
  String get identificationResult => 'شناخت کا نتیجہ';

  @override
  String get noCowsMessage =>
      'کوئی گائے نہیں ملی۔\nپہلی گائے شامل کرنے کے لیے \'شناخت کریں\' کا استعمال کریں۔';

  @override
  String get yourHerd => 'آپ کا ریوڑ';

  @override
  String get welcomeNotebook => 'مویشیوں کی نوٹ بک میں خوش آمدید';

  @override
  String get notebookDescription =>
      'گائے کی شناخت کرنے اور سادہ طبی ریکارڈ رکھنے کے لیے تصویر لیں یا اپلوڈ کریں۔';

  @override
  String registeredCowsCount(int count) {
    return 'رجسٹرڈ گائیں: $count';
  }

  @override
  String get initErrorOccurred => 'ایپ لوڈ کرنے کے دوران کچھ غلط ہو گیا۔';

  @override
  String get tryAgain => 'دوبارہ کوشش کریں';

  @override
  String get noPhotoSelected => 'کوئی تصویر منتخب نہیں کی گئی';

  @override
  String get identifyResultPlaceholder =>
      'نتیجہ دیکھنے کے لیے پہلے گائے کی تصویر اپلوڈ کریں۔';

  @override
  String matchConfidence(String confidence) {
    return 'مماثلت کا فیصد: $confidence%';
  }

  @override
  String get cowAlreadyInHerd => 'یہ گائے پہلے ہی آپ کے ریوڑ میں موجود ہے۔';

  @override
  String get noMatchingCowRegisterHint =>
      'کوئی مماثل گائے نہیں ملی۔ آپ اسے نئی گائے کے طور پر شامل کر سکتے ہیں۔';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'طبی ریکارڈ: $health • ویکسینز: $vaccines • نوٹس: $notes';
  }

  @override
  String get diseaseNameLabel => 'بیماری کا نام';

  @override
  String get ongoing => 'فعال';

  @override
  String get recovered => 'صحت یاب';

  @override
  String get symptomsOptional => 'علامات (اختیاری)';

  @override
  String get treatmentNotesOptional => 'علاج کے نوٹس (اختیاری)';

  @override
  String get saveHealthRecord => 'طبی ریکارڈ محفوظ کریں';

  @override
  String get updateHealthRecord => 'طبی ریکارڈ اپ ڈیٹ کریں';

  @override
  String get healthRecordAdded => 'طبی ریکارڈ شامل ہو گیا';

  @override
  String get healthRecordUpdated => 'طبی ریکارڈ اپ ڈیٹ ہو گیا';

  @override
  String get vaccineNameLabel => 'ویکسین کا نام';

  @override
  String get pickDate => 'تاریخ منتخب کریں';

  @override
  String get nextDueNotSet => 'اگلی تاریخ: سیٹ نہیں ہے';

  @override
  String get setNextDue => 'اگلی تاریخ طے کریں';

  @override
  String get notesOptional => 'نوٹس (اختیاری)';

  @override
  String get saveVaccination => 'ویکسینیشن ریکارڈ محفوظ کریں';

  @override
  String get updateVaccination => 'ویکسینیشن ریکارڈ اپ ڈیٹ کریں';

  @override
  String get vaccinationAdded => 'ویکسینیشن ریکارڈ شامل ہو گیا';

  @override
  String get vaccinationUpdated => 'ویکسینیشن ریکارڈ اپ ڈیٹ ہو گیا';

  @override
  String get addNoteDialogTitle => 'نوٹ شامل کریں';

  @override
  String get noteAdded => 'نوٹ شامل ہو گیا';

  @override
  String get noteUpdated => 'نوٹ اپ ڈیٹ ہو گیا';

  @override
  String dateLabel2(String date) {
    return 'تاریخ: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'دی گئی تاریخ: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'اگلی تاریخ: $date';
  }

  @override
  String get noSymptomsNoted => 'کوئی علامات درج نہیں ہیں';
}
