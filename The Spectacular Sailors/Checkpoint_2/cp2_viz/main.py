from get_data import get_data
from figures.make_figures import PlotData


if __name__ == '__main__':


    """
    Plot for crews
    """
    cols = ['id', 'community_id', 'member_count', 'years_on_force',
               'current_age', 'index_value', 'detected_crew',
               'currently_active', 'total_payouts']

    csv_reader = get_data.CsvReader('data_crew.csv')
    df_crews = csv_reader.to_dataframe(index_col=0, usecols=cols)
    # df = df[df.detected_crew == 'Yes']
    PlotData(df_crews).plot_crews()
    """
    Plot for crews
    """

    ## plot for officers
    csv_reader = get_data.CsvReader('officers_crews_data.csv')
    df_officers = csv_reader.to_dataframe(index_col=0)

    ## send to clean_data when ready
    # remove leading 'C' from CRID field.
    # df_officers.crid = df_officers['crid'].str.replace('C','')
    cols = ['id', 'gender', 'race',	'appointed_date', 'active',	'complaint_percentile',
            'civilian_allegation_percentile', 'last_unit_id', 'crid']
    # df_officers.drop_duplicates(subset=cols, keep='last', inplace=True)

    cols = ['crid', 'disciplined']
    df_officers.dropna(subset=cols, axis=0, inplace=True)
    df_officers.to_csv('test.csv')
    ## cleaning here ^^


    PlotData(df_officers).plot_officers()


    







