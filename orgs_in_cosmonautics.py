from bokeh.plotting import figure, show, ColumnDataSource, output_file
from bokeh.io import export_svgs
from bokeh.models import NumeralTickFormatter, LabelSet

import pandas as pd

data = pd.read_csv("data/orgs_in_cosmonautics.csv")
data = data.sort_values(by=['patents'], ascending=False)[:10][::-1]

p = figure(width=1500, height=800, y_range=data["organization"], toolbar_location=None, tools="")
p.xaxis.formatter=NumeralTickFormatter(format="0,0")

labels = LabelSet(x='patents', y='organization', text='patents', level='glyph',
        y_offset=-9, x_offset=-100, source=ColumnDataSource(data), render_mode='canvas')

p.hbar(source=data, y="organization", right="patents", height=.8)

p.xaxis.axis_label="Number of patents"
p.yaxis.axis_label="Organization"

output_file("test.html")
show(p)