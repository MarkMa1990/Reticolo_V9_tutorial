% this file is initially a copy of Reticolo V9 package
% modifications are made to simulate a silver gratings on top of glass
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CROSS-SECTION-VIEW
%
%   AIR     (1.0)
%---------------------------------------------------------
%   200nm width Silver gratings of 700nm height
%---------------------------------------------------------
%   GLASS   (1.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   TRANSVERSE-VIEW
%
%'|', periodic boundary
%'----',200 nm width, air
%'####',200 nm width, silver
% the width in Y direction is 400 nm
%
%||||||||||||||
%|----####----|
%|----####----|
%|----####----|
%|----####----|
%||||||||||||||
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
pd0x = 6;
pd0y = 4;
h0 = 7;

LD=6.17;% longueur d'onde, wavelength
D=[pd0x,pd0y];% period in X and Y

silver = importdata('E:\papers_datas\songqiang\RCWA\RCWA_FDTD\silver.txt');

teta0=0;nh=1;ro=nh*sin(teta0*pi/180);
delta0=0;
parm=res0;parm.not_io=1;
parm.sym.x=0;parm.sym.y=0;parm.sym.pol=1;% utilisation de 2 symetries
%parm.res1.trace=1; % tr1ace des textures


nn=[6,6];% ordres de fourier 

% description des textures
textures{1}= 1;   
textures{2}= 1.5  ; 

% initialisation
%aa=res1(LD,D,textures,nn,ro,delta0,parm);
% definition du profil et calcul de la diffraction (on ne fait ce calcul qu'une fois)
figure;
t=[];epaisseur=[];tsum=[];
for h=linspace(4.5,7.0,160);
    
    LD=h;% longueur d'onde
    
    index_silver_real = interp1(silver(:,1),silver(:,2),h/10.0);
    index_silver_imag = interp1(silver(:,1),silver(:,3),h/10.0);
    
    textures{3}={ 1.0   ,  [0, 0, 2, 4, index_silver_real+index_silver_imag*j, 1]     };
    aa=res1(LD,D,textures,nn,ro,delta0,parm);

    profil={[0,h0,0] ,[1,3,2]};
    ef=res2(aa,profil);
     % TE diffractee en bas dans l'ordre 0 
    tsum_cal = sum(ef.TEinc_top_transmitted.efficiency_TE);
    tsum=[tsum,tsum_cal];
    t=[t,ef.TEinc_top_transmitted.efficiency_TE{0}];
    %t=[t,ef.TEinc_top_transmitted.amplitude_TE{0}];
    epaisseur=[epaisseur,h];
    plot(epaisseur,tsum,'b-','LineWidth',2);xlabel('epaisseur');ylim([0,1]);ylabel('transmission dans l''ordre 0');title('VARIATION DE LA TRANSMISSION DANS L''ORDRE 0 FONCTION DE L''EPAISSEUR');pause(eps);
end

x_fdtd = importdata('E:\papers_datas\songqiang\RCWA\RCWA_FDTD\fdtd.txt');
figure;
plot(epaisseur*1e2,tsum,'b-','LineWidth',2);
hold on;
plot(x_fdtd.data(:,1)*1e9,x_fdtd.data(:,2),'r.');
legend('FDTD Lumerical','RCWA Reticolo V9');
xlabel('Wavelength(nm)');
ylabel('transmission');
ylim([0,1]);
