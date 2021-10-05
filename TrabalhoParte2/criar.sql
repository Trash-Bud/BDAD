PRAGMA foreign_keys=ON;

DROP TABLE IF EXISTS PAVILHAO;
CREATE TABLE PAVILHAO(
    idPavilhao INTEGER PRIMARY KEY,
    localizacao TEXT NOT NULL
);

DROP TABLE IF EXISTS CANTINA;
CREATE TABLE CANTINA(   
	idCantina INTEGER PRIMARY KEY,
	idPavilhao INTEGER REFERENCES PAVILHAO(idPavilhao),
	lotacao INTEGER CONSTRAINT VALID_LOT check (lotacao > 0)
);

DROP TABLE IF EXISTS FORNECEDOR_DE_COMIDA;
CREATE TABLE FORNECEDOR_DE_COMIDA(
	idFornecedor INTEGER PRIMARY KEY,
	nome TEXT NOT NULL
);

DROP TABLE IF EXISTS ESTUDANTE;
CREATE TABLE ESTUDANTE(
	idEstudante INTEGER PRIMARY KEY,
	nome TEXT NOT NULL,
    nif INTEGER UNIQUE,
    morada TEXT NOT NULL,
    telefone INTEGER UNIQUE
);

DROP TABLE IF EXISTS STAFF;
CREATE TABLE STAFF(
	idStaff INTEGER PRIMARY KEY,
	nome TEXT NOT NULL,
    nif INTEGER UNIQUE,
    salario FLOAT CONSTRAINT VALID_SALARY check(salario > 0)
);

DROP TABLE IF EXISTS DOCENTE;
CREATE TABLE DOCENTE(
	idDocente INTEGER PRIMARY KEY,
    idDepartamento INTEGER REFERENCES DEPARTAMENTO(idDepartamento),
    especializacao TEXT NOT NULL,
    idStaff INTEGER UNIQUE REFERENCES STAFF(idStaff)
);

DROP TABLE IF EXISTS NAO_DOCENTE;
CREATE TABLE NAO_DOCENTE(
	idNaoDocente INTEGER PRIMARY KEY,
	duracaoContrato INTEGER NOT NULL CONSTRAINT VALID_CONTRACT_DURATION check(duracaoContrato > 0),
    idStaff INTEGER UNIQUE REFERENCES STAFF(idStaff)
);

DROP TABLE IF EXISTS SEGURANCA;
CREATE TABLE SEGURANCA(
	idSeguranca INTEGER PRIMARY KEY,
	idNaoDocente INTEGER UNIQUE REFERENCES NAO_DOCENTE(idNaoDocente)
);

DROP TABLE IF EXISTS COZINHEIRO;
CREATE TABLE COZINHEIRO(
	idCozinheiro INTEGER PRIMARY KEY,
	idNaoDocente INTEGER UNIQUE REFERENCES NAO_DOCENTE(idNaoDocente)
);

DROP TABLE IF EXISTS CONTINUO;
CREATE TABLE CONTINUO(
	idContinuo INTEGER PRIMARY KEY,
	idNaoDocente INTEGER UNIQUE REFERENCES NAO_DOCENTE(idNaoDocente)
);

DROP TABLE IF EXISTS UNIDADE_CURRICULAR;
CREATE TABLE UNIDADE_CURRICULAR(
	idCadeira INTEGER PRIMARY KEY,
    regente INTEGER REFERENCES DOCENTE(idDocente),
    nome TEXT NOT NULL,
    notaMinima FLOAT CONSTRAINT VALID_NOTA_MINIMA check(notaMinima > 0 AND notaMinima <= 9.5),
    taxadeReprovacao FLOAT CONSTRAINT VALID_TAXA_REPROVA check (taxadeReprovacao >= 0 AND taxadeReprovacao <= 100)
);


