Place the exported TensorFlow Lite embedding model here as:

`assets/models/cow_identifier.tflite`

The Flutter app expects a model with:
- Input shape: `[1, 224, 224, 3]`
- Output shape: `[1, 128]`

Use `export_embedding_tflite.py` to convert the Python-trained embedding model.
