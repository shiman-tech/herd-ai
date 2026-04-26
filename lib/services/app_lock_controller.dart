class AppLockController {
  AppLockController._();

  static final AppLockController instance = AppLockController._();

  int _suspendCount = 0;
  bool _skipNextResumeLock = false;

  bool get isLockSuspended => _suspendCount > 0;

  bool consumeSkipNextResumeLock() {
    if (!_skipNextResumeLock) {
      return false;
    }
    _skipNextResumeLock = false;
    return true;
  }

  void suspendLock() {
    _suspendCount += 1;
  }

  void resumeLock() {
    if (_suspendCount > 0) {
      _suspendCount -= 1;
    }
    _skipNextResumeLock = true;
  }
}
