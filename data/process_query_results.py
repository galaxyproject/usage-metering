## The purpose of this file is to process the initial query results returned so as to
## be inverted for the purpose of stacked area chart and for the replacement of the tool_id column 
## to be that of the tool_name_version for better readibility

import pandas as pd

## function that gets the tool_name from the tool_id
def getName(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 2]

## function that gets the tool_version from the tool_id
def getVersion(tool_id):
    arr = tool_id.split('/')
    return arr[len(arr) - 1]

## Get the tool_id in the query results for numjobs vs numusers to be in the format tool_name/version
numjobs_numusers = pd.read_csv('../unprocessed_toolid/numjobs_numusers.txt',
                                delimiter = '|',names = ['tool_id','num_jobs','num_users'],skiprows = 1)
numjobs_numusers = numjobs_numusers.dropna()
numjobs_numusers['tool_id'] = numjobs_numusers['tool_id'].str.strip()
numjobs_numusers['tool_name_version'] = ''
numjobs_numusers['tool_name_version'] = numjobs_numusers.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numjobs_numusers = numjobs_numusers.drop(columns = ['tool_id'])
numjobs_numusers.to_csv('numjobs_numusers.csv')

## Get the tool_id in the query results for total_cpu_time vs numjobs to be in the format tool_name/version
total_cpu_time_numjobs = pd.read_csv('../unprocessed_toolid/total_cpu_time_numjobs.txt',
                                delimiter = '|',names = ['tool_id','total_cpu_time','num_jobs'],skiprows = 1)
total_cpu_time_numjobs = total_cpu_time_numjobs.dropna()
total_cpu_time_numjobs['tool_id'] = total_cpu_time_numjobs['tool_id'].str.strip()
total_cpu_time_numjobs['tool_name_version'] = ''
total_cpu_time_numjobs['tool_name_version'] = total_cpu_time_numjobs.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
total_cpu_time_numjobs = total_cpu_time_numjobs.drop(columns = ['tool_id'])
total_cpu_time_numjobs.to_csv('total_cpu_time_numjobs.csv')

## Get the tool_id in the query results for totalmemory vs numjobs to be in the format tool_name/version
totalmemory_numjobs = pd.read_csv('../unprocessed_toolid/totalmemory_numjobs.txt',
                                delimiter = '|',names = ['tool_id','totalmemory','num_jobs'],skiprows = 1)
totalmemory_numjobs = totalmemory_numjobs.dropna()
totalmemory_numjobs['tool_id'] = totalmemory_numjobs['tool_id'].str.strip()
totalmemory_numjobs['tool_name_version'] = ''
totalmemory_numjobs['tool_name_version'] = totalmemory_numjobs.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
totalmemory_numjobs = totalmemory_numjobs.drop(columns = ['tool_id'])
totalmemory_numjobs.to_csv('totalmemory_numjobs.csv')


## Get the tool_id in the query results for numjobs for all months to be in the format tool_name/version
numjobs_all = pd.read_csv("../unprocessed_toolid/numjobs_all.txt",
                    delimiter = '|',names = ['month_year','tool_id','num_jobs'],skiprows = 1)
numjobs_all = numjobs_all.dropna() # Removes all the Nan values
numjobs_all['tool_id'] = numjobs_all['tool_id'].str.strip()
numjobs_all['tool_name_version'] = ''
numjobs_all['tool_name_version'] = numjobs_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numjobs_all = numjobs_all.drop(columns = ['tool_id'])
numjobs_all.to_csv('numjobs_all.csv')

## Get the tool_id in the query results for numusers for all months to be in the format tool_name/version
numusers_all = pd.read_csv("../unprocessed_toolid/numusers_all.txt",
                    delimiter = '|',names = ['month_year','tool_id','num_users'],skiprows = 1)
