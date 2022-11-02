## The purpose of this file is to transform the initial query results into
## readable data for chart visualization tools (stacked area, scatter/bubble):
## (1) exports Raw .TXT files into .CSV files for use by chart plotting tool 
## (2) replaces tool_id column for tool_name_version for better readibility 
## (3) modifies/removes NULL values for use by chart plotting tool 
## (4) ensures consistent column header names/placement for better readibility 

import pandas as pd
import json

LOCAL_DIRECTORY_READ = '../../psql-main-data/STEP_2_1_export_enumerate/'    ## contains Txt files (created from SQL exports from AWS)
LOCAL_DIRECTORY_WRITE = '20221019/'     ## contains Csv files (created from above Txt files)
# LOCAL_DIRECTORY_PREFIX = '202210181743/'     ## unique date-time string value for multiple runs

def get_tool_name(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 2]

def get_version(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 1]

def normalize_tool_name_version(dataset):
    tool_name_version = dataset.apply(lambda x: x['tool_name_version'] + get_tool_name(str(x['tool_id'])) + "/" + get_version(str(x['tool_id'])),axis =1)
    return tool_name_version

def normalize_headers(columns, is_pivot):
    if is_pivot:
        columns.insert(1, "tool_id")
    else:
        columns.insert(0, "tool_id")
    return columns

## function that (1) exports the Txt file data into Csv files (2) removes null values (3) enumerates the rows in the Csv files (4) normalizes tool name/version
def export_data_txt_to_csv(txt_file_in, headers):
    txt_file = LOCAL_DIRECTORY_READ + txt_file_in + '.txt'
    print('txt_file', txt_file)
    csv_file = LOCAL_DIRECTORY_WRITE + 'STEP_3_0_clean_data/' + txt_file_in + '.csv'
    print('csv_file', csv_file)
    dataset = pd.read_csv(txt_file, delimiter = '|',names = headers,skiprows = 1)
    dataset = dataset.dropna()
    dataset['tool_id'] = dataset['tool_id'].str.strip()
    dataset['tool_name_version'] = ''
    dataset['tool_name_version'] = normalize_tool_name_version(dataset)
    dataset = dataset.drop(columns = ['tool_id'])
    dataset.to_csv(csv_file)

## function that (1) formats Csv data into pivoted data (2) replaces null values with zeros/0 values in order that the pivot chart displays properly
def export_data_csv_to_csv_inverted(csv_file_in, headers):
    csv_file = LOCAL_DIRECTORY_WRITE + 'STEP_3_0_clean_data/' + csv_file_in + '.csv'
    print('csv_file', csv_file)
    csv_inverted_file = LOCAL_DIRECTORY_WRITE + 'STEP_3_1_chart_views/' + csv_file_in + '_inverted.csv'
    print('csv_inverted_file', csv_inverted_file)
    print('headers[2]', headers[2])
    dataset = pd.read_csv(csv_file,names = ['month_year',headers[2],'tool_name_version'],skiprows = 1)
    dataset = dataset.drop_duplicates(['month_year','tool_name_version'])
    dataset_inverted = dataset.pivot(index='month_year', columns='tool_name_version', values=headers[2])
    dataset_inverted = dataset_inverted.fillna(0)
    dataset_inverted.to_csv(csv_inverted_file)

# Main: Opening JSON file which contains instructions on proper labeling of chart data
with open('constants_data_labels.json') as json_file:
    data = json.load(json_file)

    print("\nPrinting nested dictionary as a key-value pair\n")
    for i in data['data_labels']:
        headers = normalize_headers(i['columns'], i['has_inverted_dataset'])
        print("> starting file import / export for:", i['filename'])
        export_data_txt_to_csv(i['filename'], headers)
        if i['has_inverted_dataset']:
            export_data_csv_to_csv_inverted(i['filename'], headers)
            print("> starting file inversion for:", i['filename'])
        else:
            print("> no file inversion for:", i['filename'])
        print()

print('finished !')
