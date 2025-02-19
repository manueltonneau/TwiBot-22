import json
import csv
from tqdm import tqdm
import time
import os
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
import pandas as pd


def generate_userful(num):
    start = time.time()
    dir_ = '/scratch/mt4493/bot_detection/data/Twibot-22/'
    t = json.load(open(dir_ + 'tweet_{}.json'.format(num)))
    length = len(t)
    print('Read tweet_{} finish:'.format(num), time.time() - start)

    df = pd.DataFrame(columns = ['id','text','like','retweet'])
    for i in range(length):
        content = {}
        content['id'] = t[i]['id']
        content['text'] = t[i]['text']
        content['like'] = t[i]['public_metrics']['like_count']
        content['retweet'] = t[i]['public_metrics']['retweet_count']

        df.append(content, ignore_index=True)

    return df


if __name__ == '__main__':
    init_tweet = locals()
    code_path = '/scratch/mt4493/bot_detection/code/TwiBot-22/src/Kouvela'
    for i in range(9):
        print(f'loading file {i}')
        init_tweet['t{}'.format(i)] = generate_userful(i)

    final = pd.concat([t0, t1, t2, t3, t4, t5, t6, t7, t8], axis=0)
    final = final.fillna(0)
    final.sort_values(by="id", axis=0, ascending=True, inplace=True, ignore_index=True)
    print(f'len(final): {len(final)}')
    # the initial 9 tweets_i.json files are splited into some small csv files
    # in order to speed up content feature extraction
    num = 1000000
    batch = int(len(final) / num)

    os.makedirs(os.path.join(code_path, 'Twibot-22', 'small_split_dataset'))
    print('starting to save csvs')
    for i in range(batch):
        begin = i * num
        tweet = final.loc[begin : begin + num - 1]
        tweet.to_csv(os.path.join(code_path,'Twibot-22','small_split_dataset/tweet{}.csv'.format(i), index=False))