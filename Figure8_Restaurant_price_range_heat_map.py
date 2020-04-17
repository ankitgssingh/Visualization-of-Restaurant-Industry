# -*- coding: utf-8 -*-
"""
Created on Sun Jun 23 21:44:23 2019

@author: Ankit
"""

# library & dataset
import pandas as pd
import seaborn as sns
df = pd.read_csv("Restaurant.csv")

df = df[df.Rating >= 3.5]  #Filtering only high rated restaurants > 3.5
df.Rating 
df.columns =df.columns.str.lower()   #converting all the columns names to lower cases
df.columns =df.columns.str.strip()   #removing any gap between column names
df.columns =df.columns.str.replace(' ', '_') #removing spaces
df.columns
df["price"]

#plotting heat map
sns.heatmap(data=pd.DataFrame(df["price"].value_counts()), xticklabels='auto' )