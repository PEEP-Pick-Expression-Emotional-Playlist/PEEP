import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

import pandas as pd

class ContentBasedRecommender:
    def __init__(self):
        pass

class CollaborativeRecommender:
    def __init__(self):
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
    :type emotions: list
    :type genres: list
    :type tags: list
    :type titile: string
    :type vote_average: double or float
    :type vote_count: int
    :type year: string

    unused:
        artist, artwork, favorite
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

            emotions = list()
            for emotion in value['emotions']:
                # Debug info
                # print('key: ',emotion)
                emotions.append(emotion)
            row['emotions'] = emotions

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
    print(df)

if __name__ == '__main__':
    main()