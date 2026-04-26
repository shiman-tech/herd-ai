import 'package:flutter/material.dart';

import '../services/app_auth_service.dart';
import '../services/app_lock_controller.dart';

const Color kFarmPrimary = Color(0xFF2D6A4F);
const Color kFarmSecondary = Color(0xFF95A97F);
const Color kFarmBackground = Color(0xFFF4F1E6);
const Color kFarmAccent = Color(0xFF8D6E63);

class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.child});

  final Widget child;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

enum _AuthMode { loading, createPin, enterPin, unlocked }

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  final AppAuthService _authService = AppAuthService();

  _AuthMode _mode = _AuthMode.loading;
  String _message = 'Preparing secure access...';
  String _pinEntry = '';
  String _firstPin = '';
  bool _confirmingPin = false;
  bool _isAuthenticating = false;
  DateTime? _lastUnlockAt;
  DateTime? _lastBackgroundAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAuthFlow();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (_mode == _AuthMode.unlocked) {
        _lastBackgroundAt = DateTime.now();
      }
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (AppLockController.instance.consumeSkipNextResumeLock()) {
        _lastBackgroundAt = null;
        return;
      }
      if (AppLockController.instance.isLockSuspended) {
        _lastBackgroundAt = null;
        return;
      }
      if (_lastBackgroundAt != null) {
        final int gapMs = DateTime.now()
            .difference(_lastBackgroundAt!)
            .inMilliseconds;
        _lastBackgroundAt = null;
        if (gapMs < 2500) {
          // Ignore very short app switches (camera/gallery/native picker).
          return;
        }
      }
      _lockOnResume();
    }
  }

  Future<void> _initializeAuthFlow() async {
    final bool hasPin = await _authService.hasPin();
    if (!mounted) {
      return;
    }
    if (!hasPin) {
      setState(() {
        _mode = _AuthMode.createPin;
        _message = 'Create a 4-digit PIN';
      });
      return;
    }

    _isAuthenticating = true;
    final bool biometricsSuccess = await _authService.unlockFlow();
    _isAuthenticating = false;
    if (!mounted) {
      return;
    }
    if (biometricsSuccess) {
      setState(() {
        _mode = _AuthMode.unlocked;
        _lastUnlockAt = DateTime.now();
      });
      return;
    }

    setState(() {
      _mode = _AuthMode.enterPin;
      _message = 'Enter your PIN';
    });
  }

  Future<void> _lockOnResume() async {
    if (_isAuthenticating) {
      return;
    }
    if (_mode != _AuthMode.unlocked) {
      return;
    }
    final DateTime now = DateTime.now();
    if (_lastUnlockAt != null && now.difference(_lastUnlockAt!).inSeconds < 2) {
      return;
    }

    final bool hasPin = await _authService.hasPin();
    if (!mounted || !hasPin || _mode == _AuthMode.loading) {
      return;
    }

    setState(() {
      _mode = _AuthMode.loading;
      _message = 'Unlock your app';
      _pinEntry = '';
    });

    _isAuthenticating = true;
    final bool biometricsSuccess = await _authService.unlockFlow();
    _isAuthenticating = false;
    if (!mounted) {
      return;
    }
    if (biometricsSuccess) {
      setState(() {
        _mode = _AuthMode.unlocked;
        _lastUnlockAt = DateTime.now();
      });
      return;
    }
    setState(() {
      _mode = _AuthMode.enterPin;
      _message = 'Enter your PIN';
    });
  }

  void _showSnack(String text) {
    if (!mounted) {
      return;
    }
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onPinCompleted(String pin) async {
    if (_mode == _AuthMode.createPin) {
      if (!_confirmingPin) {
        setState(() {
          _firstPin = pin;
          _confirmingPin = true;
          _pinEntry = '';
          _message = 'Confirm your PIN';
        });
        return;
      }

      if (pin != _firstPin) {
        setState(() {
          _pinEntry = '';
          _firstPin = '';
          _confirmingPin = false;
          _message = 'PIN did not match. Try again';
        });
        _showSnack('PIN did not match');
        return;
      }

      await _authService.savePin(pin);
      if (!mounted) {
        return;
      }
      setState(() {
        _mode = _AuthMode.unlocked;
        _pinEntry = '';
        _lastUnlockAt = DateTime.now();
      });
      _showSnack('PIN created');
      return;
    }

    if (_mode == _AuthMode.enterPin) {
      final bool ok = await _authService.verifyPin(pin);
      if (!mounted) {
        return;
      }
      if (ok) {
        setState(() {
          _mode = _AuthMode.unlocked;
          _pinEntry = '';
          _lastUnlockAt = DateTime.now();
        });
        _showSnack('Unlocked');
      } else {
        setState(() {
          _pinEntry = '';
          _message = 'Wrong PIN. Try again';
        });
        _showSnack('Wrong PIN');
      }
    }
  }

  void _onKeyTap(String key) {
    if (_mode != _AuthMode.createPin && _mode != _AuthMode.enterPin) {
      return;
    }

    if (key == 'back') {
      if (_pinEntry.isEmpty) {
        return;
      }
      setState(() {
        _pinEntry = _pinEntry.substring(0, _pinEntry.length - 1);
      });
      return;
    }

    if (_pinEntry.length >= 4) {
      return;
    }
    setState(() {
      _pinEntry = '$_pinEntry$key';
    });
    if (_pinEntry.length == 4) {
      _onPinCompleted(_pinEntry);
    }
  }

  Future<void> _retryBiometric() async {
    if (_isAuthenticating) {
      return;
    }
    _isAuthenticating = true;
    final bool ok = await _authService.authenticateWithBiometrics();
    _isAuthenticating = false;
    if (!mounted) {
      return;
    }
    if (ok) {
      setState(() {
        _mode = _AuthMode.unlocked;
        _lastUnlockAt = DateTime.now();
      });
      _showSnack('Unlocked');
    } else {
      _showSnack('Use PIN to unlock');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_mode == _AuthMode.unlocked) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: kFarmBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Herd AI',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: kFarmPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your cattle notebook',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: kFarmAccent),
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _mode == _AuthMode.loading
                              ? 'Unlock your app'
                              : _message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: kFarmPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 14),
                        if (_mode == _AuthMode.loading) ...<Widget>[
                          const CircularProgressIndicator(),
                        ] else ...<Widget>[
                          _PinDots(count: _pinEntry.length),
                          const SizedBox(height: 16),
                          if (_mode == _AuthMode.enterPin) ...<Widget>[
                            OutlinedButton.icon(
                              onPressed: _retryBiometric,
                              icon: const Icon(Icons.fingerprint),
                              label: const Text('Try fingerprint/face'),
                            ),
                            const SizedBox(height: 8),
                          ],
                          _PinPad(onTap: _onKeyTap),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  const _PinDots({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(4, (int index) {
        final bool filled = index < count;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? kFarmPrimary : const Color(0xFFD7D2C4),
          ),
        );
      }),
    );
  }
}

class _PinPad extends StatelessWidget {
  const _PinPad({required this.onTap});

  final void Function(String key) onTap;

  @override
  Widget build(BuildContext context) {
    final List<String> keys = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'back',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.7,
      ),
      itemCount: keys.length,
      itemBuilder: (BuildContext context, int index) {
        final String key = keys[index];
        if (key.isEmpty) {
          return const SizedBox.shrink();
        }
        return FilledButton.tonal(
          onPressed: () => onTap(key),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFF3EDDE),
            foregroundColor: kFarmPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: key == 'back'
              ? const Icon(Icons.backspace_outlined, color: kFarmAccent)
              : Text(
                  key,
                  style: const TextStyle(
                    fontSize: 22,
                    color: kFarmPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        );
      },
    );
  }
}
