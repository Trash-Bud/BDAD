PRAGMA foreign_keys = ON;

SELECT nome, horaInicio, horaFim, diaDaSemana, tipo FROM BLOCO_HORARIO 
JOIN TURMA USING(idTurma) 
JOIN INSCRITO_EM_TURMA USING(idTurma) 
JOIN ESTUDANTE USING(idEstudante)
WHERE ESTUDANTE.nome = "Diogo Pereira";