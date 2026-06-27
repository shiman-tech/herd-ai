
#dataset 2 : frontol view ( 50 cows - around 2500 images - 50 images/cow)
'''
!git clone https://github.com/aideep1400/Cattely-Cattle-Face-Images-Dataset.git

!rm -rf /content/Cattely-Cattle-Face-Images-Dataset/.git
!rm -rf /content/Cattely-Cattle-Face-Images-Dataset/valid
!rm -rf /content/Cattely-Cattle-Face-Images-Dataset/README.md
!rm -rf /content/Cattely-Cattle-Face-Images-Dataset/README.roboflow.txt
!rm -rf /content/Cattely-Cattle-Face-Images-Dataset/data.yaml
'''


import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
from tensorflow.keras.preprocessing.image import ImageDataGenerator

import os
count=0

base_path = '/content/Cattely-Cattle-Face-Images-Dataset'

for item in os.listdir(base_path):
    print(item)
    count+=1

print(f"Dataset Size: {count}")

#!rm -rf /content/dataset_subset

import os
import shutil

source = "/content/Cattely-Cattle-Face-Images-Dataset"
target = "/content/dataset_subset"

os.makedirs(target, exist_ok=True)

selected_folders = os.listdir(source)

for folder in selected_folders:
    shutil.copytree(
        os.path.join(source, folder),
        os.path.join(target, folder)
    )

print("Subset created!")

datagen = ImageDataGenerator(
    rescale=1./255,
    validation_split=0.2,
    horizontal_flip=True,
    zoom_range=0.3,
    rotation_range=20,
    brightness_range=[0.8,1.2]
)
train_data = datagen.flow_from_directory(
    '/content/dataset_subset',
    target_size=(224,224),
    batch_size=16,
    class_mode='categorical',
    subset='training'
)

val_data = datagen.flow_from_directory(
    '/content/dataset_subset',
    target_size=(224,224),
    batch_size=16,
    class_mode='categorical',
    subset='validation'
)

base_model = tf.keras.applications.MobileNetV2(
    input_shape=(224,224,3),
    include_top=False,
    weights='imagenet'
)

for layer in base_model.layers[:-20]:
    layer.trainable = False

x = base_model.output
x = tf.keras.layers.GlobalAveragePooling2D()(x)
x = tf.keras.layers.Dense(128, activation='relu')(x)
x = tf.keras.layers.Dropout(0.5)(x)
output = tf.keras.layers.Dense(train_data.num_classes, activation='softmax')(x)

model = tf.keras.Model(inputs=base_model.input, outputs=output)

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

history = model.fit(
    train_data,
    validation_data=val_data,
    epochs=10
)

embedding_model = tf.keras.Model(
    inputs=model.input,
    outputs=model.layers[-2].output   # second last layer (Dense 128)
)

import numpy as np
from tensorflow.keras.preprocessing import image

def get_embedding(img_path):
    img = image.load_img(img_path, target_size=(224,224))
    img_array = image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)

    embedding = embedding_model.predict(img_array)[0]

    # 🔥 normalize
    embedding = embedding / np.linalg.norm(embedding)

    return embedding

database = {}
test_set = {}

base_path="/content/dataset_subset"

for cow in os.listdir(base_path):
    cow_path = os.path.join(base_path, cow)
    images = os.listdir(cow_path)

    split = int(0.7 * len(images))

    train_imgs = images[:split]
    test_imgs = images[split:]

    # build database (MULTI embeddings)
    embeddings = []
    for img in train_imgs:
        emb = get_embedding(os.path.join(cow_path, img))
        embeddings.append(emb)

    database[cow] = embeddings

    # store test images
    test_set[cow] = test_imgs

print("Database built!")

from numpy.linalg import norm

def cosine_distance(a, b):
    return 1 - np.dot(a, b) / (norm(a) * norm(b))

def predict_cow(img_path, threshold=0.12):
    query_emb = get_embedding(img_path)

    min_dist = float("inf")
    best_match = None

    for cow, emb_list in database.items():
        for emb in emb_list:

            dist = cosine_distance(query_emb, emb)

            if dist < min_dist:
                min_dist = dist
                best_match = cow

    if min_dist > threshold:
        return "Unknown", min_dist


    return best_match, min_dist

def register_cow(img_path, cow_id):
    emb = get_embedding(img_path)

    if cow_id not in database:
        database[cow_id] = []

    database[cow_id].append(emb)

    return database



test_img ="/content/akshay_image_2.jpeg"
fail_test='/content/akshay_image_1.jpeg'


# First prediction
pred, dist = predict_cow(fail_test)

print("First attempt:")
print("Predicted:", pred)
print("Distance:", dist)


# If unknown → register
if pred == "Unknown":
    print("\nRegistering new cow as: Akshay")


    register_cow(test_img, "Akshay")


# Second prediction (should now work)
pred, dist = predict_cow(test_img)

print("\nAfter registration:")
print("Predicted:", pred)
print("Distance:", dist)

import os

base_path = "/content/dataset_subset"

correct = 0
total = 0

for cow, imgs in test_set.items():
    for img in imgs:
        img_path = os.path.join(base_path, cow, img)

        pred, dist = predict_cow(img_path)

        print(f"Actual: {cow} | Predicted: {pred} | Distance: {round(dist,3)}")

        if pred == cow:
            correct += 1

        total += 1

print("\nReal Accuracy:", correct/total)

