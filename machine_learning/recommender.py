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

    def content_based(self,target_id,top_n):
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
        df[['id','vote_average','weighted_vote','vote_count']].sort_values('weighted_vote',ascending=False)[:top_n]

        # [df]에 없으면 에러난거 고침(미리 필터링했기 때문에 기준 음악이 선택한 감정, 연도, 장르에 포함안되면 목록에없었어서 [has_target] 이용해서 넣었음)
        similar_movies = self.find_sim_movie(df, genre_sim_sorted_ind, target_id, top_n)
        return dict.fromkeys(similar_movies['id'].values.tolist(),True)


    def find_sim_movie(self, df, sorted_ind, song_id, top_n=20): # title_name: 기준 음악, top_n: 기준 음악과 유사한 음악 추천 갯수
        id_song = df[df['id'] == song_id]
        id_index = id_song.index.values
        
        similar_indexes = sorted_ind[id_index, :(top_n*2)] # 2배로 뽑음
        similar_indexes = similar_indexes.reshape(-1) # 1dem for fancy indexing
        
        similar_indexes = similar_indexes[similar_indexes != id_index] # 기준 음악 index는 제외
        return df.iloc[similar_indexes].sort_values('weighted_vote', ascending=False)[:top_n] # 2배의 후보군 중 weighted_vote 높은 순으로 top_n만큼 추출

    def collaborative(self,top_n):
        
        return dict()


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

    Get [emotion], [genre], [year], [target_id] from client
    ---------------------------------------------------------------
    
    :emotion: 'happy', 'angry', 'fear', 'calm', 'blue'
    :genre: '모든 장르', '댄스', '발라드', '랩∙힙합', '록∙메탈'
    :year: '모든 연도', '2020', '2010', '2000', '1990'
    :target_id: song id for recommendation
    
    Target song data is always needed.
    So, If target conditions are not equal to selected conditions, 
    needs:
        :target_genre: list. ex.['댄스','발라드']
        :target_tags: list
        :target_vote_average: float
        :target_vote_count: int
        :target_year: string
    """

    set_firebase()

    # TODO: Get [emotion], [genre], [year], [target_id] from client

    emotion = 'happy'
    genre = '댄스'
    year = '2020'
    target_id = '-MohtWR6AEiu53ztW4xU' # it has same conditions
    target_id = '-MoiIKxUXuWAaFSw5h3i'
    target_genre = ['국내드라마','댄스']
    target_tags = ['노래','바른연애길잡이','분노','빡침','스트레스', '야경', '웹툰OST', '한강', '화날때', '힙합'] 
    target_vote_average = 4.3
    target_vote_count = 1724
    target_year = '2020'

    """Get songs by emotion, genre, year."""
    songs = db.reference("songs").order_by_child('emotions/'+emotion).equal_to(True).get()
    
    if genre != '모든 장르' :
        songs = {k: v for (k,v) in songs.items() if v['genre'].get(genre) == True}
    if year != '모든 연도' :
        songs = {k: v for (k, v) in songs.items() if v['year'] == year}

    """Data Processing for songs. Dict to DataFrame
    
    :type id: string
    :type genres: list
    :type tags: list
    :type vote_average: float
    :type vote_count: int
    :type year: string

    :unused:
        :type titile: string
        :type emotions: list
        :type artist: string
        :type artwork: string
        :type favorite: int

    .. note::
        :song_id_list: filltered song id only for collaborative
    """
    song_list = list()
    song_id_list = list()

    has_target = False
    for key, value in songs.items():
        if key == target_id:
            has_target = True
            break

    if has_target is False:
        row = dict()
        row['id'] = target_id
        row['genres'] = target_genre
        row['tags'] = target_tags
        row['vote_average'] = target_vote_average
        row['vote_count'] = target_vote_count
        row['year'] = target_year
        song_list.append(row)

    try:
        for key, value in songs.items():
            # Debug info
            # print('key: ',key)
            # print('value: ',value)

            row = dict()
            row['id'] = key
            song_id_list.append(row['id'])
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

            # row['title'] = value['title'] # unused
            row['vote_average'] = value['vote_average']
            row['vote_count'] = value['vote_count']
            row['year'] = value['year']

            # Debug info
            # print(row)
            song_list.append(row)
            pass
        pass
    except Exception as e:
        print(e)
        pass

    songs_df = pd.DataFrame(song_list)
    # Debug info
    # print(songs_df)

    """Data Processing for ratings. Dict to DataFrame

    :type user_id: string
    :type song_id: string
    :type rating: float

    .. note::
        :song_id_list: filltered by emotion, year, genre
    """

    ratings = db.reference("ratings").get()

    rating_list = list()
    try:
        for key, value in ratings.items():
            # Debug info
            # print("key:",key)
            # print("value:",value)

            for song_id, rating in value.items():
                if song_id not in song_id_list : continue
                row = dict()
                row['user_id'] = key
                row['song_id'] = song_id
                row['rating'] = rating
                rating_list.append(row)
                # Debug info
                # print(row)
                pass
            pass
        pass
    except:
         pass

    ratings_df = pd.DataFrame(rating_list)
    # Debug info
    # print(ratings_df)

    """Recommendation"""
    top_n = 10 # Number of songs to be recommended
    res = dict()
    res.update(Recommender(df=songs_df).content_based(target_id,top_n))
    res.update(Recommender(df=ratings_df).collaborative(top_n))

    """send recommended songs to client"""
    # TODO: send song information to client using res and firebase
    # TODO: [res] is dict of song id
    # TODO: So, 1. get *items* from '/songs' in firebase using [res]
    # TODO: and 2. send *items* to client
    for r in res:
        print(r)
        pass

    pass

if __name__ == '__main__':
    main()