DROP TABLE IF EXISTS AVALIACAO;
CREATE TABLE AVALIACAO(
	idAvaliacao INTEGER PRIMARY KEY,
    dataAvaliacao DATE NOT NULL,
    notaFinal FLOAT CONSTRAINT VALID_NOTA_FINAL check(notaFinal >= 0 AND notaFinal <= 20),
    pesoComponente FLOAT CONSTRAINT VALID_PESO_COMPONENTE check(pesoComponente >= 0 AND pesoComponente <= 100)
);

DROP TABLE IF EXISTS TESTE;
CREATE TABLE TESTE(
	idTeste INTEGER PRIMARY KEY,
    duracao INTEGER CONSTRAINT VALID_DURACAO check(duracao > 0),
    idAvaliacao INTEGER UNIQUE REFERENCES AVALIACAO(idAvaliacao)
);

DROP TABLE IF EXISTS EXAME_FINAL;
CREATE TABLE EXAME_FINAL(
	idExame INTEGER PRIMARY KEY,
    duracao INTEGER CONSTRAINT VALID_DURACAO check(duracao > 0),
    idAvaliacao INTEGER UNIQUE REFERENCES AVALIACAO(idAvaliacao)
);

DROP TABLE IF EXISTS TRABALHO;
CREATE TABLE TRABALHO(
	idTrabalho INTEGER PRIMARY KEY,
    dataEntrega DATE NOT NULL,
    idAvaliacao INTEGER UNIQUE REFERENCES AVALIACAO(idAvaliacao)
);

DROP TABLE IF EXISTS BLOCO_HORARIO;
CREATE TABLE BLOCO_HORARIO(
	idHorario INTEGER PRIMARY KEY,
    horaInicio TIME NOT NULL,
    horaFim TIME NOT NULL,
    diaDaSemana TEXT NOT NULL CONSTRAINT VALID_DAY check (diaDaSemana == 'Seg' OR diaDaSemana == 'Ter' OR diaDaSemana == 'Qua' OR diaDaSemana == 'Qui' OR diaDaSemana == 'Sex' OR diaDaSemana  == 'Sab'),
    tipo TEXT NOT NULL CONSTRAINT VALID_TYPE check (tipo == 'PRÁTICA' OR tipo == 'TUTORIAL' OR tipo == 'TEÓRICO-PRÁTICA' OR tipo == 'TEÓRICA' OR tipo == 'LABORATORIAL'),
    idTurma INTEGER REFERENCES TURMA(idTurma),
    idSala INTEGER REFERENCES SALA(idSala),
    CONSTRAINT VALID_HORA check (horaFim > horaInicio)
);

DROP TABLE IF EXISTS TURMA;
CREATE TABLE TURMA(
    idTurma INTEGER PRIMARY KEY,
	idCadeira INTEGER REFERENCES UNIDADE_CURRICULAR(idCadeira),
	numero INTEGER CONSTRAINT VALID_NUMERO check(numero > 0),
	ano INTEGER CONSTRAINT VALID_ANO check(ano > 0),
    UNIQUE (idCadeira,numero,ano)
);

DROP TABLE IF EXISTS CURSO;
CREATE TABLE CURSO(
	idCurso INTEGER PRIMARY KEY,
    diretor INTEGER REFERENCES DOCENTE(idDocente),
    nome TEXT NOT NULL,
    notaMinimaIngresso FLOAT CONSTRAINT VALID_NOTA_MINIMA check (notaMinimaIngresso > 0 AND notaMinimaIngresso <= 20),
    vagas INTEGER CONSTRAINT VALID_VAGAS check (vagas > 0)

);

DROP TABLE IF EXISTS ANDAR;
CREATE TABLE ANDAR(
	idAndar INTEGER PRIMARY KEY,
    idPavilhao INTEGER REFERENCES PAVILHAO(idPavilhao),
    numero INTEGER

);

DROP TABLE IF EXISTS SALA;
CREATE TABLE SALA(
	idSala INTEGER PRIMARY KEY,
	idAndar INTEGER REFERENCES ANDAR(idAndar),
	numero INTEGER CONSTRAINT VALID_NUMERO check(numero > 0),
	lotacao INTEGER CONSTRAINT VALID_LOTACAO check(lotacao > 0)
);

