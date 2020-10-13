from get_data import get_data
from figures.make_figures import PlotData


if __name__ == '__main__':

    columns = ['id', 'community_id', 'member_count', 'years_on_force',
               'current_age', 'index_value', 'detected_crew',
               'currently_active', 'total_payouts']

    csv_reader = get_data.CsvReader('data_crew.csv')

    df = csv_reader.to_dataframe(index_col=0, usecols=columns)

    # df = df[df.detected_crew == 'Yes']

    PlotData(df).to_plot()





