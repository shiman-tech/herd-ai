import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../services/cloud_sync_service.dart';
import 'cloud_restore_sheet.dart';

class CloudSyncSheet extends StatefulWidget {
  const CloudSyncSheet({super.key});

  @override
  State<CloudSyncSheet> createState() => _CloudSyncSheetState();
}

class _CloudSyncSheetState extends State<CloudSyncSheet> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showLinkPhoneDialog() {
    _phoneController.text = CloudSyncService.instance.profile?.phoneNumber ?? '';

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Link Mobile Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Linking your 10-digit mobile number lets you restore your herd on a new phone with SMS verification.',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Phone Number',
                  hintText: 'e.g. +919876543210',
                  prefixIcon: Icon(Icons.phone_rounded),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final String phone = _phoneController.text.trim();
                if (phone.isNotEmpty) {
                  await CloudSyncService.instance.setPhoneNumber(phone);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Phone number linked: $phone')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF2D6A4F);
    const Color accentColor = Color(0xFF8D6E63);

    return ListenableBuilder(
      listenable: CloudSyncService.instance,
      builder: (BuildContext context, _) {
        final CloudSyncService service = CloudSyncService.instance;
        final farmId = service.profile?.farmId ?? 'HERD-PENDING';
        final phone = service.profile?.phoneNumber;
        final lastSync = service.profile?.lastSyncedAt;
        final isAutoSync = service.profile?.isAutoSyncEnabled ?? true;

        String statusLabel = 'Saved Locally';
        Color statusColor = accentColor;
        IconData statusIcon = Icons.save_alt_rounded;

        if (service.status == SyncStatus.syncing) {
          statusLabel = 'Syncing...';
          statusColor = primaryColor;
          statusIcon = Icons.sync_rounded;
        } else if (service.status == SyncStatus.synced) {
          statusLabel = 'Cloud Synced';
          statusColor = primaryColor;
          statusIcon = Icons.check_circle_rounded;
        } else if (service.status == SyncStatus.offline) {
          statusLabel = 'Offline';
          statusColor = accentColor;
          statusIcon = Icons.cloud_off_rounded;
        } else if (service.status == SyncStatus.error) {
          statusLabel = 'Sync Issue';
          statusColor = Colors.amber.shade800;
          statusIcon = Icons.warning_rounded;
        }

        final String formattedLastSync = lastSync != null
            ? DateFormat('dd MMM yyyy, hh:mm a').format(lastSync)
            : 'Never synced';

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
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
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title and status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Row(
                    children: <Widget>[
                      Icon(Icons.cloud_sync_rounded, color: primaryColor, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'Cloud Backup & Sync',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Farm Code Card
              Card(
                elevation: 0,
                color: const Color(0xFFF0EBD8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: Color(0xFFDFDAC8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'YOUR FARM CODE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                              color: accentColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: farmId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Farm Code copied to clipboard!')),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.copy_rounded, size: 15, color: primaryColor),
                                  SizedBox(width: 4),
                                  Text(
                                    'Copy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        farmId,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Keep this code written down. If you lose your phone or SIM card, you can restore your entire herd on any replacement phone using this Farm Code and your 4-digit PIN.',
                        style: TextStyle(fontSize: 12, height: 1.35, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Phone Linking Tile
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.phone_android_rounded, color: primaryColor, size: 20),
                ),
                title: const Text(
                  'Linked Mobile Number',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  phone != null && phone.isNotEmpty ? phone : 'No phone linked (Tap to link)',
                  style: TextStyle(
                    fontSize: 12,
                    color: phone != null && phone.isNotEmpty ? Colors.black87 : accentColor,
                  ),
                ),
                trailing: TextButton(
                  onPressed: _showLinkPhoneDialog,
                  child: Text(phone != null && phone.isNotEmpty ? 'Edit' : 'Link'),
                ),
              ),

              const Divider(height: 1),

              // Auto-Sync Switch Tile
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: primaryColor,
                title: const Text(
                  'Auto-Sync on Internet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Automatically sync herd data when Wi-Fi or mobile data is detected.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                value: isAutoSync,
                onChanged: (bool val) => service.toggleAutoSync(val),
              ),

              const Divider(height: 1),
              const SizedBox(height: 10),

              // Last Synced Info
              Row(
                children: <Widget>[
                  const Icon(Icons.history_rounded, size: 16, color: Colors.black54),
                  const SizedBox(width: 6),
                  Text(
                    'Last synced: $formattedLastSync',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Sync Now Button
              FilledButton.icon(
                onPressed: service.isSyncing
                    ? null
                    : () async {
                        final bool ok = await service.syncNow(force: true);
                        if (context.mounted) {
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All herd data synced to cloud!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  service.lastError ??
                                      'Offline - changes are saved safely on your device.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                icon: service.isSyncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.sync_rounded),
                label: Text(service.isSyncing ? 'Syncing Herd...' : 'Sync Now'),
              ),
              const SizedBox(height: 8),

              // Restore Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) => const CloudRestoreSheet(),
                  );
                },
                icon: const Icon(Icons.settings_backup_restore_rounded),
                label: const Text('Restore Herd from Cloud Backup'),
              ),
            ],
          ),
        );
      },
    );
  }
}
