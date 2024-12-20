-- TRABALHO PR�TICO 2 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar um W_reg conforme documenta��o

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY W_reg IS 
	PORT (
	
	nrst: IN STD_LOGIC; --entrada de reset ass�ncrono
						-- ativada = n�vel baixo (0) => bits zerados "00000000"					
	clk_in: IN STD_LOGIC; --entrada clock para escrita no registrador
 	                      -- escrita (se habilitada) ocorre na subida do clock 
	d_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- entrada de dados para escrita no registrador
										   -- habilita a partir de wr_en
	wr_en: IN STD_LOGIC; -- entrada de habilita��o para escrita no registrador
						 -- ativada = n�vel alto (1) => sincrono com o clock, ser� escrito o valor de d_in
	
	w_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- saida de dados do registrador
	);
END ENTITY;

ARCHITECTURE ARCH OF W_reg IS	

BEGIN

	process(clk_in, nrst)
	BEGIN
		IF nrst = '0' THEN --n�vel baixo para nrst
			w_out <= (others => '0'); -- sa�da ser� 0's
		ELSIF rising_edge(clk_in) THEN --caso contr�rio subida do clk 
			IF wr_en = '1' THEN -- wr_en n�vel alto
				w_out <= d_in; --sa�da ser� os valores de d_in
			END IF;
		END IF;
	END PROCESS;

END ARCH;