numusers_all = numusers_all.dropna()
numusers_all['tool_id'] = numusers_all['tool_id'].str.strip()
numusers_all['tool_name_version'] = ''
numusers_all['tool_name_version'] = numusers_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numusers_all = numusers_all.drop(columns = ['tool_id'])
numusers_all.to_csv('numusers_all.csv')

## Get the tool_id in the query results for total_cpu_time for all months to be in the format tool_name/version
total_cpu_time_all = pd.read_csv("../unprocessed_toolid/total_cpu_time_all.txt",
                    delimiter = '|',names = ['tool_id','month_year','total_cpu_time'],skiprows = 1)
total_cpu_time_all = total_cpu_time_all.dropna()
total_cpu_time_all['tool_id'] = total_cpu_time_all['tool_id'].str.strip()
total_cpu_time_all['tool_name_version'] = ''
total_cpu_time_all['tool_name_version'] = total_cpu_time_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
total_cpu_time_all = total_cpu_time_all.drop(columns = ['tool_id'])
total_cpu_time_all.to_csv('total_cpu_time_all.csv')

## Get the tool_id in the query results for totalmemory for all months to be in the format tool_name/version
totalmemory_all = pd.read_csv("../unprocessed_toolid/totalmemory_all.txt",
                    delimiter = '|',names = ['month_year','tool_id','totalmemory'],skiprows = 1)
totalmemory_all = totalmemory_all.dropna()
totalmemory_all['tool_id'] = totalmemory_all['tool_id'].str.strip()
totalmemory_all['tool_name_version'] = ''
totalmemory_all['tool_name_version'] = totalmemory_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
totalmemory_all = totalmemory_all.drop(columns = ['tool_id'])
totalmemory_all.to_csv('totalmemory_all.csv')

## Get the tool_id in the query results for avg_cpu_time for all months to be in the format tool_name/version
avg_cpu_time_all = pd.read_csv("../unprocessed_toolid/avg_cpu_time_all.txt",
                    delimiter = '|',names = ['tool_id','month_year','avg_cpu_time'],skiprows = 1)
avg_cpu_time_all = avg_cpu_time_all.dropna()
avg_cpu_time_all['tool_id'] = avg_cpu_time_all['tool_id'].str.strip()
avg_cpu_time_all['tool_name_version'] = ''
avg_cpu_time_all['tool_name_version'] = avg_cpu_time_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
avg_cpu_time_all = avg_cpu_time_all.drop(columns = ['tool_id'])
avg_cpu_time_all.to_csv('avg_cpu_time_all.csv')

## Get the tool_id in the query results for avg_memory for all months to be in the format tool_name/version
avg_memory_all = pd.read_csv("../unprocessed_toolid/avgmemory_all.txt",
                    delimiter = '|',names = ['month_year','tool_id','avg_memory'],skiprows = 1)
avg_memory_all = avg_memory_all.dropna()
avg_memory_all['tool_id'] = avg_memory_all['tool_id'].str.strip()
avg_memory_all['tool_name_version'] = ''
avg_memory_all['tool_name_version'] = avg_memory_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
avg_memory_all = avg_memory_all.drop(columns = ['tool_id'])
avg_memory_all.to_csv('avg_memory_all.csv')

## Get the tool_id in the query results for numjobs for May 2021 to be in the format tool_name/version
numjobs_May2021 = pd.read_csv("../unprocessed_toolid/numjobs_May2021.txt",
                    delimiter = '|',names = ['month_year','tool_id','num_jobs'],skiprows = 1)
numjobs_May2021 = numjobs_May2021.dropna() # Removes all the Nan values
numjobs_May2021['tool_id'] = numjobs_May2021['tool_id'].str.strip()
numjobs_May2021['tool_name_version'] = ''
numjobs_May2021['tool_name_version'] = numjobs_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numjobs_May2021 = numjobs_May2021.drop(columns = ['tool_id'])
numjobs_May2021.to_csv('numjobs_May2021.csv')

