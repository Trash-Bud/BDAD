PRAGMA foreign_keys = ON;

SELECT DISTINCT STAFF.nome, CURSO.nome FROM STAFF
JOIN DOCENTE USING (idStaff)
JOIN LECIONA USING (idDocente)
JOIN PERTENCE_A USING (idCadeira)
JOIN CURSO USING (idCurso)
WHERE CURSO.nome = 'Mestrado Integrado de Engenharia Informática e Computação';