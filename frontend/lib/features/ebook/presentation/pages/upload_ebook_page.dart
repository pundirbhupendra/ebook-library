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
        listenWhen: (previous, current) =>
            previous.mutationStatus != current.mutationStatus,
        listener: (context, state) {
          if (state.mutationStatus == EbookMutationStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ebook uploaded successfully')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          final uploading =
              state.mutationStatus == EbookMutationStatus.uploading;
          final fileTooLarge =
              _file != null && _file!.size > UploadEbookPage.maxFileSizeBytes;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Upload Ebook',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  OutlinedButton.icon(
                    onPressed: uploading ? null : _pickFile,
                    icon: const FaIcon(FontAwesomeIcons.filePdf),
                    label: Text(_file?.name ?? 'Select PDF'),
                  ),
                  if (_file == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A PDF file is required.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (fileTooLarge)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please choose a PDF smaller than 20 MB.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    enabled: !uploading,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      prefixIcon: FaIcon(FontAwesomeIcons.heading),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a title'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _authorController,
                    enabled: !uploading,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      prefixIcon: FaIcon(FontAwesomeIcons.user),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter an author'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  if (uploading) ...[
                    LinearProgressIndicator(value: state.uploadProgress),
                    const SizedBox(height: 12),
                    Text('${(state.uploadProgress * 100).round()}% uploaded'),
                    const SizedBox(height: 24),
                  ],
                  FilledButton.icon(
                    onPressed: uploading || fileTooLarge
                        ? null
                        : () => _submit(context),
                    icon: uploading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const FaIcon(FontAwesomeIcons.cloudArrowUp),
                    label: const Text('Upload'),
                  ),
                  if (state.mutationStatus == EbookMutationStatus.failure &&
                      state.errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
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
        _titleController.text = file.name.replaceAll(
          RegExp(r'\.pdf$', caseSensitive: false),
          '',
        );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a PDF smaller than 20 MB.'),
        ),
      );
      return;
    }
    context.read<EbookBloc>().add(
      EbookUploadRequested(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        filePath: file.path,
        filename: file.name,
        fileSize: file.size,
      ),
    );
  }
}
