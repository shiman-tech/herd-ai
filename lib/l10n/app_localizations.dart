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

  /// No description provided for @cowsNotebook.
  ///
  /// In en, this message translates to:
  /// **'Cows Notebook'**
  String get cowsNotebook;

  /// No description provided for @noCows.
  ///
  /// In en, this message translates to:
  /// **'No cows registered yet.'**
  String get noCows;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your herd...'**
  String get searchHint;

  /// No description provided for @cowIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Cow ID: {id}'**
  String cowIdLabel(String id);

  /// No description provided for @registeredLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered: {date}'**
  String registeredLabel(String date);

  /// No description provided for @readyToIdentify.
  ///
  /// In en, this message translates to:
  /// **'Ready to identify cows and keep records.'**
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

  /// No description provided for @checkingCow.
  ///
  /// In en, this message translates to:
  /// **'Checking cow...'**
  String get checkingCow;

  /// No description provided for @cowIdentified.
  ///
  /// In en, this message translates to:
  /// **'Cow identified.'**
  String get cowIdentified;

  /// No description provided for @borderlineMatch.
  ///
  /// In en, this message translates to:
  /// **'This looks like a cow you already have — see below.'**
  String get borderlineMatch;

  /// No description provided for @noMatchingCow.
  ///
  /// In en, this message translates to:
  /// **'No matching cow found.'**
  String get noMatchingCow;

  /// No description provided for @couldNotIdentify.
  ///
  /// In en, this message translates to:
  /// **'Could not identify this cow right now.'**
  String get couldNotIdentify;

  /// No description provided for @addThisCow.
  ///
  /// In en, this message translates to:
  /// **'Add this cow'**
  String get addThisCow;

  /// No description provided for @cowId.
  ///
  /// In en, this message translates to:
  /// **'Cow ID'**
  String get cowId;

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

  /// No description provided for @addCow.
  ///
  /// In en, this message translates to:
  /// **'Add cow'**
  String get addCow;

  /// No description provided for @cowAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Cow ID already exists'**
  String get cowAlreadyExists;

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

  /// No description provided for @cowRegistered.
  ///
  /// In en, this message translates to:
  /// **'Cow registered'**
  String get cowRegistered;

  /// No description provided for @failedToRegister.
  ///
  /// In en, this message translates to:
  /// **'Could not register cow'**
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
  /// **'Low confidence — try a clearer full-body photo.'**
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

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhoto;

  /// No description provided for @photoDesc.
  ///
  /// In en, this message translates to:
  /// **'Track how this cow looks over time. Newest photos appear first.'**
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
  /// **'Delete this photo? It will also be removed from cow identification.'**
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
  /// **'This photo will be saved with today\'s date so you can track how this cow looks over time. It will also help identify this cow in the future.'**
  String get addPhotoConfirm;

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
  /// **'Take or choose a clear photo of this cow.'**
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
  /// **'Take or choose a clear full-body photo of this cow.'**
  String get takeOrChooseFullBody;

  /// No description provided for @deleteCowRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Cow Record'**
  String get deleteCowRecord;

  /// No description provided for @deleteCowRecordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {id} and all related records?'**
  String deleteCowRecordConfirm(String id);

  /// No description provided for @cowRecordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Cow record deleted'**
  String get cowRecordDeleted;

  /// No description provided for @cowDetails.
  ///
  /// In en, this message translates to:
  /// **'Cow details'**
  String get cowDetails;

  /// No description provided for @cowNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cow record not found.'**
  String get cowNotFound;

  /// No description provided for @detailsHeader.
  ///
  /// In en, this message translates to:
  /// **'{id} details'**
  String detailsHeader(String id);

  /// No description provided for @identifyCow.
  ///
  /// In en, this message translates to:
  /// **'Identify Cow'**
  String get identifyCow;

  /// No description provided for @identifyTab.
  ///
  /// In en, this message translates to:
  /// **'Identify'**
  String get identifyTab;

  /// No description provided for @cowsTab.
  ///
  /// In en, this message translates to:
  /// **'My Cows'**
  String get cowsTab;

  /// No description provided for @tapIdentify.
  ///
  /// In en, this message translates to:
  /// **'Photo added. Tap Identify Cow.'**
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

  /// No description provided for @unknownCow.
  ///
  /// In en, this message translates to:
  /// **'Unknown Cow'**
  String get unknownCow;

  /// No description provided for @registerThisCow.
  ///
  /// In en, this message translates to:
  /// **'Register this cow'**
  String get registerThisCow;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @noCowsFound.
  ///
  /// In en, this message translates to:
  /// **'No cows found'**
  String get noCowsFound;

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
  /// **'This cow looks a lot like {id} (Confidence: {confidence}%). Do you want to save this photo under {id}\'s history instead of registering a new cow?'**
  String dialogIdentifyAsConfirm(String id, int confidence);

  /// No description provided for @dialogIdentifySavePhoto.
  ///
  /// In en, this message translates to:
  /// **'Save photo to {id}'**
  String dialogIdentifySavePhoto(String id);

  /// No description provided for @dialogIdentifyNewCow.
  ///
  /// In en, this message translates to:
  /// **'No, it\'s a new cow'**
  String get dialogIdentifyNewCow;

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
  /// **'Add this photo to that cow?'**
  String get addPhotoToThat;

  /// No description provided for @createNewCow.
  ///
  /// In en, this message translates to:
  /// **'Create new cow'**
  String get createNewCow;

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

  /// No description provided for @savingCowDetails.
  ///
  /// In en, this message translates to:
  /// **'Saving cow details...'**
  String get savingCowDetails;

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

  /// No description provided for @noCowsMessage.
  ///
  /// In en, this message translates to:
  /// **'No cows yet.\nUse Identify to add your first cow.'**
  String get noCowsMessage;

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
  /// **'Take or upload a photo to identify a cow and keep simple records.'**
  String get notebookDescription;

  /// No description provided for @registeredCowsCount.
  ///
  /// In en, this message translates to:
  /// **'Registered cows: {count}'**
  String registeredCowsCount(int count);

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
  /// **'Identify a cow to see the result here.'**
  String get identifyResultPlaceholder;

  /// No description provided for @matchConfidence.
  ///
  /// In en, this message translates to:
  /// **'Match confidence: {confidence}%'**
  String matchConfidence(String confidence);

  /// No description provided for @cowAlreadyInHerd.
  ///
  /// In en, this message translates to:
  /// **'This cow is already in your herd.'**
  String get cowAlreadyInHerd;

  /// No description provided for @noMatchingCowRegisterHint.
  ///
  /// In en, this message translates to:
  /// **'No matching cow found. You can add this as a new cow.'**
  String get noMatchingCowRegisterHint;

  /// No description provided for @cowSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Health: {health} • Vaccines: {vaccines} • Notes: {notes}'**
  String cowSummarySubtitle(int health, int vaccines, int notes);

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
