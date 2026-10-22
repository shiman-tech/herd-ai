import 'package:flutter/material.dart';

import '../services/cloud_sync_service.dart';
import '../services/supabase_sync_backend.dart';

class CloudRestoreSheet extends StatefulWidget {
  const CloudRestoreSheet({super.key, this.onRestored});

  final VoidCallback? onRestored;

  @override
  State<CloudRestoreSheet> createState() => _CloudRestoreSheetState();
}

class _CloudRestoreSheetState extends State<CloudRestoreSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _farmIdController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();

  bool _isRestoring = false;
  String? _errorMessage;

  String? _verificationId;
  bool _otpSent = false;
  bool _isSendingOtp = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _farmIdController.dispose();
    _pinController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _newPinController.dispose();
    super.dispose();
  }

  Future<void> _restoreWithFarmCode() async {
    final String farmId = _farmIdController.text.trim();
    final String pin = _pinController.text.trim();

    if (farmId.isEmpty) {
      setState(() => _errorMessage = 'Please enter your Farm Code.');
      return;
    }
    if (pin.length != 4) {
      setState(() => _errorMessage = 'PIN must be exactly 4 digits.');
      return;
    }

    setState(() {
      _isRestoring = true;
      _errorMessage = null;
    });

    final bool ok = await CloudSyncService.instance.restoreWithFarmCodeAndPin(
      farmId: farmId,
      pin: pin,
    );

    if (!mounted) return;

    setState(() => _isRestoring = false);

    if (ok) {
      Navigator.of(context).pop();
      widget.onRestored?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm herd restored successfully from cloud!')),
      );
    } else {
      setState(() {
        _errorMessage = CloudSyncService.instance.lastError ??
            'Could not restore farm. Please check your Farm Code and PIN.';
      });
    }
  }

  Future<void> _sendOtp() async {
    final String phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      setState(() => _errorMessage = 'Please enter a valid phone number with country code (e.g. +91...)');
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = null;
    });

    await SupabaseSyncBackend.instance.sendPhoneOtp(
      phoneNumber: phone,
      onCodeSent: (String vId) {
        if (!mounted) return;
        setState(() {
          _verificationId = vId;
          _otpSent = true;
          _isSendingOtp = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent to your phone!')),
        );
      },
      onError: (String err) {
        if (!mounted) return;
        setState(() {
          _isSendingOtp = false;
          _errorMessage = err;
        });
      },
    );
  }

  Future<void> _verifyOtpAndRestore() async {
    final String phone = _phoneController.text.trim();
    final String otp = _otpController.text.trim();
    final String localPin = _newPinController.text.trim();

    if (_verificationId == null || otp.length < 6) {
      setState(() => _errorMessage = 'Please enter the 6-digit SMS verification code.');
      return;
    }
    if (localPin.length != 4) {
      setState(() => _errorMessage = 'Please choose a 4-digit PIN for this device.');
      return;
    }

    setState(() {
      _isRestoring = true;
      _errorMessage = null;
    });

    final bool ok = await CloudSyncService.instance.restoreWithPhoneOtp(
      phoneNumber: phone,
      verificationId: _verificationId!,
      smsCode: otp,
      localPin: localPin,
    );

    if (!mounted) return;

    setState(() => _isRestoring = false);

    if (ok) {
      Navigator.of(context).pop();
      widget.onRestored?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm herd restored successfully via Phone verification!')),
      );
    } else {
      setState(() {
        _errorMessage = SupabaseSyncBackend.instance.lastVerifyError ??
            CloudSyncService.instance.lastError ??
            'Could not restore farm. Please check the code and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2D6A4F);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFAF4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Text(
            'Restore Herd on this Device',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Retrieve your cattle, milk yields, facial embeddings, and photos from cloud backup.',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 14),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.black54,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            tabs: const <Widget>[
              Tab(icon: Icon(Icons.pin_rounded, size: 20), text: 'Farm Code & PIN'),
              Tab(icon: Icon(Icons.phone_iphone_rounded, size: 20), text: 'Phone OTP'),
            ],
          ),
          const SizedBox(height: 16),

          if (_errorMessage != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Tab content
          Flexible(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 330,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    // Tab 1: Farm Code & PIN
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Ideal if your phone was lost and you do not have your SIM active yet.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _farmIdController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Farm Code',
                            hintText: 'e.g. HERD-482910',
                            prefixIcon: Icon(Icons.badge_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: '4-Digit PIN',
                            hintText: 'Enter your existing PIN',
                            prefixIcon: Icon(Icons.lock_rounded),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: _isRestoring ? null : _restoreWithFarmCode,
                          icon: _isRestoring
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.cloud_download_rounded),
                          label: Text(_isRestoring ? 'Restoring Herd...' : 'Restore using Farm Code'),
                        ),
                      ],
                    ),

                    // Tab 2: Phone OTP
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Restore using the phone number linked to your farm profile.',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                enabled: !_otpSent,
                                decoration: const InputDecoration(
                                  labelText: 'Mobile Number',
                                  hintText: '+91...',
                                  prefixIcon: Icon(Icons.phone_rounded),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: _isSendingOtp ? null : _sendOtp,
                              child: Text(_isSendingOtp
                                  ? 'Sending...'
                                  : (_otpSent ? 'Resend' : 'Send OTP')),
                            ),
                          ],
                        ),
                        if (_otpSent) ...<Widget>[
                          const SizedBox(height: 10),
                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              labelText: '6-Digit SMS Code',
                              prefixIcon: Icon(Icons.sms_rounded),
                            ),
                          ),
                          TextField(
                            controller: _newPinController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Set 4-Digit App PIN for this device',
                              prefixIcon: Icon(Icons.lock_rounded),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FilledButton.icon(
                            onPressed: _isRestoring ? null : _verifyOtpAndRestore,
                            icon: _isRestoring
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.cloud_download_rounded),
                            label: Text(_isRestoring ? 'Verifying & Restoring...' : 'Verify OTP & Restore'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
