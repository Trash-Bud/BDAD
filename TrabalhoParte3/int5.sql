PRAGMA foreign_keys = ON;

SELECT nome, count(idTurma) as num_of_turmas FROM INSCRITO_EM_TURMA
JOIN TURMA USING(idTurma) 
JOIN ESTUDANTE USING(idEstudante)
GROUP BY idEstudante;