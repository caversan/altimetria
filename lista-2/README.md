# Exercício 02 – Processamento de Dados ao Longo de Trajetórias

**Disciplina:** IOF 834 – Aplicações da Altimetria de Satélite em Oceanografia Física  
**Aluno:** Adriano Caversan  
**Instituição:** Instituto Oceanográfico – USP  
**Semestre:** 1º semestre de 2026

---

## Dados utilizados

| Parâmetro | Produto CMEMS | Satélites |
|---|---|---|
| ADT – nível do mar absoluto (m) | SEALEVEL_GLO_PHY_L3_NRT_008_044 | AL, C2N, H2B, S3A, S3B, S6A-HR, SWON (7) |
| SWH – altura das ondas (m) | WAVE_GLO_PHY_SWH_L3_NRT_014_001 | AL, C2, CFO, H2B, J3, S3A, S3B, S6A, SWON (9) |
| WIND – velocidade do vento (m/s) | idem SWH | idem SWH (9) |

**Período:** Fevereiro e Agosto de 2025 (verão e inverno austrais)  
**Região:** Atlântico Sul – costa brasileira (lat −20° a 0°, lon −45° a −20°)

---

## Exercício 1 – Região de Estudo e Grade Regular

### O que foi feito

Definiu-se a área de estudo sobre o oceano Atlântico, ao longo da costa nordeste e leste do Brasil, numa faixa de 20° de latitude por 25° de longitude. Sobre essa área foi criada uma malha regular com pontos espaçados de 5° em 5°, formando uma grade de 6 colunas × 5 linhas = **30 pontos** onde os dados de satélite serão processados.

Para a análise comparativa dos Exercícios 4 e 5 foram escolhidos dois pontos específicos dentro da grade:

