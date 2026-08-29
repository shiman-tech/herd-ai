import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_or.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('or'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Herd AI'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your cattle notebook'**
  String get appSubtitle;

  /// No description provided for @preparingSecureAccess.
  ///
  /// In en, this message translates to:
  /// **'Preparing secure access...'**
  String get preparingSecureAccess;

  /// No description provided for @createPin.
  ///
  /// In en, this message translates to:
  /// **'Create a 4-digit PIN'**
  String get createPin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPin;

  /// No description provided for @unlockApp.
  ///
  /// In en, this message translates to:
  /// **'Unlock your app'**
  String get unlockApp;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmPin;

  /// No description provided for @pinDidNotMatchTryAgain.
  ///
  /// In en, this message translates to:
  /// **'PIN did not match. Try again'**
  String get pinDidNotMatchTryAgain;

  /// No description provided for @pinDidNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PIN did not match'**
  String get pinDidNotMatch;

  /// No description provided for @pinCreated.
  ///
  /// In en, this message translates to:
  /// **'PIN created'**
  String get pinCreated;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @wrongPinTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Try again'**
  String get wrongPinTryAgain;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get wrongPin;

  /// No description provided for @usePinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use PIN to unlock'**
  String get usePinToUnlock;

  /// No description provided for @tryFingerprintFace.
  ///
  /// In en, this message translates to:
  /// **'Try fingerprint/face'**
  String get tryFingerprintFace;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get confirmNewPin;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @wrongCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong current PIN'**
  String get wrongCurrentPin;

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get pinChanged;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'New PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @enterAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get enterAllFields;

  /// No description provided for @invalidPinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get invalidPinLength;

  /// No description provided for @cattleNotebook.
  ///
  /// In en, this message translates to:
  /// **'Cattle Notebook'**
  String get cattleNotebook;

  /// No description provided for @noCattles.
  ///
  /// In en, this message translates to:
  /// **'No cattle registered yet.'**
  String get noCattles;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your herd...'**
  String get searchHint;

  /// No description provided for @cattleIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Cattle ID: {id}'**
  String cattleIdLabel(String id);

  /// No description provided for @registeredLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered: {date}'**
  String registeredLabel(String date);

  /// No description provided for @readyToIdentify.
  ///
  /// In en, this message translates to:
  /// **'Ready to identify cattle and keep records.'**
  String get readyToIdentify;

  /// No description provided for @initializingDb.
  ///
  /// In en, this message translates to:
  /// **'Getting your cattle notebook ready...'**
  String get initializingDb;

  /// No description provided for @readyText.
  ///
  /// In en, this message translates to:
  /// **'Ready to identify'**
  String get readyText;

  /// No description provided for @notReady.
  ///
  /// In en, this message translates to:
  /// **'App setup is not complete yet. Please retry.'**
  String get notReady;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select an image after the model finishes loading.'**
  String get selectImage;

  /// No description provided for @checkingCattle.
  ///
  /// In en, this message translates to:
  /// **'Checking cattle...'**
  String get checkingCattle;

  /// No description provided for @cattleIdentified.
  ///
  /// In en, this message translates to:
  /// **'Cattle identified.'**
  String get cattleIdentified;

  /// No description provided for @borderlineMatch.
  ///
  /// In en, this message translates to:
  /// **'This looks like a cattle you already have — see below.'**
  String get borderlineMatch;

  /// No description provided for @noMatchingCattle.
  ///
  /// In en, this message translates to:
  /// **'No matching cattle found.'**
  String get noMatchingCattle;

  /// No description provided for @couldNotIdentify.
  ///
  /// In en, this message translates to:
  /// **'Could not identify this cattle right now.'**
  String get couldNotIdentify;

  /// No description provided for @addThisCattle.
  ///
  /// In en, this message translates to:
  /// **'Add this cattle'**
  String get addThisCattle;

  /// No description provided for @cattleId.
  ///
  /// In en, this message translates to:
  /// **'Cattle ID'**
  String get cattleId;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get optionalNote;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @addCattle.
  ///
  /// In en, this message translates to:
  /// **'Add cattle'**
  String get addCattle;

  /// No description provided for @cattleAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Cattle ID already exists'**
  String get cattleAlreadyExists;

  /// No description provided for @pleaseEnterId.
  ///
  /// In en, this message translates to:
  /// **'Please enter an ID'**
  String get pleaseEnterId;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// No description provided for @cattleRegistered.
  ///
  /// In en, this message translates to:
  /// **'Cattle registered'**
  String get cattleRegistered;

  /// No description provided for @failedToRegister.
  ///
  /// In en, this message translates to:
  /// **'Could not register cattle'**
  String get failedToRegister;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get basicInfo;

  /// No description provided for @registeredOn.
  ///
  /// In en, this message translates to:
  /// **'Registered: {date}'**
  String registeredOn(String date);

  /// No description provided for @breedClassification.
  ///
  /// In en, this message translates to:
  /// **'Breed Classification'**
  String get breedClassification;

  /// No description provided for @classifyBreed.
  ///
  /// In en, this message translates to:
  /// **'Classify Breed'**
  String get classifyBreed;

  /// No description provided for @reClassify.
  ///
  /// In en, this message translates to:
  /// **'Re-classify'**
  String get reClassify;

  /// No description provided for @noBreedClassificationYet.
  ///
  /// In en, this message translates to:
  /// **'No breed classification yet. Take a full-body photo.'**
  String get noBreedClassificationYet;

  /// No description provided for @confirmedBreed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed Breed: {breed}'**
  String confirmedBreed(String breed);

  /// No description provided for @lowConfidenceWarning.
  ///
  /// In en, this message translates to:
  /// **'Low Confidence'**
  String get lowConfidenceWarning;

  /// No description provided for @setManually.
  ///
  /// In en, this message translates to:
  /// **'Set Manually'**
  String get setManually;

  /// No description provided for @unknownMixed.
  ///
  /// In en, this message translates to:
  /// **'Unknown / Mixed'**
  String get unknownMixed;

  /// No description provided for @likelyBreedsVisual.
  ///
  /// In en, this message translates to:
  /// **'Likely breeds (visual estimate):'**
  String get likelyBreedsVisual;

  /// No description provided for @confirmBreed.
  ///
  /// In en, this message translates to:
  /// **'Confirm {breed}'**
  String confirmBreed(String breed);

  /// No description provided for @chooseDifferent.
  ///
  /// In en, this message translates to:
  /// **'Choose different'**
  String get chooseDifferent;

  /// No description provided for @breedClassified.
  ///
  /// In en, this message translates to:
  /// **'Breed classified'**
  String get breedClassified;

  /// No description provided for @couldNotClassify.
  ///
  /// In en, this message translates to:
  /// **'Could not classify breed'**
  String get couldNotClassify;

  /// No description provided for @noBreedPredictions.
  ///
  /// In en, this message translates to:
  /// **'No breed predictions returned'**
  String get noBreedPredictions;

  /// No description provided for @breedConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Breed confirmed: {breed}'**
  String breedConfirmed(String breed);

  /// No description provided for @chooseBreed.
  ///
  /// In en, this message translates to:
  /// **'Choose breed'**
  String get chooseBreed;

  /// No description provided for @orTypeBreedName.
  ///
  /// In en, this message translates to:
  /// **'Or type a breed name:'**
  String get orTypeBreedName;

  /// No description provided for @confirmCustomBreed.
  ///
  /// In en, this message translates to:
  /// **'Confirm custom breed'**
  String get confirmCustomBreed;

  /// No description provided for @customBreedHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Jersey Cross'**
  String get customBreedHint;

  /// No description provided for @breedSetUnknown.
  ///
  /// In en, this message translates to:
  /// **'Breed set to Unknown / Mixed'**
  String get breedSetUnknown;

  /// No description provided for @healthRecords.
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get healthRecords;

  /// No description provided for @addHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Health Record'**
  String get addHealthRecord;

  /// No description provided for @editHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Health Record'**
  String get editHealthRecord;

  /// No description provided for @noHealthRecords.
  ///
  /// In en, this message translates to:
  /// **'No health records yet.'**
  String get noHealthRecords;

  /// No description provided for @diseaseName.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get diseaseName;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete health record'**
  String get deleteHealthRecord;

  /// No description provided for @deleteHealthRecordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this health record?'**
  String get deleteHealthRecordConfirm;

  /// No description provided for @healthRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Health record deleted'**
  String get healthRecordDeleted;

  /// No description provided for @healthRecordSaved.
  ///
  /// In en, this message translates to:
  /// **'Health record saved'**
  String get healthRecordSaved;

  /// No description provided for @vaccinationRecords.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Records'**
  String get vaccinationRecords;

  /// No description provided for @addVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination'**
  String get addVaccination;

  /// No description provided for @editVaccination.
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccination'**
  String get editVaccination;

  /// No description provided for @noVaccinationRecords.
  ///
  /// In en, this message translates to:
  /// **'No vaccination records yet.'**
  String get noVaccinationRecords;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name'**
  String get vaccineName;

  /// No description provided for @dateGiven.
  ///
  /// In en, this message translates to:
  /// **'Date Given'**
  String get dateGiven;

  /// No description provided for @nextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date (optional)'**
  String get nextDueDate;

  /// No description provided for @deleteVaccination.
  ///
  /// In en, this message translates to:
  /// **'Delete vaccination'**
  String get deleteVaccination;

  /// No description provided for @deleteVaccinationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this vaccination record?'**
  String get deleteVaccinationConfirm;

  /// No description provided for @vaccinationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Vaccination deleted'**
  String get vaccinationDeleted;

  /// No description provided for @vaccinationSaved.
  ///
  /// In en, this message translates to:
  /// **'Vaccination saved'**
  String get vaccinationSaved;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes added.'**
  String get noNotes;

  /// No description provided for @deleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNote;

  /// No description provided for @deleteNoteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get deleteNoteConfirm;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeleted;

  /// No description provided for @noteSaved.
  ///
  /// In en, this message translates to:
  /// **'Note saved'**
  String get noteSaved;

  /// No description provided for @cattleIdentification.
  ///
  /// In en, this message translates to:
  /// **'Cattle Identification'**
  String get cattleIdentification;

  /// No description provided for @cattleIdentificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Add facial photos used to recognize this cattle.'**
  String get cattleIdentificationDesc;

  /// No description provided for @noIdentityPhotos.
  ///
  /// In en, this message translates to:
  /// **'No facial photos added yet.'**
  String get noIdentityPhotos;

  /// No description provided for @addFacialPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addFacialPhoto;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @photoDesc.
  ///
  /// In en, this message translates to:
  /// **'Add photos to track this cattle\'s appearance over time.'**
  String get photoDesc;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos yet.'**
  String get noPhotos;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace this photo?'**
  String get replacePhoto;

  /// No description provided for @replacePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'The old photo will be removed and replaced with the new one.'**
  String get replacePhotoConfirm;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get photoUpdated;

  /// No description provided for @couldNotUpdatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not update photo'**
  String get couldNotUpdatePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete photo'**
  String get deletePhoto;

  /// No description provided for @deletePhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this photo? It will also be removed from cattle identification.'**
  String get deletePhotoConfirm;

  /// No description provided for @photoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted'**
  String get photoDeleted;

  /// No description provided for @addPhotoTo.
  ///
  /// In en, this message translates to:
  /// **'Add photo to {id}?'**
  String addPhotoTo(String id);

  /// No description provided for @addPhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'This photo will be saved and can be used to identify this cattle later.'**
  String get addPhotoConfirm;

  /// No description provided for @galleryPhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'This photo will be saved to track this cattle\'s appearance over time.'**
  String get galleryPhotoConfirm;

  /// No description provided for @photoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added'**
  String get photoAdded;

  /// No description provided for @couldNotAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not add photo'**
  String get couldNotAddPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @takeOrChooseClear.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a clear photo of this cattle.'**
  String get takeOrChooseClear;

  /// No description provided for @classifyThisPhoto.
  ///
  /// In en, this message translates to:
  /// **'Classify this photo?'**
  String get classifyThisPhoto;

  /// No description provided for @classifyThisPhotoConfirm.
  ///
  /// In en, this message translates to:
  /// **'A clear, well-lit full-body photo gives the best breed prediction.'**
  String get classifyThisPhotoConfirm;

  /// No description provided for @classify.
  ///
  /// In en, this message translates to:
  /// **'Classify'**
  String get classify;

  /// No description provided for @takeOrChooseFullBody.
  ///
  /// In en, this message translates to:
  /// **'Take or choose a clear full-body photo of this cattle.'**
  String get takeOrChooseFullBody;

  /// No description provided for @deleteCattleRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Cattle Record'**
  String get deleteCattleRecord;

  /// No description provided for @deleteCattleRecordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {id} and all related records?'**
  String deleteCattleRecordConfirm(String id);

  /// No description provided for @cattleRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Cattle record deleted'**
  String get cattleRecordDeleted;

  /// No description provided for @cattleDetails.
  ///
  /// In en, this message translates to:
  /// **'Cattle details'**
  String get cattleDetails;

  /// No description provided for @cattleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cattle record not found.'**
  String get cattleNotFound;

  /// No description provided for @detailsHeader.
  ///
  /// In en, this message translates to:
  /// **'{id} details'**
  String detailsHeader(String id);

  /// No description provided for @identifyCattle.
  ///
  /// In en, this message translates to:
  /// **'Identify Cattle'**
  String get identifyCattle;

  /// No description provided for @identifyTab.
  ///
  /// In en, this message translates to:
  /// **'Identify'**
  String get identifyTab;

  /// No description provided for @cattleTab.
  ///
  /// In en, this message translates to:
  /// **'My Cattle'**
  String get cattleTab;

  /// No description provided for @tapIdentify.
  ///
  /// In en, this message translates to:
  /// **'Photo added. Tap Identify Cattle.'**
  String get tapIdentify;

  /// No description provided for @selectImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an image first.'**
  String get selectImageFirst;

  /// No description provided for @matchesHeading.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matchesHeading;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @unknownCattle.
  ///
  /// In en, this message translates to:
  /// **'Unknown Cattle'**
  String get unknownCattle;

  /// No description provided for @registerThisCattle.
  ///
  /// In en, this message translates to:
  /// **'Register this cattle'**
  String get registerThisCattle;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @noCattlesFound.
  ///
  /// In en, this message translates to:
  /// **'No cattle found'**
  String get noCattlesFound;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @recoveredLabel.
  ///
  /// In en, this message translates to:
  /// **'Recovered'**
  String get recoveredLabel;

  /// No description provided for @givenLabel.
  ///
  /// In en, this message translates to:
  /// **'Given: {date}'**
  String givenLabel(String date);

  /// No description provided for @nextDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Next due: {date}'**
  String nextDueLabel(String date);

  /// No description provided for @tabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tabOverview;

  /// No description provided for @tabMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get tabMedical;

  /// No description provided for @tabGalleryNotes.
  ///
  /// In en, this message translates to:
  /// **'Gallery & Notes'**
  String get tabGalleryNotes;

  /// No description provided for @dialogIdentifyAs.
  ///
  /// In en, this message translates to:
  /// **'Identify as {id}?'**
  String dialogIdentifyAs(String id);

  /// No description provided for @dialogIdentifyAsConfirm.
  ///
  /// In en, this message translates to:
  /// **'This cattle looks a lot like {id} (Confidence: {confidence}%). Do you want to save this photo under {id}\'s history instead of registering a new cattle?'**
  String dialogIdentifyAsConfirm(String id, int confidence);

  /// No description provided for @dialogIdentifySavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Save photo to {id}'**
  String dialogIdentifySavePhoto(String id);

  /// No description provided for @dialogIdentifyNewCattle.
  ///
  /// In en, this message translates to:
  /// **'No, it\'s a new cattle'**
  String get dialogIdentifyNewCattle;

  /// No description provided for @checkingPhotoBeforeReg.
  ///
  /// In en, this message translates to:
  /// **'Checking photo before registration...'**
  String get checkingPhotoBeforeReg;

  /// No description provided for @alreadyInHerd.
  ///
  /// In en, this message translates to:
  /// **'{id} is already in your herd'**
  String alreadyInHerd(String id);

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yesAddTo.
  ///
  /// In en, this message translates to:
  /// **'Yes, add to {id}'**
  String yesAddTo(String id);

  /// No description provided for @looksLike.
  ///
  /// In en, this message translates to:
  /// **'This looks like {id}'**
  String looksLike(String id);

  /// No description provided for @addPhotoToThat.
  ///
  /// In en, this message translates to:
  /// **'Add this photo to that cattle?'**
  String get addPhotoToThat;

  /// No description provided for @createNewCattle.
  ///
  /// In en, this message translates to:
  /// **'Create new cattle'**
  String get createNewCattle;

  /// No description provided for @savingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Saving photo...'**
  String get savingPhoto;

  /// No description provided for @photoAddedTo.
  ///
  /// In en, this message translates to:
  /// **'Photo added to {id}'**
  String photoAddedTo(String id);

  /// No description provided for @couldNotSavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not save this photo.'**
  String get couldNotSavePhoto;

  /// No description provided for @savingCattleDetails.
  ///
  /// In en, this message translates to:
  /// **'Saving cattle details...'**
  String get savingCattleDetails;

  /// No description provided for @addedToHerd.
  ///
  /// In en, this message translates to:
  /// **'{id} added to your herd.'**
  String addedToHerd(String id);

  /// No description provided for @addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{id} added successfully'**
  String addedSuccessfully(String id);

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get exitApp;

  /// No description provided for @exitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to close the app?'**
  String get exitAppConfirm;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled.'**
  String get cancelled;

  /// No description provided for @couldNotCheckPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not check this photo before registration.'**
  String get couldNotCheckPhoto;

  /// No description provided for @couldNotPrepareReg.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare registration'**
  String get couldNotPrepareReg;

  /// No description provided for @captureImage.
  ///
  /// In en, this message translates to:
  /// **'Capture Image'**
  String get captureImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @identificationResult.
  ///
  /// In en, this message translates to:
  /// **'Identification result'**
  String get identificationResult;

  /// No description provided for @noCattlesMessage.
  ///
  /// In en, this message translates to:
  /// **'No cattle yet.\nUse Identify to add your first cattle.'**
  String get noCattlesMessage;

  /// No description provided for @yourHerd.
  ///
  /// In en, this message translates to:
  /// **'Your herd'**
  String get yourHerd;

  /// No description provided for @welcomeNotebook.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your cattle notebook'**
  String get welcomeNotebook;

  /// No description provided for @notebookDescription.
  ///
  /// In en, this message translates to:
  /// **'Take or upload a photo to identify a cattle and keep simple records.'**
  String get notebookDescription;

  /// No description provided for @registeredCattlesCount.
  ///
  /// In en, this message translates to:
  /// **'Registered cattle: {count}'**
  String registeredCattlesCount(int count);

  /// No description provided for @initErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while opening the app.'**
  String get initErrorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noPhotoSelected.
  ///
  /// In en, this message translates to:
  /// **'No photo selected'**
  String get noPhotoSelected;

  /// No description provided for @identifyResultPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Identify a cattle to see the result here.'**
  String get identifyResultPlaceholder;

  /// No description provided for @matchConfidence.
  ///
  /// In en, this message translates to:
  /// **'Match confidence: {confidence}%'**
  String matchConfidence(String confidence);

  /// No description provided for @cattleAlreadyInHerd.
  ///
  /// In en, this message translates to:
  /// **'This cattle is already in your herd.'**
  String get cattleAlreadyInHerd;

  /// No description provided for @noMatchingCattleRegisterHint.
  ///
  /// In en, this message translates to:
  /// **'No matching cattle found. You can add this as a new cattle.'**
  String get noMatchingCattleRegisterHint;

  /// No description provided for @cattleSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Health: {health} • Vaccines: {vaccines} • Notes: {notes}'**
  String cattleSummarySubtitle(int health, int vaccines, int notes);

  /// No description provided for @diseaseNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Disease name'**
  String get diseaseNameLabel;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @recovered.
  ///
  /// In en, this message translates to:
  /// **'Recovered'**
  String get recovered;

  /// No description provided for @symptomsOptional.
  ///
  /// In en, this message translates to:
  /// **'Symptoms (optional)'**
  String get symptomsOptional;

  /// No description provided for @treatmentNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Treatment notes (optional)'**
  String get treatmentNotesOptional;

  /// No description provided for @saveHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Save health record'**
  String get saveHealthRecord;

  /// No description provided for @updateHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Update health record'**
  String get updateHealthRecord;

  /// No description provided for @healthRecordAdded.
  ///
  /// In en, this message translates to:
  /// **'Health record added'**
  String get healthRecordAdded;

  /// No description provided for @healthRecordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Health record updated'**
  String get healthRecordUpdated;

  /// No description provided for @vaccineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Vaccine name'**
  String get vaccineNameLabel;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get pickDate;

  /// No description provided for @nextDueNotSet.
  ///
  /// In en, this message translates to:
  /// **'Next due: Not set'**
  String get nextDueNotSet;

  /// No description provided for @setNextDue.
  ///
  /// In en, this message translates to:
  /// **'Set next due'**
  String get setNextDue;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @saveVaccination.
  ///
  /// In en, this message translates to:
  /// **'Save vaccination'**
  String get saveVaccination;

  /// No description provided for @updateVaccination.
  ///
  /// In en, this message translates to:
  /// **'Update vaccination'**
  String get updateVaccination;

  /// No description provided for @vaccinationAdded.
  ///
  /// In en, this message translates to:
  /// **'Vaccination added'**
  String get vaccinationAdded;

  /// No description provided for @vaccinationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Vaccination updated'**
  String get vaccinationUpdated;

  /// No description provided for @addNoteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addNoteDialogTitle;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// No description provided for @noteUpdated.
  ///
  /// In en, this message translates to:
  /// **'Note updated'**
  String get noteUpdated;

  /// No description provided for @dateLabel2.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel2(String date);

  /// No description provided for @givenLabel2.
  ///
  /// In en, this message translates to:
  /// **'Given: {date}'**
  String givenLabel2(String date);

  /// No description provided for @nextDueLabel2.
  ///
  /// In en, this message translates to:
  /// **'Next due: {date}'**
  String nextDueLabel2(String date);

  /// No description provided for @noSymptomsNoted.
  ///
  /// In en, this message translates to:
  /// **'No symptoms noted'**
  String get noSymptomsNoted;

  /// No description provided for @milkYieldTab.
  ///
  /// In en, this message translates to:
  /// **'Milk Yield'**
  String get milkYieldTab;

  /// No description provided for @milkAndLactationTitle.
  ///
  /// In en, this message translates to:
  /// **'Milk & Lactation'**
  String get milkAndLactationTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @filterButton.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterButton;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @showingCattleCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {filtered} of {total} cattle'**
  String showingCattleCount(int filtered, int total);

  /// No description provided for @noCattleMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No cattle match the selected filters.'**
  String get noCattleMatchFilter;

  /// No description provided for @resetSearchAndFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Search & Filters'**
  String get resetSearchAndFilters;

  /// No description provided for @filterAndSortCattle.
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort Cattle'**
  String get filterAndSortCattle;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrder;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @showMatchingCattle.
  ///
  /// In en, this message translates to:
  /// **'Show {count} Cattle'**
  String showMatchingCattle(int count);

  /// No description provided for @sexLabel.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sexLabel;

  /// No description provided for @lifeStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Life Stage'**
  String get lifeStageLabel;

  /// No description provided for @healthStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatusLabel;

  /// No description provided for @reproductiveStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Reproductive Status'**
  String get reproductiveStatusLabel;

  /// No description provided for @vaccinationStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccinationStatusLabel;

  /// No description provided for @milkAndLactation.
  ///
  /// In en, this message translates to:
  /// **'Milk & Lactation'**
  String get milkAndLactation;

  /// No description provided for @breedCategory.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breedCategory;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @calf.
  ///
  /// In en, this message translates to:
  /// **'Calf'**
  String get calf;

  /// No description provided for @heifer.
  ///
  /// In en, this message translates to:
  /// **'Heifer'**
  String get heifer;

  /// No description provided for @cow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// No description provided for @bull.
  ///
  /// In en, this message translates to:
  /// **'Bull'**
  String get bull;

  /// No description provided for @steer.
  ///
  /// In en, this message translates to:
  /// **'Steer'**
  String get steer;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @underObservation.
  ///
  /// In en, this message translates to:
  /// **'Under Observation'**
  String get underObservation;

  /// No description provided for @diseased.
  ///
  /// In en, this message translates to:
  /// **'Diseased'**
  String get diseased;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @pregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// No description provided for @notPregnant.
  ///
  /// In en, this message translates to:
  /// **'Not Pregnant'**
  String get notPregnant;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'Up to Date'**
  String get upToDate;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get dueSoon;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @noRecord.
  ///
  /// In en, this message translates to:
  /// **'No Record'**
  String get noRecord;

  /// No description provided for @milkingCows.
  ///
  /// In en, this message translates to:
  /// **'Milking Cows'**
  String get milkingCows;

  /// No description provided for @dryCows.
  ///
  /// In en, this message translates to:
  /// **'Dry Cows'**
  String get dryCows;

  /// No description provided for @highProducers.
  ///
  /// In en, this message translates to:
  /// **'High Producers (>15 L/day)'**
  String get highProducers;

  /// No description provided for @mediumProducers.
  ///
  /// In en, this message translates to:
  /// **'Medium Producers (8–15 L/day)'**
  String get mediumProducers;

  /// No description provided for @lowProducers.
  ///
  /// In en, this message translates to:
  /// **'Low Producers (<8 L/day)'**
  String get lowProducers;

  /// No description provided for @recentlyCalved.
  ///
  /// In en, this message translates to:
  /// **'Recently Calved'**
  String get recentlyCalved;

  /// No description provided for @sortRecentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get sortRecentlyAdded;

  /// No description provided for @sortOldestAdded.
  ///
  /// In en, this message translates to:
  /// **'Oldest Added'**
  String get sortOldestAdded;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'ID (A → Z)'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'ID (Z → A)'**
  String get sortNameDesc;

  /// No description provided for @sortAgeAsc.
  ///
  /// In en, this message translates to:
  /// **'Age (Youngest)'**
  String get sortAgeAsc;

  /// No description provided for @sortAgeDesc.
  ///
  /// In en, this message translates to:
  /// **'Age (Oldest)'**
  String get sortAgeDesc;

  /// No description provided for @todaysMilkProduction.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Milk Production'**
  String get todaysMilkProduction;

  /// No description provided for @cowsMilked.
  ///
  /// In en, this message translates to:
  /// **'{count} cows milked'**
  String cowsMilked(int count);

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// No description provided for @averagePerCow.
  ///
  /// In en, this message translates to:
  /// **'Average / Cow'**
  String get averagePerCow;

  /// No description provided for @topProducer.
  ///
  /// In en, this message translates to:
  /// **'Top: #{id} ({yield} L)'**
  String topProducer(String id, String yield);

  /// No description provided for @topProducerNone.
  ///
  /// In en, this message translates to:
  /// **'Top Producer: None yet'**
  String get topProducerNone;

  /// No description provided for @lowestProducer.
  ///
  /// In en, this message translates to:
  /// **'Low: #{id} ({yield} L)'**
  String lowestProducer(String id, String yield);

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @milkingHerd.
  ///
  /// In en, this message translates to:
  /// **'Milking Herd'**
  String get milkingHerd;

  /// No description provided for @cowsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cows'**
  String cowsCount(int count);

  /// No description provided for @recordMilk.
  ///
  /// In en, this message translates to:
  /// **'Record Milk'**
  String get recordMilk;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @productionAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Production Analytics'**
  String get productionAnalytics;

  /// No description provided for @milkHistory.
  ///
  /// In en, this message translates to:
  /// **'Milk History'**
  String get milkHistory;

  /// No description provided for @daysLogged.
  ///
  /// In en, this message translates to:
  /// **'{count} days logged'**
  String daysLogged(int count);

  /// No description provided for @noMilkRecordsSavedYet.
  ///
  /// In en, this message translates to:
  /// **'No milk records saved yet. Tap \"Record Milk\" to start.'**
  String get noMilkRecordsSavedYet;

  /// No description provided for @breedAnalyticsFilter.
  ///
  /// In en, this message translates to:
  /// **'Breed Analytics Filter:'**
  String get breedAnalyticsFilter;

  /// No description provided for @allBreeds.
  ///
  /// In en, this message translates to:
  /// **'All Breeds'**
  String get allBreeds;

  /// No description provided for @cowsRecordedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cow{plural} recorded'**
  String cowsRecordedCount(int count, String plural);

  /// No description provided for @morningShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get morningShort;

  /// No description provided for @eveningShort.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get eveningShort;

  /// No description provided for @editMilkRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Milk Record'**
  String get editMilkRecord;

  /// No description provided for @recordMilkYield.
  ///
  /// In en, this message translates to:
  /// **'Record Milk Yield'**
  String get recordMilkYield;

  /// No description provided for @recordExistsWarning.
  ///
  /// In en, this message translates to:
  /// **'A record for this cow on this date already exists. Saving will update it.'**
  String get recordExistsWarning;

  /// No description provided for @cattleLabel.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get cattleLabel;

  /// No description provided for @selectCow.
  ///
  /// In en, this message translates to:
  /// **'Select Cow'**
  String get selectCow;

  /// No description provided for @milkingBadge.
  ///
  /// In en, this message translates to:
  /// **'Milking'**
  String get milkingBadge;

  /// No description provided for @recordDate.
  ///
  /// In en, this message translates to:
  /// **'Record Date'**
  String get recordDate;

  /// No description provided for @morningLiters.
  ///
  /// In en, this message translates to:
  /// **'Morning (L)'**
  String get morningLiters;

  /// No description provided for @eveningLiters.
  ///
  /// In en, this message translates to:
  /// **'Evening (L)'**
  String get eveningLiters;

  /// No description provided for @totalDailyYield.
  ///
  /// In en, this message translates to:
  /// **'Total Daily Yield'**
  String get totalDailyYield;

  /// No description provided for @notesOptionalMilk.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptionalMilk;

  /// No description provided for @notesHintMilk.
  ///
  /// In en, this message translates to:
  /// **'e.g. Fed silage, normal appetite'**
  String get notesHintMilk;

  /// No description provided for @updateRecord.
  ///
  /// In en, this message translates to:
  /// **'Update Record'**
  String get updateRecord;

  /// No description provided for @saveRecordButton.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecordButton;

  /// No description provided for @pleaseSelectCattle.
  ///
  /// In en, this message translates to:
  /// **'Please select a cattle'**
  String get pleaseSelectCattle;

  /// No description provided for @milkProductionReports.
  ///
  /// In en, this message translates to:
  /// **'Milk Production Reports'**
  String get milkProductionReports;

  /// No description provided for @breedFilterBadge.
  ///
  /// In en, this message translates to:
  /// **'Breed Filter: {breed}'**
  String breedFilterBadge(String breed);

  /// No description provided for @dailyTab.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dailyTab;

  /// No description provided for @weeklyTab.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyTab;

  /// No description provided for @monthlyTab.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyTab;

  /// No description provided for @reportDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Date: '**
  String get reportDateLabel;

  /// No description provided for @weekStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Week Start: '**
  String get weekStartLabel;

  /// No description provided for @downloadCsvReport.
  ///
  /// In en, this message translates to:
  /// **'Download {type} CSV Report'**
  String downloadCsvReport(String type);

  /// No description provided for @reportSaved.
  ///
  /// In en, this message translates to:
  /// **'Report saved: {fileName}'**
  String reportSaved(String fileName);

  /// No description provided for @reportCopied.
  ///
  /// In en, this message translates to:
  /// **'Report copied to clipboard!'**
  String get reportCopied;

  /// No description provided for @dailyAvg.
  ///
  /// In en, this message translates to:
  /// **'Daily Avg'**
  String get dailyAvg;

  /// No description provided for @totalYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Yield'**
  String get totalYieldLabel;

  /// No description provided for @bestLabel.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestLabel;

  /// No description provided for @worstLabel.
  ///
  /// In en, this message translates to:
  /// **'Worst'**
  String get worstLabel;

  /// No description provided for @orderLabel.
  ///
  /// In en, this message translates to:
  /// **'Order:'**
  String get orderLabel;

  /// No description provided for @bestToWorst.
  ///
  /// In en, this message translates to:
  /// **'Best → Worst'**
  String get bestToWorst;

  /// No description provided for @worstToBest.
  ///
  /// In en, this message translates to:
  /// **'Worst → Best'**
  String get worstToBest;

  /// No description provided for @noMilkRecordsForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No milk records found for this period{breedText}.'**
  String noMilkRecordsForPeriod(String breedText);

  /// No description provided for @recordedOutOfDays.
  ///
  /// In en, this message translates to:
  /// **'Recorded: {recorded}/{total} days'**
  String recordedOutOfDays(int recorded, int total);

  /// No description provided for @recordedEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'Recorded: {count} entries'**
  String recordedEntriesCount(int count);

  /// No description provided for @morningEveningBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Morning: {morning} L  •  Evening: {evening} L'**
  String morningEveningBreakdown(String morning, String evening);

  /// No description provided for @notificationsAndSmartAlerts.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Smart Alerts'**
  String get notificationsAndSmartAlerts;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All Clear!'**
  String get allClear;

  /// No description provided for @noPendingAlerts.
  ///
  /// In en, this message translates to:
  /// **'No pending notifications or alerts.'**
  String get noPendingAlerts;

  /// No description provided for @viewAction.
  ///
  /// In en, this message translates to:
  /// **'VIEW'**
  String get viewAction;

  /// No description provided for @recordMilkAction.
  ///
  /// In en, this message translates to:
  /// **'RECORD MILK'**
  String get recordMilkAction;

  /// No description provided for @logCalvingAction.
  ///
  /// In en, this message translates to:
  /// **'LOG CALVING'**
  String get logCalvingAction;

  /// No description provided for @vaccinateAction.
  ///
  /// In en, this message translates to:
  /// **'VACCINATE'**
  String get vaccinateAction;

  /// No description provided for @editCattleDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Cattle Details'**
  String get editCattleDetails;

  /// No description provided for @dateOfBirthAge.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (Age)'**
  String get dateOfBirthAge;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @yearsMonthsAge.
  ///
  /// In en, this message translates to:
  /// **'{years} yr{yPlural} {months} mo{mPlural}'**
  String yearsMonthsAge(int years, String yPlural, int months, String mPlural);

  /// No description provided for @yearsAge.
  ///
  /// In en, this message translates to:
  /// **'{years} yr{yPlural}'**
  String yearsAge(int years, String yPlural);

  /// No description provided for @monthsAge.
  ///
  /// In en, this message translates to:
  /// **'{months} mo{mPlural}'**
  String monthsAge(int months, String mPlural);

  /// No description provided for @unknownAge.
  ///
  /// In en, this message translates to:
  /// **'Unknown age'**
  String get unknownAge;

  /// No description provided for @milkAndLactationProfile.
  ///
  /// In en, this message translates to:
  /// **'Milk & Lactation Profile'**
  String get milkAndLactationProfile;

  /// No description provided for @currentlyMilking.
  ///
  /// In en, this message translates to:
  /// **'Currently Milking'**
  String get currentlyMilking;

  /// No description provided for @lastCalvingDate.
  ///
  /// In en, this message translates to:
  /// **'Last Calving Date'**
  String get lastCalvingDate;

  /// No description provided for @inseminationDate.
  ///
  /// In en, this message translates to:
  /// **'Insemination Date'**
  String get inseminationDate;

  /// No description provided for @expectedDailyYieldBenchmark.
  ///
  /// In en, this message translates to:
  /// **'Expected Daily Yield (Benchmark)'**
  String get expectedDailyYieldBenchmark;

  /// No description provided for @benchmarkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15.0'**
  String get benchmarkHint;

  /// No description provided for @symptomsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Not eating properly'**
  String get symptomsHint;

  /// No description provided for @cattleDetailsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cattle details updated'**
  String get cattleDetailsUpdated;

  /// No description provided for @milkProductionTab.
  ///
  /// In en, this message translates to:
  /// **'Milk Production'**
  String get milkProductionTab;

  /// No description provided for @lactationStatus.
  ///
  /// In en, this message translates to:
  /// **'Lactation Status'**
  String get lactationStatus;

  /// No description provided for @daysInMilk.
  ///
  /// In en, this message translates to:
  /// **'Days in Milk (DIM)'**
  String get daysInMilk;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysUnit(int count);

  /// No description provided for @lastCalving.
  ///
  /// In en, this message translates to:
  /// **'Last Calving'**
  String get lastCalving;

  /// No description provided for @estNextCalving.
  ///
  /// In en, this message translates to:
  /// **'Est. Next Calving'**
  String get estNextCalving;

  /// No description provided for @thirtyDayAverage.
  ///
  /// In en, this message translates to:
  /// **'30-Day Average'**
  String get thirtyDayAverage;

  /// No description provided for @totalThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Total This Month'**
  String get totalThisMonth;

  /// No description provided for @recentMilkYieldTrend.
  ///
  /// In en, this message translates to:
  /// **'Recent Milk Yield Trend'**
  String get recentMilkYieldTrend;

  /// No description provided for @dailyMilkRecords.
  ///
  /// In en, this message translates to:
  /// **'Daily Milk Records'**
  String get dailyMilkRecords;

  /// No description provided for @noDailyMilkRecords.
  ///
  /// In en, this message translates to:
  /// **'No daily milk yields recorded for this cow yet.'**
  String get noDailyMilkRecords;

  /// No description provided for @litersPerDay.
  ///
  /// In en, this message translates to:
  /// **'{yield} L/day'**
  String litersPerDay(String yield);

  /// No description provided for @freshStage.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get freshStage;

  /// No description provided for @earlyStage.
  ///
  /// In en, this message translates to:
  /// **'Early'**
  String get earlyStage;

  /// No description provided for @midStage.
  ///
  /// In en, this message translates to:
  /// **'Mid'**
  String get midStage;

  /// No description provided for @lateStage.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get lateStage;

  /// No description provided for @extendedStage.
  ///
  /// In en, this message translates to:
  /// **'Extended Lactation'**
  String get extendedStage;

  /// No description provided for @dryStage.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get dryStage;

  /// No description provided for @stageSuffix.
  ///
  /// In en, this message translates to:
  /// **'{stage} Stage'**
  String stageSuffix(String stage);

  /// No description provided for @calvingDateOverdue.
  ///
  /// In en, this message translates to:
  /// **'Calving Date Overdue'**
  String get calvingDateOverdue;

  /// No description provided for @calvingOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'Expected calving ({date}) has passed. Update calving information or pregnancy status.'**
  String calvingOverdueMessage(String date);

  /// No description provided for @logCalving.
  ///
  /// In en, this message translates to:
  /// **'Log Calving'**
  String get logCalving;

  /// No description provided for @predictedBreed.
  ///
  /// In en, this message translates to:
  /// **'Predicted Breed'**
  String get predictedBreed;

  /// No description provided for @noMilkChartRecords.
  ///
  /// In en, this message translates to:
  /// **'No milk records yet.\nStart recording to see production trends.'**
  String get noMilkChartRecords;

  /// No description provided for @setAsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Set as Unknown'**
  String get setAsUnknown;

  /// No description provided for @breedPredictionItem.
  ///
  /// In en, this message translates to:
  /// **'• {name} — {percent}%'**
  String breedPredictionItem(String name, int percent);

  /// No description provided for @sexRequired.
  ///
  /// In en, this message translates to:
  /// **'Sex *'**
  String get sexRequired;

  /// No description provided for @optionalNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pregnant'**
  String get optionalNoteHint;

  /// No description provided for @missingMilkEntryToday.
  ///
  /// In en, this message translates to:
  /// **'Missing Milk Entry Today'**
  String get missingMilkEntryToday;

  /// No description provided for @missingMilkEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing Milk Entry ({date})'**
  String missingMilkEntryTitle(String date);

  /// No description provided for @noMilkRecordEntered.
  ///
  /// In en, this message translates to:
  /// **'No milk record entered {dateLabel} for #{id}.'**
  String noMilkRecordEntered(String dateLabel, String id);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @onDate.
  ///
  /// In en, this message translates to:
  /// **'on {date}'**
  String onDate(String date);

  /// No description provided for @lowYieldAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Yield Alert'**
  String get lowYieldAlertTitle;

  /// No description provided for @lowYieldAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} milk production dropped {percent}% ({latest} L vs {avg} L avg).'**
  String lowYieldAlertMessage(
    String id,
    String percent,
    String latest,
    String avg,
  );

  /// No description provided for @dryOffReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Dry-Off Reminder'**
  String get dryOffReminderTitle;

  /// No description provided for @dryOffReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} is expected to calve in {days} days. Prepare cow for dry period.'**
  String dryOffReminderMessage(String id, int days);

  /// No description provided for @calvingDateOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Calving Date Overdue'**
  String get calvingDateOverdueTitle;

  /// No description provided for @calvingDateOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} expected calving date was {days} day{plural} ago ({date}). Update calving information or pregnancy status.'**
  String calvingDateOverdueMessage(
    String id,
    int days,
    String plural,
    String date,
  );

  /// No description provided for @calvingReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Calving Reminder'**
  String get calvingReminderTitle;

  /// No description provided for @calvingReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} is due for calving in {days} day{plural}. Prepare maternity pen.'**
  String calvingReminderMessage(String id, int days, String plural);

  /// No description provided for @vaccinationOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Overdue'**
  String get vaccinationOverdueTitle;

  /// No description provided for @vaccinationOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} — {vacName} was due {days} day{plural} ago ({date}).'**
  String vaccinationOverdueMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  );

  /// No description provided for @vaccinationDueSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Due Soon'**
  String get vaccinationDueSoonTitle;

  /// No description provided for @vaccinationDueSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'#{id} — {vacName} due in {days} day{plural} ({date}).'**
  String vaccinationDueSoonMessage(
    String id,
    String vacName,
    int days,
    String plural,
    String date,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'gu',
    'hi',
    'kn',
    'mr',
    'or',
    'ta',
    'te',
    'ur',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'or':
      return AppLocalizationsOr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
