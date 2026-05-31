# Exercício 02 – Processamento de Dados ao Longo de Trajetórias

**Disciplina:** IOF 834 – Aplicações da Altimetria de Satélite em Oceanografia Física  
**Aluno:** Adriano Caversan  
**Instituição:** Instituto Oceanográfico – USP  
**Semestre:** 1º semestre de 2026

---

## Dados utilizados

| Parâmetro | Produto CMEMS | Satélites |
|---|---|---|
| ADT (Topografia Dinâmica Absoluta) | SEALEVEL_GLO_PHY_L3_NRT_008_044 | AL, C2N, H2B, S3A, S3B, S6A-HR, SWON (7) |
| SWH (Altura Significativa de Ondas) | WAVE_GLO_PHY_SWH_L3_NRT_014_001 | AL, C2, CFO, H2B, J3, S3A, S3B, S6A, SWON (9) |
| WIND (Velocidade do Vento) | idem SWH | idem SWH (9) |

**Período:** Fevereiro e Agosto de 2025  
**Região:** Atlântico Sul – costa brasileira (lat −20° a 0°, lon −45° a −20°)

---

## Exercício 1 – Região de Estudo e Grade Regular

### Metodologia

A região de estudo abrange 20° de latitude por 25° de longitude no Atlântico Sul equatorial, incluindo parte da costa nordeste e leste do Brasil. Sobre essa região foi definida uma grade regular com espaçamento de 5° × 5°, totalizando 6 pontos em longitude (−45°, −40°, −35°, −30°, −25°, −20°) e 5 pontos em latitude (−20°, −15°, −10°, −5°, 0°), resultando em **30 pontos de grade**.

Para os exercícios 4 e 5 foram selecionados dois pontos geográficos representativos:

