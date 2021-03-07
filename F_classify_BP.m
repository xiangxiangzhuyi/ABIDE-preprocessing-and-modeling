function [train_output_fore,test_output_fore] = F_classify_BP(train_input, train_output, test_input, test_output)
%UNTITLED3 Summary of this function goes here
% this function is about BP algorithm

% to convert the form of the labels
train_output1=F_convert_labels(train_output);
test_output1=F_convert_labels(test_output);
% to construct the net of the BP
net=newff(train_input,train_output1,10); 
net.trainParam.epochs=1000;
net.trainParam.lr=0.1;
net.trainParam.goal=0.00000004;
net.trainParam.max_fail=6;
% to train the BP classifer
net=train(net,train_input,train_output1);
train_output_fore=net(train_input);
% to test the BP classifer
test_output_fore=sim(net,test_input);
end






