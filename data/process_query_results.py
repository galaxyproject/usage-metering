## The purpose of this file is to process the initial query results returned so as to
## be inverted for the purpose of stacked area chart and for the replacement of the tool_id column 
## to be that of the tool_name_version for better readibility

import pandas as pd
import json

LOCAL_DIRECTORY_READ = '../../psql-main-data/STEP_2_1_export_enumerate/'    ## contains Txt files (created from SQL exports from AWS)
LOCAL_DIRECTORY_WRITE = '20221019/'     ## contains Csv files (created from above Txt files)
# LOCAL_DIRECTORY_PREFIX = '202210181743/'     ## unique date-time string value for multiple runs

def getToolName(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 2]

def getVersion(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 1]

def normalizeToolNameVersion(dataset):
    toolNameVersion = dataset.apply(lambda x: x['tool_name_version'] + getToolName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
    return toolNameVersion

def normalizeHeaders(columns, isPivot):
    if isPivot:
        columns.insert(1, "tool_id")
    else:
        columns.insert(0, "tool_id")
    return columns

## function that (1) exports the Txt file data into Csv files (2) removes null values (3) enumerates the rows in the Csv files (4) normalizes tool name/version
def exportDataTxtToCsv(txtFileIn, headers):
    txtFile = LOCAL_DIRECTORY_READ + txtFileIn + '.txt'
    print('txtFile', txtFile)
    csvFile = LOCAL_DIRECTORY_WRITE + 'STEP_3_0_clean_data/' + txtFileIn + '.csv'
    print('csvFile', csvFile)
    dataset = pd.read_csv(txtFile, delimiter = '|',names = headers,skiprows = 1)
    dataset = dataset.dropna()
    dataset['tool_id'] = dataset['tool_id'].str.strip()
    dataset['tool_name_version'] = ''
    dataset['tool_name_version'] = normalizeToolNameVersion(dataset)
    dataset = dataset.drop(columns = ['tool_id'])
    dataset.to_csv(csvFile)

## function that (1) formats Csv data into pivoted data (2) replaces null values with zeros/0 values in order that the pivot chart displays properly
def exportDataCsvToCsvInverted(csvFileIn, headers):
    csvFile = LOCAL_DIRECTORY_WRITE + 'STEP_3_0_clean_data/' + csvFileIn + '.csv'
    print('csvFile', csvFile)
    csvInvertedFile = LOCAL_DIRECTORY_WRITE + 'STEP_3_1_chart_views/' + csvFileIn + '_inverted.csv'
    print('csvInvertedFile', csvInvertedFile)
    print('headers[2]', headers[2])
    dataset = pd.read_csv(csvFile,names = ['month_year',headers[2],'tool_name_version'],skiprows = 1)
    dataset = dataset.drop_duplicates(['month_year','tool_name_version'])
    datasetInverted = dataset.pivot(index='month_year', columns='tool_name_version', values=headers[2])
    datasetInverted = datasetInverted.fillna(0)
    datasetInverted.to_csv(csvInvertedFile)

# Main: Opening JSON file which contains instructions on proper labeling of chart data
with open('constants_data_labels.json') as json_file:
    data = json.load(json_file)

    print("\nPrinting nested dictionary as a key-value pair\n")
    for i in data['data_labels']:
        headers = normalizeHeaders(i['columns'], i['has_inverted_dataset'])
        print("> starting file import / export for:", i['filename'])
        exportDataTxtToCsv(i['filename'], headers)
        if i['has_inverted_dataset']:
            exportDataCsvToCsvInverted(i['filename'], headers)
            print("> starting file inversion for:", i['filename'])
        else:
            print("> no file inversion for:", i['filename'])
        print()

print('finished !')
