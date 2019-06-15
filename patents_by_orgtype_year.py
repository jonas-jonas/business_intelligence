# Second Level Analysis
from bokeh.plotting import figure, show
from bokeh.core.properties import value
from bokeh.io import export_png
import pandas as pd
from bokeh.palettes import Category20c

data = pd.read_csv('data/patents_by_year_and_org.csv')

orgs = data['organization'].unique()
years = data['year'].unique()

data = data.pivot(
    index='year',
    columns='organization',
    values='count'
)
data = data.fillna(0)

p = figure(
    width=800,
    height=470,
    # sizing_mode="stretch_both",
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
    color=Category20c[10],
    legend=[value(org) for org in orgs]
)

p.xaxis.axis_label = 'Jahre'
p.yaxis.axis_label = 'Patente pro Jahr'

p.y_range.start = 0
p.x_range.start = 1975
p.x_range.end = 2019

p.legend.location = 'top_left'
p.title.text = 'Top 5 Patentanmelder pro Jahr'

show(p)
export_png(p, filename='submission/images/top5_orgs.png')
