-- TRABALHO PR�TICO 2 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar um FSR_reg conforme documenta��o

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY FSR_reg IS
	PORT (
	
		--entradas
		nrst : IN STD_LOGIC; --entrada de reset ass�ncrono
		clk_in : IN STD_LOGIC; --entrada clock para escrita no registrador
 	                           -- escrita (se habilitada) ocorre na subida do clock 
		abus_in : IN STD_LOGIC_VECTOR(8 DOWNTO 0); -- entrada de enderecamento 
		                                           --quando a entrada abus_in[6..0] = 0000100, o registrador deve ser lido ou escrito 
		                                           -- 7 bits menos signifiativos ser�o usados
		dbus_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- entrada de dados para escrita no registrador
										           -- habilita a partir de wr_en
		wr_en : IN STD_LOGIC;-- entrada de habilita��o para escrita no registrador
						     -- ativada = n�vel alto (1) => sincrono com o clock, ser� escrito o valor de d_in e se estiver presente em abus_in				 
		rd_en : IN STD_LOGIC; -- entrada para habilita�ao da leitura dbus_out = fsr_out
		
		--sa�das
		dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- saida da leitura, quando n�o usada ("ZZZZZZZZ")
		fsr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- saida do registrador
	);
END ENTITY;

ARCHITECTURE ARCH OF FSR_reg IS
	SIGNAL fsr_out_tmp : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

	PROCESS (clk_in, nrst)
	BEGIN
	IF nrst = '0' THEN
				fsr_out_tmp <= (OTHERS => '0');

	ELSIF rising_edge(clk_in) THEN
			
			IF abus_in (6 DOWNTO 0) = "0000100" THEN
				IF wr_en = '1' THEN
					fsr_out_tmp <= dbus_in;
				END IF;
			END IF;
			
		END IF;
		
	END PROCESS;
	fsr_out <= fsr_out_tmp;
	dbus_out <= fsr_out_tmp WHEN abus_in(6 DOWNTO 0) = "0000100" AND rd_en = '1' ELSE
		"ZZZZZZZZ";
END ARCH
;