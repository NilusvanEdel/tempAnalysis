import csv
import glob
import os

### where the dataFiles are stored
path = '/home/nilus/PycharmProjects/tempAnalysis/Data'
### where the created Files will be stored
folder = '/home/nilus/PycharmProjects/tempAnalysis/'

os.chdir(path)
fileList = []
combinedCSV = []
counter = 0
### get each file in path with ending csv
for file in glob.glob("*.csv"):
    with open(path +'/'+ file) as csvfile:
        reader = csv.reader(csvfile, delimiter = ',')
        for row in reader:
            if counter == 0:
                counter += 1
                firstRow = row
                combinedCSV.append(firstRow)
                continue
            if row[0] == firstRow[0]:
                continue
            combinedCSV.append(row)
            
### writeCombined CSV file
with open(folder+'combinedCSV.csv', 'w+') as myfile:
    wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
    for i in range(len(combinedCSV)):
        wr.writerow(combinedCSV[i])


