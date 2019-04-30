from bokeh.plotting import figure, show, save, ColumnDataSource, output_file
from bokeh.io import export_svgs
from bokeh.models import NumeralTickFormatter, LabelSet

import pandas as pd

data = pd.read_csv("data/patents_in_cosmonautics.csv")

data = data.drop(['kind', 'title', 'group_id', 'type'], axis=1)

data = data.groupby(['country', 'year']).count()

data['size'] = data['patent_id'] * 50 / data['patent_id'].max()
c = ColumnDataSource(pd.DataFrame(data.to_records()))

p = figure(width=1800, height=800, y_range=list(set(c.data['country'])))

p.circle(x="year", y="country", line_width=3, source=c, size="size")

save(p)
