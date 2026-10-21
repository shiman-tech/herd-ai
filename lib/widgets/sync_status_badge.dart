import 'package:flutter/material.dart';

import '../services/cloud_sync_service.dart';
import 'cloud_sync_sheet.dart';

class SyncStatusBadge extends StatelessWidget {
  const SyncStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CloudSyncService.instance,
      builder: (BuildContext context, _) {
        final CloudSyncService service = CloudSyncService.instance;
        final SyncStatus status = service.status;

        Widget icon;
        String tooltip;

        switch (status) {
          case SyncStatus.syncing:
            icon = const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D6A4F)),
              ),
            );
            tooltip = 'Syncing herd with cloud...';
            break;
          case SyncStatus.synced:
            icon = const Icon(
              Icons.cloud_done_rounded,
              color: Color(0xFF2D6A4F),
              size: 22,
            );
            tooltip = 'Herd backed up to cloud';
            break;
          case SyncStatus.offline:
            icon = const Icon(
              Icons.cloud_off_rounded,
              color: Color(0xFF8D6E63),
              size: 22,
            );
            tooltip = 'Offline (Saved locally)';
            break;
          case SyncStatus.error:
            icon = const Icon(
              Icons.sync_problem_rounded,
              color: Colors.amber,
              size: 22,
            );
            tooltip = 'Sync issue: ${service.lastError ?? "Tap to retry"}';
            break;
          case SyncStatus.unconfigured:
          case SyncStatus.idle:
            icon = const Icon(
              Icons.cloud_outlined,
              color: Color(0xFF2D6A4F),
              size: 22,
            );
            tooltip = 'Cloud Sync & Backup';
            break;
        }

        return IconButton(
          icon: icon,
          tooltip: tooltip,
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => const CloudSyncSheet(),
            );
          },
        );
      },
    );
  }
}
