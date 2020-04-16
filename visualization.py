# -*- coding: utf-8 -*-
"""
Created on Sat Jun 22 03:37:49 2019

@author: Ankit
"""

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
%matplotlib inline
import warnings
warnings.filterwarnings('ignore')

visitor = pd.read_csv("Visitors.csv")
plt.barh(visitor.Country, visitor.Visitors_millions, label="Number of Visitors")
plt.legend()
plt.xlabel('Visitors in Millions')
plt.show()





Created on Sat Jun 22 03:37:49 2019
"""
@author: Ankit
"""

import pandas as pd
import matplotlib.pyplot as plt
dat = pd.read_csv("dat.csv")
# Plot
plt.pie(dat.share, labels=dat.platform)
plt.axis('equal')
plt.show()








