# IronicImpExp---Data-Analysis
performing statistical analyses on the data collected from the experiment using MATLAB

## Data Processing
After obtaining the raw result data (.csv file) from the experiment, the data is processed using MS Excel:
1) the unrelated and unnecessary columns were excluded while the related and significant variables their and values were retained. 
2) each of the ReactionTime values was calculated by subtracting the timestamp when a stimulus and its question were presented on the screen from the timestamp when a key was pressed to answer the question. 
3) the values in PressedKey variable, originally character values, “F”s for answering Yes (conveying a stimulus' literal meaning) and “J”s for answering No (conveying the stimulus' opposing meaning) then were replaced by integer values 1s and 0s respectively.
4) the dataset finally was sorted ascendingly by the Condition Number.

## Data Analyses
Statistical analyses were performed on both dependent variables of this experiment: Judgement (on ironic implicature of a stimulus phrase) and Reaction Time (an amount of time taken for making the judgement). 

The dependent variable Judgement, considered as a categorical and nominal-scale variable, has two values: Yes or No. For measure of centrality, the mode of the judgement values of each condition were measured to give a summary about the most frequential judgement of the data. For inferential statistics, Logistic regression and mixed-effect Logistic regression were also calculated to compare and to form a model which best fits the outcome data.

Reaction Time is a continuous and ratio-scale variable. Each of the Reaction Time values are in the range of the positive realnumbers. To give descriptive summaries of the reaction time data, the means and medians (of the RT values) on each condition were calculated (as numeric measurements of centrality), and the standard deviation is also measured as numeric measurements of variance. Multiple linear regression and mixed-effect linear regression were also conducted to make a model which best fits the data.
