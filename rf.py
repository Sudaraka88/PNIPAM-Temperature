from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier, AdaBoostClassifier, RandomForestRegressor, GradientBoostingRegressor, AdaBoostRegressor
from sklearn import svm
import pandas as pd
import numpy as np

def predictor(fname):
    tr = pd.read_csv(fname + '_tr' + '.csv')
    y = pd.read_csv(fname + '_tgt' + '.csv')
    y = np.ravel(y)
    X = pd.read_csv(fname + '_pr' + '.csv')

    clf = RandomForestClassifier(n_estimators=1500, min_samples_leaf=1, n_jobs=-1, random_state=None, max_features=None,
                                 max_leaf_nodes=None, bootstrap=True)
    clf.fit(tr, y)
    predictRF = clf.predict(X)

    clr = RandomForestRegressor(n_estimators=1500, min_samples_leaf=1, n_jobs=-1, random_state=None, max_features=None,
                                max_leaf_nodes=None, bootstrap=True)
    clr.fit(tr, y)
    regressRF = clr.predict(X)

    clf = GradientBoostingClassifier(n_estimators=1500, min_samples_leaf=1, random_state=None, max_features=None,
                                     max_leaf_nodes=None)
    clf.fit(tr, y)
    predictGB = clf.predict(X)
    
    clr = GradientBoostingRegressor(n_estimators=1500, min_samples_leaf=1, random_state=None, max_features=None,
                                    max_leaf_nodes=None)
    clr.fit(tr, y)
    regressGB = clr.predict(X)

    clf = AdaBoostClassifier(n_estimators=1500, random_state=None)
    clf.fit(tr, y)
    predictAB = clf.predict(X)

    clr = AdaBoostRegressor(n_estimators=1500, random_state=None)
    clr.fit(tr, y)
    regressAB = clr.predict(X)

    # clf = svm.NuSVC(gamma='auto', kernel='rbf', degree=5, decision_function_shape='ovr')
    # clf.fit(tr, y)
    # predictSV = clf.predict(X)

    X['T_RF'] = predictRF
    X['R_RF'] = regressRF
    X['T_GB'] = predictGB
    X['R_GB'] = regressGB
    X['T_AB'] = predictAB
    X['R_AB'] = regressAB

    X.to_csv(fname + '_PRED.csv', index=False)


predictor('CSV/1')
predictor('CSV/2')
predictor('CSV/3')
predictor('CSV/4')
predictor('CSV/6')