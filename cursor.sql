create database BancoCursor

go

use BancoCursor

go

-- Criar tabela Curso
CREATE TABLE Curso (
    Codigo INT PRIMARY KEY,
    Nome VARCHAR(100),
    Duracao INT
);
 
-- Inserir dados na tabela Curso
INSERT INTO Curso (Codigo, Nome, Duracao) VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600);
 
-- Criar tabela Disciplinas
CREATE TABLE Disciplinas (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nome VARCHAR(100),
    Carga_Horaria INT
);
 
-- Inserir dados na tabela Disciplinas
INSERT INTO Disciplinas (Codigo, Nome, Carga_Horaria) VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);
 
-- Criar tabela Disciplina_Curso
CREATE TABLE Disciplina_Curso (
    Codigo_Disciplina VARCHAR(10),
    Codigo_Curso INT
);
 
-- Inserir dados na tabela Disciplina_Curso
INSERT INTO Disciplina_Curso (Codigo_Disciplina, Codigo_Curso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);

go

create function fn_cursor(@codCurso int)
returns @tabela table (
	codDisciplina	varchar(10),
	nomeDisciplina	varchar(100),
	cargaHoraria	int,
	nomeCurso		varchar(100)
)
as
begin
		declare @codDisciplina varchar(10),
				@nomeDisciplina varchar(100),
				@cargaHoraria	int,
				@nomeCurso		varchar(100)

		set @cargaHoraria = 0

		declare c cursor for
				select d.Codigo, d.Nome, d.Carga_Horaria, c.Nome 
				from Disciplinas d, Curso c, Disciplina_Curso dc
				where d.Codigo = dc.Codigo_Disciplina and
					  c.Codigo = dc.Codigo_Curso and c.Codigo = @codCurso
		open c
		fetch next from c 
				into @codDisciplina, @nomeDisciplina, @cargaHoraria, @nomeCurso
		while @@FETCH_STATUS = 0
		begin
				
			insert into @tabela values (@codDisciplina, @nomeDisciplina, @cargaHoraria, @nomeCurso)

			fetch next from c into @codDisciplina, @nomeDisciplina, @cargaHoraria, @nomeCurso
		end

		close c
		deallocate c
		return

end

select * from fn_cursor(48)
