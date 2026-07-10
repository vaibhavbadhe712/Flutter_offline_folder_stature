import 'package:enterprise_app/features/widgets/ai_agent_shared.dart';
import 'package:flutter/material.dart';
import '../../core/utils/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';

class AiAgentSettingsScreen extends StatefulWidget {
  const AiAgentSettingsScreen({super.key});

  @override
  State<AiAgentSettingsScreen> createState() => _AiAgentSettingsScreenState();
}

class _AiAgentSettingsScreenState extends State<AiAgentSettingsScreen> {
  ArchMode _archMode = ArchMode.default_;
  String _llmProvider = 'OpenAI';
  String _speechToText = 'Deepgram';
  String _textToSpeech = 'ElevenLabs';

  final _llmOptions = ['OpenAI', 'Anthropic', 'Google Gemini', 'Mistral'];
  final _sttOptions = ['Deepgram', 'AssemblyAI', 'Whisper', 'Google STT'];
  final _ttsOptions = ['ElevenLabs', 'PlayHT', 'Google TTS', 'Azure TTS'];


  KnowledgeMode _knowledgeMode = KnowledgeMode.uploadFile;
  final List<String> _uploadedFiles = ['refund_policy.txt'];
  final _knowledgeTextController = TextEditingController();

  final Set<String> _selectedIntents = {'Book Appointment', 'Collect Leads'};

  final List<String> _positiveKeywords = ['thank you'];
  final List<String> _neutralKeywords = ['okay', 'maybe later'];
  final List<String> _negativeKeywords = ['cancel', 'not interested'];

  @override
  void dispose() {
    _knowledgeTextController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _uploadedFiles.add(result.files.single.name);
      });
    }
  }

  void _toggleIntent(String label) {
    setState(() {
      if (_selectedIntents.contains(label)) {
        _selectedIntents.remove(label);
      } else {
        _selectedIntents.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.darkText, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'AI Agent Settings',
          style: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              icon: Icons.memory,
              title: 'Model Architecture',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedToggle(
                    options: const ['Default', 'Custom'],
                    selectedIndex: _archMode == ArchMode.default_ ? 0 : 1,
                    onChanged: (i) =>
                        setState(() => _archMode = i == 0 ? ArchMode.default_ : ArchMode.custom),
                  ),
                  const SizedBox(height: 14),
                  if (_archMode == ArchMode.default_)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: AppColors.greyText, height: 1.5),
                          children: [
                            TextSpan(text: "Using BAAP AI's recommended stack: "),
                            TextSpan(
                              text: 'GPT-4o',
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkText),
                            ),
                            TextSpan(text: ' \u00b7 '),
                            TextSpan(
                              text: 'Deepgram Nova',
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkText),
                            ),
                            TextSpan(text: ' \u00b7 '),
                            TextSpan(
                              text: 'ElevenLabs Turbo',
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkText),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        DropdownField(
                          label: 'LLM PROVIDER',
                          value: _llmProvider,
                          items: _llmOptions,
                          onChanged: (v) => setState(() => _llmProvider = v!),
                        ),
                        const SizedBox(height: 14),
                        DropdownField(
                          label: 'SPEECH-TO-TEXT',
                          value: _speechToText,
                          items: _sttOptions,
                          onChanged: (v) => setState(() => _speechToText = v!),
                        ),
                        const SizedBox(height: 14),
                        DropdownField(
                          label: 'TEXT-TO-SPEECH',
                          value: _textToSpeech,
                          items: _ttsOptions,
                          onChanged: (v) => setState(() => _textToSpeech = v!),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              icon: Icons.storage,
              title: 'Knowledge Base',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SegmentedToggle(
                    options: const ['Upload File', 'Type Text'],
                    selectedIndex: _knowledgeMode == KnowledgeMode.uploadFile ? 0 : 1,
                    onChanged: (i) => setState(() =>
                        _knowledgeMode = i == 0 ? KnowledgeMode.uploadFile : KnowledgeMode.typeText),
                  ),
                  const SizedBox(height: 14),
                  if (_knowledgeMode == KnowledgeMode.uploadFile) ...[
                    GestureDetector(
                      onTap: _pickFile,
                      child: DottedUploadBox(onTap: _pickFile),
                    ),
                    for (final f in _uploadedFiles)
                      UploadedFileRow(
                        fileName: f,
                        onDelete: () => setState(() => _uploadedFiles.remove(f)),
                      ),
                  ] else
                    TextField(
                      controller: _knowledgeTextController,
                      maxLines: 6,
                      style: const TextStyle(fontSize: 14, color: AppColors.darkText),
                      decoration: InputDecoration(
                        hintText: 'Paste FAQs, policies, or product info...',
                        hintStyle: const TextStyle(color: AppColors.iconGrey, fontSize: 14),
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGreyColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.lightGreyColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryBlue),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              icon: Icons.bolt,
              title: 'Intent Actions',
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  IntentActionCard(
                    icon: Icons.calendar_today_outlined,
                    label: 'Book Appointment',
                    selected: _selectedIntents.contains('Book Appointment'),
                    onTap: () => _toggleIntent('Book Appointment'),
                  ),
                  IntentActionCard(
                    icon: Icons.people_outline,
                    label: 'Collect Leads',
                    selected: _selectedIntents.contains('Collect Leads'),
                    onTap: () => _toggleIntent('Collect Leads'),
                  ),
                  IntentActionCard(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Generate Ticket',
                    selected: _selectedIntents.contains('Generate Ticket'),
                    onTap: () => _toggleIntent('Generate Ticket'),
                  ),
                  IntentActionCard(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Place Order',
                    selected: _selectedIntents.contains('Place Order'),
                    onTap: () => _toggleIntent('Place Order'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              icon: Icons.sentiment_satisfied_alt,
              title: 'Sentiment Parameters',
              child: Column(
                children: [
                  SentimentGroup(
                    label: 'Positive',
                    icon: Icons.sentiment_satisfied,
                    color: AppColors.emeraldGreen,
                    bgColor: AppColors.mintGreen,
                    keywords: _positiveKeywords,
                    onAdd: (k) => setState(() => _positiveKeywords.add(k)),
                    onRemove: (k) => setState(() => _positiveKeywords.remove(k)),
                  ),
                  const SizedBox(height: 12),
                  SentimentGroup(
                    label: 'Neutral',
                    icon: Icons.sentiment_neutral,
                    color: AppColors.noticeYellowText,
                    bgColor: AppColors.noticeYellowBg,
                    keywords: _neutralKeywords,
                    onAdd: (k) => setState(() => _neutralKeywords.add(k)),
                    onRemove: (k) => setState(() => _neutralKeywords.remove(k)),
                  ),
                  const SizedBox(height: 12),
                  SentimentGroup(
                    label: 'Negative',
                    icon: Icons.sentiment_dissatisfied,
                    color: AppColors.errorRed,
                    bgColor: AppColors.errorRed.withValues(alpha: 0.1),
                    keywords: _negativeKeywords,
                    onAdd: (k) => setState(() => _negativeKeywords.add(k)),
                    onRemove: (k) => setState(() => _negativeKeywords.remove(k)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class DottedUploadBox extends StatelessWidget {
  final VoidCallback onTap;
  const DottedUploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          alignment: Alignment.center,
          child: Column(
            children: const [
              Icon(Icons.file_upload_outlined, color: AppColors.primaryBlue, size: 28),
              SizedBox(height: 10),
              Text(
                'Tap to upload PDF / Text',
                style: TextStyle(fontSize: 14, color: AppColors.greyText, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGreyColor
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(14),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}