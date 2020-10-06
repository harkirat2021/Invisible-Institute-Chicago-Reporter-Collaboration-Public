import json


# pip install psycopg2
import psycopg2

def convertRowToDict(row):
    return {
        'officer_id': row[0],
        'salary': row[1],
        'pay_grade': row[2],
        'rank_changed': row[3],
        'rank': row[4],
        'year': row[5]
    }







if __name__ == '__main__':




    with open('secrets.json') as f:
      data = json.load(f)


    pw = data['db_password']

    connection = psycopg2.connect(
        database="cpdb",
        user="cpdb-student",
        password=pw,
        host="cpdb.cgod7egsd6vr.us-east-2.rds.amazonaws.com",
        port='5432'
    )


    cur = connection.cursor()
    cur.execute('select officer_id, salary, pay_grade, rank_changed, rank, year from data_salary order by year;')

    results = cur.fetchall()

    print('fetched ' + str(len(results)) + ' results')
    results = list(map(convertRowToDict, results))
    print('results mapped to dicts')

    unique_years = set()

    for row in results:
        if row['year'] in unique_years:
            continue

        unique_years.add(row['year'])

    print('got unique years: ' + str(unique_years))

    officers_by_year = {}

    for y in unique_years:
        officers_by_year[y] = {}

    for row in results:
        year = row['year']
        officer = row['officer_id']
        if officer in officers_by_year[year]:
            officers_by_year[year][officer].append(row)
        else:
            officers_by_year[year][officer] = [row]


    # y = 2008

    # promoted = 0
    # not_promoted = 0

    promotions = {}

    for year in officers_by_year:
        y = year
        promotions[y] = {
            'promoted': 0,
            'not_promoted': 0
        }

        if (y-1) not in officers_by_year:
            continue

        for officer in officers_by_year[y]:
            if officer not in officers_by_year[y-1]:
                continue

            if officers_by_year[y][officer][0]['pay_grade'] != officers_by_year[y-1][officer][0]['pay_grade']:
                # print('officer ' + str(officer) + ' promoted in year ' + str(y))
                promotions[y]['promoted'] += 1
            else:
                promotions[y]['not_promoted'] += 1

    print(str(promotions))