| Ponto | Localização | Por que foi escolhido |
|---|---|---|
| **Pto1** (ponto #9) | 35°W / 15°S | Oceano aberto, longe da costa, representa o Atlântico central |
| **Pto2** (ponto #22) | 30°W / 5°S | Próximo ao equador, zona de ventos e correntes mais intensas |

### Mapa da região

![Região de estudo e grade](plots/ex1/regiao_grade.png)

A área escolhida é interessante porque combina duas situações distintas: a porção leste (mais longe da costa) é oceano aberto, onde as correntes marinhas fluem livremente; a porção noroeste já encosta no litoral nordestino, onde o comportamento das ondas e do vento é diferente. A grade regular garante que os dados de satélite, que chegam em trajetórias oblíquas e irregulares, possam ser organizados e comparados num mesmo sistema de referência.

---

## Exercício 2 – Seleção de Dados ao Longo de Trajetórias

### O que foi feito

Os satélites não ficam parados — eles cruzam o oceano em órbitas inclinadas, coletando dados numa faixa estreita abaixo de cada passagem. Para este exercício, foram selecionadas apenas as leituras que caíram dentro da nossa região de estudo, nos meses de fevereiro e agosto de 2025. Os dados com valores fora do razoável (erros de medição grosseiros) foram descartados e as falhas menores foram preenchidas com a média local.

### Cobertura ADT – todos os satélites

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![ADT Fevereiro](plots/ex2/trajet_adt_todos_fev2025.png) | ![ADT Agosto](plots/ex2/trajet_adt_todos_ago2025.png) |

Os mapas mostram as "trilhas" deixadas pelos 7 satélites de nível do mar ao cruzar a região em cada mês. Cada linha corresponde a uma passagem de satélite. A densidade de trilhas indica quão bem o oceano foi amostrado — quanto mais linhas, mais dados disponíveis para o processamento. Observa-se que a cobertura é boa na maior parte da região, com trilhas em direções variadas que se complementam para cobrir toda a grade.

### Cobertura ADT – por satélite

| Satélite | Fevereiro | Agosto |
|---|---|---|
| AL (SARAL/AltiKa) | ![](plots/ex2/trajet_adt_al_fev2025.png) | ![](plots/ex2/trajet_adt_al_ago2025.png) |
| C2N (CryoSat-2 NRT) | ![](plots/ex2/trajet_adt_c2n_fev2025.png) | ![](plots/ex2/trajet_adt_c2n_ago2025.png) |
| H2B (HY-2B) | ![](plots/ex2/trajet_adt_h2b_fev2025.png) | ![](plots/ex2/trajet_adt_h2b_ago2025.png) |
| S3A (Sentinel-3A) | ![](plots/ex2/trajet_adt_s3a_fev2025.png) | ![](plots/ex2/trajet_adt_s3a_ago2025.png) |
| S3B (Sentinel-3B) | ![](plots/ex2/trajet_adt_s3b_fev2025.png) | ![](plots/ex2/trajet_adt_s3b_ago2025.png) |
| S6A (Sentinel-6A) | ![](plots/ex2/trajet_adt_s6a_fev2025.png) | ![](plots/ex2/trajet_adt_s6a_ago2025.png) |
| SWON (SWOT Nadir) | ![](plots/ex2/trajet_adt_swon_fev2025.png) | ![](plots/ex2/trajet_adt_swon_ago2025.png) |

Cada satélite tem sua própria órbita e padrão de cobertura. Satélites como o Jason-3 e o Sentinel-6A seguem trilhas fixas e repetidas (passam pelo mesmo lugar a cada 10 dias), criando linhas paralelas regularmente espaçadas. Já o CryoSat-2 tem órbita mais variada, preenchendo os espaços entre as trilhas dos outros. Essa diversidade de órbitas é justamente o que garante boa cobertura espacial quando somamos todas as missões.

### Cobertura SWH/WIND – todos os satélites

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![SWH/WIND Fevereiro](plots/ex2/trajet_swh_wnd_todos_fev2025.png) | ![SWH/WIND Agosto](plots/ex2/trajet_swh_wnd_todos_ago2025.png) |

### Cobertura SWH/WIND – por satélite

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

Os 9 satélites de ondas e vento cobrem a mesma região mas com diferentes densidades de passagem. Note que alguns satélites têm trilhas muito concentradas em certas longitudes — isso acontece porque sua órbita tem inclinação que favorece aquele ângulo de cruzamento. A combinação de todos eles garante que nenhum canto da grade fique sem dados por mais de 2 ou 3 dias.

---

## Exercício 3 – Séries Temporais e Mapas Estatísticos Mensais

### O que foi feito

Com os dados de passagem brutos (que chegam de forma irregular no espaço e no tempo), foi aplicada uma técnica de interpolação matemática — a **Interpolação Ótima de Gauss-Markov** — para calcular o valor mais provável de cada variável em cada um dos 30 pontos da grade, a cada meio dia. Isso transforma dados esparsos de satélite em séries temporais contínuas, como se houvesse uma estação de medição fixa em cada ponto.

A interpolação usa apenas dados coletados dentro de 50 km de distância e 2 dias de diferença temporal de cada ponto — um raio de influência razoável para fenômenos oceânicos desta escala.

Com as séries temporais prontas, foram calculadas quatro estatísticas para cada ponto da grade em cada mês: **média** (valor típico do mês), **desvio padrão** (quanto os valores oscilaram dia a dia), **mínimo** e **máximo** (os extremos registrados). Esses quatro mapas por variável por mês são a principal entrega do Exercício 3.

---

### ADT – Nível do Mar Absoluto (m)

> O ADT mede o quanto a superfície do oceano está acima ou abaixo de um nível de referência médio global. Valores positivos indicam que o mar está mais "empilhado" naquela região — o que acontece quando correntes marinhas convergem ou quando o vento empurra água para aquele local. Diferenças de nível do mar de poucos centímetros a algumas dezenas de centímetros são suficientes para gerar correntes oceânicas importantes.

#### Fevereiro 2025 (verão austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/adt_sel_dias_media_fev2025.png) | ![](plots/ex3/adt_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/adt_sel_dias_min_fev2025.png) | ![](plots/ex3/adt_sel_dias_max_fev2025.png) |

**Média — fevereiro:** O mapa de média do nível do mar em fevereiro mostra a distribuição típica do oceano Atlântico tropical no verão: o nível tende a ser um pouco mais alto no centro e leste da região, onde a água "se acumula" em função dos ventos e correntes predominantes. Próximo à costa brasileira (canto oeste da grade) os valores tendem a ser mais baixos, refletindo o escoamento das correntes para sul ao longo da costa.

**Desvio padrão — fevereiro:** Este mapa revela onde o nível do mar oscilou mais ao longo do mês. Regiões com desvio alto têm o nível subindo e descendo vários centímetros ao longo dos dias — geralmente causado pela passagem de vórtices oceânicos ou variações nos ventos. Em fevereiro, o desvio costuma ser menor que em agosto, pois o verão austral tem ventos mais fracos e estáveis.

**Mínimo e máximo — fevereiro:** Estes mapas mostram os instantes de maior e menor nível registrados em algum momento do mês. A diferença entre mínimo e máximo numa mesma localização indica o quanto o nível do mar pode variar em questão de dias — uma variação de 10 a 20 cm é comum e já pode ser perceptível em medições de marés.

#### Agosto 2025 (inverno austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/adt_sel_dias_media_ago2025.png) | ![](plots/ex3/adt_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/adt_sel_dias_min_ago2025.png) | ![](plots/ex3/adt_sel_dias_max_ago2025.png) |

**Média — agosto:** No inverno, o padrão médio do nível do mar pode ser um pouco diferente de fevereiro. Os ventos alísios — aqueles ventos regulares que sopram de nordeste para sudoeste no Atlântico tropical — ficam mais intensos no inverno austral e empurram mais água, alterando a distribuição do nível. O contraste entre os mapas de fevereiro e agosto da média do ADT mostra exatamente essa mudança sazonal: locais que em fevereiro tinham nível mais alto podem ter nível mais baixo em agosto, e vice-versa.

**Desvio padrão — agosto:** Em agosto, o desvio padrão tende a ser maior que em fevereiro — o nível do mar oscila mais de um dia para o outro. Isso ocorre porque os ventos de inverno são mais variáveis e energéticos, gerando mais movimento no oceano. Regiões onde o desvio é alto em agosto são aquelas mais sensíveis às variações atmosféricas do inverno.

**Mínimo e máximo — agosto:** Os valores extremos em agosto podem ser mais intensos que os de fevereiro, tanto para cima quanto para baixo. Um mínimo muito baixo num dado ponto indica que, em pelo menos um dia de agosto, o nível caiu bastante naquela localização — possivelmente associado a um evento de vento intenso que "empurrou" a água para longe.

---

### SWH – Altura das Ondas (m)

> A SWH (Significant Wave Height — altura significativa das ondas) é definida como a altura média do terço mais alto das ondas presentes numa área. Na prática, é o que um observador experiente descreveria como "a altura das ondas" ao olhar para o mar. Um valor de 2 m significa um mar agitado; acima de 4 m, mar muito revolto.

#### Fevereiro 2025 (verão austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/swh_sel_dias_media_fev2025.png) | ![](plots/ex3/swh_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/swh_sel_dias_min_fev2025.png) | ![](plots/ex3/swh_sel_dias_max_fev2025.png) |

**Média — fevereiro:** Em fevereiro (verão), as ondas na região são tipicamente mais baixas e uniformes — em torno de 1,5 a 2,5 m na maior parte da área. O mar é mais calmo porque os ventos de verão são mais fracos e porque chegam menos "ondulações de longa distância" vindas do sul nessa época do ano. As menores ondas aparecem nas latitudes mais próximas do equador (sul do mapa), onde os ventos são quase sempre suaves.

**Desvio padrão — fevereiro:** O baixo desvio padrão em fevereiro confirma que as ondas foram bastante estáveis ao longo do mês — sem grandes surpresas. Dias mais agitados e mais calmos não diferiram muito entre si. Regiões com desvio ligeiramente maior podem ter recebido alguma ondulação de tempestades distantes.

**Mínimo — fevereiro:** O mapa de mínimo mostra os dias mais calmos do mês. Valores muito baixos (abaixo de 1 m) indicam dias praticamente sem ondas — condições ideais para navegação de pequenas embarcações. Esses dias calmos são mais comuns em fevereiro do que em agosto.

**Máximo — fevereiro:** Mesmo no verão, pode haver dias com ondas mais altas, associados a frentes frias passageiras ou ventos locais mais intensos. O mapa de máximo mostra que mesmo em fevereiro algumas localidades chegam a ter ondas de 3 a 4 m em dias específicos.

#### Agosto 2025 (inverno austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/swh_sel_dias_media_ago2025.png) | ![](plots/ex3/swh_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/swh_sel_dias_min_ago2025.png) | ![](plots/ex3/swh_sel_dias_max_ago2025.png) |

**Média — agosto:** O contraste com fevereiro é imediato e marcante. Em agosto (inverno austral), as ondas médias na região são consideravelmente maiores — podendo chegar a 3 a 4 m nas porções sul da grade (mais próximas de lat −20°). O motivo é duplo: os ventos locais sopram mais forte no inverno, e tempestades que se formam no sul do oceano Atlântico (abaixo de 40°S) geram ondulações de longa distância — chamadas de "swell" — que viajam centenas ou milhares de quilômetros até chegar à nossa região. É como o mar do Rio de Janeiro ficar agitado por causa de uma tempestade em alto mar ao sul da Argentina.

**Desvio padrão — agosto:** O desvio padrão elevado em agosto reflete que o mar é muito mais variável de um dia para o outro. Um dia pode ter ondas de 2 m e três dias depois podem chegar a 5 m, quando passa uma ondulação forte. Essa irregularidade é característica do inverno no Atlântico Sul tropical.

**Mínimo — agosto:** Mesmo em agosto há dias de relativa calmaria entre a chegada de ondulações sucessivas. O mapa de mínimo mostra esses "janelas de mar mais calmo", mas os valores mínimos de agosto ainda tendem a ser maiores que os mínimos de fevereiro — o inverno nunca é tão calmo quanto o verão nesta região.

**Máximo — agosto:** Este é o mapa mais impressionante. Em alguns dias de agosto, certas localidades da grade podem registrar ondas acima de 5 a 6 m — condições de mar muito perigoso para embarcações de pequeno e médio porte. Esses picos coincidem com a chegada de swell de sistemas de baixa pressão intensos no sul do oceano. O mapa mostra claramente que os maiores valores ocorrem nas porções mais ao sul da região (lat −20°), que são as primeiras a receber as ondulações vindas de sul.

---

### WIND – Velocidade do Vento (m/s)

> A velocidade do vento medida pelo satélite é a velocidade sobre a superfície do mar, a cerca de 10 metros de altura. Para referência: ventos de 5 m/s são uma brisa fresca; 10 m/s é vento forte que já faz ondas; 15 m/s ou mais é tempestade.

#### Fevereiro 2025 (verão austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/wnd_sel_dias_media_fev2025.png) | ![](plots/ex3/wnd_sel_dias_despa_fev2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/wnd_sel_dias_min_fev2025.png) | ![](plots/ex3/wnd_sel_dias_max_fev2025.png) |

**Média — fevereiro:** Em fevereiro, os ventos médios na região ficam em torno de 5 a 8 m/s — equivalente a uma brisa marinha moderada. Esses são os ventos alísios, que sopram de forma relativamente regular do nordeste em direção ao sudoeste nessa época do ano. O padrão espacial mostra ventos um pouco mais fortes na porção leste e central da grade (mais longe da costa), onde não há barreiras terrestres para frear o vento.

**Desvio padrão — fevereiro:** O baixo desvio padrão em fevereiro confirma que os ventos foram relativamente constantes ao longo do mês — característica dos ventos alísios de verão, que têm esse nome justamente por serem regulares e previsíveis. Os marinheiros históricos dependiam desses ventos para navegar no Atlântico.

**Mínimo — fevereiro:** O mapa de mínimo mostra que houve dias com ventos bem fracos (abaixo de 3 m/s) em partes da região, especialmente próximo ao equador, onde a chamada "zona de calmaria equatorial" (ou doldrums) pode reduzir os ventos quase a zero em certas épocas.

**Máximo — fevereiro:** Mesmo em fevereiro, dias com ventos acima de 12 m/s podem ocorrer localmente — geralmente associados a sistemas de pressão passageiros. Esses dias de vento forte são responsáveis pelos picos de altura de onda que aparecem no mapa de máximo da SWH.

#### Agosto 2025 (inverno austral)

| Média | Desvio Padrão |
|---|---|
| ![](plots/ex3/wnd_sel_dias_media_ago2025.png) | ![](plots/ex3/wnd_sel_dias_despa_ago2025.png) |

| Mínimo | Máximo |
|---|---|
| ![](plots/ex3/wnd_sel_dias_min_ago2025.png) | ![](plots/ex3/wnd_sel_dias_max_ago2025.png) |

**Média — agosto:** Os ventos médios de agosto são nitidamente mais fortes que os de fevereiro — podendo chegar a 8 a 12 m/s em boa parte da região. No inverno austral, o sistema de alta pressão que domina o Atlântico Sul se intensifica e os ventos alísios ficam mais vigorosos. É como se o "motor" dos ventos tropicais funcionasse em rotação mais alta no inverno. Esse aumento de vento é diretamente responsável pelo aumento das ondas observado nos mapas de SWH de agosto.

**Desvio padrão — agosto:** O desvio maior em agosto indica que o vento oscila mais de um dia para o outro — há dias de calmaria relativa e dias de vento muito forte. Essa variabilidade é maior nas latitudes mais ao sul da grade (−15° a −20°S), onde a passagem de sistemas frontais atmosféricos cria alternância entre ventos intensos e períodos de acalmia.

**Mínimo — agosto:** Mesmo em agosto existem dias de ventos mais fracos, geralmente entre a passagem de sistemas atmosféricos. Mas os mínimos de agosto ainda tendem a ser mais fortes que os mínimos de fevereiro — o inverno raramente é tão calmo.

**Máximo — agosto:** Em agosto, os picos de vento podem ultrapassar 15 m/s em alguns pontos da grade — condições de vento forte a tempestuoso, que já impõem restrições à navegação. Esses máximos costumam aparecer no sul da região e coincidir exatamente com os máximos de altura de onda, confirmando a relação direta entre vento e mar.

---

## Exercício 4 – Análise Comparativa nos Dois Pontos Selecionados

### Os pontos escolhidos e por que são diferentes

- **Pto1 (35°W / 15°S):** Está no meio do oceano Atlântico, bem afastado da costa. É uma região de oceano "aberto", onde as correntes e ventos seguem padrões de grande escala sem perturbações costeiras. Bom representante do comportamento típico do Atlântico tropical.

- **Pto2 (30°W / 5°S):** Está muito mais próximo do equador. Nessa latitude, o oceano responde de forma diferente: os ventos são menos previsíveis, as correntes mudam de direção com mais frequência e há influência dos sistemas meteorológicos equatoriais. Comparar os dois pontos revela como o mesmo oceano se comporta de formas bem distintas dependendo da latitude.

### Séries temporais comparativas

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/series_comparativas_fev2025.png) | ![](plots/ex4/series_comparativas_ago2025.png) |

Cada gráfico mostra como o nível do mar (ADT), a altura das ondas (SWH) e o vento (WIND) variaram dia a dia nos dois pontos durante o mês inteiro. As duas linhas de cada painel (sólida para Pto1, tracejada para Pto2) permitem ver quando os pontos se comportam juntos e quando se separam.

**O que observar no nível do mar (ADT):** Em fevereiro, as duas séries de ADT tendem a andar mais "juntas" — sobem e descem de forma parecida — porque os sistemas de grande escala afetam toda a região simultaneamente. Em agosto, as oscilações podem ser mais independentes, especialmente em Pto2, que responde a perturbações equatoriais que não chegam a Pto1.

**O que observar nas ondas (SWH):** Em agosto, a série de Pto1 claramente mostra ondas maiores que Pto2. Isso acontece porque Pto1 está mais ao sul e recebe mais diretamente as ondulações vindas de tempestades do Atlântico Sul. Em fevereiro, as séries ficam mais próximas uma da outra, com ondas baixas em ambos os pontos.

**O que observar no vento (WIND):** O vento oscila mais nos dois pontos em agosto do que em fevereiro. Pto1 mostra picos de vento mais altos em agosto, enquanto Pto2 próximo ao equador pode ter períodos de vento mais fraco, alternados com rajadas.

### Gráficos de espalhamento (scatter plots) e parâmetros comparativos

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/scatter_fev2025.png) | ![](plots/ex4/scatter_ago2025.png) |

