% altim_L2_adriano_caversan.m
% Resolucao dos exercicios 1-5 da Lista 2 - Altimetria de Satelite
% Adriano Caversan - IOF 834 - 2026
%
% Dados: CMEMS L3 along-track (SEALEVEL_GLO_PHY_L3_NRT_008_044)
%   ADT : al, c2n, h2b, s3a, s3b, s6a-hr, swon (7 satelites)
%   SWH/WIND: al, c2, cfo, h2b, j3, s3a, s3b, s6a, swon (9 satelites)
%   Periodo: fevereiro e agosto de 2025
%   Regiao : Atlantico Sul, costa brasileira (lat -20 a 0, lon -45 a -20)

clear all; close all; clc

% ================================================================
%  CONFIGURACOES GERAIS
% ================================================================

path_plots  = 'plots/';
path_proc   = 'processed-data/';
path_adt    = [path_proc 'grafs_tabs_adt/'];
path_swh    = [path_proc 'grafs_tabs_swh/'];
path_wnd    = [path_proc 'grafs_tabs_wnd/'];
path_correl = [path_proc 'correl/'];
dp          = 'data/';

for p = {path_plots,[path_plots 'ex1'],[path_plots 'ex2'], ...
         [path_plots 'ex3'],[path_plots 'ex4'],[path_plots 'ex5'], ...
         path_proc, path_adt, path_swh, path_wnd, path_correl}
    if ~exist(p{1},'dir'), mkdir(p{1}); end
end

latmin=-20; latmax=0; lonmin=-45; lonmax=-20;

ano_ref=2025; ano='2025'; time_orig=datenum(ano_ref,1,1);
buf=3;
fev_ini=31-buf; fev_fim=58+buf;
ago_ini=212-buf; ago_fim=242+buf;
fev_p1=31; fev_p2=58;
ago_p1=212; ago_p2=242;

dlon=5; dlat=5;
longrid_vec=lonmin:dlon:lonmax;
latgrid_vec=latmin:dlat:latmax;
nulon=length(longrid_vec); nulat=length(latgrid_vec); nugrid=nulon*nulat;

% Parametros OI Gauss-Markov - iguais ao professor
rcx=50000; rcy=50000; rct=2;
b=3.34/sqrt(rcx^2+rcy^2);
rcx2=rcx*rcx;
rcy2=rcy*rcy;
RT=6378135.59;
conv=pi/180;
dt_interp=0.5;

% Pontos selecionados para exercicios 4 e 5
pto1=9;   % lon=-35, lat=-15
pto2=22;  % lon=-30, lat=-5
ptos_arr=[pto1,pto2];

% Arquivos ADT (7 satelites)
arq_adt={
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_al-l3-duacs_PT1S_1780198689221.csv'],   'al',   true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_c2n-l3-duacs_PT1S_1780198485791.csv'],  'c2n',  true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_h2b-l3-duacs_PT1S_1780198580641.csv'],  'h2b',  true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_s3a-l3-duacs_PT1S_1780198742773.csv'],  's3a',  true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_s3b-l3-duacs_PT1S_1780198813016.csv'],  's3b',  true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_s6a-hr-l3-duacs_PT1S_1780198848181.csv'],'s6a', true;
    [dp 'cmems_obs-sl_glo_phy-ssh_nrt_swon-l3-duacs_PT1S_1780201217867.csv'], 'swon', false;
};
numsats_adt=size(arq_adt,1);

% Arquivos SWH/WIND (9 satelites)
arq_swh={
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_al-l3_PT1S_1780196685206.csv'],  'al';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_c2-l3_PT1S_1780196492906.csv'],  'c2';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_cfo-l3_PT1S_1780196447959.csv'], 'cfo';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_h2b-l3_PT1S_1780196599442.csv'], 'h2b';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_j3-l3_PT1S_1780196646674.csv'],  'j3';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_s3a-l3_PT1S_1780196729731.csv'], 's3a';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_s3b-l3_PT1S_1780196757764.csv'], 's3b';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_s6a-l3_PT1S_1780196863288.csv'], 's6a';
    [dp 'cmems_obs-wave_glo_phy-swh_nrt_swon-l3_PT1S_1780196915034.csv'],'swon';
};
numsats_swh=size(arq_swh,1);

fprintf('Configuracoes carregadas.\n\n');

% ================================================================
%% EXERCICIO 1: Regiao de estudo e grade regular
% ================================================================
fprintf('=== EXERCICIO 1: Regiao e grade ===\n');

grade=zeros(nugrid,4);
ng=0;
for nlat=1:nulat
    for nlon=1:nulon
        ng=ng+1;
        grade(ng,:)=[ng, longrid_vec(nlon), latgrid_vec(nlat), 1];
    end
end
longrid=grade(:,2); latgrid=grade(:,3); codgrid=grade(:,4);

