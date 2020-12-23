from preprocess import getImages, getLabels
from sklearn.model_selection import train_test_split
from model import defineModel




images = getImages()
labels = getLabels() 

X_train, X_test, y_train, y_test = train_test_split(images, labels, test_size=0.33, random_state=42)

model = defineModel()

history = model.fit(X_train, y_train, epochs=5, batch_size=32, validation_data=(X_test, y_test), verbose=1)