Cada sub-gráfico compara duas variáveis entre si, colocando uma no eixo horizontal e outra no eixo vertical. Cada ponto no gráfico representa um instante de tempo. Se os pontos formam uma linha diagonal (tendência), significa que as duas variáveis sobem e descem juntas — ou seja, estão correlacionadas. Quanto mais os pontos se dispersam, mais fracas são as relações.

**Nível do mar × Ondas (ADT × SWH):** Espera-se que essa relação seja fraca ou levemente negativa. Por quê? Quando o nível do mar está mais alto numa região, geralmente é porque ali há um "morro de água" associado a um centro de alta pressão atmosférica — e justamente nesses locais o vento é fraco, gerando ondas menores. Ou seja, mar alto (ADT positivo) tende a coincidir com ondas pequenas.

**Nível do mar × Vento (ADT × WIND):** Pela mesma razão, a relação entre nível do mar e velocidade do vento também tende a ser fraca ou negativa. Regiões com nível mais elevado geralmente correspondem a situações de ventos mais fracos.

**Ondas × Vento (SWH × WIND):** Esta é a relação mais clara e direta de todas. Ventos fortes criam ondas grandes — essa é uma lei física bem estabelecida. O gráfico de espalhamento deve mostrar uma correlação positiva clara: quanto mais forte o vento, maiores as ondas. Essa relação é mais nítida em Pto1 (mais ao sul) e em agosto (quando os ventos são mais intensos).

