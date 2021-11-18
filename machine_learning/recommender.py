import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

class Recommender:

    def __init__(self, df):
        self.df = df

    def content_based(self):
        df = self.df

        """Count-Based Vectorize Features"""
        ## TODO: Replace df['genres'] to df[['genres','keywords']]
        # CountVectorizer를 적용하기 위해 공백문자로 word 단위가 구분되는 문자열로 변환
        df['genres_literal'] = df['genres'].apply(lambda x : (' ').join(x))
        count_vect = CountVectorizer(min_df=0, ngram_range=(1,2))
        genre_mat = count_vect.fit_transform(df['genres_literal'])

        """Cosine Similarity"""
        genre_sim = cosine_similarity(genre_mat, genre_mat)
        genre_sim_sorted_ind = genre_sim.argsort()[:,::-1]  # 반환값이 numpy일 경우에 실제 추출은 dataframe 해야할 경우, numpy의 idx를 가져오는 연산

        """Weighted Rating""" # 평점이 높아도 낮은 것보다 밀려나는 문제해결위함
        percentile = 0.6
        C = df['vote_average'].mean() # 모든 영화 평점의 평균
        m = df['vote_count'].quantile(percentile) # 상위 0.6의 투표 횟수
        v = df['vote_count']
        R = df['vote_average']

        df['weighted_vote'] = ((v/(v+m)) * R) + ((m/(m+v))*C)
        df[['title','vote_average','weighted_vote','vote_count']].sort_values('weighted_vote',ascending=False)[:10]

        similar_movies = self.find_sim_movie(df, genre_sim_sorted_ind, 'DREAMER', 10)
        return similar_movies['id'].values.tolist()


    def find_sim_movie(self, df, sorted_ind, title_name, top_n=10): # title_name: 기준 음악, top_n: 기준 음악과 유사한 음악 추천 갯수
        title_movie = df[df['title'] == title_name]
        title_index = title_movie.index.values
        
        similar_indexes = sorted_ind[title_index, :(top_n*2)] # 2배로 뽑음
        similar_indexes = similar_indexes.reshape(-1) # 1dem for fancy indexing
        
        similar_indexes = similar_indexes[similar_indexes != title_index] # 기준 음악 index는 제외
        return df.iloc[similar_indexes].sort_values('weighted_vote', ascending=False)[:top_n] # 2배의 후보군 중 weighted_vote 높은 순으로 top_n만큼 추출

    def collaborative(self):
        pass

def set_firebase():
    firebase_config_path = './firebaseConfig.json'
    cred = credentials.Certificate(firebase_config_path)
    with open('./secrets.json', 'r') as f:
        tmp = json.load(f)
        db_url = tmp['db_url']

    firebase_admin.initialize_app(cred,{
        "databaseURL": db_url
    })
    
def main():
    """
    If you use Anaconda, Use this
    commands:
        source activate [environment_name]
        source deactivate

    :Example:

    >>> source activate ddony
    """


    """Set Firebase and Get songs by client from Firebase

    Get [recommender_type], [emotion], [genre], [year] from client
    ---------------------------------------------------------------

    :recommender_type: 'content', 'collaborative'
    :emotion: 'happy', 'angry', 'fear', 'calm', 'blue'
    :genre: '모든 장르', '댄스', '발라드', '랩∙힙합', '록∙메탈'
    :year: '모든 연도', '2020', '2010', '2000', '1990'
    """

    set_firebase()

    # TODO: Get [recommender_type], [emotion], [genre], [year] from client
    # TODO: Logic of getting pass list

    recommender_type = 'content'
    emotion = 'happy'
    genre = '댄스'
    year = '2020'

    """Get songs by emotion, genre, year."""
    ref = db.reference("songs")
    songs = ref.order_by_child('emotions/'+emotion).equal_to(True).get()

    # TODO: Remove songs by pass list
    
    if genre != '모든 장르' :
        songs = {k: v for (k,v) in songs.items() if v['genre'].get(genre) == True}
    if year != '모든 연도' :
        songs = {k: v for (k, v) in songs.items() if v['year'] == year}

    """Data Processing. Dict to DataFrame
    
    :type id: string
    :type genres: list
    :type tags: list
    :type titile: string
    :type vote_average: float
    :type vote_count: int
    :type year: string

    :unused:
        :type emotions: list
        :type artist: string
        :type artwork: string
        :type favorite: int
    """
    processed_list = list()
    try:
        for key, value in songs.items():
            # Debug info
            # print('key: ',key)
            # print('value: ',value)

            row = dict()
            row['id'] = key
            # row['artist'] = value['artist'] # unused
            # row['artwork'] = value['artwork'] # unused

            # unused
            # emotions = list()
            # for emotion in value['emotions']:
            #     # Debug info
            #     # print('key: ',emotion)
            #     emotions.append(emotion)
            # row['emotions'] = emotions

            # row['favorite'] = value['favorite'] # unused
            genres = list()
            for genre in value['genre']:
                genres.append(genre)
            row['genres'] = genres

            tags = list()
            for tag in value['tags']:
                tags.append(tag)
            row['tags'] = tags

            row['title'] = value['title']
            row['vote_average'] = value['vote_average']
            row['vote_count'] = value['vote_count']
            row['year'] = value['year']

            # Debug info
            # print(row)
            processed_list.append(row)
    except:
        pass

    df = pd.DataFrame(processed_list)
    # Debug info
    # print(df)

    if(recommender_type == 'content'):
        res = Recommender(df=df).content_based()
        pass
    elif(recommender_type == 'collaborative'):
        res = Recommender(df=df).collaborative()
        pass

    # TODO: send res to client
    print(res)
    pass

if __name__ == '__main__':
    main()