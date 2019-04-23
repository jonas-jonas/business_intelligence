from bokeh.plotting import figure, show
from bokeh.io import export_svgs
from bokeh.models import DatetimeTickFormatter, ColumnDataSource, FactorRange

import pandas as pd

data = pd.read_csv('data/top-organizations.csv')

data = data[0:5]
data = data[::-1]

num_patents = sum(data['count'])

num_orgs = len(data['organisation'])

source = ColumnDataSource(data)

sum_counts = [0]

current = 0
for count in data['count']:
   current = current+count
   sum_counts.append(current)

p = figure(
   plot_width=900,
   plot_height=900,
   title='Patents by Organization',
   x_axis_label="Sum Org",
   y_axis_label="Sum patents",
   y_range=(0, 100),
   x_range=(0, 100),
   tools="",
   output_backend="svg"
)
p.multi_line(
   [[x/num_orgs*100 for x in range(0, num_orgs+1)], list(range(0,101))],
   [[y/num_patents*100 for y in sum_counts], list(range(0,101))],
   line_width=2,
)

export_svgs(p, filename="plot.svg")
