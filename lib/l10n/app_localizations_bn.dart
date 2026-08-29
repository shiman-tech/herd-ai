// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'Herd AI';

  @override
  String get appSubtitle => 'আপনার গবাদি পশুর ডিজিটাল নোটবুক';

  @override
  String get preparingSecureAccess => 'নিরাপদ অ্যাক্সেস প্রস্তুত করা হচ্ছে...';

  @override
  String get createPin => '৪-সংখ্যার পিন তৈরি করুন';

  @override
  String get enterPin => 'আপনার পিন দিন';

  @override
  String get unlockApp => 'অ্যাপ আনলক করুন';

  @override
  String get confirmPin => 'পিন নিশ্চিত করুন';

  @override
  String get pinDidNotMatchTryAgain => 'পিন মেলেনি। আবার চেষ্টা করুন';

  @override
  String get pinDidNotMatch => 'পিন মেলেনি';

  @override
  String get pinCreated => 'পিন তৈরি হয়েছে';

  @override
  String get unlocked => 'আনলক করা হয়েছে';

  @override
  String get wrongPinTryAgain => 'ভুল পিন। আবার চেষ্টা করুন';

  @override
  String get wrongPin => 'ভুল পিন';

  @override
  String get usePinToUnlock => 'আনলক করতে পিন ব্যবহার করুন';

  @override
  String get tryFingerprintFace => 'ফিঙ্গারপ্রিন্ট বা ফেস আইডি চেষ্টা করুন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get changePin => 'পিন পরিবর্তন করুন';

  @override
  String get language => 'ভাষা';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get currentPin => 'বর্তমান পিন';

  @override
  String get newPin => 'নতুন পিন';

  @override
  String get confirmNewPin => 'নতুন পিন নিশ্চিত করুন';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get wrongCurrentPin => 'বর্তমান পিন ভুল';

  @override
  String get pinChanged => 'পিন পরিবর্তন করা হয়েছে';

  @override
  String get pinsDoNotMatch => 'নতুন পিন মিলছে না';

  @override
  String get enterAllFields => 'অনুগ্রহ করে সব ঘর পূরণ করুন';

  @override
  String get invalidPinLength => 'পিন অবশ্যই ৪ সংখ্যার হতে হবে';

  @override
  String get cattleNotebook => 'Cattles Notebook';

  @override
  String get noCattles => 'এখনও কোনো গবাদি পশু নিবন্ধিত হয়নি।';

  @override
  String get searchHint => 'আপনার পাল অনুসন্ধান করুন...';

  @override
  String cattleIdLabel(String id) {
    return 'গরুর আইডি: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'নিবন্ধিত: $date';
  }

  @override
  String get readyToIdentify => 'গরু সনাক্ত করতে এবং রেকর্ড রাখতে প্রস্তুত।';

  @override
  String get initializingDb => 'নোটবুক প্রস্তুত করা হচ্ছে...';

  @override
  String get readyText => 'শনাক্তকরণের জন্য প্রস্তুত';

  @override
  String get notReady => 'অ্যাপ সেটআপ এখনও সম্পন্ন হয়নি। আবার চেষ্টা করুন।';

  @override
  String get selectImage => 'মডেল লোড হওয়ার পর ছবি নির্বাচন করুন।';

  @override
  String get checkingCattle => 'গরু পরীক্ষা করা হচ্ছে...';

  @override
  String get cattleIdentified => 'গরু শনাক্ত করা হয়েছে।';

  @override
  String get borderlineMatch =>
      'এটি আপনার বিদ্যমান গরুর মতো দেখাচ্ছে — নিচে দেখুন।';

  @override
  String get noMatchingCattle => 'মিল থাকা কোনো গরু পাওয়া যায়নি।';

  @override
  String get couldNotIdentify => 'এই মুহূর্তে গরুটি শনাক্ত করা যায়নি।';

  @override
  String get addThisCattle => 'এই গরুটি যোগ করুন';

  @override
  String get cattleId => 'গরুর আইডি';

  @override
  String get optionalNote => 'নোট (ঐচ্ছিক)';

  @override
  String get register => 'নিবন্ধন করুন';

  @override
  String get addCattle => 'গরু যোগ করুন';

  @override
  String get cattleAlreadyExists => 'এই গরুর আইডি ইতিমধ্যেই বিদ্যমান';

  @override
  String get pleaseEnterId => 'অনুগ্রহ করে একটি আইডি দিন';

  @override
  String get registering => 'নিবন্ধন করা হচ্ছে...';

  @override
  String get cattleRegistered => 'গরু নিবন্ধিত হয়েছে';

  @override
  String get failedToRegister => 'গরু নিবন্ধন করা যায়নি';

  @override
  String get basicInfo => 'মৌলিক তথ্য';

  @override
  String registeredOn(String date) {
    return 'নিবন্ধিত: $date';
  }

  @override
  String get breedClassification => 'জাত শ্রেণীবিন্যাস';

  @override
  String get classifyBreed => 'জাত নির্ধারণ করুন';

  @override
  String get reClassify => 'পুনরায় নির্ধারণ করুন';

  @override
  String get noBreedClassificationYet =>
      'এখনও কোনো জাত শ্রেণীবিন্যাস করা হয়নি। একটি পুরো শরীরের ছবি তুলুন।';

  @override
  String confirmedBreed(String breed) {
    return 'নিশ্চিত জাত: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'Low confidence — try a clearer full-body photo.';

  @override
  String get setManually => 'ম্যানুয়ালি সেট করুন';

  @override
  String get unknownMixed => 'অজানা / মিশ্র';

  @override
  String get likelyBreedsVisual => 'সম্ভাব্য জাতসমূহ (দৃশ্যমান অনুমান):';

  @override
  String confirmBreed(String breed) {
    return '$breed নিশ্চিত করুন';
  }

  @override
  String get chooseDifferent => 'অন্যটি বেছে নিন';

  @override
  String get breedClassified => 'জাত শ্রেণীবদ্ধ করা হয়েছে';

  @override
  String get couldNotClassify => 'জাত নির্ধারণ করা যায়নি';

  @override
  String get noBreedPredictions => 'কোনো জাতের পূর্বাভাস পাওয়া যায়নি';

  @override
  String breedConfirmed(String breed) {
    return 'জাত নিশ্চিত করা হয়েছে: $breed';
  }

  @override
  String get chooseBreed => 'জাত নির্বাচন করুন';

  @override
  String get orTypeBreedName => 'অথবা জাতের নাম লিখুন:';

  @override
  String get confirmCustomBreed => 'কাস্টম জাত নিশ্চিত করুন';

  @override
  String get customBreedHint => 'যেমন: জার্সি ক্রস';

  @override
  String get breedSetUnknown => 'জাত অজানা/মিশ্র হিসেবে সেট করা হয়েছে';

  @override
  String get healthRecords => 'স্বাস্থ্য রেকর্ডস';

  @override
  String get addHealthRecord => 'স্বাস্থ্য রেকর্ড যোগ করুন';

  @override
  String get editHealthRecord => 'স্বাস্থ্য রেকর্ড সম্পাদনা করুন';

  @override
  String get noHealthRecords => 'এখনও কোনো স্বাস্থ্য রেকর্ড নেই।';

  @override
  String get diseaseName => 'রোগের নাম';

  @override
  String get symptoms => 'উপসর্গ';

  @override
  String get status => 'অবস্থা';

  @override
  String get dateLabel => 'তারিখ';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get deleteHealthRecord => 'স্বাস্থ্য রেকর্ড মুছে ফেলুন';

  @override
  String get deleteHealthRecordConfirm =>
      'এই স্বাস্থ্য রেকর্ডটি কি মুছে ফেলতে চান?';

  @override
  String get healthRecordDeleted => 'স্বাস্থ্য রেকর্ড মুছে ফেলা হয়েছে';

  @override
  String get healthRecordSaved => 'স্বাস্থ্য রেকর্ড সংরক্ষিত হয়েছে';

  @override
  String get vaccinationRecords => 'টিকা রেকর্ডস';

  @override
  String get addVaccination => 'টিকা যোগ করুন';

  @override
  String get editVaccination => 'টিকা সম্পাদনা করুন';

  @override
  String get noVaccinationRecords => 'এখনও কোনো টিকার রেকর্ড নেই।';

  @override
  String get vaccineName => 'টিকার নাম';

  @override
  String get dateGiven => 'প্রদানের তারিখ';

  @override
  String get nextDueDate => 'পরবর্তী তারিখ (ঐচ্ছিক)';

  @override
  String get deleteVaccination => 'টিকা মুছে ফেলুন';

  @override
  String get deleteVaccinationConfirm => 'এই টিকার রেকর্ডটি কি মুছে ফেলতে চান?';

  @override
  String get vaccinationDeleted => 'টিকা মুছে ফেলা হয়েছে';

  @override
  String get vaccinationSaved => 'টিকা সংরক্ষিত হয়েছে';

  @override
  String get notes => 'নোটসমূহ';

  @override
  String get addNote => 'নোট যোগ করুন';

  @override
  String get editNote => 'নোট সম্পাদনা করুন';

  @override
  String get noNotes => 'কোনো নোট যোগ করা হয়নি।';

  @override
  String get deleteNote => 'নোট মুছে ফেলুন';

  @override
  String get deleteNoteConfirm => 'এই নোটটি কি মুছে ফেলতে চান?';

  @override
  String get noteDeleted => 'নোট মুছে ফেলা হয়েছে';

  @override
  String get noteSaved => 'নোট সংরক্ষিত হয়েছে';

  @override
  String get cattleIdentification => 'গরু শনাক্তকরণ';

  @override
  String get cattleIdentificationDesc =>
      'এই গরুটি চেনার জন্য মুখের ছবি যোগ করুন।';

  @override
  String get noIdentityPhotos => 'এখনও কোনও মুখের ছবি যোগ করা হয়নি।';

  @override
  String get addFacialPhoto => 'ছবি যোগ করুন';

  @override
  String get photos => 'Photos';

  @override
  String get addPhoto => 'ছবি যোগ করুন';

  @override
  String get photoDesc =>
      'Track how this cattle looks over time. Newest photos appear first.';

  @override
  String get noPhotos => 'এখনও কোনো ছবি নেই।';

  @override
  String get replace => 'পরিবর্তন করুন';

  @override
  String get replacePhoto => 'এই ছবি পরিবর্তন করবেন?';

  @override
  String get replacePhotoConfirm => 'পুরানো ছবিটি সরিয়ে নতুন ছবি বসানো হবে।';

  @override
  String get photoUpdated => 'ছবি আপডেট করা হয়েছে';

  @override
  String get couldNotUpdatePhoto => 'ছবি আপডেট করা যায়নি';

  @override
  String get deletePhoto => 'ছবি মুছে ফেলুন';

  @override
  String get deletePhotoConfirm => 'ছবিটি মুছে ফেলতে চান?';

  @override
  String get photoDeleted => 'ছবি মুছে ফেলা হয়েছে';

  @override
  String addPhotoTo(String id) {
    return '$id এ ছবি যোগ করবেন?';
  }

  @override
  String get addPhotoConfirm =>
      'This photo will be saved with today\'s date so you can track how this cattle looks over time. It will also help identify this cattle in the future.';

  @override
  String get galleryPhotoConfirm =>
      'সময়ের সাথে সাথে এই গরুর শারীরিক বৃদ্ধি ট্র্যাক করতে এই ছবিটি সংরক্ষণ করা হবে।';

  @override
  String get photoAdded => 'ছবি যোগ করা হয়েছে';

  @override
  String get couldNotAddPhoto => 'ছবি যোগ করা যায়নি';

  @override
  String get takePhoto => 'ছবি তুলুন';

  @override
  String get chooseFromGallery => 'গ্যালারি থেকে বেছে নিন';

  @override
  String get takeOrChooseClear =>
      'এই গরুর একটি স্পষ্ট ছবি তুলুন বা নির্বাচন করুন।';

  @override
  String get classifyThisPhoto => 'এই ছবিটি শ্রেণীবদ্ধ করবেন?';

  @override
  String get classifyThisPhotoConfirm =>
      'একটি স্পষ্ট পুরো শরীরের ছবি সেরা ফলাফলের নিশ্চয়তা দেয়।';

  @override
  String get classify => 'শ্রেণীবদ্ধ করুন';

  @override
  String get takeOrChooseFullBody =>
      'একটি স্পষ্ট পুরো শরীরের ছবি তুলুন বা নির্বাচন করুন।';

  @override
  String get deleteCattleRecord => 'গরুর রেকর্ড মুছুন';

  @override
  String deleteCattleRecordConfirm(String id) {
    return '$id এবং এর সাথে সম্পর্কিত সমস্ত রেকর্ড মুছে ফেলবেন?';
  }

  @override
  String get cattleRecordDeleted => 'গরুর রেকর্ড মুছে ফেলা হয়েছে';

  @override
  String get cattleDetails => 'গরুর বিস্তারিত তথ্য';

  @override
  String get cattleNotFound => 'গরুর রেকর্ড পাওয়া যায়নি।';

  @override
  String detailsHeader(String id) {
    return '$id এর বিস্তারিত';
  }

  @override
  String get identifyCattle => 'গরু শনাক্ত করুন';

  @override
  String get identifyTab => 'শনাক্তকরণ';

  @override
  String get cattleTab => 'My Cattles';

  @override
  String get tapIdentify => 'ছবি যোগ হয়েছে। শনাক্তকরণে চাপুন।';

  @override
  String get selectImageFirst => 'প্রথমে একটি ছবি নির্বাচন করুন।';

  @override
  String get matchesHeading => 'মিলে যাওয়া গরুসমূহ';

  @override
  String get details => 'বিস্তারিত';

  @override
  String get unknownCattle => 'অজানা গরু';

  @override
  String get registerThisCattle => 'এই গরুটি নিবন্ধন করুন';

  @override
  String get backButton => 'ফিরে যান';

  @override
  String get noCattlesFound => 'কোনো গরু পাওয়া যায়নি';

  @override
  String get activeLabel => 'সক্রিয়';

  @override
  String get recoveredLabel => 'সুস্থ হয়েছে';

  @override
  String givenLabel(String date) {
    return 'প্রদানের তারিখ: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'পরবর্তী তারিখ: $date';
  }

  @override
  String get tabOverview => 'সংক্ষিপ্ত বিবরণ';

  @override
  String get tabMedical => 'চিকিৎসা';

  @override
  String get tabGalleryNotes => 'গ্যালারি ও নোট';

  @override
  String dialogIdentifyAs(String id) {
    return '$id হিসেবে শনাক্ত করবেন?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'এটি দেখতে $id এর মতো। আপনি কি এটি সংরক্ষণ করবেন?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return '$id এ ছবি সংরক্ষণ করুন';
  }

  @override
  String get dialogIdentifyNewCattle => 'না, এটি নতুন গরু';

  @override
  String get checkingPhotoBeforeReg => 'নিবন্ধনের আগে ছবি পরীক্ষা করা হচ্ছে...';

  @override
  String alreadyInHerd(String id) {
    return '$id is already in your herd';
  }

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String yesAddTo(String id) {
    return 'হ্যাঁ, $id এ যোগ করুন';
  }

  @override
  String looksLike(String id) {
    return 'এটি দেখতে $id এর মতো';
  }

  @override
  String get addPhotoToThat => 'ছবিটি সেই গরুতে যোগ করবেন?';

  @override
  String get createNewCattle => 'নতুন গরু তৈরি করুন';

  @override
  String get savingPhoto => 'ছবি সংরক্ষণ করা হচ্ছে...';

  @override
  String photoAddedTo(String id) {
    return '$id এ ছবি যোগ করা হয়েছে';
  }

  @override
  String get couldNotSavePhoto => 'ছবি সংরক্ষণ করা যায়নি।';

  @override
  String get savingCattleDetails => 'গরুর বিবরণ সংরক্ষণ করা হচ্ছে...';

  @override
  String addedToHerd(String id) {
    return '$id added to your herd.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id added successfully';
  }

  @override
  String get exitApp => 'অ্যাপ থেকে বের হন';

  @override
  String get exitAppConfirm => 'আপনি কি অ্যাপটি বন্ধ করতে চান?';

  @override
  String get cancelled => 'বাতিল করা হয়েছে।';

  @override
  String get couldNotCheckPhoto => 'ছবি পরীক্ষা করা যায়নি।';

  @override
  String get couldNotPrepareReg => 'নিবন্ধন প্রস্তুত করা যায়নি';

  @override
  String get captureImage => 'ছবি তুলুন';

  @override
  String get uploadImage => 'ছবি আপলোড করুন';

  @override
  String get identificationResult => 'শনাক্তকরণের ফলাফল';

  @override
  String get noCattlesMessage => 'এখনও কোনো গরু নেই।';

  @override
  String get yourHerd => 'আপনার পাল';

  @override
  String get welcomeNotebook => 'নোটবুকে স্বাগতম';

  @override
  String get notebookDescription =>
      'গরু শনাক্ত করতে এবং রেকর্ড রাখতে ছবি তুলুন বা আপলোড করুন।';

  @override
  String registeredCattlesCount(int count) {
    return 'নিবন্ধিত গরু: $count';
  }

  @override
  String get initErrorOccurred => 'অ্যাপ খুলতে সমস্যা হয়েছে।';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get noPhotoSelected => 'কোনো ছবি নির্বাচিত হয়নি';

  @override
  String get identifyResultPlaceholder => 'ফলাফল দেখতে গরু শনাক্ত করুন।';

  @override
  String matchConfidence(String confidence) {
    return 'মিল থাকার হার: $confidence%';
  }

  @override
  String get cattleAlreadyInHerd => 'এই গরুটি ইতিমধ্যেই আপনার পালে আছে।';

  @override
  String get noMatchingCattleRegisterHint =>
      'কোনো মিল পাওয়া যায়নি। আপনি এটি নতুন হিসেবে যোগ করতে পারেন।';

  @override
  String cattleSummarySubtitle(int health, int vaccines, int notes) {
    return 'স্বাস্থ্য: $health • টিকা: $vaccines • নোট: $notes';
  }

  @override
  String get diseaseNameLabel => 'রোগের নাম';

  @override
  String get ongoing => 'চলমান';

  @override
  String get recovered => 'সুস্থ হয়েছে';

  @override
  String get symptomsOptional => 'উপসর্গ (ঐচ্ছিক)';

  @override
  String get treatmentNotesOptional => 'চিকিৎসার বিবরণ (ঐচ্ছিক)';

  @override
  String get saveHealthRecord => 'স্বাস্থ্য রেকর্ড সংরক্ষণ করুন';

  @override
  String get updateHealthRecord => 'স্বাস্থ্য রেকর্ড আপডেট করুন';

  @override
  String get healthRecordAdded => 'স্বাস্থ্য রেকর্ড যোগ করা হয়েছে';

  @override
  String get healthRecordUpdated => 'স্বাস্থ্য রেকর্ড আপডেট করা হয়েছে';

  @override
  String get vaccineNameLabel => 'টিকার নাম';

  @override
  String get pickDate => 'তারিখ নির্বাচন করুন';

  @override
  String get nextDueNotSet => 'পরবর্তী তারিখ: নির্ধারিত নেই';

  @override
  String get setNextDue => 'পরবর্তী তারিখ নির্ধারণ করুন';

  @override
  String get notesOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get saveVaccination => 'টিকা সংরক্ষণ করুন';

  @override
  String get updateVaccination => 'টিকা আপডেট করুন';

  @override
  String get vaccinationAdded => 'টিকা যোগ করা হয়েছে';

  @override
  String get vaccinationUpdated => 'টিকা আপডেট করা হয়েছে';

  @override
  String get addNoteDialogTitle => 'একটি নোট যোগ করুন';

  @override
  String get noteAdded => 'নোট যোগ করা হয়েছে';

  @override
  String get noteUpdated => 'নোট আপডেট করা হয়েছে';

  @override
  String dateLabel2(String date) {
    return 'তারিখ: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'প্রদানের তারিখ: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'পরবর্তী তারিখ: $date';
  }

  @override
  String get noSymptomsNoted => 'কোনো উপসর্গ উল্লেখ নেই';

  @override
  String get milkYieldTab => 'দুধের ফলন';

  @override
  String get milkAndLactationTitle => 'দুধ ও দুগ্ধকাল';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get filterButton => 'ফিল্টার';

  @override
  String get clearAll => 'সব মুছুন';

  @override
  String showingCattleCount(int filtered, int total) {
    return '$total এর মধ্যে $filtered টি গরু দেখানো হচ্ছে';
  }

  @override
  String get noCattleMatchFilter =>
      'নির্বাচিত ফিল্টারের সাথে কোনো গরু মিলছে না।';

  @override
  String get resetSearchAndFilters => 'অনুসন্ধান ও ফিল্টার রিসেট করুন';

  @override
  String get filterAndSortCattle => 'গরু ফিল্টার ও সাজান';

  @override
  String get sortOrder => 'ক্রম';

  @override
  String get resetAll => 'সব রিসেট করুন';

  @override
  String showMatchingCattle(int count) {
    return '$count টি গরু দেখুন';
  }

  @override
  String get sexLabel => 'লিঙ্গ';

  @override
  String get lifeStageLabel => 'জীবনের পর্যায়';

  @override
  String get healthStatusLabel => 'স্বাস্থ্যের অবস্থা';

  @override
  String get reproductiveStatusLabel => 'প্রজনন অবস্থা';

  @override
  String get vaccinationStatusLabel => 'টিকা';

  @override
  String get milkAndLactation => 'দুধ ও দুগ্ধকাল';

  @override
  String get breedCategory => 'জাত';

  @override
  String get female => 'স্ত্রী';

  @override
  String get male => 'পুরুষ';

  @override
  String get calf => 'বাছুর';

  @override
  String get heifer => 'বকনা';

  @override
  String get cow => 'গাভী';

  @override
  String get bull => 'ষাঁড়';

  @override
  String get steer => 'বলদ';

  @override
  String get healthy => 'সুস্থ';

  @override
  String get underObservation => 'পর্যবেক্ষণে';

  @override
  String get diseased => 'অসুস্থ';

  @override
  String get unknown => 'অজানা';

  @override
  String get pregnant => 'গর্ভবতী';

  @override
  String get notPregnant => 'গর্ভবতী নয়';

  @override
  String get upToDate => 'আপ টু ডেট';

  @override
  String get dueSoon => 'শীঘ্রই বাকি';

  @override
  String get overdue => 'মেয়াদোত্তীর্ণ';

  @override
  String get noRecord => 'কোনো রেকর্ড নেই';

  @override
  String get milkingCows => 'দুগ্ধবতী গাভী';

  @override
  String get dryCows => 'দুধহীন গাভী';

  @override
  String get highProducers => 'উচ্চ উৎপাদক (>১৫ লি/দিন)';

  @override
  String get mediumProducers => 'মাঝারি উৎপাদক (৮–১৫ লি/দিন)';

  @override
  String get lowProducers => 'কম উৎপাদক (<৮ লি/দিন)';

  @override
  String get recentlyCalved => 'সম্প্রতি প্রসব করা';

  @override
  String get sortRecentlyAdded => 'সম্প্রতি যুক্ত';

  @override
  String get sortOldestAdded => 'সবচেয়ে পুরানো';

  @override
  String get sortNameAsc => 'আইডি (A → Z)';

  @override
  String get sortNameDesc => 'আইডি (Z → A)';

  @override
  String get sortAgeAsc => 'বয়স (ছোট থেকে বড়)';

  @override
  String get sortAgeDesc => 'বয়স (বড় থেকে ছোট)';

  @override
  String get todaysMilkProduction => 'আজকের দুধ উৎপাদন';

  @override
  String cowsMilked(int count) {
    return '$count টি গাভীর দুধ দোয়ানো হয়েছে';
  }

  @override
  String get liters => 'লিটার';

  @override
  String get averagePerCow => 'গড় / গাভী';

  @override
  String topProducer(String id, String yield) {
    return 'শীর্ষ: #$id ($yield লি)';
  }

  @override
  String get topProducerNone => 'শীর্ষ উৎপাদক: এখনও নেই';

  @override
  String lowestProducer(String id, String yield) {
    return 'সর্বনিম্ন: #$id ($yield লি)';
  }

  @override
  String get thisWeek => 'এই সপ্তাহ';

  @override
  String get thisMonth => 'এই মাস';

  @override
  String get milkingHerd => 'দুগ্ধবতী পাল';

  @override
  String cowsCount(int count) {
    return '$count টি গাভী';
  }

  @override
  String get recordMilk => 'দুধ রেকর্ড করুন';

  @override
  String get reports => 'রিপোর্ট';

  @override
  String get productionAnalytics => 'উৎপাদন বিশ্লেষণ';

  @override
  String get milkHistory => 'দুধের ইতিহাস';

  @override
  String daysLogged(int count) {
    return '$count দিন রেকর্ডকৃত';
  }

  @override
  String get noMilkRecordsSavedYet =>
      'এখনও দুধের কোনো রেকর্ড নেই। শুরু করতে \'দুধ রেকর্ড করুন\'-এ চাপুন।';

  @override
  String get breedAnalyticsFilter => 'জাত বিশ্লেষণ ফিল্টার:';

  @override
  String get allBreeds => 'সকল জাত';

  @override
  String cowsRecordedCount(int count, String plural) {
    return '$count টি গাভী রেকর্ডকৃত';
  }

  @override
  String get morningShort => 'সকাল';

  @override
  String get eveningShort => 'সন্ধ্যা';

  @override
  String get editMilkRecord => 'দুধের রেকর্ড সম্পাদনা করুন';

  @override
  String get recordMilkYield => 'দুধের পরিমাণ রেকর্ড করুন';

  @override
  String get recordExistsWarning =>
      'এই গাভীর এই তারিখের রেকর্ড ইতিমধ্যেই রয়েছে। সংরক্ষণ করলে তা আপডেট হবে।';

  @override
  String get cattleLabel => 'গরু';

  @override
  String get selectCow => 'গাভী নির্বাচন করুন';

  @override
  String get milkingBadge => 'দুধ দিচ্ছে';

  @override
  String get recordDate => 'রেকর্ডের তারিখ';

  @override
  String get morningLiters => 'সকাল (লিটার)';

  @override
  String get eveningLiters => 'সন্ধ্যা (লিটার)';

  @override
  String get totalDailyYield => 'মোট দৈনিক উৎপাদন';

  @override
  String get notesOptionalMilk => 'নোট (ঐচ্ছিক)';

  @override
  String get notesHintMilk => 'যেমন: সাইলেজ খাওয়ানো হয়েছে, স্বাভাবিক ক্ষুধা';

  @override
  String get updateRecord => 'রেকর্ড আপডেট করুন';

  @override
  String get saveRecordButton => 'রেকর্ড সংরক্ষণ করুন';

  @override
  String get pleaseSelectCattle => 'অনুগ্রহ করে একটি গরু নির্বাচন করুন';

  @override
  String get milkProductionReports => 'দুধ উৎপাদন রিপোর্ট';

  @override
  String breedFilterBadge(String breed) {
    return 'জাত ফিল্টার: $breed';
  }

  @override
  String get dailyTab => 'দৈনিক';

  @override
  String get weeklyTab => 'সাপ্তাহিক';

  @override
  String get monthlyTab => 'মাসিক';

  @override
  String get reportDateLabel => 'রিপোর্টের তারিখ: ';

  @override
  String get weekStartLabel => 'সপ্তাহ শুরু: ';

  @override
  String downloadCsvReport(String type) {
    return '$type CSV রিপোর্ট ডাউনলোড করুন';
  }

  @override
  String reportSaved(String fileName) {
    return 'রিপোর্ট সংরক্ষিত: $fileName';
  }

  @override
  String get reportCopied => 'রিপোর্ট ক্লিপবোর্ডে কপি করা হয়েছে!';

  @override
  String get dailyAvg => 'দৈনিক গড়';

  @override
  String get totalYieldLabel => 'মোট উৎপাদন';

  @override
  String get bestLabel => 'সেরা';

  @override
  String get worstLabel => 'সর্বনিম্ন';

  @override
  String get orderLabel => 'ক্রম:';

  @override
  String get bestToWorst => 'সেরা → সর্বনিম্ন';

  @override
  String get worstToBest => 'সর্বনিম্ন → সেরা';

  @override
  String noMilkRecordsForPeriod(String breedText) {
    return 'এই সময়ের জন্য কোনো দুধের রেকর্ড পাওয়া যায়নি$breedText।';
  }

  @override
  String recordedOutOfDays(int recorded, int total) {
    return 'রেকর্ডকৃত: $recorded/$total দিন';
  }

  @override
  String recordedEntriesCount(int count) {
    return 'রেকর্ডকৃত: $count টি এন্ট্রি';
  }

  @override
  String morningEveningBreakdown(String morning, String evening) {
    return 'সকাল: $morning লি  •  সন্ধ্যা: $evening লি';
  }

  @override
  String get notificationsAndSmartAlerts => 'বিজ্ঞপ্তি ও স্মার্ট সতর্কতা';

  @override
  String get allClear => 'সব ঠিক আছে!';

  @override
  String get noPendingAlerts => 'কোনো মুলতুবি বিজ্ঞপ্তি বা সতর্কতা নেই।';

  @override
  String get viewAction => 'দেখুন';

  @override
  String get recordMilkAction => 'দুধ রেকর্ড করুন';

  @override
  String get logCalvingAction => 'প্রসব লগ করুন';

  @override
  String get vaccinateAction => 'টিকা দিন';

  @override
  String get editCattleDetails => 'গরুর বিবরণ সম্পাদনা করুন';

  @override
  String get dateOfBirthAge => 'জন্ম তারিখ (বয়স)';

  @override
  String get notSet => 'নির্ধারিত নয়';

  @override
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural) {
    return '$years বছর $months মাস';
  }

  @override
  String yearsAge(int years, String yPlural) {
    return '$years বছর';
  }

  @override
  String monthsAge(int months, String mPlural) {
    return '$months মাস';
  }

  @override
  String get unknownAge => 'অজানা বয়স';

  @override
  String get milkAndLactationProfile => 'দুধ ও দুগ্ধকাল প্রোফাইল';

  @override
  String get currentlyMilking => 'বর্তমানে দুধ দিচ্ছে';

  @override
  String get lastCalvingDate => 'শেষ প্রসবের তারিখ';

  @override
  String get inseminationDate => 'প্রজনন/গর্ভধারণের তারিখ';

  @override
  String get expectedDailyYieldBenchmark => 'প্রত্যাশিত দৈনিক উৎপাদন (মানদণ্ড)';

  @override
  String get benchmarkHint => 'যেমন: ১৫.০';

  @override
  String get symptomsHint => 'যেমন: ঠিকমত খাচ্ছে না';

  @override
  String get cattleDetailsUpdated => 'গরুর বিবরণ আপডেট করা হয়েছে';

  @override
  String get milkProductionTab => 'দুধ উৎপাদন';

  @override
  String get lactationStatus => 'দুগ্ধকালের অবস্থা';

  @override
  String get daysInMilk => 'দুধ দানের দিন (DIM)';

  @override
  String daysUnit(int count) {
    return '$count দিন';
  }

  @override
  String get lastCalving => 'শেষ প্রসব';

  @override
  String get estNextCalving => 'সম্ভাব্য পরবর্তী প্রসব';

  @override
  String get thirtyDayAverage => '৩০ দিনের গড়';

  @override
  String get totalThisMonth => 'এই মাসের মোট';

  @override
  String get recentMilkYieldTrend => 'সাম্প্রতিক দুধ উৎপাদনের প্রবণতা';

  @override
  String get dailyMilkRecords => 'দৈনিক দুধ রেকর্ড';

  @override
  String get noDailyMilkRecords =>
      'এই গাভীর জন্য এখনও কোনো দৈনিক দুধের রেকর্ড নেই।';

  @override
  String litersPerDay(String yield) {
    return '$yield লি/দিন';
  }

  @override
  String get freshStage => 'নতুন (Fresh)';

  @override
  String get earlyStage => 'প্রথম পর্যায় (Early)';

  @override
  String get midStage => 'মধ্য পর্যায় (Mid)';

  @override
  String get lateStage => 'শেষ পর্যায় (Late)';

  @override
  String get extendedStage => 'বর্ধিত দুগ্ধকাল';

  @override
  String get dryStage => 'দুধহীন পর্যায় (Dry)';

  @override
  String stageSuffix(String stage) {
    return '$stage পর্যায়';
  }

  @override
  String get calvingDateOverdue => 'প্রসবের তারিখ মেয়াদোত্তীর্ণ';

  @override
  String calvingOverdueMessage(String date) {
    return 'প্রত্যাশিত প্রসবের তারিখ ($date) অতিক্রান্ত হয়েছে। প্রসবের তথ্য বা গর্ভধারণের অবস্থা আপডেট করুন।';
  }

  @override
  String get logCalving => 'প্রসব রেকর্ড করুন';

  @override
  String get predictedBreed => 'আনুমানিক জাত';

  @override
  String get noMilkChartRecords =>
      'এখনও কোনো দুধ রেকর্ড নেই।\nপ্রবণতা দেখতে রেকর্ড শুরু করুন।';

  @override
  String get setAsUnknown => 'অজানা হিসেবে সেট করুন';

  @override
  String breedPredictionItem(String name, int percent) {
    return '• $name — $percent%';
  }

  @override
  String get sexRequired => 'লিঙ্গ *';

  @override
  String get optionalNoteHint => 'যেমন: গর্ভবতী';

  @override
  String get missingMilkEntryToday => 'আজকের দুধ এন্ট্রি বাকি';

  @override
  String missingMilkEntryTitle(String date) {
    return 'দুধ এন্ট্রি বাকি ($date)';
  }

  @override
  String noMilkRecordEntered(String dateLabel, String id) {
    return '$dateLabel #$id এর জন্য কোনো দুধের রেকর্ড এন্ট্রি করা হয়নি।';
  }

  @override
  String get today => 'আজ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String onDate(String date) {
    return '$date তারিখে';
  }

  @override
  String get lowYieldAlertTitle => 'কম উৎপাদনের সতর্কতা';

  @override
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  ) {
    return '#$id এর দুধ উৎপাদন $percent% কমে গেছে ($latest লি বনাম গড় $avg লি)।';
  }

  @override
  String get dryOffReminderTitle => 'দুধ বন্ধের রিমাইন্ডার';

  @override
  String dryOffReminderMessage(String id, int days) {
    return '#$id এর $days দিনের মধ্যে প্রসবের সম্ভাবনা রয়েছে। শুকনো সময়ের জন্য প্রস্তুত করুন।';
  }

  @override
  String get calvingDateOverdueTitle => 'প্রসবের তারিখ অতিক্রান্ত';

  @override
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  ) {
    return '#$id এর প্রসবের তারিখ $days দিন আগে ছিল ($date)। তথ্য আপডেট করুন।';
  }

  @override
  String get calvingReminderTitle => 'প্রসবের রিমাইন্ডার';

  @override
  String calvingReminderMessage(String id, int days, String plural) {
    return '#$id এর $days দিনের মধ্যে প্রসব হতে চলেছে। প্রসবের ঘর প্রস্তুত করুন।';
  }

  @override
  String get vaccinationOverdueTitle => 'টিকা অতিক্রান্ত';

  @override
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days দিন আগে দেয়ার কথা ছিল ($date)।';
  }

  @override
  String get vaccinationDueSoonTitle => 'টিকা শীঘ্রই দেয়ার সময়';

  @override
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  ) {
    return '#$id — $vacName $days দিনের মধ্যে দিতে হবে ($date)।';
  }
}
