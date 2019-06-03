# WordCloud
import pandas as pd
from nltk.corpus import stopwords
from wordcloud import WordCloud

patents = pd.read_csv('data/patents_title_abstract.csv')

stop = set(stopwords.words('english'))

title_joined = ' '.join([title for title, _, _ in patents.values])

wordcloud = WordCloud(
    background_color='white',
    max_words=500,
    stopwords=stop,
    contour_width=3,
    width=1600,
    height=700
)

# generate word cloud
wordcloud.generate(title_joined)

# store to file
wordcloud.to_file('submission/images/title_wordcloud.png')
