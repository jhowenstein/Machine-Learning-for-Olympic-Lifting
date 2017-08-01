import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.svm import LinearSVC
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier

data = np.loadtxt('acceleration_data.csv', delimiter=',')
targets = np.loadtxt('target_data.csv', delimiter=',')

avg = np.mean(data, axis=0)

stdev = np.std(data, axis=0)

data_scaled = np.subtract(data, avg)

data_scaled = np.divide(data_scaled, stdev)

#X_train, X_test, y_train, y_test = train_test_split(data_scaled, targets, random_state=0)
X_train, X_test, y_train, y_test = train_test_split(data, targets, random_state=0)

lift_SVC = LinearSVC().fit(X_train,y_train)
print("SVM")
print("Test set preditions: {}".format(lift_SVC.predict(X_test)))
print("Test set lift types: {}".format(y_test))
print("Test set accuracy: {:.2f}".format(lift_SVC.score(X_test, y_test)))

lift_LR = LogisticRegression().fit(X_train,y_train)
print("Log Regression")
print("Test set preditions: {}".format(lift_LR.predict(X_test)))
print("Test set lift types: {}".format(y_test))
print("Test set accuracy: {:.2f}".format(lift_LR.score(X_test, y_test)))

lift_DT = DecisionTreeClassifier(random_state=0).fit(X_train, y_train)
print("Decision Tree")
print("Test set preditions: {}".format(lift_DT.predict(X_test)))
print("Test set lift types: {}".format(y_test))
print("Test set accuracy: {:.2f}".format(lift_DT.score(X_test, y_test)))