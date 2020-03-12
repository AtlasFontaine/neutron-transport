clc
clear all

h=input('Enter mesh size: ');
N=10/h;
sigma=1;
S=input('Enter S for Sn approximation: ');

%%For S2
w2=[1 1];
mu2=[1/sqrt(3) -1/sqrt(3)];

%%For S4
w4=[0.6521 0.3479 0.3479 0.6521];
mu4=[0.3399 0.8611 -0.8611 -0.3399 ];

%%For S8
w8=[0.3627 0.3137 0.2224 0.1012 0.1012 0.2224 0.3137 0.3627];
mu8=[0.1834 0.5255 0.7967 0.9603 -0.9603 -0.7967 -0.5255 -0.1834];

psi_p=[];
psi_n=[];
psi_n(N+1)=2;
psi_p(1)=2;

if S==2;
    mu=mu2;
    w=w2;
elseif S==4
    mu=mu4;
    w=w4;
elseif S==8;
    mu=mu8;
    w=w8;
end                                                                                                                                     
    
t=zeros(S,N+1); %This will gather all vectors in a matrix    
for j=1:S
    if mu(j)>0
        for i=1:N
            psi_p(i+1)=((mu(j)-(sigma*h/2))/(mu(j)+(sigma*h/2)))*psi_p(i);
        end
        t(j,:)=psi_p;
    end
    if mu(j)<0
        for i=N+1:-1:2
            psi_n(i-1)=((-mu(j)-(sigma*h/2))/(-mu(j)+(sigma*h/2)))*psi_n(i);
        end
        t(j,:)=psi_n;
    end
    current(j,:)=mu(j)*w(j)*min(t(j,:));
end

j_p=sum(current(1:S/2,:));
j_n=-j_p;

meanflux_p=mean(t(1:S/2,:));
meanflux_n=mean(t(S/2+1:S,:));

if S==2
    meanflux_p=t(1,:);
    meanflux_n=t(2,:);
end
    
x=0:h:10;
plot(x,meanflux_p)
hold on
plot(x,meanflux_n)
title('Flux vs x')
ylabel('Flux (n/s.cm^2)')
xlabel('x (cm)')

display(sprintf('The current at x=0 is %d and at x=10 is %d',j_n,j_p))