import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';

Future<MultipartFile?> uploadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: [],
  );

  if (result != null && result.files.single.bytes != null) {
    return MultipartFile.fromBytes(
      result.files.single.name,
      result.files.single.bytes ?? [],
      filename: result.files.single.name,
    );
  } else {
    return null;
  }
}