DROP TABLE IF EXISTS DEPARTAMENTO;
CREATE TABLE DEPARTAMENTO(
	idDepartamento INTEGER PRIMARY KEY,
    chefeDoDepartamento INTEGER REFERENCES DOCENTE(idDocente),
    nome TEXT NOT NULL,
    dataFundacao DATE NOT NULL

);

DROP TABLE IF EXISTS CONTRATO_FORNECE_COMIDA;
CREATE TABLE CONTRATO_FORNECE_COMIDA(
	idFornecedor INTEGER REFERENCES FORNECEDOR_DE_COMIDA(idFornecedor),
    idCantina INTEGER REFERENCES CANTINA(idCantina),
	duracaoContrato INTEGER CONSTRAINT VALID_DURATION check(duracaoContrato > 0),
    PRIMARY KEY(idFornecedor,idCantina)
);

DROP TABLE IF EXISTS COZINHA_EM;
CREATE TABLE COZINHA_EM(
	idCozinheiro INTEGER REFERENCES COZINHEIRO(idCozinheiro),
    idCantina INTEGER REFERENCES CANTINA(idCantina),
    PRIMARY KEY (idCozinheiro, idCantina)
);

DROP TABLE IF EXISTS INSTANCIA_DE_AVALIACAO;
CREATE TABLE INSTANCIA_DE_AVALIACAO(
	idEstudante INTEGER REFERENCES ESTUDANTE(idEstudante),
    idCadeira INTEGER REFERENCES UNIDADE_CURRICULAR(idCadeira),
    idAvaliacao INTEGER UNIQUE REFERENCES AVALIACAO(idAvaliacao),
    PRIMARY KEY (idEstudante,idCadeira,idAvaliacao)
);

DROP TABLE IF EXISTS INSCRITO_EM;
CREATE TABLE INSCRITO_EM(
	idEstudante INTEGER REFERENCES ESTUDANTE(idEstudante),
    idTurma INTEGER REFERENCES TURMA(idTurma),
    PRIMARY KEY(idEstudante,idTurma)
);

DROP TABLE IF EXISTS LECIONA;
CREATE TABLE LECIONA(
	idDocente INTEGER REFERENCES DOCENTE(idDocente),
    idCadeira INTEGER REFERENCES UNIDADE_CURRICULAR(idCadeira),
    PRIMARY KEY(idDocente,idCadeira)
);

DROP TABLE IF EXISTS PERTENCE_A;
CREATE TABLE PERTENCE_A(
	idCadeira INTEGER REFERENCES UNIDADE_CURRICULAR(idCadeira),
    idCurso INTEGER REFERENCES CURSO(idCurso),
    PRIMARY KEY(idCadeira,idCurso)
);

DROP TABLE IF EXISTS ATRIBUIDO_A;
CREATE TABLE ATRIBUIDO_A(
	idDocente INTEGER REFERENCES DOCENTE(idDocente),
    idTurma INTEGER REFERENCES TURMA(idTurma),
    PRIMARY KEY(idDocente,idTurma)
);

DROP TABLE IF EXISTS LIMPA;
CREATE TABLE LIMPA(
	idContinuo INTEGER REFERENCES CONTINUO(idContinuo),
    idSala INTEGER REFERENCES SALA(idSala),
    PRIMARY KEY(idContinuo,idSala)
);

DROP TABLE IF EXISTS GUARDA;
CREATE TABLE GUARDA(
	idSeguranca INTEGER REFERENCES SEGURANCA(idSeguranca),
    idPavilhao INTEGER REFERENCES PAVILHAO(idPavilhao),
    PRIMARY KEY(idSeguranca,idPavilhao)
);

DROP TABLE IF EXISTS DEPARTAMENTO_TEM_PAVILHAO;
CREATE TABLE DEPARTAMENTO_TEM_PAVILHAO(
	idPavilhao INTEGER REFERENCES PAVILHAO(idPavilhao),
    idDepartamento INTEGER REFERENCES DEPARTAMENTO(idDepartamento),
    PRIMARY KEY(idPavilhao,idDepartamento)
);