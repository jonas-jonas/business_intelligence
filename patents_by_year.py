# 1st Level Analysis
from bokeh.plotting import figure, show
from bokeh.io import export_png
import pandas as pd

patents = pd.read_csv('data/patents_by_year.csv')

p = figure(
    width=800,
    height=350,
    title='Patente pro Jahr',
    x_axis_label='Jahre',
    y_axis_label='Anzahl Patente'
)

p.vbar(
    x='year',
    width=0.8,
    top='count',
    source=patents,
    color='#D65DB1',
)

p.toolbar_location = None

p.y_range.start = 0
p.x_range.start = 1975
p.x_range.end = 2019

show(p)
export_png(p, filename='submission/images/patents_by_year.png')