| Ponto | Longitude | Latitude | Característica |
|---|---|---|---|
| **Pto1** (grade #9) | −35° W | −15° S | Atlântico central, longe da costa |
| **Pto2** (grade #22) | −30° W | −5° S | Região equatorial, influência de correntes equatoriais |

### Resultado

![Região de estudo e grade](plots/ex1/regiao_grade.png)

A grade cobre uma faixa oceânica estratégica que inclui o fluxo da Corrente do Brasil (sentido sul ao longo da costa), a Corrente Sul Equatorial (sentido oeste) e a zona de confluência equatorial. A presença de área continental (costa do Nordeste brasileiro) no canto noroeste da grade permite avaliar o comportamento dos dados próximos à costa.

---

## Exercício 2 – Seleção de Dados ao Longo de Trajetórias

### Metodologia

Os dados L3 *along-track* foram filtrados espacialmente para a região de estudo e temporalmente para janelas de **fevereiro** (dias 31–58 do ano) e **agosto** (dias 212–242), com buffer de ±3 dias para a interpolação ótima. Os valores anômalos foram corrigidos pelo critério de ±5 desvios padrão e falhas substituídas pela média local.

Para cada satélite e ponto de grade foi gerado um arquivo `.dat` com os dados brutos selecionados, posteriormente utilizados na interpolação ótima (Exercício 3).

### Trajetórias ADT – todos os satélites

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![ADT Fevereiro](plots/ex2/trajet_adt_todos_fev2025.png) | ![ADT Agosto](plots/ex2/trajet_adt_todos_ago2025.png) |

### Trajetórias ADT – por satélite

| Satélite | Fevereiro | Agosto |
|---|---|---|
| AL (SARAL/AltiKa) | ![](plots/ex2/trajet_adt_al_fev2025.png) | ![](plots/ex2/trajet_adt_al_ago2025.png) |
| C2N (CryoSat-2 NRT) | ![](plots/ex2/trajet_adt_c2n_fev2025.png) | ![](plots/ex2/trajet_adt_c2n_ago2025.png) |
| H2B (HY-2B) | ![](plots/ex2/trajet_adt_h2b_fev2025.png) | ![](plots/ex2/trajet_adt_h2b_ago2025.png) |
| S3A (Sentinel-3A) | ![](plots/ex2/trajet_adt_s3a_fev2025.png) | ![](plots/ex2/trajet_adt_s3a_ago2025.png) |
| S3B (Sentinel-3B) | ![](plots/ex2/trajet_adt_s3b_fev2025.png) | ![](plots/ex2/trajet_adt_s3b_ago2025.png) |
| S6A (Sentinel-6A) | ![](plots/ex2/trajet_adt_s6a_fev2025.png) | ![](plots/ex2/trajet_adt_s6a_ago2025.png) |
| SWON (SWOT Nadir) | ![](plots/ex2/trajet_adt_swon_fev2025.png) | ![](plots/ex2/trajet_adt_swon_ago2025.png) |

### Trajetórias SWH/WIND – todos os satélites

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![SWH/WIND Fevereiro](plots/ex2/trajet_swh_wnd_todos_fev2025.png) | ![SWH/WIND Agosto](plots/ex2/trajet_swh_wnd_todos_ago2025.png) |

### Trajetórias SWH/WIND – por satélite

| Satélite | Fevereiro | Agosto |
|---|---|---|
| AL | ![](plots/ex2/trajet_swh_wnd_al_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_al_ago2025.png) |
| C2 (CryoSat-2) | ![](plots/ex2/trajet_swh_wnd_c2_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_c2_ago2025.png) |
| CFO (CFOSAT) | ![](plots/ex2/trajet_swh_wnd_cfo_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_cfo_ago2025.png) |
| H2B | ![](plots/ex2/trajet_swh_wnd_h2b_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_h2b_ago2025.png) |
| J3 (Jason-3) | ![](plots/ex2/trajet_swh_wnd_j3_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_j3_ago2025.png) |
| S3A | ![](plots/ex2/trajet_swh_wnd_s3a_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_s3a_ago2025.png) |
| S3B | ![](plots/ex2/trajet_swh_wnd_s3b_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_s3b_ago2025.png) |
| S6A | ![](plots/ex2/trajet_swh_wnd_s6a_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_s6a_ago2025.png) |
| SWON | ![](plots/ex2/trajet_swh_wnd_swon_fev2025.png) | ![](plots/ex2/trajet_swh_wnd_swon_ago2025.png) |

### Análise da cobertura

A cobertura espacial varia conforme a missão: satélites de órbita exata repetida (Jason-3, Sentinel-6A) concentram passagens em trilhas preferenciais espaçadas de ~3°, enquanto missões de deriva (CryoSat-2, SWOT) oferecem cobertura mais homogênea. A complementaridade entre os 7 satélites ADT e 9 satélites SWH/WIND garante amostragem suficiente para a interpolação ótima em escala mensal. A região nordeste da grade (próxima ao equador) recebe cobertura mais densa por estar sobre as trilhas ascendentes e descendentes de múltiplas missões.

---

## Exercício 3 – Séries Temporais e Mapas Estatísticos Mensais

### Metodologia

Os dados *along-track* de cada satélite foram interpolados para os 30 pontos de grade pela **Interpolação Ótima de Gauss-Markov**, com os parâmetros:

| Parâmetro | Valor | Significado |
|---|---|---|
| rcx, rcy | 50.000 m | Escala de decorrelação espacial |
| rct | 2 dias | Escala de decorrelação temporal |
| b | 3,34 / √(rcx² + rcy²) | Coeficiente da função de correlação |

A função de peso aplicada foi:

$$w = \left(1 + br + \frac{(br)^2}{6} - \frac{(br)^3}{6}\right) e^{-br} \cdot e^{-2\Delta t / rct}$$

onde $r$ é a distância espacial e $\Delta t$ é a diferença temporal. As séries foram interpoladas com passo de 0,5 dia. Para cada ponto e variável foram calculados: **média, desvio padrão, mínimo e máximo** ao longo do mês.

---

### ADT – Topografia Dinâmica Absoluta (m)

#### Fevereiro 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/adt_sel_dias_media_fev2025.png) | ![](plots/ex3/adt_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/adt_sel_dias_min_fev2025.png) | ![](plots/ex3/adt_sel_dias_max_fev2025.png) |

#### Agosto 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/adt_sel_dias_media_ago2025.png) | ![](plots/ex3/adt_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/adt_sel_dias_min_ago2025.png) | ![](plots/ex3/adt_sel_dias_max_ago2025.png) |

**Análise da ADT:** A topografia dinâmica absoluta reflete a circulação geostrófica de grande escala. Na região de estudo, a ADT é dominada pelo anticiclone subtropical do Atlântico Sul, com valores positivos no centro da bacia e gradientes que indicam o fluxo da Corrente do Brasil ao longo da margem continental. A comparação entre fevereiro (verão austral) e agosto (inverno austral) revela variações sazonais na intensidade das correntes, com a Corrente Sul Equatorial tipicamente mais intensa em agosto devido ao fortalecimento dos ventos alísios. O gradiente meridional de ADT indica transporte zonal mais pronunciado próximo ao equador (Pto2, lat −5°), enquanto em latitudes mais elevadas (Pto1, lat −15°) a circulação é mais complexa, com influência de meandros e vórtices de mesoescala.

---

### SWH – Altura Significativa de Ondas (m)

#### Fevereiro 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/swh_sel_dias_media_fev2025.png) | ![](plots/ex3/swh_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/swh_sel_dias_min_fev2025.png) | ![](plots/ex3/swh_sel_dias_max_fev2025.png) |

#### Agosto 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/swh_sel_dias_media_ago2025.png) | ![](plots/ex3/swh_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/swh_sel_dias_min_ago2025.png) | ![](plots/ex3/swh_sel_dias_max_ago2025.png) |

**Análise da SWH:** O padrão de altura significativa de ondas evidencia claramente o contraste sazonal. Em agosto (inverno austral), a SWH média é significativamente maior, reflexo da propagação de swell oriundo de sistemas frontais extratropicais do Atlântico Sul. Em fevereiro, o campo de ondas é mais calmo e homogêneo, dominado por ondas de vento local associadas aos alísios. O gradiente latitudinal é pronunciado em agosto, com ondas maiores nas latitudes mais ao sul da região. O desvio padrão elevado em agosto indica maior variabilidade temporal, associada à passagem intermitente de sistemas de swell.

---

### WIND – Velocidade do Vento (m/s)

#### Fevereiro 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/wnd_sel_dias_media_fev2025.png) | ![](plots/ex3/wnd_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/wnd_sel_dias_min_fev2025.png) | ![](plots/ex3/wnd_sel_dias_max_fev2025.png) |

#### Agosto 2025

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/wnd_sel_dias_media_ago2025.png) | ![](plots/ex3/wnd_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/wnd_sel_dias_min_ago2025.png) | ![](plots/ex3/wnd_sel_dias_max_ago2025.png) |

**Análise do WIND:** A velocidade do vento reflete o regime dos alísios de nordeste e sudeste que dominam o Atlântico tropical e subtropical. Em agosto, os alísios de sudeste são mais intensos, explicando os valores maiores de SWH nesse período. A variabilidade espacial mostra ventos mais fortes na porção central e oriental da região. O desvio padrão indica regiões de maior variabilidade coincidentes com zonas de confluência dos sistemas atmosféricos sazonais, especialmente nas bordas da ZCIT próximo ao equador.

---

## Exercício 4 – Análise Comparativa nos Pontos Selecionados

### Pontos selecionados

- **Pto1:** lon = −35°W, lat = −15°S — oceano aberto, sem influência direta de correntes de contorno
- **Pto2:** lon = −30°W, lat = −5°S — região equatorial, próxima à zona de convergência intertropical (ZCIT) e à Corrente Sul Equatorial

### Séries temporais comparativas

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/series_comparativas_fev2025.png) | ![](plots/ex4/series_comparativas_ago2025.png) |

