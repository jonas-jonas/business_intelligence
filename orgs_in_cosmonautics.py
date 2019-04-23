from bokeh.plotting import figure, show, ColumnDataSource
from bokeh.io import export_svgs
from bokeh.models import NumeralTickFormatter, LabelSet


import pandas as pd

data = pd.read_csv("data/orgs_in_cosmonautics.csv")
data = data.sort_values(by=['num_patents'], ascending=False)[:10][::-1]
print(data)
p = figure(width=1500, height=800, output_backend="svg", y_range=data["organization"], toolbar_location=None, tools="")
p.xaxis.formatter=NumeralTickFormatter(format="0,0")

labels = LabelSet(x='num_patents', y='organization', text='num_patents', level='glyph',
        y_offset=-9, x_offset=-100, source=ColumnDataSource(data), render_mode='canvas')

p.hbar(source=data, y="organization", right="num_patents", height=.8)

p.add_layout(labels)
#export_svgs(p, filename=__file__+'.svg')
show(p)