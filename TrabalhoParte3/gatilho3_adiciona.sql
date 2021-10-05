PRAGMA foreign_keys = ON;

CREATE TRIGGER AVOID_CONFLICTING_STUDENT_TIMETABLES
BEFORE INSERT ON INSCRITO_EM_TURMA
FOR EACH ROW
WHEN NOT EXISTS(
    SELECT * FROM INSCRITO_EM_CURSO
    JOIN PERTENCE_A USING(idCurso)
    JOIN Turma USING(idCadeira)
    WHERE NEW.idTurma = idTurma AND NEW.idEstudante = idEstudante
)
BEGIN
	SELECT RAISE(ABORT, "Estudante não se pode inscrever em cadeiras que não pertençam ao seu curso!");
END;
