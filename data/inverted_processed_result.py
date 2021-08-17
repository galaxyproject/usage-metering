""" invert the processed query results for the purpose of the possible stacked area chart. When new
data arises, you will need to run the process_query_results.py first"""

import pandas as pd

### invert the numusers_all csv file
numusers_all = pd.read_csv('./numusers_all.csv',names = ['month_year','num_users','tool_name_version'],skiprows = 1)
numusers_all = numusers_all.drop_duplicates(['month_year','tool_name_version'])
numusers_all_inverted = numusers_all.pivot(index='month_year', columns='tool_name_version', values='num_users')
numusers_all_inverted = numusers_all_inverted.fillna(0)
numusers_all_inverted.to_csv('numusers_all_inverted.csv')

### invert the numjobs_all csv file
numjobs_all = pd.read_csv('./numjobs_all.csv',names = ['month_year','num_jobs','tool_name_version'],skiprows = 1)
numjobs_all = numjobs_all.drop_duplicates(['month_year','tool_name_version'])
numjobs_all_inverted = numjobs_all.pivot(index='month_year', columns='tool_name_version', values='num_jobs')
numjobs_all_inverted = numjobs_all_inverted.fillna(0)
numjobs_all_inverted.to_csv('numjobs_all_inverted.csv')

### invert the total_cpu_time_all csv file
total_cpu_time_all = pd.read_csv('./total_cpu_time_all.csv',names = ['month_year','total_cpu_time','tool_name_version'],skiprows = 1)
total_cpu_time_all = total_cpu_time_all.drop_duplicates(['month_year','tool_name_version'])
total_cpu_time_all_inverted = total_cpu_time_all.pivot(index='month_year', columns='tool_name_version', values='total_cpu_time')
total_cpu_time_all_inverted = total_cpu_time_all_inverted.fillna(0)
total_cpu_time_all_inverted.to_csv('total_cpu_time_all_inverted.csv')

### invert the totalmemory_all csv file
totalmemory_all = pd.read_csv('./totalmemory_all.csv',names = ['month_year','totalmemory','tool_name_version'],skiprows = 1)
totalmemory_all = totalmemory_all.drop_duplicates(['month_year','tool_name_version'])
totalmemory_all_inverted = totalmemory_all.pivot(index='month_year', columns='tool_name_version', values='totalmemory')
totalmemory_all_inverted = totalmemory_all_inverted.fillna(0)
totalmemory_all_inverted.to_csv('totalmemory_all_inverted.csv')

### invert the avg_cpu_time_all csv file
avg_cpu_time_all = pd.read_csv('./avg_cpu_time_all.csv',names = ['month_year','avg_cpu_time','tool_name_version'],skiprows = 1)
avg_cpu_time_all = avg_cpu_time_all.drop_duplicates(['month_year','tool_name_version'])
avg_cpu_time_all_inverted = avg_cpu_time_all.pivot(index='month_year', columns='tool_name_version', values='avg_cpu_time')
avg_cpu_time_all_inverted = avg_cpu_time_all_inverted.fillna(0)
avg_cpu_time_all_inverted.to_csv('avg_cpu_time_all_inverted.csv')

### invert the avgmemory_all csv file
avgmemory_all = pd.read_csv('./avg_memory_all.csv',names = ['month_year','avgmemory','tool_name_version'],skiprows = 1)
avgmemory_all = avgmemory_all.drop_duplicates(['month_year','tool_name_version'])
avgmemory_all_inverted = avgmemory_all.pivot(index='month_year', columns='tool_name_version', values='avgmemory')
avgmemory_all_inverted = avgmemory_all_inverted.fillna(0)
avgmemory_all_inverted.to_csv('avgmemory_all_inverted.csv')