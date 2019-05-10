from bokeh.plotting import figure, show, ColumnDataSource, output_file
from bokeh.models import NumeralTickFormatter
from bokeh.core.properties import value
import pandas as pd

data = pd.read_csv("data/patents_by_country_year.csv")

countries = data['country'].unique()
years = data['year'].unique()

data = data.pivot(index="year", columns="country", values="count").fillna(0)

colors = ['#845EC2', '#D65DB1', '#FF6F91', '#FF9671', '#FFC75F', '#F9F871', '#0081CF', '#0089BA', '#008E9B', '#008F7A']

p = figure(
    sizing_mode="stretch_both",
    tools='hover',
    tooltips=[("Jahr", "@year"), ("Land", "$name"), ("Anzahl Patente", "@$name")],
    toolbar_location=None
)

source_data = {'year': years}
for k, v in data.items():
    source_data[str(k)] = [value for key, value in v.items()]

p.vbar_stack(
    countries,
    x="year",
    width=.9,
    source=source_data,
    color=colors,
    legend=[value(country) for country in countries]
)

p.xaxis.axis_label = "Jahre"

p.yaxis.axis_label = "Patente pro Jahr"
p.y_range.start = 0

p.legend.location='top_left'
p.title.text = "Patente pro Jahr pro Land"

output_file("generated/patents_countries_by_year.html")
show(p)
