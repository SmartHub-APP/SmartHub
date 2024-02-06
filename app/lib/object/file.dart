class File {
  String fileName, fileHash;

  Map<String, String> toJson() => {
        "FileName": fileName,
        "FileHash": fileHash,
      };

  File({required this.fileName, required this.fileHash});
}