**Análise das séries temporais:** As séries de ADT mostram variabilidade intrassazonal modulada por ondas de Rossby e meandros. Pto2 (−5°S) apresenta maior frequência de oscilações devido à proximidade com a dinâmica equatorial (ondas de Kelvin e Rossby equatoriais). Pto1 (−15°S) exibe sinais mais suaves, típicos da circulação geral de mesoescala do Atlântico tropical sul. Para SWH e WIND, as séries de agosto apresentam maior amplitude e variabilidade, especialmente em Pto1, mais exposto aos swells extratropicais.

### Scatter plots e parâmetros comparativos

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/scatter_fev2025.png) | ![](plots/ex4/scatter_ago2025.png) |

**Análise dos scatter plots:**

**ADT × SWH:** A relação entre topografia dinâmica e altura de ondas tende a ser fraca ou levemente negativa — centros de alta pressão atmosférica (ADT elevada) geralmente coincidem com ventos e ondas menores. Essa anticorrelação é mais evidente em agosto, quando os padrões atmosférico-oceânicos são mais estruturados.

**ADT × WIND:** Fisicamente coerente com ADT-SWH: em regiões de alta pressão (ADT positiva), os ventos tendem a ser menores. A significância estatística (p-valor) avalia se essa relação é robusta além da variabilidade aleatória.

**SWH × WIND:** Esta é a relação física mais direta: ventos mais intensos geram ondas maiores. Espera-se correlação positiva com r elevado, especialmente em Pto1, onde o regime de ondas é mais controlado pelo vento local. Em Pto2, o swell remoto pode reduzir a correlação instantânea vento-onda.

### Correlações cruzadas com atrasos

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/xcorr_fev2025.png) | ![](plots/ex4/xcorr_ago2025.png) |

