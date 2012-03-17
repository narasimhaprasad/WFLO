function [MAXITER,solu,xbest,f,fsol] = modIths(N,umin,umax,object)
% object = @uwflo;

tic;
%% ITHS PARAMETER INITIALIZATION
MS=10;
MCR=0.99;
PARMI=0;
PARM=1;
MAXITER=2000;
%--------------------END OF INITIALIZATION----------------------------------
MAXT=1;
%%
%% --------STEP2:INITIALIZE HARMONY MEMORY----------------------------------
for t=1:1:1
    x=zeros(1,N);
    HM=zeros(MS,N+1);
    for trial=1:MAXT
        for hms=1:1
            for popu=1:1
                i=0;
                while( i < MS(hms))
                    i=i+1;
                    %FOR RANDOMLY GENERATING THE N variables
                    for j=1:N
                        HM(i,j)=(umin(j) + int16((umax(j)-umin(j))*rand));
                        
                    end
                end
                for i=1:MS(hms)
                    x=HM(i,1:N);
                    HM(i,N+1)=object(x);
                end
                HM1=HM;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [hmin,hmin_num]=min(HM(:,N+1));
                xbest=HM(hmin_num,1:N);
                [hmax,hmax_num]=max(HM(:,N+1));
                xworst=HM(hmax_num,1:N);
                %         %-------HARMONY IMPROVMENT-------------------------------------------------
                iter=1;
                while(iter <= MAXITER)
                    PAR=PARM-((PARM -PARMI)*(iter)/(MAXITER));
                    HMmean=mean(HM);
                    %SELECTION OF N SOLUTION VECTORS
                    for j=1:N
                        %RANDOM SELECTION
                        if(rand >= MCR(popu))
                           x(j)=(umin(j) + int16((umax(j)-umin(j))*rand));    
                        else
                            %HARMONY MEMORY SEARCHING
                            d=int16((MS(hms)-1)*rand)+1;
                            m=int16(1+(N-1)*rand);
                            y=HM(d,j);
                            x(j)=y;
                            % PITCH ADJUSTMENT
                            
                            if(rand<=PAR)
                                bm =(xbest(j)-y);
                                bc=(xworst(j)-y);
                                %innovative reference generator for values of different range
                                delta=(xbest(m)-umin(m))/(umax(m)-umin(m));
                                xbestnew=umin(j)+delta*(umax(j)-umin(j));
                                
                                if(HM(d,N+1)<=HMmean(N+1))
                                    if(rand>=0.5)
                                        y=xbest(j)+int16(bm*rand);
                                    else
                                        y=xbest(j)-int16(bc*rand);
                                    end
                                    
                                else
                                    bi=xbestnew-y;
                                    if(rand>=0.5)
                                        y=HMmean(j)+int16(bi*rand);
                                    else
                                        y=int16(xbestnew);
                                    end
                                end
                                if((y<=umax(j))&&(umin(j)<=y))
                                    x(j)=(y);
                                end 
                            end
                        end
                    end
%STEP 3 ------------UPDATE HM-----------------------------------------------------

                  value=object(x);
               %REPLACE THE WORST SOLUTION WITH SOL
               if(value<=hmax)
                   HM(hmax_num,1:N)=x;
                   HM(hmax_num,N+1)=value;
               end
                    [hmin,hmin_num]=min(HM(:,N+1));
                    xbest=HM(hmin_num,1:N);
                    [hmax,hmax_num]=max(HM(:,N+1));
                    xworst=HM(hmax_num,1:N);
                    solu(trial,iter)=hmin;
                    iter =iter+1;
                end
                fsol(trial)=hmin;
                x1=HM(hmin_num,1:N);
                f(trial,1:N)= x1;
            end
        end
        ALLSOLU(trial+(t-1)*MAXT,1:N)=f(trial,1:N);
        ALLSOLU(trial+(t-1)*MAXT,N+1)=fsol(trial); 
    end
end