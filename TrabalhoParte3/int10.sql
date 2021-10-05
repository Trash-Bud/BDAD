PRAGMA foreign_keys = ON;

SELECT * FROM DEPARTAMENTO 
WHERE strftime('%m', dataFundacao) == '09' AND julianday('now') - julianday(dataFundacao) >= julianday('now') - julianday('now','-21 years');