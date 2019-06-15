from sklearn.cluster import KMeans
from nltk.corpus import stopwords
from bokeh.plotting import figure, show
from bokeh.io import export_png
import numpy as np
import pandas as pd

data = pd.read_csv('data/patent_groups.csv')

patents = data['patent_id']
stop = set(stopwords.words('english'))

orgs = list(data['organization'].unique())

words = set(np.array([y.lower() for x in data['title'] for y in x.split(' ')
                      if y not in stop]).flatten())

word_data = pd.DataFrame(index=patents, columns=words, data=0)

for row in data.itertuples():
    patent_id = row.patent_id
    title = row.title.split(' ')
    for word in title:
        lower = word.lower()
        if lower not in stop:
            word_data.at[patent_id, lower] += 1

clusters = 10

cluster = KMeans(n_clusters=clusters)
cluster.fit(word_data)

data['cluster'] = cluster.labels_

data = data.groupby(['organization', 'cluster']).count().reset_index()

data['size'] = (data['title'] / data['title'].max()) * 30

p = figure(
    width=500,
    height=500,
    # sizing_mode="stretch_both",
    x_range=orgs,
    tooltips=[
        ("Unternehmen", "@organization"),
        ("Cluster", "@cluster"),
        ("Anzahl", "@title")
    ],
    tools=['hover'],
    title='Clustering basierend auf Patenttiteln',
    x_axis_label='Organisation',
    y_axis_label='Cluster'
)

p.square(
    'organization',
    'cluster',
    source=data,
    size="size",
    color="#00204e",
)

p.xaxis.major_label_orientation = 1.57079632679
p.toolbar_location = None

show(p)
export_png(p, filename='submission/images/patent_clusters.png')
