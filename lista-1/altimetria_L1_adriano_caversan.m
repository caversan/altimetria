% altimetria_L1_adriano_caversan.m
% Resolucao dos exercicios 1-5 da Lista 1 - Altimetria
% Adriano Caversan
% Dados: cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776647219637.nc
%        cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776647181069.nc

clear all; close all; clc

%% Exercicio 1: Escolha da area oceanica
% Area selecionada: Atlantico Sul, costa brasileira
% Latitude -24.94 a -0.06, Longitude -44.94 a -25.06

path_data = 'data/';
file_adt = [path_data 'cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776647219637.nc'];
file_swh = [path_data 'cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776647181069.nc'];
path_plots = 'plots/';

%% Exercicio 2: Selecao de dados gradeados diarios multi-satelite
% Leitura ADT e correntes geostroficas do arquivo de altimetria
lat_adt = ncread(file_adt, 'latitude');
lon_adt = ncread(file_adt, 'longitude');
time_adt = ncread(file_adt, 'time');
adt = ncread(file_adt, 'adt');
ugosa = ncread(file_adt, 'ugosa');
vgosa = ncread(file_adt, 'vgosa');

% Leitura SWH do arquivo de ondas
lat_swh = ncread(file_swh, 'latitude');
lon_swh = ncread(file_swh, 'longitude');
time_swh = ncread(file_swh, 'time');
swh = ncread(file_swh, 'VAVH_INST');

% Conversao do tempo para datas
time_dates_adt = datetime(time_adt, 'ConvertFrom', 'posixtime');
time_dates_swh = datetime(time_swh, 'ConvertFrom', 'posixtime');

% Grade para plotagem
[LAT_ADT, LON_ADT] = meshgrid(lat_adt, lon_adt);
[LAT_SWH, LON_SWH] = meshgrid(lat_swh, lon_swh);

% Area do dominio
lat_min = min(lat_adt);
lat_max = max(lat_adt);
lon_min = min(lon_adt);
lon_max = max(lon_adt);

fprintf('Area selecionada: Lat %.2f to %.2f, Lon %.2f to %.2f\n', lat_min, lat_max, lon_min, lon_max);

% VEGEO a partir de ugosa e vgosa, como no material de aula de UV
vegeo = sqrt(ugosa.^2 + vgosa.^2);

save('dados_processados_L1.mat', 'adt', 'swh', 'ugosa', 'vgosa', 'vegeo', ...
    'lat_adt', 'lon_adt', 'lat_swh', 'lon_swh', 'time_dates_adt', 'time_dates_swh', '-v7.3')
fprintf('Dados processados salvos em dados_processados_L1.mat\n')

%% Exercicio 3: Processamento mensal e analise de mapas
months = 1:12;
monthNames = {'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'};

for m = months
    idx_adt = month(time_dates_adt) == m;
    idx_swh = month(time_dates_swh) == m;

    if any(idx_adt)
        adt_month(:, :, m) = nanmean(adt(:, :, idx_adt), 3);
        adt_std(:, :, m) = nanstd(adt(:, :, idx_adt), 0, 3);
        vegeo_month(:, :, m) = nanmean(vegeo(:, :, idx_adt), 3);
        vegeo_std(:, :, m) = nanstd(vegeo(:, :, idx_adt), 0, 3);
    end

    if any(idx_swh)
        swh_month(:, :, m) = nanmean(swh(:, :, idx_swh), 3);
        swh_std(:, :, m) = nanstd(swh(:, :, idx_swh), 0, 3);
    end
end

