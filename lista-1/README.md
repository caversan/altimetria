# Lista 1 - Processamento de Dados Gradeados

Projeto da disciplina **Aplicacoes da Altimetria de Satelite em Oceanografia Fisica** (IOUSP), dedicado ao processamento de dados gradeados diarios de **ADT**, **SWH** e **VEGEO** para uma area do Atlantico Sul na costa brasileira ao longo de **2025**.

Este diretorio reune o script MATLAB, o relatorio final e os graficos produzidos para os exercicios da lista. A documentacao detalhada das figuras esta em [ANALISE_GRAFICOS.md](ANALISE_GRAFICOS.md).

## Contexto

- **Instituicao:** Universidade de Sao Paulo - Instituto de Oceanografia
- **Curso:** Medicao, Analise, Previsao e Modelagem do Nivel do Mar
- **Disciplina:** Altimetria
- **Periodo:** 1o semestre de 2026
- **Aluno:** Adriano Caversan
- **Professor:** Joseph Harari

## Objetivo da atividade

O trabalho tem cinco frentes principais:

1. Selecionar um dominio oceanico com parte continental de referencia.
2. Ler dados gradeados diarios multi-satelite de ADT e SWH para 2025.
3. Gerar mapas mensais de media e desvio padrao para ADT, SWH e VEGEO.
4. Analisar, em um ponto do dominio, as series temporais, os histogramas e os espectros.
5. Construir um diagrama longitude x tempo x ADT para uma secao zonal.

## Recorte espacial e dados utilizados

- **Regiao:** Atlantico Sul, costa brasileira
- **Dominio aproximado:** latitude `-19.94` a `-0.06` e longitude `-44.94` a `-20.06`
- **Ponto nominal da analise temporal:** longitude `-35.0`, latitude `-12.5`
- **Ponto de grade ADT/VEGEO mais proximo:** `35.0625 W, 12.5625 S`
- **Ponto de grade SWH mais proximo:** `35 W, 13 S`

Arquivos de entrada:

- `data/cmems_obs-sl_glo_phy-ssh_nrt_allsat-l4-duacs-0.125deg_P1D_1776724281453.nc`
- `data/cmems_obs-wave_glo_phy-swh_nrt_multi-l4-2deg_P1D-i_1776724519319.nc`

## Como o script funciona

O arquivo principal [altim_L1_adriano_caversan.m](altim_L1_adriano_caversan.m) executa o fluxo completo:

1. Le o ADT, as componentes `ugosa` e `vgosa`, e o campo de SWH a partir de arquivos NetCDF.
2. Converte os tempos para `datetime` e define a grade de cada produto.
3. Calcula `VEGEO = sqrt(ugosa.^2 + vgosa.^2)`, isto e, o modulo da velocidade geostrofica.
4. Separa os dados por mes e calcula medias e desvios padrao mensais com `nanmean` e `nanstd`.
5. Gera mapas mensais para ADT, SWH e VEGEO.
6. Extrai as series diarias no ponto selecionado.
7. Preenche falhas em SWH no ponto com interpolacao linear ao longo do tempo.
8. Calcula tendencia linear, histograma e espectro de Fourier para cada variavel.
9. Monta o diagrama longitude x tempo x ADT na latitude `-12.5`.

Observacao importante: o script atual **nao interpola o SWH para a grade do ADT**. Cada variavel e tratada no seu proprio grid.

## Estrutura da pasta

- [altim_L1_adriano_caversan.m](altim_L1_adriano_caversan.m): script principal em MATLAB
- [altim_L1_adriano_caversan.pdf](altim_L1_adriano_caversan.pdf): relatorio final
- [altim_L1_adriano_caversan.docx](altim_L1_adriano_caversan.docx): versao editavel do relatorio
- [ANALISE_GRAFICOS.md](ANALISE_GRAFICOS.md): leitura comentada das figuras
- `data/`: arquivos NetCDF utilizados
- `plots/`: saidas graficas geradas pelo script
- `lista-original/`: enunciado original da atividade

## Produtos gerados

O diretorio `plots/` contem **46 figuras**:

- `12` mapas mensais de ADT
- `12` mapas mensais de SWH
- `12` mapas mensais de VEGEO
- `9` graficos de ponto fixo
- `1` diagrama longitude x tempo x ADT

## Destaques dos resultados

Com base no script e no relatorio final:

- **ADT no ponto analisado:** media de `0.617 m` e desvio padrao de `0.029 m`
- **SWH no ponto analisado:** media de `1.776 m` e desvio padrao de `0.466 m`
- **VEGEO no ponto analisado:** media de `0.086 m/s` e desvio padrao de `0.050 m/s`

Interpretacoes gerais:

- A **ADT** apresenta valores mais altos junto a costa e menores em direcao ao oceano aberto.
- O **SWH** mostra variabilidade mais forte que ADT no ponto escolhido e um gradiente espacial marcante entre costa e mar aberto.
- O **VEGEO** evidencia correntes mais intensas perto da costa e em faixas de maior dinamica no dominio.
- O diagrama longitude x tempo reforca o contraste costa-oceano e a modulacao sazonal do campo de ADT.

## Previa visual

### ADT em julho

![Mapa mensal de ADT em julho](plots/adt_mes_7.png)

### SWH em julho

![Mapa mensal de SWH em julho](plots/swh_mes_7.png)

### VEGEO em julho

![Mapa mensal de VEGEO em julho](plots/vegeo_mes_7.png)

### Diagrama longitude x tempo x ADT

![Diagrama longitude x tempo x ADT](plots/diagrama_lon_tempo_adt.png)

## Como executar

1. Abra o MATLAB no diretorio `lista-1`.
2. Garanta que os arquivos NetCDF estejam presentes em `data/`.
3. Execute:

```matlab
run('altim_L1_adriano_caversan.m')
```

4. As figuras serao gravadas automaticamente em `plots/`.

## Leitura complementar

- [Analise detalhada dos graficos](ANALISE_GRAFICOS.md)
- [Relatorio final em PDF](altim_L1_adriano_caversan.pdf)
- [Enunciado original](lista-original/exerc_01_altim_2026.pdf)
