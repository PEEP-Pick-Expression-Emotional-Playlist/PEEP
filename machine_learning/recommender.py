import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

def main():
    set_firebase()
    ref = db.reference("songs")
    songs = ref.get()
    try:
        for key, value in songs.items():
            print('key: ',key)
            print('value: ',value)
            break
    except:
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

if __name__ == '__main__':
    main()