import matplotlib.pyplot as plt
import numpy as np
import re
import statistics

def pre_process_data(time_data_path):
    data = open(time_data_path, 'r').readlines()
    times = {}
    benchmark = ""
    regex = re.compile('(\d{1,})m(\d{1,2}.\d{3})s')
    user, sys = 3, 5
    for line in data:
        values = line.split()
        if len(values) <= 1:
            benchmark = values[0]
            if benchmark not in times.keys():
                times[benchmark] = []
        else:
            match_user_time = regex.match(values[user])
            user_time = float(match_user_time.group(1))*60 + float(match_user_time.group(2))
            match_sys_time = regex.match(values[sys])
            sys_time = float(match_sys_time.group(1))*60 + float(match_sys_time.group(2))
            times[benchmark].append(user_time + sys_time)
    return times

def plot_times(benchmark, noaot, aot):
    plt.title(benchmark)
    x = range(len(noaot))
    plt.scatter(x, aot, marker='^', c='blue', label="AOT/Cache")
    plt.scatter(x, noaot, marker='o', c='orange', label="No AOT/No Cache")
    plt.legend()
    plt.xlabel('Iteration')
    plt.ylabel('Execution time (seconds)')
    plt.show()

def plot_scatter_times(not_aot_file, aot_file, benchmark=None):
    noaot = pre_process_data(not_aot_file)
    aot = pre_process_data(aot_file)
    if benchmark:
        plot_times(benchmark, noaot[benchmark], aot[benchmark])
    else:
        for b in noaot.keys():
            plot_times(b, noaot[b], aot[b])

def plot_medians(not_aot_file, aot_file):
    noaot = pre_process_data(not_aot_file)
    aot = pre_process_data(aot_file)
    median_not_aot = []
    median_aot = []
    for b in noaot.keys():
        median_not_aot.append(statistics.median(noaot[b]))
        median_aot.append(statistics.median(aot[b]))

    fig, ax = plt.subplots()
    index = np.arange(len(noaot.keys()))
    bar_width = 0.35
    opacity = 0.8

    rects1 = plt.bar(index, median_not_aot, bar_width,
                     alpha=opacity,
                     color='orange',
                     label='No AOT/No Cache')

    rects2 = plt.bar(index + bar_width, median_aot, bar_width,
                     alpha=opacity,
                     color='blue',
                     label='AOT/Cache')

    plt.xlabel('Benchmark')
    plt.ylabel('Execution time (seconds)')
    plt.title('Median execution time')
    plt.xticks(index + bar_width, noaot.keys(), rotation='vertical')
    plt.legend()

    plt.tight_layout()
    plt.show()

# Plot scatter plots for all benchmarks and execution times
# plot_scatter_times('./not_aot_sleep.txt', './aot_sleep.txt')

# Plot scatter plot for a specific benchmark
# plot_scatter_times('./not_aot_sleep.txt', './aot_sleep.txt', 'h2')

# Plot median bar chart
plot_medians('./not_aot_sleep.txt', './aot_sleep.txt')

