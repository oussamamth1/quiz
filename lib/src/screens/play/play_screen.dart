import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.join_quiz),
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.numbers),
                ),
                Tab(
                  icon: Icon(Icons.qr_code),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppConstant.kPadding),
                child: TabBarView(
                  children: [
                    //! Tab 1
                    InputCodeScreen(),

                    //! Tab 2
                    QrCodeScanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({
    super.key,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  QRViewController? _controller;
  final qrkey = GlobalKey(debugLabel: 'qr');

  void _onQrViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        context.read<LobbyCubit>().enterRoom(context, scanData.code!);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.qr_code_title,
                style: AppConstant.textTitle700,
              ),
              Text(
                l10n.qr_code_subtitle,
                style: AppConstant.textSubtitle,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: QRView(
            key: qrkey,
            onQRViewCreated: _onQrViewCreated,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}

class InputCodeScreen extends HookWidget {
  const InputCodeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController();
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Pinput(
            controller: pinController,
            length: 6,
          ),
        ),
        const Spacer(),
        CustomButton(
          onPressed: () {
            context.read<LobbyCubit>().enterRoom(context, pinController.text);
          },
          label: l10n.join_button,
        ),
        const Spacer(),
      ],
    );
  }
}