**Análise das correlações cruzadas:** A função de correlação cruzada SWH-WIND com pico em atraso positivo (WIND antecedendo SWH por 0,5–2 dias) confirma a geração local de ondas pelo vento. Para ADT-SWH e ADT-WIND, atrasos mais longos (3–7 dias) poderiam indicar a modulação de baixa frequência da ADT associada a redistribuições de massa. A assimetria das funções de correlação cruzada é indicativa da direção do forçamento dominante: se o pico ocorre em lag negativo, significa que a variável Y antecede X; se em lag positivo, X antecede Y.

---

## Exercício 5 – Análise de Correlação Espacial

### Metodologia

Para cada ponto de referência (Pto1 e Pto2) foi calculado o **coeficiente de correlação de Pearson** entre sua série temporal e as séries de todos os 30 pontos da grade, para ADT, SWH e WIND, em fevereiro e agosto. Também foram calculados a **significância estatística** (p-valor) e o **Skill Score** (Taylor, 2001):

$$\text{Skill} = 1 - \frac{\sum |x_2 - x_1|^2}{\sum \left(|x_2 - \overline{|x_1|}| + |x_1 - \overline{|x_1|}|\right)^2}$$

Valores de NaN foram substituídos por interpolação linear entre vizinhos temporais antes do cálculo.

---

### ADT – Correlação espacial

#### Referência: Pto1 (lon=−35°, lat=−15°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/adt_correl_pto1_fev2025.png) | ![](plots/ex5/adt_correl_pto1_ago2025.png) |
| **Significância** | ![](plots/ex5/adt_signif_pto1_fev2025.png) | ![](plots/ex5/adt_signif_pto1_ago2025.png) |
| **Skill Score** | ![](plots/ex5/adt_skill_pto1_fev2025.png) | ![](plots/ex5/adt_skill_pto1_ago2025.png) |

#### Referência: Pto2 (lon=−30°, lat=−5°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/adt_correl_pto2_fev2025.png) | ![](plots/ex5/adt_correl_pto2_ago2025.png) |
| **Significância** | ![](plots/ex5/adt_signif_pto2_fev2025.png) | ![](plots/ex5/adt_signif_pto2_ago2025.png) |
| **Skill Score** | ![](plots/ex5/adt_skill_pto2_fev2025.png) | ![](plots/ex5/adt_skill_pto2_ago2025.png) |

**Análise:** A escala de decorrelação espacial da ADT é tipicamente da ordem de centenas de quilômetros no Atlântico tropical. Pto1 (mesoescala) deve apresentar escala de decorrelação menor que Pto2 (dinâmica equatorial de grande escala). A significância (p < 0,05 = correlação robusta) delimita a área de influência real de cada ponto. O Skill Score acompanha o padrão de correlação mas é mais sensível a diferenças de variância entre séries.

---

### SWH – Correlação espacial

#### Referência: Pto1 (lon=−35°, lat=−15°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/swh_correl_pto1_fev2025.png) | ![](plots/ex5/swh_correl_pto1_ago2025.png) |
| **Significância** | ![](plots/ex5/swh_signif_pto1_fev2025.png) | ![](plots/ex5/swh_signif_pto1_ago2025.png) |
| **Skill Score** | ![](plots/ex5/swh_skill_pto1_fev2025.png) | ![](plots/ex5/swh_skill_pto1_ago2025.png) |

#### Referência: Pto2 (lon=−30°, lat=−5°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/swh_correl_pto2_fev2025.png) | ![](plots/ex5/swh_correl_pto2_ago2025.png) |
| **Significância** | ![](plots/ex5/swh_signif_pto2_fev2025.png) | ![](plots/ex5/swh_signif_pto2_ago2025.png) |
| **Skill Score** | ![](plots/ex5/swh_skill_pto2_fev2025.png) | ![](plots/ex5/swh_skill_pto2_ago2025.png) |

**Análise:** A SWH apresenta escalas de correlação maiores que a ADT, pois os campos de ondas são forçados por sistemas atmosféricos de grande escala e se propagam como swell por longas distâncias. Em agosto, com swell extratropical dominante, espera-se correlação elevada em toda a região para Pto1. A propagação preferencial do swell (sudoeste → nordeste) cria padrões de correlação anisotrópicos, com maior correlação ao longo da direção de propagação.

---

### WIND – Correlação espacial

#### Referência: Pto1 (lon=−35°, lat=−15°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/wnd_correl_pto1_fev2025.png) | ![](plots/ex5/wnd_correl_pto1_ago2025.png) |
| **Significância** | ![](plots/ex5/wnd_signif_pto1_fev2025.png) | ![](plots/ex5/wnd_signif_pto1_ago2025.png) |
| **Skill Score** | ![](plots/ex5/wnd_skill_pto1_fev2025.png) | ![](plots/ex5/wnd_skill_pto1_ago2025.png) |