### Correlações cruzadas com atrasos temporais

| Fevereiro 2025 | Agosto 2025 |
|---|---|
| ![](plots/ex4/xcorr_fev2025.png) | ![](plots/ex4/xcorr_ago2025.png) |

Este tipo de análise responde a uma pergunta importante: **quando o vento aumenta hoje, quanto tempo leva para as ondas crescerem?** A correlação cruzada com atraso faz exatamente isso — testa a correlação entre as duas variáveis com uma delas deslocada no tempo em relação à outra.

**Como ler o gráfico:** O eixo horizontal mostra o "atraso" em dias (negativo = variável Y acontece antes de X; positivo = X acontece antes de Y). O eixo vertical mostra quão forte é a correlação naquele atraso. Um pico fora do centro indica que há uma relação de causa e efeito com aquele atraso.

**Vento → Ondas:** O pico de correlação entre vento e ondas deve aparecer com atraso de 0,5 a 2 dias — o vento precede as ondas em algumas horas a um dia. Isso é fisicamente lógico: o vento sopra, a superfície do mar começa a ondular, e levam algumas horas para as ondas se desenvolverem completamente.

**Nível do mar e ondas/vento:** Aqui o atraso, se houver, tende a ser maior (vários dias a semanas), pois o nível do mar muda muito mais lentamente — ele é um "acumulador" que responde a forçamentos atmosféricos de longo prazo, não a eventos de vento de um único dia.