## Get the tool_id in the query results for numusers for May 2021 to be in the format tool_name/version
numusers_May2021 = pd.read_csv("../unprocessed_toolid/numusers_May2021.txt",
                    delimiter = '|',names = ['month_year','tool_id','num_users'],skiprows = 1)
numusers_May2021 = numusers_May2021.dropna() # Removes all the Nan values
numusers_May2021['tool_id'] = numusers_May2021['tool_id'].str.strip()
numusers_May2021['tool_name_version'] = ''
numusers_May2021['tool_name_version'] = numusers_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numusers_May2021 = numusers_May2021.drop(columns = ['tool_id'])
numusers_May2021.to_csv('numusers_May2021.csv')

## Get the tool_id in the query results for total_cpu_time for May 2021 to be in the format tool_name/version
total_cpu_time_May2021 = pd.read_csv("../unprocessed_toolid/total_cpu_time_May2021.txt",
                    delimiter = '|',names = ['tool_id','month_year','total_cpu_time'],skiprows = 1)
total_cpu_time_May2021 = total_cpu_time_May2021.dropna() # Removes all the Nan values
total_cpu_time_May2021['tool_id'] = total_cpu_time_May2021['tool_id'].str.strip()
total_cpu_time_May2021['tool_name_version'] = ''
total_cpu_time_May2021['tool_name_version'] = total_cpu_time_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
total_cpu_time_May2021 = total_cpu_time_May2021.drop(columns = ['tool_id'])
total_cpu_time_May2021.to_csv('total_cpu_time_May2021.csv')

## Get the tool_id in the query results for total_memory for May 2021 to be in the format tool_name/version
totalmemory_May2021 = pd.read_csv("../unprocessed_toolid/totalmemory_May2021.txt",
                    delimiter = '|',names = ['month_year','tool_id','totalmemory'],skiprows = 1)
totalmemory_May2021 = totalmemory_May2021.dropna() # Removes all the Nan values
totalmemory_May2021['tool_id'] = totalmemory_May2021['tool_id'].str.strip()
totalmemory_May2021['tool_name_version'] = ''
totalmemory_May2021['tool_name_version'] = totalmemory_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
totalmemory_May2021 = totalmemory_May2021.drop(columns = ['tool_id'])
totalmemory_May2021.to_csv('totalmemory_May2021.csv')

## Get the tool_id in the query results for avg_cpu_time for May 2021 to be in the format tool_name/version
avg_cpu_time_May2021 = pd.read_csv("../unprocessed_toolid/avg_cpu_time_May2021.txt",
                    delimiter = '|',names = ['tool_id','month_year','avg_cpu_time'],skiprows = 1)
avg_cpu_time_May2021 = avg_cpu_time_May2021.dropna() # Removes all the Nan values
avg_cpu_time_May2021['tool_id'] = avg_cpu_time_May2021['tool_id'].str.strip()
avg_cpu_time_May2021['tool_name_version'] = ''
avg_cpu_time_May2021['tool_name_version'] = avg_cpu_time_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
avg_cpu_time_May2021 = avg_cpu_time_May2021.drop(columns = ['tool_id'])
avg_cpu_time_May2021.to_csv('avg_cpu_time_May2021.csv')

## Get the tool_id in the query results for avgmemory for May 2021 to be in the format tool_name/version
avgmemory_May2021 = pd.read_csv("../unprocessed_toolid/avgmemory_May2021.txt",
                    delimiter = '|',names = ['month_year','tool_id','avgmemory'],skiprows = 1)
avgmemory_May2021 = avgmemory_May2021.dropna() # Removes all the Nan values
avgmemory_May2021['tool_id'] = avgmemory_May2021['tool_id'].str.strip()
avgmemory_May2021['tool_name_version'] = ''
avgmemory_May2021['tool_name_version'] = avgmemory_May2021.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
avgmemory_May2021 = avgmemory_May2021.drop(columns = ['tool_id'])
avgmemory_May2021.to_csv('avgmemory_May2021.csv')

