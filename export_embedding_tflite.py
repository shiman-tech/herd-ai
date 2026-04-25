"""
Export the embedding branch of the Keras model in `identification_model.py`
to TensorFlow Lite for mobile inference.

Expected workflow:
1. Train the classifier in Python with TensorFlow/Keras.
2. Rebuild an embedding model whose output is the 128-dim penultimate layer.
3. Convert that embedding model to `.tflite`.
4. Copy the result to `assets/models/cow_identifier.tflite`.
"""

from pathlib import Path

import tensorflow as tf


def export_embedding_model(
    keras_model_path: str = "artifacts/cow_identifier.keras",
    output_path: str = "assets/models/cow_identifier.tflite",
) -> Path:
    keras_path = Path(keras_model_path)
    if not keras_path.exists():
        raise FileNotFoundError(
            f"Missing trained Keras model at {keras_path}. "
            "Save your trained model before running this exporter."
        )

    model = tf.keras.models.load_model(keras_path)
    embedding_model = tf.keras.Model(
        inputs=model.input,
        outputs=model.layers[-2].output,
        name="cow_embedding_model",
    )

    converter = tf.lite.TFLiteConverter.from_keras_model(embedding_model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()

    output_file = Path(output_path)
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_bytes(tflite_model)
    return output_file


if __name__ == "__main__":
    exported = export_embedding_model()
    print(f"Exported TFLite model to: {exported}")