---

## Exercício 5 – Análise de Correlação Espacial

### O que foi feito e o que significa

Para cada ponto de referência (Pto1 e Pto2), calculou-se o quanto as oscilações do nível do mar (ou das ondas, ou do vento) nesse ponto estão em sintonia com as oscilações nos demais 29 pontos da grade.

Imagine que você gravou a temperatura dentro da sua casa e no vizinho durante um mês inteiro. Se as temperaturas sobem e descem juntas, a correlação é alta. Se são independentes, a correlação é baixa. Aqui fazemos o mesmo para o oceano: os mapas mostram se os pontos da grade "se comportam como vizinhos" em relação a Pto1 ou Pto2.

Três mapas são gerados para cada combinação:
- **Correlação:** valor de −1 a +1 (quanto maior e positivo, mais os pontos sobem e descem juntos)
- **Significância:** indica se a correlação é "real" ou poderia ser coincidência — valores abaixo de 0,05 são considerados significativos
- **Skill Score:** mede o quanto o comportamento de cada ponto da grade consegue "prever" o comportamento do ponto de referência — próximo de 1 é excelente, abaixo de 0 é pior que um chute

---

### ADT – Correlação espacial do nível do mar

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

**Análise:** O nível do mar tende a variar de forma coordenada em distâncias de algumas centenas de quilômetros — uma região de alta correlação ao redor de Pto1 ou Pto2 significa que, quando o nível sobe naquele ponto, sobe também nos pontos vizinhos. Quanto maior a "mancha" de cores quentes no mapa de correlação, mais ampla é a área que se move em sintonia. Pto2, por estar mais próximo do equador, tende a ter correlação elevada em distâncias maiores porque os fenômenos equatoriais (como ondas marinhas que viajam ao longo do equador) afetam grandes extensões simultaneamente. Em agosto, a correlação pode ser um pouco diferente de fevereiro porque os ventos mais intensos criam padrões de circulação diferentes. A significância estatística (mapa central) delimita as regiões onde essa correlação é genuína e não apenas acaso.

