-- Qual é o nível médio de burnout dos estudantes?
SELECT AVG(burnout_score) AS burnout_mean,
		gender
FROM customer

GROUP BY gender
limit 10


--Qual a média de horas de estudo por ano?

SELECT academic_year,
	AVG(study_hours_per_day) AS mean_study
	   

FROM customer
GROUP BY academic_year

--Qual o nível médio de estresse dos alunos?

SELECT AVG(stress_level) as mean_stress

FROM customer

--Quantos alunos existem por nível de risco?

SELECT risk_level,
		COUNT(*) AS summary_students

FROM customer
GROUP BY risk_level
ORDER BY summary_students DESC;


--Qual a distribuição de estudantes por faixa de estudo diário?

SELECT 
	CASE 
		WHEN study_hours_per_day BETWEEN 0.0 AND 3.0 THEN 'Pouco estudo'
		WHEN study_hours_per_day BETWEEN 3.1 AND 6.0 THEN 'Estudo moderado'
		ELSE 'Estudo intenso'

	END AS Faixa_estudo_diario,
	COUNT(*) AS student_count

FROM customer
GROUP BY Faixa_estudo_diario
ORDER BY student_count DESC;




-- Sono influencia burnout?
-- Pode-se perceber que quanto menor é as horas de sono maior a chance de ter burnout

SELECT 
	CASE
		WHEN sleep_hours BETWEEN 0.0 AND 4.0 THEN 'Muito Curto (Risco)'
		WHEN sleep_hours BETWEEN 4.0 AND 6.0 THEN 'Curto (Privação)'
		WHEN sleep_hours BETWEEN 6.0 AND 9.0 THEN 'Ideal'
		ELSE 'Longo (Excessivo)'
	END AS Horas_sono,
	AVG(burnout_score) AS media_burnout

FROM customer
GROUP BY Horas_sono
ORDER BY media_burnout DESC;


-- Mais horas de estudo aumentam estresse?
-- Analisando os dados, percebe-se que quanto mais os alunos estudam,
-- mais tem chance de ficar estressado

SELECT 
	CASE 
		WHEN study_hours_per_day BETWEEN 0.0 AND 4.0 THEN 'Poucas Horas'
		WHEN study_hours_per_day BETWEEN 4.0 AND 7.0 THEN 'Horas Ideais'
		ELSE 'Muitas Horas'
	END AS Horas_Estudos,
	AVG(stress_level) AS media_stress

FROM customer
GROUP BY Horas_Estudos
ORDER BY media_stress DESC;




-- Pressão de prova aumenta ansiedade?
-- De acordo com as métricas abaixo, quanto maior a pressão para a prova,
-- maior será o nível de ansiedade

SELECT 
	CASE
		WHEN exam_pressure BETWEEN 0.0 AND 4.0 THEN 'Baixa Pressão'
		WHEN exam_pressure BETWEEN 4.0 AND 6.0 THEN 'Média Pressão'
		ELSE 'Alta Pressão'
	END AS pressao_prova,
	AVG(anxiety_score) AS media_ansiedade,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY anxiety_score) AS Mediana_ansiedade

FROM customer
GROUP BY pressao_prova
ORDER BY media_ansiedade DESC;



-- Apoio social reduz depressão?
-- Percebemos que, quanto maior o apoio social,
-- menor a chance de desenvolver depressão

SELECT 
	CASE
		WHEN social_support BETWEEN 0.0 AND 4.0 THEN 'Baixo Apoio'
		WHEN social_support BETWEEN 4.0 AND 7.0 THEN 'Médio Apoio'
		ELSE 'Alto Apoio'
	END AS Apoio_social,
	AVG(depression_score) AS Media_depressao,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY depression_score) AS Mediana_depressao

FROM customer
GROUP BY Apoio_social
ORDER BY Media_depressao DESC;


-- Tempo de tela impacta saúde mental?
-- Nesta base de dados, o tempo de tela não impacta diretamente na saúde mental

SELECT 
	CASE
		WHEN screen_time BETWEEN 0.0 AND 3.0 THEN 'Baixo tempo'
		WHEN screen_time BETWEEN 3.0 AND 5.0 THEN 'Médio tempo'
		WHEN screen_time BETWEEN 5.0 AND 9.0 THEN 'Alto tempo'
		ELSE 'Exagerado'
	END AS Tempo_tela,

	AVG(mental_health_index) AS media_saude_mental,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY mental_health_index) AS mediana_saude_mental

FROM customer
GROUP BY Tempo_tela
ORDER BY media_saude_mental;


-- Quais os TOP 10 alunos com maior burnout?

SELECT 
	*,
	ROW_NUMBER() OVER (ORDER BY burnout_score DESC) AS rank

FROM customer
LIMIT 10;
-- Qual combinação gera maior burnout?

SELECT
	CASE
		WHEN sleep_hours BETWEEN 0.0 AND 4.0 THEN 'Muito Curto (Risco)'
		WHEN sleep_hours BETWEEN 4.0 AND 6.0 THEN 'Curto (Privação)'
		WHEN sleep_hours BETWEEN 6.0 AND 9.0 THEN 'Ideal'
		ELSE 'Longo (Excessivo)'
	END AS Horas_sono,
	CASE 
		WHEN study_hours_per_day BETWEEN 0.0 AND 4.0 THEN 'Poucas Horas'
		WHEN study_hours_per_day BETWEEN 4.0 AND 7.0 THEN 'Horas Ideais'
		ELSE 'Muitas Horas'
	END AS Horas_Estudos,

	CASE
		WHEN stress_level BETWEEN 0.0 AND 3.0 THEN 'Nível Baixo'
		WHEN stress_level BETWEEN 3.0 AND 6.0 THEN 'Nível Médio'
		ELSE 'Nível Alto'
	END AS Nivel_estresse ,
	AVG(burnout_score) AS nivel_burnout

FROM customer
GROUP BY Horas_sono, Horas_Estudos , Nivel_estresse
ORDER BY nivel_burnout DESC
LIMIT 5;


-- Qual perfil tem maior risco de dropout?

SELECT 
  CASE 
    WHEN burnout_score > 7 THEN 'Alto burnout'
    ELSE 'Baixo burnout'
  END AS burnout_level,
  
  CASE 
    WHEN mental_health_index < 5 THEN 'Baixa saúde mental'
    ELSE 'Saudável'
  END AS mental_status,
  
  COUNT(*) AS total,
  AVG(dropout_risk) AS avg_dropout_risk
FROM customer
GROUP BY burnout_level, mental_status
ORDER BY avg_dropout_risk DESC;



-- Probabilidade de dropout por nível de burnout
-- Risco de Evasão Escolar por Burnout

SELECT 
  CASE 
    WHEN burnout_score < 4 THEN 'Baixo'
    WHEN burnout_score BETWEEN 4 AND 7 THEN 'Médio'
    ELSE 'Alto'
  END AS nivel_burnout,
  AVG(dropout_risk) AS risco_dropout
FROM customer
GROUP BY nivel_burnout
ORDER BY risco_dropout DESC;

-- Correlação entre variáveis
-- Correlação de Burnout por Nível de Estresse, 
-- Horas de Sono e pontuação de Ansiedade

SELECT 
  CORR(stress_level, burnout_score) AS stress_vs_burnout,
  CORR(sleep_hours, burnout_score) AS sono_vs_burnout,
  CORR(anxiety_score, burnout_score) AS ansiedade_vs_burnout
FROM customer;