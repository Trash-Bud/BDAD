PRAGMA foreign_keys = ON;

SELECT avg(sum) as media_de_teste_por_estudante FROM (SELECT count(*) as sum FROM INSTANCIA_DE_AVALIACAO 
JOIN TESTE USING(idAvaliacao)
GROUP BY idEstudante);