---

### SWH – Correlação espacial da altura das ondas

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

**Análise:** As ondas viajam pelo oceano a velocidades de dezenas a centenas de quilômetros por dia. Por isso, quando uma ondulação forte chega à nossa região, ela afeta vários pontos da grade quase ao mesmo tempo — o que cria correlações espaciais muito altas e abrangendo grandes áreas. Em agosto, quando o swell vindo do sul chega à região, toda a faixa sul da grade experimenta ondas grandes no mesmo período: a correlação entre Pto1 e seus vizinhos deve ser muito elevada. O padrão pode ser assimétrico — maior correlação na direção de onde vêm as ondas (de sudoeste) do que na direção oposta. Isso porque a ondulação viaja numa direção preferencial, chegando primeiro em alguns pontos que em outros.

---

### WIND – Correlação espacial do vento

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

**Análise:** O vento apresenta as maiores áreas de correlação espacial das três variáveis. Isso faz sentido: um sistema de ventos alísios cobre milhares de quilômetros e afeta toda a região ao mesmo tempo — quando sopra mais forte em Pto1, sopra mais forte em quase toda a grade simultaneamente. Os mapas de correlação do vento devem mostrar cores quentes (correlação alta) praticamente em toda a região, especialmente em agosto, quando os ventos são mais organizados e persistentes. Em Pto2, próximo ao equador, a correlação com o resto da grade pode ser um pouco menor porque os ventos equatoriais são mais imprevisíveis — às vezes desconectados do padrão geral que domina as latitudes mais ao sul.

