function[is] = rmseTest(fileID)
    fileID;

    a = importdata(fileID);
    a=a.data;
    T = a(:,1);
    C = a(:,2);
    Test=C;
    Pred=C;
    sz = size(C,1);
    m=sz/2;
    month=0;
    for n=1:m
        Test(n)
        Pred(m+n)
        rmsee = sqrt(((Test(n)-Pred(m+n)).^2)/2);

        error = Test(n)- Pred(m+n);
        absolute = abs(error);
        maee = (absolute)/2;
        
        fileID = fopen('C:\Users\User\Documents\MATLAB\demo\เอาจริง\Final\ราคา.txt','a');
        fprintf(fileID,'Price,01-%d-2561,%f,%f,%f,%f\n',month+n,Test(n),Pred(m+n),rmsee,maee);
        ...fprintf(fileID,'%f\t%f\n',rmsee,maee); 
        if mod(n,12)==0
            fprintf(fileID,'\n');
        end
    end
    is=2;
end