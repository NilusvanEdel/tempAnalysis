import csv
import os
import glob
import re


def fixVRPostQues():
    # where the dataFiles are stored
    path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), 'vr_data/raw'))
    file = "Post Questionnaire.csv"
    newFile = []
    with open(path + '/' + file) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        counter = False
        for row in reader:
            if counter == 0:
                counter = True
                newFile.append(row)
                continue
            row[1] = row[1].upper()
            no_as_string = re.findall(r'\d+', row[1])[0]
            temp = row[1].replace(no_as_string, "")
            if int(no_as_string) < 10:
                row[1] = temp + '0' + str(int(no_as_string))
                row[1] = "FIX01"
            newFile.append(row)
    with open(path + '/' + file, 'w+') as csvfile:
        wr = csv.writer(csvfile, quoting=csv.QUOTE_ALL)
        for row in newFile:
            wr.writerow(row)

    print("fixedVRPosQues")


def getMissingIDsFromPosQues():
    # where the dataFiles are stored
    path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), 'vr_data/raw'))
    print(path)
    posQues = "Post Questionnaire.csv"
    idList = []
    missingIDList = []
    for file in glob.glob(path + "/" + "*.csv"):
        if file == 'Post Questionnaire.csv':
            continue
        idList.append(os.path.basename(file).split(".")[0])
    with open(path + '/' + posQues) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            if not row[1] in idList:
                missingIDList.append(row[1])
    print(missingIDList)


if __name__ == '__main__':
    # fixVRPostQues()
    getMissingIDsFromPosQues()
