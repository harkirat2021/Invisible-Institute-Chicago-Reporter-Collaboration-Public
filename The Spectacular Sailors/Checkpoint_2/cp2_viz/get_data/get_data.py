import pandas as pd
import os

class CsvReader():
    def __init__(self, filename):
        self.filename = filename
        self.path = os.environ['PWD'] + os.sep + os.sep.join(['data', filename])

    def to_dataframe(self, index_col=None, usecols=None):
        df = pd.read_csv(self.path, index_col=index_col, usecols=usecols)
        return df

# data_folder = Path('The Spectacular Sailors/Checkpoint_2/cp2_viz/data')