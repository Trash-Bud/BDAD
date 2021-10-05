PRAGMA foreign_keys = ON;

CREATE TRIGGER AVOID_CONFILTING_ROOM_ASSIGNMENTS
BEFORE INSERT ON BLOCO_HORARIO
FOR EACH ROW
WHEN EXISTS(
    SELECT * FROM BLOCO_HORARIO
    WHERE NEW.horaInicio <= BLOCO_HORARIO.horaFim  AND NEW.diaDaSemana = BLOCO_HORARIO.diaDaSemana
    AND NEW.horaFim >= BLOCO_HORARIO.horaInicio AND NEW.idSala = BLOCO_HORARIO.idSala
)
BEGIN
	SELECT RAISE(ABORT, "Já existe um bloco horário nesta sala a estas horas! Abortando a inserção do bloco horário!");
END;
