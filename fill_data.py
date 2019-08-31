import csv
import glob
import os
import psycopg2


def load_data(csv_pattern, destination_db):
    for file_name in glob.glob(csv_pattern):
        cleaned_file = _clean_null_bytes(file_name)
        _add_to_db(cleaned_file, destination_db)

def _add_to_db(file, destination_db):
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        dbname=os.environ.get("DB_NAME")
    )
    cur = conn.cursor()
    with open(file, 'r') as f:
        # Skip header row
        next(f)
        cur.copy_from(f, destination_db, sep=',')
        conn.commit()
    conn.close()
            
# TODO: Handle extraneous newlines as well
def _clean_null_bytes(csv_file):
    new_file = csv_file + "new"
    # Easier to write to a new file versus dealing with writing in place
    with open(csv_file, 'r') as f, open(new_file, "w") as output:
        reader = csv.reader(x.replace('\0', '') for x in f)
        writer = csv.writer(output)
        for row in reader:
            writer.writerow(row)
    return new_file

def calculate_ad_scores():
    select_string = """SELECT ad_id, COUNT(event_id) as times_shown FROM marketing WHERE provider = (%s) GROUP BY marketing.ad_id ORDER BY times_shown DESC"""
    insert_string = """INSERT INTO ad_scores values (%s, %s, %s)"""
    # TODO: Consolidate DB logic into shared class
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        dbname=os.environ.get("DB_NAME")
    )
    cur = conn.cursor()
    for provider in ["Facebook", "Instagram", "Snapchat", "Spotify"]:
        select_val = cur.execute(select_string, (provider,))
        data = cur.fetchall()
        for i in range(0, len(data)):
            result = data[i]
            score = (len(data) - i)/len(data)
            cur.execute(insert_string, (result[0], provider, score))
    conn.commit()
    conn.close()

# Load users data
load_data("dataset/user_2019-07-0*", os.environ.get("USER_DB_NAME"))

# Load marketing data
load_data("dataset/marketing_2019-07-0*", os.environ.get("MARKETING_DB_NAME"))

# Calculate ad scores
calculate_ad_scores()
