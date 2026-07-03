import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/file_service.dart';
import '../../../../di/injection.dart';
import '../bloc/ebook_bloc.dart';

class UploadEbookPage extends StatefulWidget {
  const UploadEbookPage({super.key});

  static const int maxFileSizeBytes = 20 * 1024 * 1024;

  @override
  State<UploadEbookPage> createState() => _UploadEbookPageState();
}

class _UploadEbookPageState extends State<UploadEbookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  PickedEbookFile? _file;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EbookBloc>(),
      child: BlocConsumer<EbookBloc, EbookState>(
        listenWhen: (previous, current) => previous.mutationStatus != current.mutationStatus,
        listener: (context, state) {
          if (state.mutationStatus == EbookMutationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ebook uploaded successfully')));
            context.pop();
          }
        },
        builder: (context, state) {
          final uploading = state.mutationStatus == EbookMutationStatus.uploading;
          final fileTooLarge = _file != null && _file!.size > UploadEbookPage.maxFileSizeBytes;

          return Scaffold(
            appBar: AppBar(
              title: Text('Upload Ebook', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 820;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          Flex(
                            direction: isWide ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isWide)
                                Expanded(
                                  flex: 4,
                                  child: _FilePickerPanel(file: _file, uploading: uploading, onPick: _pickFile, fileTooLarge: fileTooLarge),
                                )
                              else
                                _FilePickerPanel(file: _file, uploading: uploading, onPick: _pickFile, fileTooLarge: fileTooLarge),
                              if (isWide) const SizedBox(width: 24) else const SizedBox(height: 24),
                              if (isWide)
                                Expanded(
                                  flex: 5,
                                  child: _UploadFields(
                                    uploading: uploading,
                                    fileTooLarge: fileTooLarge,
                                    titleController: _titleController,
                                    authorController: _authorController,
                                    state: state,
                                    onSubmit: () => _submit(context),
                                  ),
                                )
                              else
                                _UploadFields(
                                  uploading: uploading,
                                  fileTooLarge: fileTooLarge,
                                  titleController: _titleController,
                                  authorController: _authorController,
                                  state: state,
                                  onSubmit: () => _submit(context),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickFile() async {
    final file = await sl<FileService>().pickPdf();
    if (file == null) return;
    setState(() {
      _file = file;
      if (_titleController.text.trim().isEmpty) {
        _titleController.text = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
      }
    });
  }

  void _submit(BuildContext context) {
    final file = _file;
    if (!_formKey.currentState!.validate() || file == null) {
      setState(() {});
      return;
    }
    if (file.size > UploadEbookPage.maxFileSizeBytes) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose a PDF smaller than 20 MB.')));
      return;
    }
    context.read<EbookBloc>().add(EbookUploadRequested(title: _titleController.text.trim(), author: _authorController.text.trim(), filePath: file.path, filename: file.name, fileSize: file.size));
  }
}

class _FilePickerPanel extends StatelessWidget {
  const _FilePickerPanel({required this.file, required this.uploading, required this.onPick, required this.fileTooLarge});

  final PickedEbookFile? file;
  final bool uploading;
  final VoidCallback onPick;
  final bool fileTooLarge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Ebook file', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: uploading ? null : onPick, icon: const FaIcon(FontAwesomeIcons.filePdf), label: Text(file?.name ?? 'Select PDF')),
          const SizedBox(height: 12),
          Text(file == null ? 'Select a PDF to upload your first book.' : 'File selected: ${file!.name}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          if (fileTooLarge) ...[const SizedBox(height: 12), Text('Please choose a PDF smaller than 20 MB.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error))],
        ],
      ),
    );
  }
}

class _UploadFields extends StatelessWidget {
  const _UploadFields({required this.uploading, required this.fileTooLarge, required this.titleController, required this.authorController, required this.state, required this.onSubmit});

  final bool uploading;
  final bool fileTooLarge;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final EbookState state;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: titleController,
          enabled: !uploading,
          decoration: const InputDecoration(labelText: 'Title', prefixIcon: FaIcon(FontAwesomeIcons.heading)),
          validator: (value) => value == null || value.trim().isEmpty ? 'Enter a title' : null,
        ),
        const SizedBox(height: 18),
        TextFormField(
          controller: authorController,
          enabled: !uploading,
          decoration: const InputDecoration(labelText: 'Author', prefixIcon: FaIcon(FontAwesomeIcons.user)),
          validator: (value) => value == null || value.trim().isEmpty ? 'Enter an author' : null,
        ),
        const SizedBox(height: 24),
        if (uploading) ...[LinearProgressIndicator(value: state.uploadProgress), const SizedBox(height: 12), Text('${(state.uploadProgress * 100).round()}% uploaded'), const SizedBox(height: 24)],
        FilledButton.icon(
          onPressed: uploading || fileTooLarge ? null : onSubmit,
          icon: uploading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          label: const Text('Upload'),
        ),
        if (state.mutationStatus == EbookMutationStatus.failure && state.errorMessage != null) ...[
          const SizedBox(height: 14),
          Text(state.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
      ],
    );
  }
}
