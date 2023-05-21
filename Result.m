%% 
% 
%% 0 Data Preparation

% change path
path = matlab.desktop.editor.getActiveFilename;
path = erase(path,'2nd_Exp - Result.mlx'); % if you change the filename, modify this line
cd(path)

% load data
resultTable = readtable('test_results - cleaned and structured.csv');
%% 1 Independent Variables

% convert nominal columns into categorical data type

% Participant_Information
resultTable.Gender = categorical(resultTable.Gender);
resultTable.AgeGroup = categorical(resultTable.AgeGroup);
resultTable.HourSpent = categorical(resultTable.HourSpent);
resultTable.Hand = categorical(resultTable.Hand);

% Stimulus_Information
resultTable.StemMood = categorical(resultTable.StemMood);

% Condition_Information
%resultTable.Condition = categorical(resultTable.Condition);
resultTable.CondNum = categorical(resultTable.CondNum);
%% 2 Dependent Variables - PressedKey

% PressedKey, F (yes) = 1, J (no) = 0
% 2.1 PressedKey - Descriptive Statistics

% Descriptive Statistics

% Data Summary of categorical data: Mode

keyMode = groupsummary(resultTable, 'Condition','mode', 'PressedKey')
%% 
% The |groupsummary| function draws data from the csv table |resultTable|, and 
% then find |mode| values of |PressedKey| grouped by |Condition|.
% 
% 
% 
% Data Summary: Mode - Descritpion
% 
% control: mode = 1  
%% 
% * e.g the stimulus "สวย" was displayed, most participants pressed 'F', implying 
% they thought the stimulus item conveys its literal meaning ("สวย").
%% 
% emoji ambiguous: mode = 1
%% 
% * e.g the stimulus "สวย (emoji ambiguous)" was displayed, most participants 
% pressed 'F', implying they thought the stimulus item conveys its literal meaning 
% ("สวย"). 
%% 
% emoji irony: mode = 0 
%% 
% * e.g the stimulus "สวย (emoji irony)" was displayed, most participants pressed 
% 'J',  implying they thought the stimulus item conveys its opposite meaning ("ไม่สวย").
%% 
% linguistic ambiguous: mode = 1
%% 
% * e.g the stimulus "ส๊วยยสวย" was displayed, most participants pressed 'F', 
% implying that they thought the stimulus item conveys its literal meaning ("สวย").
%% 
% linguistic irony: mode = 0
%% 
% * e.g the stimulus "สวยบ้านแกสิ" was displayed, most participants pressed 
% 'J',  implying they thought the stimulus item conveys its opposite meaning ("ไม่สวย").
% Bar Chart - Percantage Counts of Key 'J' [0] Pressed on Each condition

% Plot a bar chart of count of key 'J' pressed (0, the stimulus conveys its opposite meaning)

% Extract the unique condtions 
uniqCond = unique(resultTable.Condition);

% Create empty arrays for storing how many times each key is opted on each condition 
Press1 = nan(1, length(uniqCond));
Press0 = nan(1, length(uniqCond));

% Create empty arrays for storing, of each condition, total number of keys pressed and sum of times when key 'F' is pressed, respectively 
Total = nan(1, length(uniqCond));
SumOfF = nan(1, length(uniqCond));

% Calculate for how many times each key is opted on each condition  
for i = 1:height(uniqCond) % i means each Condition
    key = resultTable.PressedKey(strcmp(resultTable.Condition, uniqCond{i})); % logical indexing both keys pressed on each condition
    Total(i) = length(key); % storing a total number of both pressed keys per condition
    SumOfF(i) = sum(key); % summation of 1 in the variable 'total' shows counts of Key-'F' pressed
    Press1(i) = (SumOfF(i)/Total(i))*100; % store in the array 'Press1' the percentage count of Key 'F' pressed
    Press0(i) = ((Total(i) - SumOfF(i))/Total(i))*100; % store in the array 'Press0' the percentage count of Key 'J' pressed
end

%for i = 1:height(uniqCond) % i means each Condition
%    key = resultTable.PressedKey(strcmp(resultTable.Condition, uniqCond{i})); % logical indexing both keys pressed on each condition
%    total = length(key); storeTotal(i) = total; % storing a total number of both pressed keys per condition
%    P1 = sum(key); storeSumOfF(i) = P1; % summation of 1 in the variable 'total' shows counts of Key-'F' pressed
%    Press1(i) = (P1/total)*100; % store in the array 'Press1' the percentage count of Key 'F' pressed
%    Press0(i) = ((total - P1)/total)*100; % store in the array 'Press0' the percentage count of Key 'J' pressed
%end    

