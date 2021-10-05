PRAGMA foreign_keys = ON;

SELECT nome, count(idSala) AS num_of_salas FROM CONTINUO
JOIN NAO_DOCENTE USING(idNaoDocente)
JOIN STAFF USING(idStaff)
JOIN LIMPA USING(idContinuo)
GROUP BY idContinuo;