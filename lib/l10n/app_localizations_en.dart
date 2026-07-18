// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Herd AI';

  @override
  String get appSubtitle => 'Your cattle notebook';

  @override
  String get preparingSecureAccess => 'Preparing secure access...';

  @override
  String get createPin => 'Create a 4-digit PIN';

  @override
  String get enterPin => 'Enter your PIN';

  @override
  String get unlockApp => 'Unlock your app';

  @override
  String get confirmPin => 'Confirm your PIN';

  @override
  String get pinDidNotMatchTryAgain => 'PIN did not match. Try again';

  @override
  String get pinDidNotMatch => 'PIN did not match';

  @override
  String get pinCreated => 'PIN created';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get wrongPinTryAgain => 'Wrong PIN. Try again';

  @override
  String get wrongPin => 'Wrong PIN';

  @override
  String get usePinToUnlock => 'Use PIN to unlock';

  @override
  String get tryFingerprintFace => 'Try fingerprint/face';

  @override
  String get settings => 'Settings';

  @override
  String get changePin => 'Change PIN';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN';

  @override
  String get confirmNewPin => 'Confirm new PIN';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get wrongCurrentPin => 'Wrong current PIN';

  @override
  String get pinChanged => 'PIN changed';

  @override
  String get pinsDoNotMatch => 'New PINs do not match';

  @override
  String get enterAllFields => 'Please fill in all fields';

  @override
  String get invalidPinLength => 'PIN must be 4 digits';

  @override
  String get cowsNotebook => 'Cows Notebook';

  @override
  String get noCows => 'No cows registered yet.';

  @override
  String get searchHint => 'Search your herd...';

  @override
  String cowIdLabel(String id) {
    return 'Cow ID: $id';
  }

  @override
  String registeredLabel(String date) {
    return 'Registered: $date';
  }

  @override
  String get readyToIdentify => 'Ready to identify cows and keep records.';

  @override
  String get initializingDb => 'Getting your cattle notebook ready...';

  @override
  String get readyText => 'Ready to identify';

  @override
  String get notReady => 'App setup is not complete yet. Please retry.';

  @override
  String get selectImage => 'Select an image after the model finishes loading.';

  @override
  String get checkingCow => 'Checking cow...';

  @override
  String get cowIdentified => 'Cow identified.';

  @override
  String get borderlineMatch =>
      'This looks like a cow you already have — see below.';

  @override
  String get noMatchingCow => 'No matching cow found.';

  @override
  String get couldNotIdentify => 'Could not identify this cow right now.';

  @override
  String get addThisCow => 'Add this cow';

  @override
  String get cowId => 'Cow ID';

  @override
  String get optionalNote => 'Note (optional)';

  @override
  String get register => 'Register';

  @override
  String get addCow => 'Add cow';

  @override
  String get cowAlreadyExists => 'Cow ID already exists';

  @override
  String get pleaseEnterId => 'Please enter an ID';

  @override
  String get registering => 'Registering...';

  @override
  String get cowRegistered => 'Cow registered';

  @override
  String get failedToRegister => 'Could not register cow';

  @override
  String get basicInfo => 'Basic info';

  @override
  String registeredOn(String date) {
    return 'Registered: $date';
  }

  @override
  String get breedClassification => 'Breed Classification';

  @override
  String get classifyBreed => 'Classify Breed';

  @override
  String get reClassify => 'Re-classify';

  @override
  String get noBreedClassificationYet =>
      'No breed classification yet. Take a full-body photo.';

  @override
  String confirmedBreed(String breed) {
    return 'Confirmed Breed: $breed';
  }

  @override
  String get lowConfidenceWarning =>
      'Low confidence — try a clearer full-body photo.';

  @override
  String get setManually => 'Set Manually';

  @override
  String get unknownMixed => 'Unknown / Mixed';

  @override
  String get likelyBreedsVisual => 'Likely breeds (visual estimate):';

  @override
  String confirmBreed(String breed) {
    return 'Confirm $breed';
  }

  @override
  String get chooseDifferent => 'Choose different';

  @override
  String get breedClassified => 'Breed classified';

  @override
  String get couldNotClassify => 'Could not classify breed';

  @override
  String get noBreedPredictions => 'No breed predictions returned';

  @override
  String breedConfirmed(String breed) {
    return 'Breed confirmed: $breed';
  }

  @override
  String get chooseBreed => 'Choose breed';

  @override
  String get orTypeBreedName => 'Or type a breed name:';

  @override
  String get confirmCustomBreed => 'Confirm custom breed';

  @override
  String get customBreedHint => 'e.g. Jersey Cross';

  @override
  String get breedSetUnknown => 'Breed set to Unknown / Mixed';

  @override
  String get healthRecords => 'Health Records';

  @override
  String get addHealthRecord => 'Add Health Record';

  @override
  String get editHealthRecord => 'Edit Health Record';

  @override
  String get noHealthRecords => 'No health records yet.';

  @override
  String get diseaseName => 'Disease Name';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get status => 'Status';

  @override
  String get dateLabel => 'Date';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get deleteHealthRecord => 'Delete health record';

  @override
  String get deleteHealthRecordConfirm => 'Delete this health record?';

  @override
  String get healthRecordDeleted => 'Health record deleted';

  @override
  String get healthRecordSaved => 'Health record saved';

  @override
  String get vaccinationRecords => 'Vaccination Records';

  @override
  String get addVaccination => 'Add Vaccination';

  @override
  String get editVaccination => 'Edit Vaccination';

  @override
  String get noVaccinationRecords => 'No vaccination records yet.';

  @override
  String get vaccineName => 'Vaccine Name';

  @override
  String get dateGiven => 'Date Given';

  @override
  String get nextDueDate => 'Next Due Date (optional)';

  @override
  String get deleteVaccination => 'Delete vaccination';

  @override
  String get deleteVaccinationConfirm => 'Delete this vaccination record?';

  @override
  String get vaccinationDeleted => 'Vaccination deleted';

  @override
  String get vaccinationSaved => 'Vaccination saved';

  @override
  String get notes => 'Notes';

  @override
  String get addNote => 'Add Note';

  @override
  String get editNote => 'Edit Note';

  @override
  String get noNotes => 'No notes added.';

  @override
  String get deleteNote => 'Delete note';

  @override
  String get deleteNoteConfirm => 'Delete this note?';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get noteSaved => 'Note saved';

  @override
  String get photos => 'Photos';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get photoDesc =>
      'Track how this cow looks over time. Newest photos appear first.';

  @override
  String get noPhotos => 'No photos yet.';

  @override
  String get replace => 'Replace';

  @override
  String get replacePhoto => 'Replace this photo?';

  @override
  String get replacePhotoConfirm =>
      'The old photo will be removed and replaced with the new one.';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get couldNotUpdatePhoto => 'Could not update photo';

  @override
  String get deletePhoto => 'Delete photo';

  @override
  String get deletePhotoConfirm =>
      'Delete this photo? It will also be removed from cow identification.';

  @override
  String get photoDeleted => 'Photo deleted';

  @override
  String addPhotoTo(String id) {
    return 'Add photo to $id?';
  }

  @override
  String get addPhotoConfirm =>
      'This photo will be saved with today\'s date so you can track how this cow looks over time. It will also help identify this cow in the future.';

  @override
  String get photoAdded => 'Photo added';

  @override
  String get couldNotAddPhoto => 'Could not add photo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takeOrChooseClear => 'Take or choose a clear photo of this cow.';

  @override
  String get classifyThisPhoto => 'Classify this photo?';

  @override
  String get classifyThisPhotoConfirm =>
      'A clear, well-lit full-body photo gives the best breed prediction.';

  @override
  String get classify => 'Classify';

  @override
  String get takeOrChooseFullBody =>
      'Take or choose a clear full-body photo of this cow.';

  @override
  String get deleteCowRecord => 'Delete Cow Record';

  @override
  String deleteCowRecordConfirm(String id) {
    return 'Delete $id and all related records?';
  }

  @override
  String get cowRecordDeleted => 'Cow record deleted';

  @override
  String get cowDetails => 'Cow details';

  @override
  String get cowNotFound => 'Cow record not found.';

  @override
  String detailsHeader(String id) {
    return '$id details';
  }

  @override
  String get identifyCow => 'Identify Cow';

  @override
  String get identifyTab => 'Identify';

  @override
  String get cowsTab => 'My Cows';

  @override
  String get tapIdentify => 'Photo added. Tap Identify Cow.';

  @override
  String get selectImageFirst => 'Select an image first.';

  @override
  String get matchesHeading => 'Matches';

  @override
  String get details => 'Details';

  @override
  String get unknownCow => 'Unknown Cow';

  @override
  String get registerThisCow => 'Register this cow';

  @override
  String get backButton => 'Back';

  @override
  String get noCowsFound => 'No cows found';

  @override
  String get activeLabel => 'Active';

  @override
  String get recoveredLabel => 'Recovered';

  @override
  String givenLabel(String date) {
    return 'Given: $date';
  }

  @override
  String nextDueLabel(String date) {
    return 'Next due: $date';
  }

  @override
  String get tabOverview => 'Overview';

  @override
  String get tabMedical => 'Medical';

  @override
  String get tabGalleryNotes => 'Gallery & Notes';

  @override
  String dialogIdentifyAs(String id) {
    return 'Identify as $id?';
  }

  @override
  String dialogIdentifyAsConfirm(String id, int confidence) {
    return 'This cow looks a lot like $id (Confidence: $confidence%). Do you want to save this photo under $id\'s history instead of registering a new cow?';
  }

  @override
  String dialogIdentifySavePhoto(String id) {
    return 'Save photo to $id';
  }

  @override
  String get dialogIdentifyNewCow => 'No, it\'s a new cow';

  @override
  String get checkingPhotoBeforeReg => 'Checking photo before registration...';

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
    return 'Yes, add to $id';
  }

  @override
  String looksLike(String id) {
    return 'This looks like $id';
  }

  @override
  String get addPhotoToThat => 'Add this photo to that cow?';

  @override
  String get createNewCow => 'Create new cow';

  @override
  String get savingPhoto => 'Saving photo...';

  @override
  String photoAddedTo(String id) {
    return 'Photo added to $id';
  }

  @override
  String get couldNotSavePhoto => 'Could not save this photo.';

  @override
  String get savingCowDetails => 'Saving cow details...';

  @override
  String addedToHerd(String id) {
    return '$id added to your herd.';
  }

  @override
  String addedSuccessfully(String id) {
    return '$id added successfully';
  }

  @override
  String get exitApp => 'Exit app';

  @override
  String get exitAppConfirm => 'Do you want to close the app?';

  @override
  String get cancelled => 'Cancelled.';

  @override
  String get couldNotCheckPhoto =>
      'Could not check this photo before registration.';

  @override
  String get couldNotPrepareReg => 'Could not prepare registration';

  @override
  String get captureImage => 'Capture Image';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get identificationResult => 'Identification result';

  @override
  String get noCowsMessage =>
      'No cows yet.\nUse Identify to add your first cow.';

  @override
  String get yourHerd => 'Your herd';

  @override
  String get welcomeNotebook => 'Welcome to your cattle notebook';

  @override
  String get notebookDescription =>
      'Take or upload a photo to identify a cow and keep simple records.';

  @override
  String registeredCowsCount(int count) {
    return 'Registered cows: $count';
  }

  @override
  String get initErrorOccurred => 'Something went wrong while opening the app.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noPhotoSelected => 'No photo selected';

  @override
  String get identifyResultPlaceholder =>
      'Identify a cow to see the result here.';

  @override
  String matchConfidence(String confidence) {
    return 'Match confidence: $confidence%';
  }

  @override
  String get cowAlreadyInHerd => 'This cow is already in your herd.';

  @override
  String get noMatchingCowRegisterHint =>
      'No matching cow found. You can add this as a new cow.';

  @override
  String cowSummarySubtitle(int health, int vaccines, int notes) {
    return 'Health: $health • Vaccines: $vaccines • Notes: $notes';
  }

  @override
  String get diseaseNameLabel => 'Disease name';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get recovered => 'Recovered';

  @override
  String get symptomsOptional => 'Symptoms (optional)';

  @override
  String get treatmentNotesOptional => 'Treatment notes (optional)';

  @override
  String get saveHealthRecord => 'Save health record';

  @override
  String get updateHealthRecord => 'Update health record';

  @override
  String get healthRecordAdded => 'Health record added';

  @override
  String get healthRecordUpdated => 'Health record updated';

  @override
  String get vaccineNameLabel => 'Vaccine name';

  @override
  String get pickDate => 'Pick date';

  @override
  String get nextDueNotSet => 'Next due: Not set';

  @override
  String get setNextDue => 'Set next due';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get saveVaccination => 'Save vaccination';

  @override
  String get updateVaccination => 'Update vaccination';

  @override
  String get vaccinationAdded => 'Vaccination added';

  @override
  String get vaccinationUpdated => 'Vaccination updated';

  @override
  String get addNoteDialogTitle => 'Add a note';

  @override
  String get noteAdded => 'Note added';

  @override
  String get noteUpdated => 'Note updated';

  @override
  String dateLabel2(String date) {
    return 'Date: $date';
  }

  @override
  String givenLabel2(String date) {
    return 'Given: $date';
  }

  @override
  String nextDueLabel2(String date) {
    return 'Next due: $date';
  }

  @override
  String get noSymptomsNoted => 'No symptoms noted';
}