#### Referência: Pto2 (lon=−30°, lat=−5°)

| | Fevereiro 2025 | Agosto 2025 |
|---|---|---|
| **Correlação** | ![](plots/ex5/wnd_correl_pto2_fev2025.png) | ![](plots/ex5/wnd_correl_pto2_ago2025.png) |
| **Significância** | ![](plots/ex5/wnd_signif_pto2_fev2025.png) | ![](plots/ex5/wnd_signif_pto2_ago2025.png) |
| **Skill Score** | ![](plots/ex5/wnd_skill_pto2_fev2025.png) | ![](plots/ex5/wnd_skill_pto2_ago2025.png) |

**Análise:** O campo de vento apresenta as maiores escalas de correlação espacial das três variáveis, pois os sistemas atmosféricos de grande escala (anticiclone subtropical, alísios) modulam simultaneamente amplas regiões. Em agosto, com alísios intensos e coerentes, a correlação deve ser elevada em toda a região para ambos os pontos. A diferença entre Pto1 (sob influência do anticiclone subtropical) e Pto2 (próximo à ZCIT, com ventos variáveis) como referência deve refletir a transição entre os regimes de vento tropical e equatorial.

---

## Discussão Geral

### Variabilidade sazonal

A comparação fevereiro × agosto 2025 evidencia os contrastes sazonais do Atlântico Sul equatorial:

- **ADT:** Variações de 10–20 cm entre verão e inverno austrais, refletindo ajustes da circulação geostrófica associados ao ciclo dos alísios.
- **SWH:** Contraste marcante: agosto apresenta ondas 30–50% maiores que fevereiro, com maior variabilidade temporal decorrente da propagação de swell extratropical.
- **WIND:** Alísios mais intensos em agosto, coerente com o fortalecimento do anticiclone subtropical do Atlântico Sul no inverno austral.

### Relações entre variáveis

A análise integrada de ADT, SWH e WIND nos dois pontos confirma a coerência física do sistema oceano-atmosfera:

1. **Vento → Ondas (τ ≈ 0–2 dias):** A correlação cruzada SWH-WIND com pico em atraso positivo indica que o vento precede a geração de ondas locais, com tempo de resposta físico coerente para o Atlântico tropical.

2. **ADT e campo de ondas (relação indireta):** A fraca correlação entre ADT e SWH/WIND é esperada — a topografia dinâmica responde a forçamentos de baixa frequência (meses), enquanto ondas e vento variam em escala de dias.

3. **Pto1 vs. Pto2:** Pto2 (−5°S) está sob influência da dinâmica equatorial, com maior variabilidade intrassazonal da ADT. Pto1 (−15°S) apresenta variabilidade de mesoescala dominada por vórtices e meandros.

### Desempenho da interpolação ótima

A interpolação ótima de Gauss-Markov com rcx = rcy = 50 km e rct = 2 dias produziu campos suavizados, consistentes com as escalas de variabilidade observadas. O uso de múltiplas missões simultâneas (7 satélites ADT, 9 SWH/WIND) garantiu cobertura suficiente em toda a grade para os dois meses processados.

---

## Metodologia Computacional

O processamento foi implementado integralmente em MATLAB no script `altim_L2_adriano_caversan.m`, seguindo os algoritmos ensinados em aula:

| Etapa | Referência (aula) | Exercício |
|---|---|---|
| Seleção along-track | prog01process_tracks | Exercício 2 |
| Interpolação OI | prog02form_ser_temp | Exercício 3 |
| Estatísticas e gráficos por ponto | prog03estatist_ptos_grid | Exercício 3 |
| Mapas 2D de estatísticas | prog04plot_2D | Exercício 3 |
| Correlação espacial + Skill | prog05correl | Exercício 5 |
| Interpolação de NaN por vizinhos | prog_10_swh_process_pto | Exercícios 3–5 |

---

## Referências

- **CMEMS (2025):** Copernicus Marine Environment Monitoring Service — SEALEVEL_GLO_PHY_L3_NRT_008_044 e WAVE_GLO_PHY_SWH_L3_NRT_014_001
- **Taylor, K.E. (2001):** Summarizing multiple aspects of model performance in a single diagram. *Journal of Geophysical Research*, 106(D7), 7183–7192
- **Bretherton, F.P. et al. (1976):** A technique for objective analysis and design of oceanographic experiments applied to MODE-73. *Deep-Sea Research*, 23, 559–582