fid=fopen([path_proc 'grid_tracks_adt.dat'],'w'); fprintf(fid,'%6i %10.4f %10.4f %6i\n',grade'); fclose(fid);
fid=fopen([path_proc 'grid_tracks_swh.dat'],'w'); fprintf(fid,'%6i %10.4f %10.4f %6i\n',grade'); fclose(fid);
fid=fopen([path_proc 'grid_tracks_wnd.dat'],'w'); fprintf(fid,'%6i %10.4f %10.4f %6i\n',grade'); fclose(fid);

longrid2=reshape(longrid,nulon,nulat);
latgrid2=reshape(latgrid,nulon,nulat);

figure
fill([lonmin lonmax lonmax lonmin lonmin],[latmin latmin latmax latmax latmin],[0.85 0.92 1.0])
hold on
plot(longrid,latgrid,'rx','MarkerSize',12,'LineWidth',2)
for ng=1:nugrid
    text(longrid(ng)+0.3,latgrid(ng)+0.3,num2str(ng),'FontSize',8,'Color','r')
end
plot(longrid(pto1),latgrid(pto1),'bs','MarkerSize',14,'LineWidth',2,...
     'DisplayName',['Pto1 (' num2str(longrid(pto1)) 'W,' num2str(latgrid(pto1)) 'S)'])
plot(longrid(pto2),latgrid(pto2),'g^','MarkerSize',14,'LineWidth',2,...
     'DisplayName',['Pto2 (' num2str(longrid(pto2)) 'W,' num2str(latgrid(pto2)) 'S)'])
legend('Location','southeast','FontSize',9)
grid on
axis([lonmin-3 lonmax+3 latmin-3 latmax+3])
xlabel('LONGITUDE','FontSize',12); ylabel('LATITUDE','FontSize',12)
title(['REGIAO DE ESTUDO - ATLANTICO SUL | Grade ' num2str(nulon) 'x' num2str(nulat)],'FontSize',12)
print('-dpng',[path_plots 'ex1/regiao_grade']); close

fprintf('  Grade %dx%d=%d pontos. Figura salva em plots/ex1/\n',nulon,nulat,nugrid);

% ================================================================
%% EXERCICIO 2: Selecao de dados along-track (Fev e Ago 2025)
% prog01process_tracks equivalente
% ================================================================
fprintf('\n=== EXERCICIO 2: Selecao de dados along-track ===\n');

fprintf('\n--- ADT (7 satelites) ---\n');

% Figuras combinadas: todos os satelites, fevereiro e agosto separados
fig_adt_fev=figure; hold on
title('TRAJETORIAS ADT - todos satelites - Fevereiro 2025','fontsize',11)
xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
axis([lonmin lonmax latmin latmax]); grid on

fig_adt_ago=figure; hold on
title('TRAJETORIAS ADT - todos satelites - Agosto 2025','fontsize',11)
xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
axis([lonmin lonmax latmin latmax]); grid on


for isat=1:numsats_adt
    nome=arq_adt{isat,2}; arq=arq_adt{isat,1}; tem_mdt=arq_adt{isat,3};
    fprintf('  %s... ',upper(nome));
    T=readtable(arq,'CommentStyle','#','Delimiter',',');
    if tem_mdt
        mk=strcmp(T.parameter,'mdt'); ms=strcmp(T.parameter,'sla_filtered');
        lon_v=T.longitude(mk); lat_v=T.latitude(mk); t_str=T.time(mk);
        adt_v=T.value(mk)+T.value(ms);
    else
        ms=strcmp(T.parameter,'sla_filtered');
        lon_v=T.longitude(ms); lat_v=T.latitude(ms); t_str=T.time(ms); adt_v=T.value(ms);
    end
    t_dt=datetime(t_str,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS''Z''');
    time_v=datenum(t_dt)-time_orig;
    ir=(lat_v>=latmin&lat_v<=latmax&lon_v>=lonmin&lon_v<=lonmax);
    im=((time_v>=fev_ini&time_v<=fev_fim)|(time_v>=ago_ini&time_v<=ago_fim));
    idx=ir&im;
    time_v=time_v(idx); lon_v=lon_v(idx); lat_v=lat_v(idx); adt_v=adt_v(idx);
    for pp=[1 2]
        if pp==1, ip=time_v>=fev_ini&time_v<=fev_fim; else ip=time_v>=ago_ini&time_v<=ago_fim; end
        if sum(ip)<2, continue; end
        me=nanmean(adt_v(ip)); dp_v=nanstd(adt_v(ip));
        adt_v(ip&adt_v<me-5*dp_v)=me-5*dp_v;
        adt_v(ip&adt_v>me+5*dp_v)=me+5*dp_v;
        adt_v(ip&isnan(adt_v))=me;
    end
    ifp=time_v>=fev_p1&time_v<=fev_p2;
    iap=time_v>=ago_p1&time_v<=ago_p2;

    % Figura individual - Fevereiro
    if sum(ifp)>0
        figure
        plot(lon_v(ifp),lat_v(ifp),'+b','MarkerSize',2)
        axis([lonmin lonmax latmin latmax]); grid on
        xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
        title(['TRAJETORIAS ADT - ' upper(nome) ' - Fevereiro 2025'],'fontsize',12)
        print('-dpng',[path_plots 'ex2/trajet_adt_' nome '_fev2025']); close
    end

    % Figura individual - Agosto
    if sum(iap)>0
        figure
        plot(lon_v(iap),lat_v(iap),'+r','MarkerSize',2)
        axis([lonmin lonmax latmin latmax]); grid on
        xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
        title(['TRAJETORIAS ADT - ' upper(nome) ' - Agosto 2025'],'fontsize',12)
        print('-dpng',[path_plots 'ex2/trajet_adt_' nome '_ago2025']); close
    end

    % Adicionar nas figuras combinadas (cor unica por mes)
    if sum(ifp)>0
        figure(fig_adt_fev)
        plot(lon_v(ifp),lat_v(ifp),'+r','MarkerSize',2)
    end
    if sum(iap)>0
        figure(fig_adt_ago)
        plot(lon_v(iap),lat_v(iap),'+b','MarkerSize',2)
    end

    % Salvar arquivos DAT
    for ngrid=1:nugrid
        diflat=abs(lat_v-latgrid(ngrid));
        diflon=abs(lon_v-longrid(ngrid));
        ind=find(diflat<2 & diflon<2);
        saida=[path_adt 'satel_' num2str(isat) '_grid_' num2str(ngrid) '.dat'];
        if ~isempty(ind)
            result=[time_v(ind)';lon_v(ind)';lat_v(ind)';adt_v(ind)'];
            fid=fopen(saida,'w'); fprintf(fid,'%13.6f %13.6f %13.6f %13.6f \n',result); fclose(fid);
        else
            fid=fopen(saida,'w'); fclose(fid);
        end
    end
    fprintf('OK (%d dados)\n',sum(idx));
end

% Salvar figuras combinadas ADT
figure(fig_adt_fev)
print('-dpng',[path_plots 'ex2/trajet_adt_todos_fev2025']); close

figure(fig_adt_ago)
print('-dpng',[path_plots 'ex2/trajet_adt_todos_ago2025']); close

fprintf('\n--- SWH e WIND (9 satelites) ---\n');

% Figuras combinadas: todos os satelites, fevereiro e agosto separados
fig_swh_fev=figure; hold on
title('TRAJETORIAS SWH/WIND - todos satelites - Fevereiro 2025','fontsize',11)
xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
axis([lonmin lonmax latmin latmax]); grid on

fig_swh_ago=figure; hold on
title('TRAJETORIAS SWH/WIND - todos satelites - Agosto 2025','fontsize',11)
xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
axis([lonmin lonmax latmin latmax]); grid on


for isat=1:numsats_swh
    nome=arq_swh{isat,2}; arq=arq_swh{isat,1};
    fprintf('  %s... ',upper(nome));
    T=readtable(arq,'CommentStyle','#','Delimiter',',');
    mw=strcmp(T.parameter,'VAVH'); mv=strcmp(T.parameter,'WIND_SPEED');
    if sum(mw)==0||sum(mv)==0, fprintf('sem dados\n'); continue; end
    lon_v=T.longitude(mw); lat_v=T.latitude(mw); t_str=T.time(mw);
    swh_v=T.value(mw); wnd_v=T.value(mv);
    t_dt=datetime(t_str,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SSS''Z''');
    time_v=datenum(t_dt)-time_orig;
    ir=(lat_v>=latmin&lat_v<=latmax&lon_v>=lonmin&lon_v<=lonmax);
    im=((time_v>=fev_ini&time_v<=fev_fim)|(time_v>=ago_ini&time_v<=ago_fim));
    idx=ir&im;
    time_v=time_v(idx); lon_v=lon_v(idx); lat_v=lat_v(idx);
    swh_v=swh_v(idx); wnd_v=wnd_v(idx);
    for pp=[1 2]
        if pp==1, ip=time_v>=fev_ini&time_v<=fev_fim; else ip=time_v>=ago_ini&time_v<=ago_fim; end
        if sum(ip)<2, continue; end
        ms2=nanmean(swh_v(ip)); ds=nanstd(swh_v(ip));
        mw2=nanmean(wnd_v(ip)); dw=nanstd(wnd_v(ip));
        swh_v(ip&swh_v<ms2-5*ds)=ms2-5*ds; swh_v(ip&swh_v>ms2+5*ds)=ms2+5*ds; swh_v(ip&isnan(swh_v))=ms2;
        wnd_v(ip&wnd_v<mw2-5*dw)=mw2-5*dw; wnd_v(ip&wnd_v>mw2+5*dw)=mw2+5*dw; wnd_v(ip&isnan(wnd_v))=mw2;
    end
    ifp=time_v>=fev_p1&time_v<=fev_p2;
    iap=time_v>=ago_p1&time_v<=ago_p2;

    % Figura individual - Fevereiro
    if sum(ifp)>0
        figure
        plot(lon_v(ifp),lat_v(ifp),'+b','MarkerSize',2)
        axis([lonmin lonmax latmin latmax]); grid on
        xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
        title(['TRAJETORIAS SWH/WIND - ' upper(nome) ' - Fevereiro 2025'],'fontsize',12)
        print('-dpng',[path_plots 'ex2/trajet_swh_wnd_' nome '_fev2025']); close
    end

    % Figura individual - Agosto
    if sum(iap)>0
        figure
        plot(lon_v(iap),lat_v(iap),'+r','MarkerSize',2)
        axis([lonmin lonmax latmin latmax]); grid on
        xlabel('LONGITUDE','fontsize',12); ylabel('LATITUDE','fontsize',12)
        title(['TRAJETORIAS SWH/WIND - ' upper(nome) ' - Agosto 2025'],'fontsize',12)
        print('-dpng',[path_plots 'ex2/trajet_swh_wnd_' nome '_ago2025']); close
    end

    % Adicionar nas figuras combinadas (cor unica por mes)
    if sum(ifp)>0
        figure(fig_swh_fev)
        plot(lon_v(ifp),lat_v(ifp),'+r','MarkerSize',2)
    end
    if sum(iap)>0
        figure(fig_swh_ago)
        plot(lon_v(iap),lat_v(iap),'+b','MarkerSize',2)
    end

    % Salvar arquivos DAT
    for ngrid=1:nugrid
        diflat=abs(lat_v-latgrid(ngrid));
        diflon=abs(lon_v-longrid(ngrid));
        ind=find(diflat<2 & diflon<2);
        ss=[path_swh 'satel_' num2str(isat) '_grid_' num2str(ngrid) '.dat'];
        sw=[path_wnd 'satel_' num2str(isat) '_grid_' num2str(ngrid) '.dat'];
        if ~isempty(ind)
            rs=[time_v(ind)';lon_v(ind)';lat_v(ind)';swh_v(ind)'];
            rw=[time_v(ind)';lon_v(ind)';lat_v(ind)';wnd_v(ind)'];
            fid=fopen(ss,'w'); fprintf(fid,'%13.6f %13.6f %13.6f %13.6f \n',rs); fclose(fid);
            fid=fopen(sw,'w'); fprintf(fid,'%13.6f %13.6f %13.6f %13.6f \n',rw); fclose(fid);
        else
            fid=fopen(ss,'w'); fclose(fid);
            fid=fopen(sw,'w'); fclose(fid);
        end
    end
    fprintf('OK (%d dados)\n',sum(idx));
end

% Salvar figuras combinadas SWH/WIND
figure(fig_swh_fev)
print('-dpng',[path_plots 'ex2/trajet_swh_wnd_todos_fev2025']); close

figure(fig_swh_ago)
print('-dpng',[path_plots 'ex2/trajet_swh_wnd_todos_ago2025']); close

fprintf('\n  Exercicio 2 concluido.\n');

% ================================================================
%% EXERCICIO 3: Series temporais e mapas estatisticos mensais
% prog02form_ser_temp + prog03estatist + prog04plot_2D equivalentes
% ================================================================
fprintf('\n=== EXERCICIO 3: Series temporais e mapas estatisticos ===\n');

meses_nome ={'fev2025','ago2025'};
meses_p1   =[fev_p1, ago_p1];
meses_p2   =[fev_p2, ago_p2];
meses_label={'Fevereiro 2025','Agosto 2025'};

sertemp_adt=cell(nugrid,2); sertemp_swh=cell(nugrid,2); sertemp_wnd=cell(nugrid,2);
time_interp_mes=cell(1,2);

for imes=1:2
    t_ini=meses_p1(imes); t_fim=meses_p2(imes);
    t_buf_ini=t_ini-buf; t_buf_fim=t_fim+buf;
    nome_mes=meses_nome{imes}; label_mes=meses_label{imes};
    time_interp=t_ini:dt_interp:t_fim;
    nuint=size(time_interp,2);
    time_interp_mes{imes}=time_interp;

    fprintf('\n  --- %s ---\n',label_mes);

    % ============================================================
    % prog02form_ser_temp equivalente: OI Gauss-Markov
    % Loop estruturado igual ao professor (satel_num, ngrid, nint, ndad)
    % ============================================================

    % --- ADT ---
    fprintf('    prog02 ADT: interpolacao OI...\n');
    satel_num_ini=1; satel_num_fim=numsats_adt;
    for ngrid=1:nugrid
        adt_interp(1:nuint)=NaN;
        if(codgrid(ngrid)==1)
            longrade=longrid(ngrid);
            latgrade=latgrid(ngrid);
            nfim=0;
            for satel_num=satel_num_ini:satel_num_fim
                arq=[path_adt 'satel_' num2str(satel_num) '_grid_' num2str(ngrid) '.dat'];
                fi=dir(arq);
                if isempty(fi)||fi.bytes==0, continue; end
                dados=load(arq);
                nudad_s=size(dados,1);
                if nudad_s==0, continue; end
                nsta=nfim+1; nfim=nfim+nudad_s;
                time_cat(nsta:nfim)=dados(:,1);
                lon_cat(nsta:nfim) =dados(:,2);
                lat_cat(nsta:nfim) =dados(:,3);
                adt_cat(nsta:nfim) =dados(:,4);
            end
            nudad=nfim;
            if nudad>0
                % filtra janela com buffer
                im2=time_cat(1:nudad)>=t_buf_ini & time_cat(1:nudad)<=t_buf_fim;
                time_d=time_cat(1:nudad); lon_d=lon_cat(1:nudad);
                lat_d=lat_cat(1:nudad);   adt_d=adt_cat(1:nudad);
                time_d=time_d(im2); lon_d=lon_d(im2); lat_d=lat_d(im2); adt_d=adt_d(im2);
                nudad=sum(im2);
                for nint=1:nuint
                    soma_peso=0; soma_adt=0;
                    for ndad=1:nudad
                        dlat=abs(lat_d(ndad)-latgrade)*conv;
                        dlon=abs(lon_d(ndad)-longrade)*conv;
                        latm=abs(lat_d(ndad)+latgrade)/2*conv;
                        dy=RT*dlat;
                        dx=RT*dlon*cos(latm);
                        dt=abs(time_d(ndad)-time_interp(nint));
                        if(dx<rcx && dy<rcy && dt<rct)
                            r=sqrt(dx^2/rcx2+dy^2/rcy2);
                            br=b*r;
                            br2=br*br;
                            br3=br2*br;
                            peso=(1+br+br2/6-br3/6)*exp(-br)*exp(-2*dt/rct);
                            soma_adt=adt_d(ndad)*peso+soma_adt;
                            soma_peso=peso+soma_peso;
                        end
                    end
                    adt_interp(nint)=soma_adt/soma_peso;
                end
                adt_interp2=interp1(time_interp,adt_interp,time_interp,'cubic');
                adt_interp=adt_interp2;
            end
            clear time_cat lon_cat lat_cat adt_cat
        end
        result=[time_interp; adt_interp];
        saida=[path_adt 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat'];
        fid=fopen(saida,'w'); fprintf(fid,'%10.4f %10.4f \n',result); fclose(fid);
        sertemp_adt{ngrid,imes}=adt_interp;
        adt_interp(1:nuint)=NaN;
    end

    % --- SWH ---
    fprintf('    prog02 SWH: interpolacao OI...\n');
    satel_num_ini=1; satel_num_fim=numsats_swh;
    for ngrid=1:nugrid
        swh_interp(1:nuint)=NaN;
        if(codgrid(ngrid)==1)
            longrade=longrid(ngrid);
            latgrade=latgrid(ngrid);
            nfim=0;
            for satel_num=satel_num_ini:satel_num_fim
                arq=[path_swh 'satel_' num2str(satel_num) '_grid_' num2str(ngrid) '.dat'];
                fi=dir(arq);
                if isempty(fi)||fi.bytes==0, continue; end
                dados=load(arq);
                nudad_s=size(dados,1);
                if nudad_s==0, continue; end
                nsta=nfim+1; nfim=nfim+nudad_s;
                time_cat(nsta:nfim)=dados(:,1);
                lon_cat(nsta:nfim) =dados(:,2);
                lat_cat(nsta:nfim) =dados(:,3);
                swh_cat(nsta:nfim) =dados(:,4);
            end
            nudad=nfim;
            if nudad>0
                im2=time_cat(1:nudad)>=t_buf_ini & time_cat(1:nudad)<=t_buf_fim;
                time_d=time_cat(1:nudad); lon_d=lon_cat(1:nudad);
                lat_d=lat_cat(1:nudad);   swh_d=swh_cat(1:nudad);
                time_d=time_d(im2); lon_d=lon_d(im2); lat_d=lat_d(im2); swh_d=swh_d(im2);
                nudad=sum(im2);
                for nint=1:nuint
                    soma_peso=0; soma_swh=0;
                    for ndad=1:nudad
                        dlat=abs(lat_d(ndad)-latgrade)*conv;
                        dlon=abs(lon_d(ndad)-longrade)*conv;
                        latm=abs(lat_d(ndad)+latgrade)/2*conv;
                        dy=RT*dlat;
                        dx=RT*dlon*cos(latm);
                        dt=abs(time_d(ndad)-time_interp(nint));
                        if(dx<rcx && dy<rcy && dt<rct)
                            r=sqrt(dx^2/rcx2+dy^2/rcy2);
                            br=b*r;
                            br2=br*br;
                            br3=br2*br;
                            peso=(1+br+br2/6-br3/6)*exp(-br)*exp(-2*dt/rct);
                            soma_swh=swh_d(ndad)*peso+soma_swh;
                            soma_peso=peso+soma_peso;
                        end
                    end
                    swh_interp(nint)=soma_swh/soma_peso;
                end
                swh_interp2=interp1(time_interp,swh_interp,time_interp,'nearest');
                swh_interp=swh_interp2;
                media_interp=nanmean(swh_interp2);
                key=isnan(swh_interp2);
                if sum(key)>0
                    ind_key=find(key==1);
                    swh_interp(ind_key)=media_interp;
                end
            end
            clear time_cat lon_cat lat_cat swh_cat
        end
        result=[time_interp; swh_interp];
        saida=[path_swh 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat'];
        fid=fopen(saida,'w'); fprintf(fid,'%10.4f %10.4f \n',result); fclose(fid);
        sertemp_swh{ngrid,imes}=swh_interp;
        swh_interp(1:nuint)=NaN;
    end

    % --- WIND ---
    fprintf('    prog02 WIND: interpolacao OI...\n');
    satel_num_ini=1; satel_num_fim=numsats_swh;
    for ngrid=1:nugrid
        wnd_interp(1:nuint)=NaN;
        if(codgrid(ngrid)==1)
            longrade=longrid(ngrid);
            latgrade=latgrid(ngrid);
            nfim=0;
            for satel_num=satel_num_ini:satel_num_fim
                arq=[path_wnd 'satel_' num2str(satel_num) '_grid_' num2str(ngrid) '.dat'];
                fi=dir(arq);
                if isempty(fi)||fi.bytes==0, continue; end
                dados=load(arq);
                nudad_s=size(dados,1);
                if nudad_s==0, continue; end
                nsta=nfim+1; nfim=nfim+nudad_s;
                time_cat(nsta:nfim)=dados(:,1);
                lon_cat(nsta:nfim) =dados(:,2);
                lat_cat(nsta:nfim) =dados(:,3);
                wnd_cat(nsta:nfim) =dados(:,4);
            end
            nudad=nfim;
            if nudad>0
                im2=time_cat(1:nudad)>=t_buf_ini & time_cat(1:nudad)<=t_buf_fim;
                time_d=time_cat(1:nudad); lon_d=lon_cat(1:nudad);
                lat_d=lat_cat(1:nudad);   wnd_d=wnd_cat(1:nudad);
                time_d=time_d(im2); lon_d=lon_d(im2); lat_d=lat_d(im2); wnd_d=wnd_d(im2);
                nudad=sum(im2);
                for nint=1:nuint
                    soma_peso=0; soma_wnd=0;
                    for ndad=1:nudad
                        dlat=abs(lat_d(ndad)-latgrade)*conv;
                        dlon=abs(lon_d(ndad)-longrade)*conv;
                        latm=abs(lat_d(ndad)+latgrade)/2*conv;
                        dy=RT*dlat;
                        dx=RT*dlon*cos(latm);
                        dt=abs(time_d(ndad)-time_interp(nint));
                        if(dx<rcx && dy<rcy && dt<rct)
                            r=sqrt(dx^2/rcx2+dy^2/rcy2);
                            br=b*r;
                            br2=br*br;
                            br3=br2*br;
                            peso=(1+br+br2/6-br3/6)*exp(-br)*exp(-2*dt/rct);
                            soma_wnd=wnd_d(ndad)*peso+soma_wnd;
                            soma_peso=peso+soma_peso;
                        end
                    end
                    wnd_interp(nint)=soma_wnd/soma_peso;
                end
                wnd_interp2=interp1(time_interp,wnd_interp,time_interp,'nearest');
                wnd_interp=wnd_interp2;
                media_interp=nanmean(wnd_interp2);
                key=isnan(wnd_interp2);
                if sum(key)>0
                    ind_key=find(key==1);
                    wnd_interp(ind_key)=media_interp;
                end
            end
            clear time_cat lon_cat lat_cat wnd_cat
        end
        result=[time_interp; wnd_interp];
        saida=[path_wnd 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat'];
        fid=fopen(saida,'w'); fprintf(fid,'%10.4f %10.4f \n',result); fclose(fid);
        sertemp_wnd{ngrid,imes}=wnd_interp;
        wnd_interp(1:nuint)=NaN;
    end

    % ============================================================
    % prog03estatist equivalente: estatisticas e graficos por ponto
    % Seguindo exatamente o estilo do professor
    % ============================================================
    fprintf('    prog03 estatisticas: tend/hist/FFT para pontos selecionados...\n');

    varstat={
        path_adt, 'adt', 'm',   sertemp_adt;
        path_swh, 'swh', 'm',   sertemp_swh;
        path_wnd, 'wnd', 'm/s', sertemp_wnd;
    };

    for ivar=1:3
        pasta=varstat{ivar,1}; nome_v=varstat{ivar,2}; unid=varstat{ivar,3};

        for ngrid=1:nugrid
            if(codgrid(ngrid)==0), continue; end

            arquivo=[pasta 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat'];
            dados_v=load(arquivo);
            time=dados_v(:,1);
            vdata=dados_v(:,2);
            nutime=size(dados_v,1);

            % estatistica dos dados (prog03 style)
            estat(1)=nutime;
            estat(2)=mean(vdata);
            estat(3)=std(vdata);
            estat(4)=median(vdata);
            estat(5)=min(vdata);
            estat(6)=max(vdata);
            estat(7)=kurtosis(vdata);
            estat(8)=skewness(vdata);

            file_name=[pasta 'estat_' nome_mes '_grid_' num2str(ngrid) '.dat'];
            file_ident=[' ' nome_v '_estat_grid_' num2str(ngrid) '   ano ' ano ' \n'];
            file_position=[' lon ' num2str(longrid(ngrid)) ' lat ' num2str(latgrid(ngrid)) ' \n'];
            fid=fopen(file_name,'w');
            fprintf(fid,file_ident);
            fprintf(fid,file_position);
            fprintf(fid,[' Estatistica de ' nome_v ' \n ']);
            fprintf(fid,' \n');
            fprintf(fid,' Parametros estatiticos \n');
            fprintf(fid,' no. dados, media, dp, mediana, min, max, kurt, assim \n');
            fprintf(fid,'%6i %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f \n',estat');
            fclose(fid);

            % ajuste linear (tendencia) - prog03 style
            polinom=polyfit(time,vdata,1);
            tend=polinom(1);
            altim_pol=polyval(polinom,time);
            figure
            plot(time,vdata,'LineWidth',2)
            hold
            plot(time,altim_pol,'r','LineWidth',2)
            axis([time(1) time(end) -inf inf])
            grid on
            xlabel('Dias','fontsize',12)
            ylabel(unid,'fontsize',12)
            titulo1=[upper(nome_v) ' PONTO ',num2str(ngrid),' ano ',ano,'    ',...
                num2str(longrid(ngrid)),' W ',num2str(latgrid(ngrid)),...
                ' S    TEND ',num2str(tend),' ',unid,'/dia'];
            title(titulo1,'fontsize',12)
            print('-dpng',[pasta 'tend_' nome_mes '_grid_' num2str(ngrid)])

            % histograma dos dados - prog03 style
            figure
            hist(vdata)
            grid on
            titulo2=['HISTOGR ' upper(nome_v) ' PONTO ',num2str(ngrid),' ano ',ano,'    ',...
                num2str(longrid(ngrid)),' W ',num2str(latgrid(ngrid)),' S'];
            title(titulo2,'fontsize',12)
            xlabel(['CLASSES (' unid ')'],'fontsize',12)
            ylabel('NUMERO DE OCORRENCIAS','fontsize',12)
            print('-dpng',[pasta 'hist_' nome_mes '_grid_' num2str(ngrid)])

            % Transformada de Fourier - prog03 style
            n2=nutime/2;
            n=1:n2;
            Tn=(nutime*dt_interp)./n;
            vdata=vdata-mean(vdata);
            fft_altim=fft(vdata);
            fft_altim2=fft_altim(2:n2+1);
            a_fft_altim=abs(fft_altim2)/n2;
            figure
            bar(Tn,a_fft_altim,'LineWidth',2)
            grid on
            xlabel('Periodos (em dias)','fontsize',12)
            ylabel(['Amplitude (em ' unid ')'],'fontsize',12)
            titulo3=['TRANSF FOURIER ' upper(nome_v) ' PONTO ',num2str(ngrid),' ano ',ano,'    ',...
                num2str(longrid(ngrid)),' W ',num2str(latgrid(ngrid)),' S '];
            title(titulo3,'fontsize',12)
            mat_fft=[Tn' a_fft_altim];
            mat_fft_cresc=sortrows(mat_fft,2);
            mat_fft_cresc(end-5:end,:)
            print('-dpng',[pasta 'fft_' nome_mes '_grid_' num2str(ngrid)])

            vdata=vdata+mean(vdata);

            close all
        end
    end

    % ============================================================
    % prog04plot_2D equivalente: mapas das estatisticas mensais
    % Figuras individuais por estatistica - estilo exato do professor
    % ============================================================
    fprintf('    prog04 mapas 2D: media, despa, min, max...\n');

    varmap={
        path_adt, 'adt', 'm';
        path_swh, 'swh', 'm';
        path_wnd, 'wnd', 'm/s';
    };

    for ivar=1:3
        pasta=varmap{ivar,1}; nome_v=varmap{ivar,2}; unid=varmap{ivar,3};

        % leitura dos dados (prog04 style)
        for ngrid=1:nugrid
            arquivo=[pasta 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat'];
            dados_v=load(arquivo);
            time=dados_v(:,1);
            vmat(:,ngrid)=dados_v(:,2);
        end

        ind_tempo_ini=1;
        ind_tempo_fim=nuint;

        % calculo de media, desvio padrao, min, max (prog04 style)
        for ngrid=1:nugrid
            v_media(ngrid)=nanmean(vmat(ind_tempo_ini:ind_tempo_fim,ngrid));
            v_despa(ngrid)=nanstd(vmat(ind_tempo_ini:ind_tempo_fim,ngrid));
            v_min(ngrid)  =nanmin(vmat(ind_tempo_ini:ind_tempo_fim,ngrid));
            v_max(ngrid)  =nanmax(vmat(ind_tempo_ini:ind_tempo_fim,ngrid));
        end

        % Plotagem de media (prog04 style)
        v_grid=reshape(v_media,nulon,nulat);
        figure
        contourf(longrid2,latgrid2,v_grid)
        colormap(jet)
        axis equal
        xlabel('LONGITUDE','fontsize',14)
        ylabel('LATITUDE','fontsize',14)
        title([upper(nome_v) ' (' unid ') - ' label_mes ' - media DIAS ' num2str(time(ind_tempo_ini)) ' A ' num2str(time(ind_tempo_fim))],'fontsize',14)
        grid on
        colorbar('fontsize',14);
        print('-dpng',[path_plots 'ex3/' nome_v '_sel_dias_media_' nome_mes]);

        % plotagem de desvio padrao
        v_grid=reshape(v_despa,nulon,nulat);
        figure
        contourf(longrid2,latgrid2,v_grid)
        colormap(jet)
        axis equal
        xlabel('LONGITUDE','fontsize',14)
        ylabel('LATITUDE','fontsize',14)
        title([upper(nome_v) ' (' unid ') - ' label_mes ' - despa DIAS ' num2str(time(ind_tempo_ini)) ' A ' num2str(time(ind_tempo_fim))],'fontsize',14)
        grid on
        colorbar('fontsize',14);
        print('-dpng',[path_plots 'ex3/' nome_v '_sel_dias_despa_' nome_mes]);

        % Plotagem de minimo
        v_grid=reshape(v_min,nulon,nulat);
        figure
        contourf(longrid2,latgrid2,v_grid)
        colormap(jet)
        axis equal
        xlabel('LONGITUDE','fontsize',14)
        ylabel('LATITUDE','fontsize',14)
        title([upper(nome_v) ' (' unid ') - ' label_mes ' - minimo DIAS ' num2str(time(ind_tempo_ini)) ' A ' num2str(time(ind_tempo_fim))],'fontsize',14)
        grid on
        colorbar('fontsize',14);
        print('-dpng',[path_plots 'ex3/' nome_v '_sel_dias_min_' nome_mes]);

        % plotagem de maximo
        v_grid=reshape(v_max,nulon,nulat);
        figure
        contourf(longrid2,latgrid2,v_grid)
        colormap(jet)
        axis equal
        xlabel('LONGITUDE','fontsize',14)
        ylabel('LATITUDE','fontsize',14)
        title([upper(nome_v) ' (' unid ') - ' label_mes ' - maximo DIAS ' num2str(time(ind_tempo_ini)) ' A ' num2str(time(ind_tempo_fim))],'fontsize',14)
        grid on
        colorbar('fontsize',14);
        print('-dpng',[path_plots 'ex3/' nome_v '_sel_dias_max_' nome_mes]);

        % gravacao de resultados (prog04 style)
        for ngrid=1:nugrid
            result_map(ngrid,1:7)=[ngrid longrid(ngrid) latgrid(ngrid) ...
                v_media(ngrid) v_despa(ngrid) v_min(ngrid) v_max(ngrid)];
        end
        arq_estat=[pasta nome_v '_sel_dias_estat_' nome_mes '.dat'];
        fid=fopen(arq_estat,'w');
        fprintf(fid,'%6i %10.4f %10.4f %10.4f %10.4f %10.4f %10.4f \n',result_map');
        fclose(fid);

        close all
        clear vmat v_media v_despa v_min v_max result_map
    end

end

fprintf('\n  Exercicio 3 concluido.\n');

% ================================================================
%% EXERCICIO 4: Analise comparativa em dois pontos geograficos
% ================================================================
fprintf('\n=== EXERCICIO 4: Analise comparativa - Pontos %d e %d ===\n',pto1,pto2);
fprintf('  Ponto 1: lon=%.0f  lat=%.0f\n',longrid(pto1),latgrid(pto1));
fprintf('  Ponto 2: lon=%.0f  lat=%.0f\n',longrid(pto2),latgrid(pto2));

ptos_nomes={['Pto1(lon=' num2str(longrid(pto1)) ' lat=' num2str(latgrid(pto1)) ')'],...
            ['Pto2(lon=' num2str(longrid(pto2)) ' lat=' num2str(latgrid(pto2)) ')']};

for imes=1:2
    nome_mes=meses_nome{imes}; label_mes=meses_label{imes};
    time_interp=time_interp_mes{imes};
    nuint=length(time_interp);

    fprintf('\n  --- %s ---\n',label_mes);

    adt1=sertemp_adt{pto1,imes}; if isempty(adt1), adt1=zeros(1,nuint); end
    adt2=sertemp_adt{pto2,imes}; if isempty(adt2), adt2=zeros(1,nuint); end
    swh1=sertemp_swh{pto1,imes}; if isempty(swh1), swh1=zeros(1,nuint); end
    swh2=sertemp_swh{pto2,imes}; if isempty(swh2), swh2=zeros(1,nuint); end
    wnd1=sertemp_wnd{pto1,imes}; if isempty(wnd1), wnd1=zeros(1,nuint); end
    wnd2=sertemp_wnd{pto2,imes}; if isempty(wnd2), wnd2=zeros(1,nuint); end

    % Substituir NaN pela media
    adt1(isnan(adt1))=nanmean(adt1); adt2(isnan(adt2))=nanmean(adt2);
    swh1(isnan(swh1))=nanmean(swh1); swh2(isnan(swh2))=nanmean(swh2);
    wnd1(isnan(wnd1))=nanmean(wnd1); wnd2(isnan(wnd2))=nanmean(wnd2);

    % --- Series temporais comparativas (3 subplots) ---
    figure('Position',[100 100 900 700])
    subplot(3,1,1)
    plot(time_interp,adt1,'b','LineWidth',1.5); hold on
    plot(time_interp,adt2,'b--','LineWidth',1.5)
    axis([time_interp(1) time_interp(end) -inf inf])
    grid on; ylabel('ADT (m)','fontsize',12)
    legend(ptos_nomes,'Location','best','FontSize',8)
    title(['Series temporais comparativas - ' label_mes],'fontsize',12)

    subplot(3,1,2)
    plot(time_interp,swh1,'r','LineWidth',1.5); hold on
    plot(time_interp,swh2,'r--','LineWidth',1.5)
    axis([time_interp(1) time_interp(end) -inf inf])
    grid on; ylabel('SWH (m)','fontsize',12)
    legend(ptos_nomes,'Location','best','FontSize',8)

    subplot(3,1,3)
    plot(time_interp,wnd1,'g','LineWidth',1.5); hold on
    plot(time_interp,wnd2,'g--','LineWidth',1.5)
    axis([time_interp(1) time_interp(end) -inf inf])
    grid on; ylabel('WIND (m/s)','fontsize',12)
    legend(ptos_nomes,'Location','best','FontSize',8)
    xlabel('Dias','fontsize',12)
    print('-dpng',[path_plots 'ex4/series_comparativas_' nome_mes]); close

    % --- Scatter plots e parametros comparativos ---
    fprintf('    Parametros comparativos:\n');
    fprintf('    %-18s %8s %8s %8s %8s %7s\n','Par','r','RMSE','Bias','Skill','p-val');

    pares_x={adt1,adt1,swh1, adt2,adt2,swh2};
    pares_y={swh1,wnd1,wnd1, swh2,wnd2,swh2};
    pares_t={'ADT-SWH Pto1','ADT-WIND Pto1','SWH-WIND Pto1',...
             'ADT-SWH Pto2','ADT-WIND Pto2','SWH-WIND Pto2'};

    figure('Position',[100 100 1100 800])
    for kp=1:6
        sx=pares_x{kp}; sy=pares_y{kp};
        subplot(2,3,kp)
        plot(sx,sy,'+b','MarkerSize',4); grid on; hold on
        p2=polyfit(sx,sy,1); xl=linspace(min(sx),max(sx),50);
        plot(xl,polyval(p2,xl),'r','LineWidth',1.5)
        partes=strsplit(pares_t{kp},'-');
        xlabel(partes{1},'fontsize',9); ylabel(partes{2},'fontsize',9)
        [cc,pp]=corrcoef(sx,sy); cr=cc(1,2); pv=pp(1,2);
        rmse=sqrt(mean((sy-sx).^2)); bias=mean(sy-sx);
        mao=mean(abs(sx));
        sk=1-sum((sy-sx).^2)/sum((abs(sy-mao)+abs(sx-mao)).^2);
        title(sprintf('%s   r=%.2f  p=%.3f',pares_t{kp},cr,pv),'fontsize',9)
        fprintf('    %-18s %8.3f %8.4f %8.4f %8.3f %7.3f\n',pares_t{kp},cr,rmse,bias,sk,pv);
    end
    sgtitle({'Scatter plots - ' label_mes, ...
             ['Pto1: lon=' num2str(longrid(pto1)) ' lat=' num2str(latgrid(pto1)) ...
              '     Pto2: lon=' num2str(longrid(pto2)) ' lat=' num2str(latgrid(pto2))]},'fontsize',12)
    print('-dpng',[path_plots 'ex4/scatter_' nome_mes]); close

    % --- Correlacoes cruzadas com atrasos (relacoes cruzadas) ---
    maxlag=round(14/dt_interp);

    pares_xcx={adt1, adt1, swh1, adt2, adt2, swh2};
    pares_xcy={swh1, wnd1, wnd1, swh2, wnd2, swh2};
    pares_xct={'ADT-SWH Pto1','ADT-WIND Pto1','SWH-WIND Pto1',...
               'ADT-SWH Pto2','ADT-WIND Pto2','SWH-WIND Pto2'};

    figure('Position',[100 100 1100 800])
    for kp=1:6
        sx=pares_xcx{kp}-mean(pares_xcx{kp});
        sy=pares_xcy{kp}-mean(pares_xcy{kp});
        [xcf,lags]=xcorr(sx,sy,maxlag,'coeff');
        lags_dias=lags*dt_interp;
        subplot(2,3,kp)
        stem(lags_dias,xcf,'b','MarkerSize',2); hold on
        plot([min(lags_dias) max(lags_dias)],[0 0],'k')
        grid on
        xlabel('Atraso (dias)','fontsize',9); ylabel('Correlacao','fontsize',9)
        title(pares_xct{kp},'fontsize',9)
        [mx,imx]=max(abs(xcf)); lag_max=lags_dias(imx);
        text(0.05,0.88,sprintf('max|r|=%.2f  lag=%.1fd',mx,lag_max),...
             'Units','normalized','fontsize',8,'Color','r')
    end
    sgtitle({'Correlacoes cruzadas com atrasos - ' label_mes, ...
             ['Pto1: lon=' num2str(longrid(pto1)) ' lat=' num2str(latgrid(pto1)) ...
              '     Pto2: lon=' num2str(longrid(pto2)) ' lat=' num2str(latgrid(pto2))]},'fontsize',12)
    print('-dpng',[path_plots 'ex4/xcorr_' nome_mes]); close
end

fprintf('\n  Exercicio 4 concluido.\n');

% ================================================================
%% EXERCICIO 5: Analise de correlacao espacial
% prog05correl equivalente - estilo exato do professor
% ================================================================
fprintf('\n=== EXERCICIO 5: Correlacao espacial ===\n');

for imes=1:2
    nome_mes=meses_nome{imes}; label_mes=meses_label{imes};
    time_interp=time_interp_mes{imes};
    nuint=length(time_interp);

    % leitura dos dados (prog05 style - carrega sertemp de disco)
    for ngrid=1:nugrid
        dados_v=load([path_adt 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat']);
        adt_mat(:,ngrid)=dados_v(:,2);
        dados_v=load([path_swh 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat']);
        swh_mat(:,ngrid)=dados_v(:,2);
        dados_v=load([path_wnd 'sertemp_' nome_mes '_grid_' num2str(ngrid) '.dat']);
        wnd_mat(:,ngrid)=dados_v(:,2);
    end
    nudad=size(adt_mat,1);

    % Preencher NaN por interpolacao linear dos vizinhos (prog_10 style)
    % Para cada ponto de grade, coleta os indices validos e interpola
    for ngrid=1:nugrid
        for imat=1:3
            if imat==1, serie=adt_mat(:,ngrid);
            elseif imat==2, serie=swh_mat(:,ngrid);
            else, serie=wnd_mat(:,ngrid); end
            indice=0;
            tempo_val=[]; valor_val=[];
            for ntime=1:nudad
                if ~isnan(serie(ntime))
                    indice=indice+1;
                    tempo_val(indice)=ntime;
                    valor_val(indice)=serie(ntime);
                end
            end
            if indice>1
                serie=interp1(tempo_val,valor_val,1:nudad,'linear','extrap')';
            elseif indice==1
                serie(:)=valor_val(1);
            end
            if imat==1, adt_mat(:,ngrid)=serie;
            elseif imat==2, swh_mat(:,ngrid)=serie;
            else, wnd_mat(:,ngrid)=serie; end
        end
    end

    vars5_mat={adt_mat, swh_mat, wnd_mat};
    vars5_nome={'adt','swh','wnd'};

    fprintf('\n  --- %s ---\n',label_mes);

    for ipto=1:2
        kreferen=ptos_arr(ipto);
        label_pto=['Pto' num2str(ipto) ' (lon=' num2str(longrid(kreferen)) ' lat=' num2str(latgrid(kreferen)) ')'];

        for ivar=1:3
            mat_v=vars5_mat{ivar}; nome_v=vars5_nome{ivar};

            % serie de referencia (prog05 style)
            sertemp1=mat_v(:,kreferen);

            % loop igual ao professor
            for ngrid=1:nugrid
                sertemp2=mat_v(:,ngrid);

                % coeficiente de correlacao (prog05 style)
                [cc,pp]=corrcoef(sertemp1,sertemp2);
                coefic_correl(ngrid)=cc(1,2);
                signifcc(ngrid)=pp(1,2);

                % Calculo skill (prog05 style - loop ndad igual ao professor)
                med_abs_obs=mean(abs(sertemp1));
                soma_numerador=0;
                soma_denominador=0;
                for ndad=1:nudad
                    numerador=abs(sertemp2(ndad)-sertemp1(ndad))^2;
                    denominador=(abs(sertemp2(ndad)-med_abs_obs)+abs(sertemp1(ndad)-med_abs_obs))^2;
                    soma_numerador=soma_numerador+numerador;
                    soma_denominador=soma_denominador+denominador;
                end
                skill(ngrid)=1-soma_numerador/soma_denominador;
            end

            % reshape para grade (prog05 style)
            correl_grid=reshape(coefic_correl,nulon,nulat);
            signif_grid=reshape(signifcc,nulon,nulat);
            skill_grid =reshape(skill,nulon,nulat);

            % mapa de correlacao (prog05 style - sem extras, fontsize 14)
            figure
            contourf(longrid2,latgrid2,correl_grid)
            colormap(jet)
            axis equal
            xlabel('LONGITUDE','fontsize',14)
            ylabel('LATITUDE','fontsize',14)
            title(['CORREL ' upper(nome_v) ' - referen ' label_pto],'fontsize',14)
            grid on
            colorbar('fontsize',14);
            print('-dpng',[path_plots 'ex5/' nome_v '_correl_pto' num2str(ipto) '_' nome_mes]);

            % mapa de significancia
            figure
            contourf(longrid2,latgrid2,signif_grid)
            colormap(jet)
            axis equal
            xlabel('LONGITUDE','fontsize',14)
            ylabel('LATITUDE','fontsize',14)
            title(['SIGNIF CORREL (p<0.05) ' upper(nome_v) ' - referen ' label_pto],'fontsize',14)
            grid on
            colorbar('fontsize',14);
            print('-dpng',[path_plots 'ex5/' nome_v '_signif_pto' num2str(ipto) '_' nome_mes]);

            % mapa de skill
            figure
            contourf(longrid2,latgrid2,skill_grid)
            colormap(jet)
            axis equal
            xlabel('LONGITUDE','fontsize',14)
            ylabel('LATITUDE','fontsize',14)
            title(['SKILL ' upper(nome_v) ' - referen ' label_pto],'fontsize',14)
            grid on
            colorbar('fontsize',14);
            print('-dpng',[path_plots 'ex5/' nome_v '_skill_pto' num2str(ipto) '_' nome_mes]);

            % gravacao de resultados (prog05 style)
            for ngrid=1:nugrid
                result_correl(ngrid,1:6)=[ngrid longrid(ngrid) latgrid(ngrid) ...
                    coefic_correl(ngrid) signifcc(ngrid) skill(ngrid)];
            end
            arq_estat=[path_correl nome_v '_correl_skill_pto' num2str(ipto) '_' nome_mes '.dat'];
            fid=fopen(arq_estat,'w');
            fprintf(fid,'%6i %10.4f %10.4f %10.4f %10.4f %10.4f \n',result_correl');
            fclose(fid);

            close all
        end
    end

    clear adt_mat swh_mat wnd_mat coefic_correl signifcc skill result_correl
end

fprintf('\n  Exercicio 5 concluido.\n');

% ================================================================
fprintf('\n\n=== PROCESSAMENTO COMPLETO ===\n');
fprintf('plots/ex1/       - Regiao e grade\n');
fprintf('plots/ex2/       - Trajetorias along-track\n');
fprintf('plots/ex3/       - Mapas estatisticos (media, despa, min, max)\n');
fprintf('grafs_tabs_adt/  - Tend, hist, FFT, estat, sertemp ADT\n');
fprintf('grafs_tabs_swh/  - Tend, hist, FFT, estat, sertemp SWH\n');
fprintf('grafs_tabs_wnd/  - Tend, hist, FFT, estat, sertemp WIND\n');
fprintf('plots/ex4/       - Series comparativas, scatter plots, xcorr\n');
fprintf('plots/ex5/       - Mapas de correlacao, significancia e skill\n');
