PRAGMA foreign_keys = ON;

SELECT nome, avg(notaFinal) AS media_estudante FROM 
(SELECT * FROM INSTANCIA_DE_AVALIACAO 
JOIN AVALIACAO USING(idAvaliacao)
JOIN ESTUDANTE USING(idEstudante)
WHERE AVALIACAO.notaFinal >= 9.5
GROUP BY idEstudante
) GROUP BY nome;
