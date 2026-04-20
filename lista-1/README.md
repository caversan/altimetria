# Universidade de São Paulo - Instituto de Oceanografia - IOUSP

# Aplicações da Altimetria de Satélite em Oceanografia Física – IOF 834

Exercício 01 – Processamento de Dados Gradeados

**Curso de pós-graduação:** Oceanografia  
**Área de concentração:** Oceanografia Física  
 
**Curso de Especialização:** Medição, Análise, Previsão e Modelagem do Nível do Mar 
**Módulo:** APLICAÇÕES DE ALTIMETRIA DE SATÉLITE EM OCEANOGRAFIA FÍSICA - IOF 5834
**Disciplina:** Altimetria  
**Período:** 1º Semestre de 2026 
 
**Aluno:** Adriano Caversan
**Professor:** Joseph Harari


### Objetivo
Este exercício orienta o processamento e a análise de dados gradeados diários multi-satélite referentes a ADT, SWH e VEGEO para um domínio oceânico específico.

### Requisitos
1. Cada aluno deverá escolher uma área de qualquer região oceânica, de 20º em latitude por 25º em longitude, incluindo uma parte terrestre para referência.

2. Para essa área, selecionar dados gradeados diários multi-satélite do ano completo de 2025, referentes a:
   - **ADT** – absolute dynamic topography
   - **SWH** – significant wave height
   - **VEGEO** – geostrophic velocity
3. Processar os dados de ADT, SWH e VEGEO para obtenção de mapas mensais dos valores médios e seus desvios padrão. Analisar os mapas em termos de variações espaciais e temporais dos parâmetros estatísticos.
4.  Escolher um ponto geográfico do domínio e analisar as séries temporais diárias de ADT, SWH e VEGEO, do ano completo de 2025, por métodos estatístico e espectral.

5. Escolher uma secção zonal no domínio e elaborar um diagrama longitude x tempo x ADT para o ano completo de 2025. Alternativamente, pode ser considerado um diagrama latitude x tempo x ADT. Analisar o diagrama obtido.

> Nota: caso não sejam disponíveis dados do ano completo de 2025 de SWH, ADT ou VEGEO, podem ser utilizados dados de um ano anterior completo.

## Implementação

### Área Selecionada
- **Região:** Atlântico Sul, costa brasileira
- **Coordenadas:** Latitude -24.94° a -0.06°, Longitude -44.94° a -25.06°
- **Dimensões aproximadas:** 25° lat × 20° lon (incluindo referência terrestre)

### Dados Utilizados
- **ADT (Absolute Dynamic Topography):** Arquivo `data/cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776647219637.nc`
- **SWH (Significant Wave Height):** Arquivo `data/cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776647181069.nc` (interpolado para grid ADT)
- **VEGEO (Geostrophic Velocity):** Derivado de ADT usando equações geostróficas

### Script Principal
- **Arquivo:** `altimetria_L1_adriano_caversan.m`
- **Linguagem:** MATLAB
- **Funcionalidades:**
  - Leitura e processamento de dados NetCDF
  - Interpolação de SWH para grid ADT
  - Cálculo de velocidades geostróficas
  - Geração de estatísticas mensais
  - Plots de mapas, séries temporais e diagramas espaço-temporais

## Arquivos Gerados

### Dados Processados
- `dados_processados_L1.mat`: Arquivo MATLAB contendo as matrizes ADT, SWH e VEGEO processadas

### Imagens (Pasta `plots/`)
- `adt_mes_1.png` a `adt_mes_12.png`: Mapas mensais de média e desvio padrão de ADT
- `series_temporais_ponto.png`: Séries temporais diárias de ADT, SWH e VEGEO no ponto central
- `espectro_adt.png`: Análise espectral (FFT) da série temporal de ADT
- `diagrama_lon_tempo_adt.png`: Diagrama longitude × tempo × ADT na latitude média

## Resultados Principais

### Estatísticas no Ponto Central (-12.56° lat, -35.06° lon)
- **ADT:** Média 0.617 m, Desvio padrão 0.029 m
- **SWH:** Média 1.764 m, Desvio padrão 0.455 m
- **VEGEO:** Média 0.088 m/s, Desvio padrão 0.052 m/s

### Análises
- **Mapas Mensais:** Revelam variações sazonais em ADT, com maiores alturas no inverno austral (junho-agosto)
- **Séries Temporais:** Mostram variabilidade sazonal e interdiária
- **Análise Espectral:** Indica componentes anuais e semanais na variabilidade de ADT
- **Diagrama Espaço-Temporal:** Sugere propagação zonal de anomalias, possivelmente ondas de Rossby

## Como Executar
1. Certifique-se de que MATLAB está instalado
2. Execute o script: `run('altimetria_L1_adriano_caversan.m')`
3. As imagens serão salvas automaticamente na pasta `plots/`

## Dependências
- MATLAB com toolbox NetCDF
- Arquivos de dados em `data/` (não incluídos no repositório devido ao tamanho)