for m = months
    figure
    subplot(1,2,1)
    contourf(LON_ADT, LAT_ADT, adt_month(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['adt 2025 sel - media MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    subplot(1,2,2)
    contourf(LON_ADT, LAT_ADT, adt_std(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['adt 2025 sel - despa MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    eval(['print -dpng ' path_plots 'adt_mes_' num2str(m)])
    close
end

for m = months
    figure
    subplot(1,2,1)
    contourf(LON_SWH, LAT_SWH, swh_month(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['swh 2025 sel - media MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    subplot(1,2,2)
    contourf(LON_SWH, LAT_SWH, swh_std(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['swh 2025 sel - despa MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    eval(['print -dpng ' path_plots 'swh_mes_' num2str(m)])
    close
end

for m = months
    figure
    subplot(1,2,1)
    contourf(LON_ADT, LAT_ADT, vegeo_month(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['vegeo 2025 sel - media MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    subplot(1,2,2)
    contourf(LON_ADT, LAT_ADT, vegeo_std(:, :, m))
    colormap(jet)
    axis equal
    xlabel('LONGITUDE', 'fontsize', 14)
    ylabel('LATITUDE', 'fontsize', 14)
    title(['vegeo 2025 sel - despa MES ' monthNames{m}], 'fontsize', 14)
    grid on
    colorbar('fontsize', 14)

    eval(['print -dpng ' path_plots 'vegeo_mes_' num2str(m)])
    close
end

%% Exercicio 4: Analise de series temporais em ponto geografico
kpon = 1;
lonsel = -35.0;
latsel = -12.5;

% Indices no grid ADT/UV
lonmin_adt = min(lon_adt);
latmin_adt = min(lat_adt);
dlon_adt = lon_adt(2) - lon_adt(1);
dlat_adt = lat_adt(2) - lat_adt(1);
indlonsel_adt = floor((lonsel - lonmin_adt) / dlon_adt) + 1;
indlatsel_adt = floor((latsel - latmin_adt) / dlat_adt) + 1;

% Indices no grid SWH
lonmin_swh = min(lon_swh);
latmin_swh = min(lat_swh);
dlon_swh = lon_swh(2) - lon_swh(1);
dlat_swh = lat_swh(2) - lat_swh(1);
indlonsel_swh = floor((lonsel - lonmin_swh) / dlon_swh) + 1;
indlatsel_swh = floor((latsel - latmin_swh) / dlat_swh) + 1;

fprintf('Ponto geografico escolhido: Lon %.2f, Lat %.2f\n', lonsel, latsel)
fprintf('Ponto de grade ADT/VEGEO: Lon %.2f, Lat %.2f\n', lon_adt(indlonsel_adt), lat_adt(indlatsel_adt))
fprintf('Ponto de grade SWH: Lon %.2f, Lat %.2f\n', lon_swh(indlonsel_swh), lat_swh(indlatsel_swh))

nutime_adt = size(adt, 3);
nutime_swh = size(swh, 3);

adt1d(1:nutime_adt) = adt(indlonsel_adt, indlatsel_adt, 1:nutime_adt);
adt1d = adt1d';

swh1d(1:nutime_swh) = swh(indlonsel_swh, indlatsel_swh, 1:nutime_swh);

if any(isnan(swh1d))
    indice = 0;
    for ntime = 1:nutime_swh
        ehnan = isnan(swh1d(ntime));
        if ehnan == 0
            indice = indice + 1;
            tempo10d(indice) = ntime;
            altim10d(indice) = swh1d(ntime);
        end
    end
    swh1d = interp1(tempo10d, altim10d, 1:nutime_swh, 'linear', 'extrap');
end
swh1d = swh1d';

ugosa1d(1:nutime_adt) = ugosa(indlonsel_adt, indlatsel_adt, 1:nutime_adt);
ugosa1d = ugosa1d';
vgosa1d(1:nutime_adt) = vgosa(indlonsel_adt, indlatsel_adt, 1:nutime_adt);
vgosa1d = vgosa1d';
vegeo1d = sqrt(ugosa1d.^2 + vgosa1d.^2);

fprintf('ADT: Media %.3f m, Std %.3f m\n', mean(adt1d), std(adt1d))
fprintf('SWH: Media %.3f m, Std %.3f m\n', mean(swh1d), std(swh1d))
fprintf('VEGEO: Media %.3f m/s, Std %.3f m/s\n', mean(vegeo1d), std(vegeo1d))

% ADT
dias = 1:nutime_adt;
dias = dias';
polinom = polyfit(dias, adt1d, 1);
tend = polinom(1);
adt_pol = polyval(polinom, dias);
figure
plot(dias, adt1d, 'LineWidth', 2)
hold
plot(dias, adt_pol, 'r', 'LineWidth', 2)
grid on
xlabel('Dias', 'fontsize', 12)
ylabel('m', 'fontsize', 12)
titulo1 = ['adt 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ...
    ' S . TEND ', num2str(tend), ' m/dia'];
title(titulo1, 'fontsize', 12)
eval(['print -dpng ' path_plots 'adt_2025_sel_pto_' num2str(kpon) '_fig_1'])
close

figure
hist(adt1d)
grid on
titulo2 = ['HIST adt 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ' S'];
title(titulo2, 'fontsize', 12)
xlabel('CLASSES (m)', 'fontsize', 12)
ylabel('NUMERO DE OCORRENCIAS', 'fontsize', 12)
eval(['print -dpng ' path_plots 'adt_2025_sel_pto_' num2str(kpon) '_fig_2'])
close

n2 = floor(nutime_adt / 2);
n = 1:n2;
Tn = nutime_adt ./ n;
altura_media = mean(adt1d);
adt1d = adt1d - altura_media;
fft_altim = fft(adt1d);
fft_altim2 = fft_altim(2:n2+1);
a_fft_altim = abs(fft_altim2) / n2;
figure
bar(Tn, a_fft_altim, 'LineWidth', 2)
grid on
xlabel('Periodos (em dias)', 'fontsize', 12)
ylabel('Amplitude (em m)', 'fontsize', 12)
titulo3 = ['TR FOURIER - adt 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ' S '];
title(titulo3, 'fontsize', 12)
mat_fft = [Tn' a_fft_altim];
mat_fft_cresc = sortrows(mat_fft, 2);
mat_fft_cresc(end-5:end, :)
eval(['print -dpng ' path_plots 'adt_2025_sel_pto_' num2str(kpon) '_fig_3'])
close
adt1d = adt1d + altura_media;

% SWH
dias = 1:nutime_swh;
dias = dias';
polinom = polyfit(dias, swh1d, 1);
tend = polinom(1);
swh_pol = polyval(polinom, dias);
figure
plot(dias, swh1d, 'LineWidth', 2)
hold
plot(dias, swh_pol, 'r', 'LineWidth', 2)
grid on
xlabel('Dias', 'fontsize', 12)
ylabel('m', 'fontsize', 12)
titulo1 = ['swh 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_swh(indlonsel_swh))), ' W ', num2str(abs(lat_swh(indlatsel_swh))), ...
    ' S . TEND ', num2str(tend), ' m/dia'];
title(titulo1, 'fontsize', 12)
eval(['print -dpng ' path_plots 'swh_2025_sel_pto_' num2str(kpon) '_fig_1'])
close

figure
hist(swh1d)
grid on
titulo2 = ['HIST swh 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_swh(indlonsel_swh))), ' W ', num2str(abs(lat_swh(indlatsel_swh))), ' S'];
title(titulo2, 'fontsize', 12)
xlabel('CLASSES (m)', 'fontsize', 12)
ylabel('NUMERO DE OCORRENCIAS', 'fontsize', 12)
eval(['print -dpng ' path_plots 'swh_2025_sel_pto_' num2str(kpon) '_fig_2'])
close

n2 = floor(nutime_swh / 2);
n = 1:n2;
Tn = nutime_swh ./ n;
altura_media = mean(swh1d);
swh1d = swh1d - altura_media;
fft_altim = fft(swh1d);
fft_altim2 = fft_altim(2:n2+1);
a_fft_altim = abs(fft_altim2) / n2;
figure
bar(Tn, a_fft_altim, 'LineWidth', 2)
grid on
xlabel('Periodos (em dias)', 'fontsize', 12)
ylabel('Amplitude (em m)', 'fontsize', 12)
titulo3 = ['TR FOURIER - swh 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_swh(indlonsel_swh))), ' W ', num2str(abs(lat_swh(indlatsel_swh))), ' S '];
title(titulo3, 'fontsize', 12)
mat_fft = [Tn' a_fft_altim];
mat_fft_cresc = sortrows(mat_fft, 2);
mat_fft_cresc(end-5:end, :)
eval(['print -dpng ' path_plots 'swh_2025_sel_pto_' num2str(kpon) '_fig_3'])
close
swh1d = swh1d + altura_media;

% VEGEO
dias = 1:nutime_adt;
dias = dias';
polinom = polyfit(dias, vegeo1d, 1);
tend = polinom(1);
vegeo_pol = polyval(polinom, dias);
figure
plot(dias, vegeo1d, 'LineWidth', 2)
hold
plot(dias, vegeo_pol, 'r', 'LineWidth', 2)
grid on
xlabel('Dias', 'fontsize', 12)
ylabel('m/s', 'fontsize', 12)
titulo1 = ['vegeo 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ...
    ' S . TEND ', num2str(tend), ' m/s/dia'];
title(titulo1, 'fontsize', 12)
eval(['print -dpng ' path_plots 'vegeo_2025_sel_pto_' num2str(kpon) '_fig_1'])
close

figure
hist(vegeo1d)
grid on
titulo2 = ['HIST vegeo 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ' S'];
title(titulo2, 'fontsize', 12)
xlabel('CLASSES (m/s)', 'fontsize', 12)
ylabel('NUMERO DE OCORRENCIAS', 'fontsize', 12)
eval(['print -dpng ' path_plots 'vegeo_2025_sel_pto_' num2str(kpon) '_fig_2'])
close

n2 = floor(nutime_adt / 2);
n = 1:n2;
Tn = nutime_adt ./ n;
altura_media = mean(vegeo1d);
vegeo1d = vegeo1d - altura_media;
fft_altim = fft(vegeo1d);
fft_altim2 = fft_altim(2:n2+1);
a_fft_altim = abs(fft_altim2) / n2;
figure
bar(Tn, a_fft_altim, 'LineWidth', 2)
grid on
xlabel('Periodos (em dias)', 'fontsize', 12)
ylabel('Amplitude (em m/s)', 'fontsize', 12)
titulo3 = ['TR FOURIER - vegeo 2025 sel PONTO ', num2str(kpon), '. ', ...
    num2str(abs(lon_adt(indlonsel_adt))), ' W ', num2str(abs(lat_adt(indlatsel_adt))), ' S '];
title(titulo3, 'fontsize', 12)
mat_fft = [Tn' a_fft_altim];
mat_fft_cresc = sortrows(mat_fft, 2);
mat_fft_cresc(end-5:end, :)
eval(['print -dpng ' path_plots 'vegeo_2025_sel_pto_' num2str(kpon) '_fig_3'])
close
vegeo1d = vegeo1d + altura_media;

%% Exercicio 5: Diagrama longitude x tempo x ADT
lon = lon_adt;
lat = lat_adt;
adt_diagr = adt;

lonmin = min(lon);
lonmax = max(lon);
latmin = min(lat);
latmax = max(lat);

nulon = size(lon,1);
nulat = size(lat,1);
nutime = size(adt_diagr,3);
time = 1:nutime;

latsel = -12.5;
lonini = lonmin;
lonfin = lonmax;
dia1 = 1;
dia2 = nutime;
k_diagr = 1;

diferlat = abs(lat - latsel);
difermin = min(diferlat);
indlatsel = find(diferlat == difermin);
indlatsel = indlatsel(1,1);

diferlon = abs(lon - lonini);
difermin = min(diferlon);
indlonini = find(diferlon == difermin);
indlon1 = indlonini(1,1);

diferlon = abs(lon - lonfin);
difermin = min(diferlon);
indlonfin = find(diferlon == difermin);
indlon2 = indlonfin(1,1);

[TIME, LON] = meshgrid(time(dia1:dia2), lon(indlon1:indlon2));
adt_plot(:,:) = adt_diagr(indlon1:indlon2, indlatsel, dia1:dia2);

figure
contourf(LON, TIME, adt_plot)
colormap(jet)
xlabel('LONGITUDE', 'fontsize', 14)
ylabel('TEMPO (DIAS)', 'fontsize', 14)
title(['adt 2025 (m) sel - LAT ', num2str(lat(indlatsel))], 'fontsize', 14)
grid on
colorbar('fontsize', 14)
eval(['print -dpng ' path_plots 'diagrama_lon_tempo_adt'])
close
