% altimetria_L1_adriano_caversan.m
% Resolução dos exercícios 1-5 da Lista 1 - Altimetria
% Adriano Caversan
% Dados: cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776647219637.nc (ADT)
%        cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776647181069.nc (SWH)
% VEGEO derivado de ADT

clear all; close all; clc;

%% Exercício 1: Escolha da área oceânica
% Área selecionada: Atlântico Sul, costa brasileira (-25° a 0° lat, -45° a -25° lon)

% Caminhos dos arquivos
path_data = 'data/';
file_adt = [path_data 'cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776647219637.nc'];
file_swh = [path_data 'cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776647181069.nc'];
path_plots = 'plots/';

%% Exercício 2: Seleção de dados gradeados diários multi-satélite
% Leitura ADT
lat_adt = ncread(file_adt, 'latitude');
lon_adt = ncread(file_adt, 'longitude');
time_adt = ncread(file_adt, 'time');
adt = ncread(file_adt, 'adt');

% Converter tempo para datas
time_dates = datetime(time_adt, 'ConvertFrom', 'posixtime');

% Área selecionada: toda a região dos dados (inclui terra)
lat_min = min(lat_adt);
lat_max = max(lat_adt);
lon_min = min(lon_adt);
lon_max = max(lon_adt);

fprintf('Área selecionada: Lat %.2f to %.2f, Lon %.2f to %.2f\n', lat_min, lat_max, lon_min, lon_max);

% Leitura SWH (resolução diferente, interpolar para grid ADT)
lat_swh = ncread(file_swh, 'latitude');
lon_swh = ncread(file_swh, 'longitude');
time_swh = ncread(file_swh, 'time');
swh_raw = ncread(file_swh, 'VAVH_INST');

