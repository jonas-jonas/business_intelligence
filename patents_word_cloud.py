import pandas as pd
from nltk.corpus import stopwords
from wordcloud import WordCloud

patents = pd.read_csv('./data/patent_groups.csv')

stop = set(stopwords.words('english'))

title_joined = ' '.join([title.lower() for title in patents['title'].values])

wordcloud = WordCloud(
    background_color='white',
    max_words=500,
    stopwords=stop,
    width=1600,
    height=700,
    # font_path='./submission/themes/fonts/PublicSans-normal.ttf',
    colormap='cividis'
)

# For reuse of the word frequencies
words = wordcloud.process_text(title_joined)

# Generate word cloud
wordcloud.generate_from_frequencies(words)

# store to file
wordcloud.to_file('submission/images/title_wordcloud.png')

# Generate csv file containing every word + count
words_df = pd.DataFrame(sorted([(v, k) for (k, v) in words.items()],
                        reverse=True)[:10])

words_df.columns = ['Count', 'Word']
words_df = words_df[['Word', 'Count']]
words_df.to_csv('submission/data/word_frequencies.csv', index=False)

word_data = pd.DataFrame(
    index=list(patents['organization'].unique()),
    columns=list(title_joined.split(' ')),
    data=0
)

for _, title, org in patents.values:
    title = title.split(' ')
    for word in title:
        lower = word.lower()
        if lower not in stop:
            word_data.loc[org, lower] += 1

word_data.idxmax(axis=1).to_csv('submission/data/most_used_words.csv')
