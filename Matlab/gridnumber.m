function cord = gridnumber(p)


length = numel(p);
x=zeros(1,length);
y=zeros(1,length);

for i=1:1:length
    x(i)= mod(p(i),10);
    if x(i) == 0;
        x(i)=1900;
    else
        x(i)= ((2*(x(i)-1))+1)*100;
    end
    y(i) = ceil(p(i)/10);
    y(i) = ((2*(y(i)-1))+1)*100;

end

cord = [x' y'];
cord  = sortrows(cord,[-2,1]);
end

