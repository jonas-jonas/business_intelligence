# Second Level Analysis
from bokeh.plotting import figure, show, output_file
from bokeh.core.properties import value
from bokeh.io import export_png
import pandas as pd

data = pd.read_csv('data/top5_orgs_by_year_count.csv')

orgs = data['organization'].unique()
years = data['year'].unique()
colors = ['#D65DB1', '#FF6F91', '#FF9671', '#FFC75F', '#ec9c32']

data = data.pivot(
    index='year',
    columns='organization',
    values='count'
)
data = data.fillna(0)


p = figure(
    width=800,
    height=350,
    tools='hover',
    tooltips=[
        ("Jahr", "@year"),
        ("Organisation", "$name"),
        ("Anzahl Patente", "@$name")
    ],
    toolbar_location=None
)

source_data = {'year': years}
for k, v in data.items():
    source_data[str(k)] = [value for key, value in v.items()]

p.vbar_stack(
    orgs,
    x='year',
    width=.8,
    source=source_data,
    color=colors,
    legend=['NASA', 'Navy', 'Boeing', 'Lockheed Martin', value('Thales')]
)

p.xaxis.axis_label = 'Jahre'
p.yaxis.axis_label = 'Patente pro Jahr'

p.y_range.start = 0
p.x_range.start = 1975
p.x_range.end = 2019

p.legend.location = 'top_left'
p.title.text = 'Top 5 Patentanmelder pro Jahr'

output_file('generated/patents_orgs_by_year.html')
show(p)
export_png(p, filename='submission/images/top5_orgs.png')
