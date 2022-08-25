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
numjobs_numusers = pd.read_csv('../../psql-main-data/STEP_2_1_export_enumerate/numjobs_numusers.txt',
                                delimiter = '|',names = ['tool_id','num_jobs','num_users'],skiprows = 1)
numjobs_numusers = numjobs_numusers.dropna()
numjobs_numusers['tool_id'] = numjobs_numusers['tool_id'].str.strip()
numjobs_numusers['tool_name_version'] = ''
numjobs_numusers['tool_name_version'] = numjobs_numusers.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
numjobs_numusers = numjobs_numusers.drop(columns = ['tool_id'])
numjobs_numusers.to_csv('2022_new/STEP_3_0_clean_data/numjobs_numusers.csv')

## Get the tool_id in the query results for total_cpu_time vs numjobs to be in the format tool_name/version
# total_cpu_time_numjobs = pd.read_csv('../../psql-main-data/STEP_2_1_export_enumerate/total_cpu_time_numjobs.txt',
#                                 delimiter = '|',names = ['tool_id','total_cpu_time_seconds','num_jobs'],skiprows = 1)
# total_cpu_time_numjobs = total_cpu_time_numjobs.dropna()
# total_cpu_time_numjobs['tool_id'] = total_cpu_time_numjobs['tool_id'].str.strip()
# total_cpu_time_numjobs['tool_name_version'] = ''
# total_cpu_time_numjobs['tool_name_version'] = total_cpu_time_numjobs.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# total_cpu_time_numjobs = total_cpu_time_numjobs.drop(columns = ['tool_id'])
# total_cpu_time_numjobs.to_csv('2022_new/STEP_3_0_clean_data/total_cpu_time_numjobs.csv')

## Get the tool_id in the query results for totalmemory vs numjobs to be in the format tool_name/version
# totalmemory_numjobs = pd.read_csv('../../psql-main-data/STEP_2_1_export_enumerate/totalmemory_numjobs.txt',
#                                 delimiter = '|',names = ['tool_id','num_jobs','consumed_mem_gb','allocated_mem_gb','pct_mem_consumed'],skiprows = 1)
# totalmemory_numjobs = totalmemory_numjobs.dropna()
# totalmemory_numjobs['tool_id'] = totalmemory_numjobs['tool_id'].str.strip()
# totalmemory_numjobs['tool_name_version'] = ''
# totalmemory_numjobs['tool_name_version'] = totalmemory_numjobs.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# totalmemory_numjobs = totalmemory_numjobs.drop(columns = ['tool_id'])
# totalmemory_numjobs.to_csv('2022_new/STEP_3_0_clean_data/totalmemory_numjobs.csv')


## Get the tool_id in the query results for numjobs for all months to be in the format tool_name/version
# numjobs_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/numjobs_all.txt",
#                     delimiter = '|',names = ['month_year','tool_id','num_jobs'],skiprows = 1)
# numjobs_all = numjobs_all.dropna() # Removes all the Nan values
# numjobs_all['tool_id'] = numjobs_all['tool_id'].str.strip()
# numjobs_all['tool_name_version'] = ''
# numjobs_all['tool_name_version'] = numjobs_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# numjobs_all = numjobs_all.drop(columns = ['tool_id'])
# numjobs_all.to_csv('2022_new/STEP_3_0_clean_data/numjobs_all.csv')

# ## Get the tool_id in the query results for numusers for all months to be in the format tool_name/version
# numusers_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/numusers_all.txt",
#                     delimiter = '|',names = ['month_year','tool_id','num_users'],skiprows = 1)
# numusers_all = numusers_all.dropna()
# numusers_all['tool_id'] = numusers_all['tool_id'].str.strip()
# numusers_all['tool_name_version'] = ''
# numusers_all['tool_name_version'] = numusers_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# numusers_all = numusers_all.drop(columns = ['tool_id'])
# numusers_all.to_csv('2022_new/STEP_3_0_clean_data/numusers_all.csv')

# Get the tool_id in the query results for total_cpu_time for all months to be in the format tool_name/version
# total_cpu_time_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/total_cpu_time.txt",
#                     delimiter = '|',names = ['month_year','tool_id','total_cpu_time'],skiprows = 1)
# total_cpu_time_all = total_cpu_time_all.dropna()
# total_cpu_time_all['tool_id'] = total_cpu_time_all['tool_id'].str.strip()
# total_cpu_time_all['tool_name_version'] = ''
# total_cpu_time_all['tool_name_version'] = total_cpu_time_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# total_cpu_time_all = total_cpu_time_all.drop(columns = ['tool_id'])
# total_cpu_time_all.to_csv('2022_new/STEP_3_0_clean_data/total_cpu_time_all.csv')

## Get the tool_id in the query results for totalmemory for all months to be in the format tool_name/version
# totalmemory_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/totalmemory_all.txt",
#                     delimiter = '|',names = ['month_year','tool_id','totalmemory'],skiprows = 1)
# totalmemory_all = totalmemory_all.dropna()
# totalmemory_all['tool_id'] = totalmemory_all['tool_id'].str.strip()
# totalmemory_all['tool_name_version'] = ''
# totalmemory_all['tool_name_version'] = totalmemory_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# totalmemory_all = totalmemory_all.drop(columns = ['tool_id'])
# totalmemory_all.to_csv('2022_new/STEP_3_0_clean_data/totalmemory_all.csv')

## Get the tool_id in the query results for avg_cpu_time for all months to be in the format tool_name/version
# avg_cpu_time_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/avg_cpu_time.txt",
#                     delimiter = '|',names = ['month_year','tool_id','avg_cpu_time'],skiprows = 1)
# avg_cpu_time_all = avg_cpu_time_all.dropna()
# avg_cpu_time_all['tool_id'] = avg_cpu_time_all['tool_id'].str.strip()
# avg_cpu_time_all['tool_name_version'] = ''
# avg_cpu_time_all['tool_name_version'] = avg_cpu_time_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# avg_cpu_time_all = avg_cpu_time_all.drop(columns = ['tool_id'])
# avg_cpu_time_all.to_csv('2022_new/STEP_3_0_clean_data/avg_cpu_time_all.csv')

## Get the tool_id in the query results for avg_memory for all months to be in the format tool_name/version
# avg_memory_all = pd.read_csv("../../psql-main-data/STEP_2_1_export_enumerate/avgmemory_all.txt",
#                     delimiter = '|',names = ['month_year','tool_id','avg_memory'],skiprows = 1)
# avg_memory_all = avg_memory_all.dropna()
# avg_memory_all['tool_id'] = avg_memory_all['tool_id'].str.strip()
# avg_memory_all['tool_name_version'] = ''
# avg_memory_all['tool_name_version'] = avg_memory_all.apply(lambda x: x['tool_name_version'] + getName(str(x['tool_id'])) + "/" + getVersion(str(x['tool_id'])),axis =1)
# avg_memory_all = avg_memory_all.drop(columns = ['tool_id'])
# avg_memory_all.to_csv('2022_new/STEP_3_0_clean_data/avg_memory_all.csv')