% Interpolar SWH para grid ADT
[LON_ADT, LAT_ADT] = ndgrid(lon_adt, lat_adt);
swh = zeros(length(lon_adt), length(lat_adt), length(time_adt));
for t = 1:length(time_adt)
    swh(:,:,t) = interp2(lon_swh, lat_swh, swh_raw(:,:,t)', LON_ADT, LAT_ADT, 'linear');
end

% Derivar VEGEO de ADT (geostrophic velocity)
% f = 2*Omega*sin(lat), Omega = 7.2921e-5 rad/s, g = 9.81 m/s^2
Omega = 7.2921e-5;
g = 9.81;
f = 2 * Omega * sind(LAT_ADT);

dx = (lon_adt(2) - lon_adt(1)) * 111000 * cosd(mean(lat_adt)); % m
dy = (lat_adt(2) - lat_adt(1)) * 111000; % m

ugeo = zeros(size(adt));
vgeo = zeros(size(adt));
for t = 1:size(adt,3)
    [dadt_dx, dadt_dy] = gradient(adt(:,:,t), dx, dy);
    ugeo(:,:,t) = -g ./ f .* dadt_dy;
    vgeo(:,:,t) = g ./ f .* dadt_dx;
end

% Magnitude de VEGEO
vegeo = sqrt(ugeo.^2 + vgeo.^2);

% Salvar dados processados para prova da questão 2
save('dados_processados_L1.mat', 'adt', 'swh', 'vegeo', 'lat_adt', 'lon_adt', 'time_dates', '-v7.3');
fprintf('Dados processados salvos em dados_processados_L1.mat\n');

%% Exercício 3: Processamento mensal e análise de mapas
% Processar dados mensais: médias e desvios padrão
months = 1:12;
for m = months
    idx = month(time_dates) == m;
    if any(idx)
        adt_month(:,:,m) = mean(adt(:,:,idx), 3, 'omitnan');
        adt_std(:,:,m) = std(adt(:,:,idx), 0, 3, 'omitnan');
        
        swh_month(:,:,m) = mean(swh(:,:,idx), 3, 'omitnan');
        swh_std(:,:,m) = std(swh(:,:,idx), 0, 3, 'omitnan');
        
        vegeo_month(:,:,m) = mean(vegeo(:,:,idx), 3, 'omitnan');
        vegeo_std(:,:,m) = std(vegeo(:,:,idx), 0, 3, 'omitnan');
    end
end

% Plots mensais ADT
monthNames = {'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'};
for m = months
    figure;
    subplot(1,2,1);
    contourf(LON_ADT, LAT_ADT, adt_month(:,:,m));
    colorbar;
    title(['ADT Médio - ' monthNames{m}]);
    xlabel('Longitude'); ylabel('Latitude');
    
    subplot(1,2,2);
    contourf(LON_ADT, LAT_ADT, adt_std(:,:,m));
    colorbar;
    title(['Desvio ADT - ' monthNames{m}]);
    xlabel('Longitude'); ylabel('Latitude');
    
    saveas(gcf, [path_plots 'adt_mes_' num2str(m) '.png']);
    close;
end

% Análise: Variações espaciais e temporais - ADT mostra padrões sazonais com maiores alturas no inverno (junho-agosto), menores no verão. Desvios maiores em regiões de fronteiras.

%% Exercício 4: Análise de séries temporais em ponto geográfico
% Ponto geográfico: centro da área
lat_pt = mean([lat_min lat_max]);
lon_pt = mean([lon_min lon_max]);
[~, idx_lat] = min(abs(lat_adt - lat_pt));
[~, idx_lon] = min(abs(lon_adt - lon_pt));

adt_series = squeeze(adt(idx_lon, idx_lat, :));
swh_series = squeeze(swh(idx_lon, idx_lat, :));
vegeo_series = squeeze(vegeo(idx_lon, idx_lat, :));

% Estatísticas
fprintf('Ponto: Lat %.2f, Lon %.2f\n', lat_adt(idx_lat), lon_adt(idx_lon));
fprintf('ADT: Média %.3f m, Std %.3f m\n', mean(adt_series, 'omitnan'), std(adt_series, 'omitnan'));
fprintf('SWH: Média %.3f m, Std %.3f m\n', mean(swh_series, 'omitnan'), std(swh_series, 'omitnan'));
fprintf('VEGEO: Média %.3f m/s, Std %.3f m/s\n', mean(vegeo_series, 'omitnan'), std(vegeo_series, 'omitnan'));

% Plot séries temporais
figure;
subplot(3,1,1);
plot(time_dates, adt_series);
title('Série Temporal ADT');
xlabel('Tempo'); ylabel('ADT (m)');

subplot(3,1,2);
plot(time_dates, swh_series);
title('Série Temporal SWH');
xlabel('Tempo'); ylabel('SWH (m)');

subplot(3,1,3);
plot(time_dates, vegeo_series);
title('Série Temporal VEGEO');
xlabel('Tempo'); ylabel('VEGEO (m/s)');

saveas(gcf, [path_plots 'series_temporais_ponto.png']);
close;

% Análise espectral (FFT)
Fs = 1; % 1 dia
n = length(adt_series);
f = (0:n-1)*(Fs/n);
Y = fft(adt_series - mean(adt_series, 'omitnan'));
P = abs(Y).^2 / n;

figure;
plot(f(1:floor(n/2)), P(1:floor(n/2)));
title('Espectro ADT');
xlabel('Frequência (1/dia)'); ylabel('Potência');
saveas(gcf, [path_plots 'espectro_adt.png']);
close;

% Análise: Séries mostram variabilidade sazonal, com picos em ADT durante inverno. Espectro indica componentes anuais e semanais.

%% Exercício 5: Diagrama longitude x tempo x ADT
% Seção zonal: latitude média
lat_sec = mean(lat_adt);
[~, idx_lat_sec] = min(abs(lat_adt - lat_sec));

adt_sec = squeeze(adt(:, idx_lat_sec, :)); % lon x time

figure;
contourf(lon_adt, 1:365, adt_sec');
colorbar;
title(['Diagrama Longitude x Tempo x ADT - Lat ' num2str(lat_adt(idx_lat_sec))]);
xlabel('Longitude'); ylabel('Dia do Ano');
saveas(gcf, [path_plots 'diagrama_lon_tempo_adt.png']);
close;

% Análise: O diagrama mostra propagação de ondas de Rossby ou variações sazonais, com padrões de alta/baixa ADT movendo-se zonalmente.