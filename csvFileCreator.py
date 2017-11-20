import csv

path = '/home/nilus/Desktop/tempAnalysis/dataframe_data_so_far(1).csv'
folder = '/home/nilus/Desktop/tempAnalysis/'

data = []
with open(path) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for column in reader:
        data.append(column[6:11])
with open(folder+'new.csv', 'w') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(data)):
        wr.writerow(data[i])
