import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:attendance/models/settings.dart';
import 'package:attendance/constants.dart';
import 'package:attendance/data/sqlite.dart';
import 'components/header.dart';

class AddSetting extends StatelessWidget {
  const AddSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddSettingData();
  }
}

class AddSettingData extends StatefulWidget {
  const AddSettingData({Key? key}) : super(key: key);

  @override
  State<AddSettingData> createState() => _AddSettingDataState();
}

class _AddSettingDataState extends State<AddSettingData> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _gcaController = TextEditingController();
  final TextEditingController _abController = TextEditingController();
  final TextEditingController _ttsController = TextEditingController(text: '0');
  final TextEditingController  _ttsimpleController = TextEditingController(text: '0');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _userController.dispose();
    _gcaController.dispose();
    _abController.dispose();
    _ttsController.dispose();
    _ttsimpleController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final settings = await DatabaseHelper().getSetting();
      if (settings != null && mounted) {
        setState(() {
          _gcaController.text = GCAs[settings.gcaID] ?? '';
          _abController.text = ABs[settings.abID] ?? '';
          _ttsController.text = settings.tts.toString();
          _ttsimpleController.text = settings.ttsimple.toString();
          _userController.text = settings.userName;
        });
      }
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to load settings: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int? _getKeyByValue(String value, Map<int, String> map) {
    for (final entry in map.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return null;
  }

  Future<void> _showSelectionDialog({
    required BuildContext context,
    required String title,
    required Map<int, String> options,
    required TextEditingController controller,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                onTap: () {
                  setState(() => controller.text = entry.value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_isLoading) return;

    final gcaText = _gcaController.text.trim();
    final abText = _abController.text.trim();
    final userText = _userController.text.trim();
    final ttsText = _ttsController.text.trim();
    final ttsimpleText = _ttsimpleController.text.trim();

    if (gcaText.isEmpty || abText.isEmpty || userText.isEmpty) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Incomplete Information',
        text: 'Please fill all required fields',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final gcaID = _getKeyByValue(gcaText, GCAs);
      final abID = _getKeyByValue(abText, ABs);
      final tts = int.tryParse(ttsText) ?? 0;
      final ttsimple = int.tryParse(ttsimpleText) ?? 0;

      if (gcaID == null || abID == null) {
        throw Exception('Invalid selection');
      }

      final setting = SettingsLoad(
        id: 1,
        abID: abID,
        gcaID: gcaID,
        userName: userText,
        tts: tts, ttsimple: ttsimple,
      );

      final success = await DatabaseHelper().setSettings(setting) > 0;

      if (mounted) {
        await QuickAlert.show(
          context: context,
          type: success ? QuickAlertType.success : QuickAlertType.error,
          title: success ? 'Success' : 'Error',
          text: success
              ? "Settings saved successfully!\nPlease restart the application."
              : "Failed to save settings",
        );
      }
    } catch (e) {
      if (mounted) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to save settings: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(title: 'Settings'),
            const SizedBox(height: defaultPadding),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              const Text(
                'Note: Restart the application after changing settings',
                style: TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: defaultPadding * 2),

              // User Name Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  border: OutlineInputBorder(),
                ),
                controller: _userController,
              ),
              const SizedBox(height: defaultPadding),

              // GCA Selection
              TextField(
                controller: _gcaController,
                decoration: const InputDecoration(
                  labelText: 'GCA',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                readOnly: true,
                onTap: () => _showSelectionDialog(
                  context: context,
                  title: 'Select GCA',
                  options: GCAs,
                  controller: _gcaController,
                ),
              ),
              const SizedBox(height: defaultPadding),

              // AB Selection
              TextField(
                controller: _abController,
                decoration: const InputDecoration(
                  labelText: 'AB',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                readOnly: true,
                onTap: () => _showSelectionDialog(
                  context: context,
                  title: 'Select AB',
                  options: ABs,
                  controller: _abController,
                ),
              ),
              const SizedBox(height: defaultPadding),

              // TTS Toggle
              Row(
                children: [
                  const Text('Enable Text-to-Speech:'),
                  const SizedBox(width: defaultPadding),
                  ToggleSwitch(
                    initialLabelIndex: int.tryParse(_ttsController.text) ?? 0,
                    onToggle: (index) {
                      setState(() => _ttsController.text = index?.toString() ?? '0');
                    },
                    customWidths: const [90.0, 90.0],
                    cornerRadius: 20.0,
                    activeBgColors: const [
                      [Colors.redAccent],
                      [Colors.cyan],
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['OFF', 'ON'],
                    icons: const [FontAwesomeIcons.xmark, FontAwesomeIcons.check],
                  ),
                  // const SizedBox(width: 12),

                ],
              ),
              const SizedBox(height: defaultPadding),
              Row(
                children: [
                  const Text('Enable Simple Text-to-Speech:'),
                  const SizedBox(width: defaultPadding),
                  ToggleSwitch(
                    initialLabelIndex: int.tryParse(_ttsimpleController.text) ?? 0,
                    onToggle: (index) {
                      setState(() => _ttsimpleController.text = index?.toString() ?? '0');
                    },
                    customWidths: const [90.0, 90.0],
                    cornerRadius: 20.0,
                    activeBgColors: const [
                      [Colors.redAccent],
                      [Colors.cyan],
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['OFF', 'ON'],
                    icons: const [FontAwesomeIcons.xmark, FontAwesomeIcons.check],
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding * 2),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SAVE SETTINGS'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}