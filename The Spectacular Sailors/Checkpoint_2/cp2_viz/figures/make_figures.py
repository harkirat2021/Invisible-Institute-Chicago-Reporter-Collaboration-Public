import plotly.graph_objs as go

class PlotData:

    def __init__(self, datafile):
        self.datafile = datafile

    def to_plot(self):
        df = self.datafile

        # fig = go.Scatter(df.query('detected_crew==Yes'), x='years_on_force', y='index_value', size='index_value')

        data_plot = go.Scatter(
            x=df.index_value,
            y=df.years_on_force,
            mode='markers',
            marker=dict(
                size=df.index_value * 30,
                color=df.index_value
            ),
            # marker_size=df.index_value * 30,
            text='Community ID: ' + df['community_id'].astype(str)
            # hover_name=df.community_id
        )

        fig = go.Figure(data=[data_plot])

        fig.update_layout(
            title='Police Officer Communities and Crews',
            xaxis=dict(
                title='Index Value of Community (Where 1.0 means strong likelihood of Crew Status)'),
            yaxis=dict(
                title='Average Years on Force for Officers in a Community'))

        fig.show()



        # df.community_id = 'Community ID' + df['community_id'].astype(str)

        # print(df.community_id)





