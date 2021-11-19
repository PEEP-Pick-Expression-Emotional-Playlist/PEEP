import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

from sklearn.metrics import mean_squared_error
import warnings; warnings.filterwarnings('ignore')

class Recommender:

    def __init__(self, df):
        self.df = df

    def content_based(self,target_id,top_n):
        df = self.df

        """Count-Based Vectorize Features"""
        # 장르, 태그, 연도를 기준으로 유사한 것
        # CountVectorizer를 적용하기 위해 공백문자로 word 단위가 구분되는 문자열로 변환
        standard_list = df['genres']+df['tags']
        standard_list.append(df['year'])
        df['standard_literal'] = standard_list.apply(lambda x : (' ').join(x))
        count_vect = CountVectorizer(min_df=0, ngram_range=(1,2))
        mat = count_vect.fit_transform(df['standard_literal'])

        """Cosine Similarity"""
        sim = cosine_similarity(mat, mat)
        sim_sorted_ind = sim.argsort()[:,::-1]  # 반환값이 numpy일 경우에 실제 추출은 dataframe 해야할 경우, numpy의 idx를 가져오는 연산

        """Weighted Rating""" # 평점이 높아도 낮은 것보다 밀려나는 문제해결위함
        percentile = 0.6
        C = df['vote_average'].mean() # 모든 영화 평점의 평균
        m = df['vote_count'].quantile(percentile) # 상위 0.6의 투표 횟수
        v = df['vote_count']
        R = df['vote_average']

        df['weighted_vote'] = ((v/(v+m)) * R) + ((m/(m+v))*C)
        df[['id','vote_average','weighted_vote','vote_count']].sort_values('weighted_vote',ascending=False)[:top_n]

        # [df]에 없으면 에러난거 고침(미리 필터링했기 때문에 기준 음악이 선택한 감정, 연도, 장르에 포함안되면 목록에없었어서 [has_target] 이용해서 넣었음)
        similar_movies = self.find_sim_movie(df, sim_sorted_ind, target_id, top_n)
        return dict.fromkeys(similar_movies['id'].values.tolist(),True)


    def find_sim_movie(self, df, sorted_ind, song_id, top_n=20): # title_name: 기준 음악, top_n: 기준 음악과 유사한 음악 추천 갯수
        id_song = df[df['id'] == song_id]
        id_index = id_song.index.values
        
        similar_indexes = sorted_ind[id_index, :(top_n*2)] # 2배로 뽑음
        similar_indexes = similar_indexes.reshape(-1) # 1dem for fancy indexing
        
        similar_indexes = similar_indexes[similar_indexes != id_index] # 기준 음악 index는 제외
        return df.iloc[similar_indexes].sort_values('weighted_vote', ascending=False)[:top_n] # 2배의 후보군 중 weighted_vote 높은 순으로 top_n만큼 추출

    def collaborative(self,user_id, top_n):
        ratings = self.df

        """사용자-아이템 평점 행렬"""
        ratings_matrix = ratings.pivot_table('rating', index='user_id', columns='song_id')
        ratings_matrix = ratings_matrix.fillna(0) # NaN 값을 모두 0 으로 변환


        """Cosine Similarity"""
        ratings_matrix_T = ratings_matrix.transpose()
        item_sim = cosine_similarity(ratings_matrix_T, ratings_matrix_T)
        # cosine_similarity() 로 반환된 넘파이 행렬을 DataFrame으로 변환
        item_sim_df = pd.DataFrame(data=item_sim, index=ratings_matrix.columns,columns=ratings_matrix.columns)
        # print(item_sim_df.get(target_id).sort_values(ascending=False)[:6]) # item_sim_df.get(target_id) : None

        # top-n 유사도를 가진 데이터들에 대해서만 예측 평점 계산
        ratings_pred = self.predict_rating_topsim(ratings_matrix.values , item_sim_df.values, n=(top_n*2))

        # 계산된 예측 평점 데이터는 DataFrame으로 재생성
        ratings_pred_matrix = pd.DataFrame(data=ratings_pred, index= ratings_matrix.index, columns = ratings_matrix.columns)

        # Debug info
        # user_rating_id = ratings_matrix.loc[user_id, :]
        # print(user_rating_id[ user_rating_id > 0].sort_values(ascending=False)[:10])

        # 사용자가 관람하지 않는 음악id 추출 
        unlistened_list = self.get_unlistened_songs(ratings_matrix, user_id)

        # 아이템 기반의 인접 이웃 협업 필터링으로 음악 추천 
        recomm_songs = self.recomm_song_by_userid(ratings_pred_matrix, user_id, unlistened_list, top_n=top_n)

        # 평점 데이타를 DataFrame으로 생성. 
        # recomm_songs = pd.DataFrame(data=recomm_songs.values,index=recomm_songs.index,columns=['pred_score'])

        d = dict()
        d.update((x[0],True) for x in recomm_songs.items())
        return d

    # 사용자가 평점을 부여한 영화에 대해서만 예측 성능 평가 MSE 를 구함. 
    def get_mse(pred, actual):
        # Ignore nonzero terms.
        pred = pred[actual.nonzero()].flatten()
        actual = actual[actual.nonzero()].flatten()
        return mean_squared_error(pred, actual)

    def predict_rating_topsim(self, ratings_arr, item_sim_arr, n=20):
        # 사용자-아이템 평점 행렬 크기만큼 0으로 채운 예측 행렬 초기화
        pred = np.zeros(ratings_arr.shape)

        # 사용자-아이템 평점 행렬의 열 크기만큼 Loop 수행. 
        for col in range(ratings_arr.shape[1]):
            # 유사도 행렬에서 유사도가 큰 순으로 n개 데이터 행렬의 index 반환
            top_n_items = [np.argsort(item_sim_arr[:, col])[:-n-1:-1]]
            # 개인화된 예측 평점을 계산
            for row in range(ratings_arr.shape[0]):
                pred[row, col] = item_sim_arr[col, :][top_n_items].dot(ratings_arr[row, :][top_n_items].T)
                pred[row, col] /= np.sum(np.abs(item_sim_arr[col, :][top_n_items]))        
        return pred

    def get_unlistened_songs(self,ratings_matrix, user_id):
        # user_id로 입력받은 사용자의 모든 음악정보 추출하여 Series로 반환함. 
        # 반환된 user_rating 은 음악 id를 index로 가지는 Series 객체임. 
        user_rating = ratings_matrix.loc[user_id,:]
        
        # user_rating이 0보다 크면 기존에 관람한 음악임. 대상 index를 추출하여 list 객체로 만듬
        already_listened = user_rating[ user_rating > 0].index.tolist()
        
        # 모든 음악명을 list 객체로 만듬. 
        songs_list = ratings_matrix.columns.tolist()
        
        # list comprehension으로 already_listened에 해당하는 movie는 songs_list에서 제외함. 
        unlistened_list = [ movie for movie in songs_list if movie not in already_listened]
        
        return unlistened_list

    def recomm_song_by_userid(self,pred_df, user_id, unlistened_list, top_n=10):
        # 예측 평점 DataFrame에서 사용자id index와 unlistened_list로 들어온 음악명 컬럼을 추출하여
        # 가장 예측 평점이 높은 순으로 정렬함. 
        recomm_songs = pred_df.loc[user_id, unlistened_list].sort_values(ascending=False)[:top_n]
        return recomm_songs
    

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

    Get [emotion], [genre], [year], [target_id], [user_id] from client
    ---------------------------------------------------------------
    
    :emotion: 'happy', 'angry', 'fear', 'calm', 'blue'
    :genre: '모든 장르', '댄스', '발라드', '랩∙힙합', '록∙메탈'
    :year: '모든 연도', '2020', '2010', '2000', '1990'
    :target_id: string. song id for recommendation
    :user_id: string. client id
    
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
    # target_id = '-MohtWR6AEiu53ztW4xU' # it has same conditions
    target_id = '-MoiIKxUXuWAaFSw5h3i'
    user_id = 'q1ysgPq4AXarDDW1e5GKqlBaj5L2'
    user_id = 'dd'

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
        target = db.reference("songs/"+target_id).get()
        row = dict()

        row['id'] = target_id
        song_id_list.append(row['id'])

        target_genres = list()
        for genre in target['genre']:
            target_genres.append(genre)
        row['genres'] = target_genres

        target_tags = list()
        for tag in target['tags']:
            target_tags.append(tag)
        row['tags'] = target_tags
        
        row['vote_average'] = target['vote_average']
        row['vote_count'] = target['vote_count']
        row['year'] = target['year']
        song_list.append(row)

    try:
        for key, value in songs.items():
            # Debug info
            # print('key: ',key)
            # print('value: ',value)

            row = dict()
            row['id'] = key
            song_id_list.append(row['id'])

            genres = list()
            for genre in value['genre']:
                genres.append(genre)
            row['genres'] = genres

            tags = list()
            for tag in value['tags']:
                tags.append(tag)
            row['tags'] = tags

            row['vote_average'] = value['vote_average']
            row['vote_count'] = value['vote_count']
            row['year'] = value['year']

            # Debug info
            # print(row)
            song_list.append(row)
            pass
        pass
    except:
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

    # Test Query ##################################
    # with open("collaborative_item.json", "r") as f:
    #     file_contents = json.load(f)
    # db.reference("ratings").set(file_contents)
    ###############################################

    ratings = db.reference("ratings").get()

    # Test Query ####################
    # db.reference("ratings").set({})
    #################################

    rating_list = list()
    # Debug info
    # print(song_id_list)
    has_user_id = False
    try:
        for key, value in ratings.items():
            # Debug info
            # print("key:",key)
            # print("value:",value)
            if key == user_id: has_user_id = True

            for song_id, rating in value.items():
                if song_id not in song_id_list: continue
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

    # Debug info
    print(rating_list)
    
    if (not has_user_id) and (rating_list):
        row = dict()
        row['user_id'] = user_id
        row['song_id'] = target_id
        row['rating'] = 0
        rating_list.append(row)

    ratings_df = pd.DataFrame(rating_list)
    # Debug info
    # print(ratings_df)

    """Recommendation"""
    top_n = 10 # Number of songs to be recommended
    res = dict()
    if not ratings_df.empty: # 조건에 맞는 음악이 하나라도 평가되지 않았으면 추천해줄 수가 없다
        res.update(Recommender(df=ratings_df).collaborative(user_id,top_n))
    else:
        top_n = 20
    res.update(Recommender(df=songs_df).content_based(target_id,top_n))

    """send recommended songs to client"""
    # TODO: send [res] to client
    # TODO: [res] is dict of song ids

    for r in res:
        print(r)
        pass

    pass

if __name__ == '__main__':
    main()