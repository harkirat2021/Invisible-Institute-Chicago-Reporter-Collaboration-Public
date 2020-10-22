# Checkpoint 2: Data Visualization

## Important Info

For this checkpoint, we needed to build and train a machine learning model to classify the complaints and the categories to which they belong. To this end, we put together code for building a bad of embeddings model and BERT transformer model with the AllenNLP framework, as well as how to pull down the necessary code, clean it, and prepare it for training the models. The code and instructions for doing that are contained in the `src/complaint_classifcation` directory.

Some of the visualizations we produce make use of the output from these classification models. We have included the classification results within that directory (entitled `uncategorized_results_boe.json` and `uncategorized_results_bert.json` for the bag of embeddings and BERT classifiers respectively). A detailed description of how we completed that entire process is including in the `findings.pdf` for this checkpoint. 


## Questions and How to View the Answers

To view the visualizations simply:
* open terminal and navigate to checkpoint 2 source file (e.g. checkpoint-2/src)
* start a python server with the following command: `python3 -m http.server`
* open a web browser and cut and paste the following URL: http://0.0.0.0:8000/

This will display the contents of the source directory in the web browser. Now simply click the visualization you want to view.

### Question 1: Horizontal bar chart to visualize the distribution of complaints

TBD: How to view this

### Question 2: Stacked bar chart to visualize which category has the most uncategorized complaints, and what types of uncategorized complaints

TBD: How to view this

### Quesiton 3: Line chart to visualize the percentage of uncategorized complaints (year over year)

TBD: How to view this