% Sorting the result
X = categorical(uniqCond');
X = reordercats(X,{'linguistic irony','emoji irony', 'linguistic ambiguous','emoji ambiguous', 'control'});

% Data Visualization
b = bar(X, round(Press0,1));
xtips = b.XEndPoints;
ytips = b.YEndPoints;
ylim([0 105])
labels = string(b.YData);
text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')

b.FaceColor = 'flat';
b.CData(2,:) = [0.3010 0.7450 0.9330];

title('Percentage Counts of Pressing "J" by Condition')
ylabel('Percentage')
grid on

% Note
    % more specific with each condition, percentage relative frequency

% 2.2 PressedKey - Inferential Statistics 

% Logistic Regression

% Logistic Regression

% Note
    % random effect: ItemID, PartID
    % compare: emoji irony and linguistic irony

% baseline: negative, control, man, 16-25 
%modelspec = 'PressedKey ~ Condition + Gender + AgeGroup' ;
modelspec = ['PressedKey ~ (StemMood * Condition) + StemFreq + Gender + AgeGroup + HourSpent + Hand'] ;
mdl = fitglm(resultTable,modelspec,'Distribution','binomial')
                
% Mixied-Effect Logistic Regression

% mixed-effect Logistic regression

mdlN = fitglme(resultTable, ['PressedKey ~ (StemMood * Condition) + StemFreq + Gender + AgeGroup + HourSpent + Hand' ...
    '+ (1|PartID) + (1|ItemID) + (1+StemFreq|ItemID)'], 'Distribution','Binomial')
                
%% 3 Dependent Variable - ReactionTime 
% 3.1 ReactionTime  - Descriptive Statistics
%% 
% * Key "J" pressed - think that the stimulus item implies its opposite meaning

% Extract the reaction time values and their condition where Key-0 is opted  
x = resultTable.PressedKey == 0;
y = resultTable.ReactionTime(x);
x1 = resultTable.Condition(x);

% Build a new table containing the reaction time data and their condition | Key-0 is pressed
clear T
T.ReactionTime = y;
T.Condition = x1;
tbl = struct2table(T);

% Data Summary: Median
rtMedian0 = groupsummary(tbl, 'Condition','median', 'ReactionTime')
% Violin Plot - Reaction Time of Pressing "J" on Each Condition

% Data Visualization

%violinplot
figure; hold on;
% plot a swarm plot
s = swarmchart(categorical(tbl.Condition), tbl.ReactionTime);
s.MarkerEdgeAlpha = 0.5; % set transparency of scatter points
% plot a box plot on top
b = boxchart(categorical(tbl.Condition), tbl.ReactionTime, "Notch","on");
b.BoxFaceColor = 'k'; % set color of box
b.BoxFaceAlpha = 0.4; % set transparency of box
b.BoxWidth = 0.4; % set box width
b.WhiskerLineColor = 'k'; % set whisker line color
b.MarkerStyle = '*'; % set outlier symbols
b.MarkerColor = 'k'; % set outlier symbol color
ylabel("Reaction time (ms)")
ylim([50 5500])
title('Violin plot of Reaction Time of Pressing "J" on Each Condition')
%set(gca,'FontSize',16); % set font size
grid on
                
%figure;
%boxchart(categorical(tbl.Condition), tbl.ReactionTime, "Notch","on")
%ylabel("Reaction time (ms)")
%ylim([50 5500])
%title('Box Chart of Reaction Time of Pressing "J" on Each Condition')
%grid on

% 3.2 ReactionTime  - Inferential Statistics
% Linear Regression

% fit linear regression

testmdl1 = 'ReactionTime ~ (Condition * StemMood) + StemFreq + Gender + AgeGroup + HourSpent + Hand';
%testmdl1 = 'ReactionTime ~ StemFreq * StemMood * Condition * Gender * AgeGroup + HourSpent';
%testmdl1 = 'ReactionTime ~ StemFreq + StemMood + Condition + Gender + AgeGroup + HourSpent';

mdl1 = fitlm(resultTable, testmdl1)
% Mixed-Effect Linear Regression

% mixed-effect linear regression
mdlNull = fitlme(resultTable,['ReactionTime ~ (Condition * StemMood) + StemFreq + Gender + AgeGroup + HourSpent ' ...
    '+ (1|PartID) + (1|ItemID) + (1+StemFreq|ItemID) + (1+Condition|PartID)'])