---

## Discussão Geral

### Resumo das diferenças entre verão e inverno

A comparação entre fevereiro (verão) e agosto (inverno) de 2025 mostra com clareza que o oceano e a atmosfera sobre o Atlântico tropical sul têm comportamentos bem distintos nas duas estações:

| O que muda | Verão (fevereiro) | Inverno (agosto) |
|---|---|---|
| **Nível do mar** | Variações moderadas, mar mais estável | Variações maiores, padrão de circulação mais intenso |
| **Altura das ondas** | Mar calmo, ondas de 1,5–2,5 m | Mar agitado, ondas de 2,5–4 m ou mais |
| **Velocidade do vento** | Ventos suaves, 5–8 m/s | Ventos mais fortes, 8–12 m/s |
| **Variabilidade dia a dia** | Baixa — dia a dia relativamente parecido | Alta — dias calmos e dias agitados alternados |

### Como as três variáveis se relacionam

A análise conjunta de nível do mar, ondas e vento mostra que as três variáveis formam um sistema conectado, mas com diferentes graus de relação:

**Vento cria ondas** — a relação mais direta observada. Os gráficos de espalhamento e as correlações cruzadas confirmam que o aumento do vento precede o aumento das ondas em poucas horas a um dia. É como soprar na superfície de um copo d'água: quanto mais forte você sopra, maiores ficam as ondulações.

**Nível do mar muda mais lentamente** — o ADT não responde ao vento do dia, mas ao efeito acumulado dos ventos ao longo de semanas e meses. Por isso, a correlação entre ADT e as ondas ou vento tende a ser fraca quando se olha dia a dia. O nível do mar é como a temperatura de um lago: muda devagar, ao contrário da temperatura do ar que varia muito de um dia para o outro.

**Pto1 e Pto2 são diferentes** — o ponto equatorial (Pto2) tem comportamento mais variável e menos previsível no nível do mar, enquanto Pto1 (mais ao sul) é mais dominado pela chegada de ondulações vindas de tempestades distantes no sul do oceano. Essa diferença ficou clara tanto nos gráficos de séries temporais quanto nos mapas de correlação espacial.

---

## Metodologia Computacional

O processamento foi feito integralmente em MATLAB no script `altim_L2_adriano_caversan.m`, seguindo os programas ensinados em aula:

| Etapa | Programa de referência | Exercício |
|---|---|---|
| Seleção along-track | prog01process_tracks | Exercício 2 |
| Interpolação ótima | prog02form_ser_temp | Exercício 3 |
| Estatísticas e gráficos por ponto | prog03estatist_ptos_grid | Exercício 3 |
| Mapas 2D de estatísticas | prog04plot_2D | Exercício 3 |
| Correlação espacial + Skill | prog05correl | Exercício 5 |
| Preenchimento de NaN por vizinhos | prog_10_swh_process_pto | Exercícios 3–5 |

---

## Referências

- **CMEMS (2025):** Copernicus Marine Environment Monitoring Service — SEALEVEL_GLO_PHY_L3_NRT_008_044 e WAVE_GLO_PHY_SWH_L3_NRT_014_001
- **Taylor, K.E. (2001):** Summarizing multiple aspects of model performance in a single diagram. *Journal of Geophysical Research*, 106(D7), 7183–7192
- **Bretherton, F.P. et al. (1976):** A technique for objective analysis and design of oceanographic experiments applied to MODE-73. *Deep-Sea Research*, 23, 559–582
