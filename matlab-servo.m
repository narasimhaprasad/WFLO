clear;
clc;
% connect the board
a=arduino('COM8');

a.pinMode(5,'OUTPUT');
a.pinMode(3,'OUTPUT');
a.pinMode(2,'INPUT');
a.pinMode(7,'INPUT');
% for j=1:1:2
for i=0:30:180
a.analogWrite(5,i);
a.analogWrite(3,i);
% a.analogRead(2);
% a.analogRead(7);
pause(0.5);
end
for i=180:-30:0
a.analogWrite(5,i);
a.analogWrite(3,i);
pause(0.5);
end
% end
delete(a);

    %   Copyright 2011 The MathWorks, Inc.
