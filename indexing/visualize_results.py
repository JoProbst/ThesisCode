import matplotlib.pyplot as plt
import pandas as pd
import glob

# Get a list of all CSV files
files = glob.glob('results/*.csv')

# Create an empty DataFrame
df = pd.DataFrame()

# Loop over the files
for file in files:
    # Read the CSV file
    df_file = pd.read_csv(file)

    # Append the data to the DataFrame
    df = df.append(df_file)

# Filter the dataframe for each judgement
for judgement in df['judgement'].unique():
    df_judgement = df[df['judgement'] == judgement]

    # Create a new figure
    plt.figure(figsize=(10, 6))

    # Create a bar chart for each metric
    for metric in ['ndcg@10', 'map', 'bpref']:
        plt.subplot(1, 3, ['ndcg@10', 'map', 'bpref'].index(metric) + 1)
        df_judgement.groupby('name')[metric].mean().plot(kind='bar', title=f'{metric}')
        plt.ylim(0, 1)
        plt.yticks([0, 0.2, 0.4, 0.6, 0.8, 1])
        plt.ylabel(judgement)
        plt.xlabel('Retrieval method')


    # Show the plot
    plt.tight_layout()
    plt.savefig(f'results/{judgement}.png')