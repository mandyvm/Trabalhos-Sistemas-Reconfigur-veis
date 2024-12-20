-- TRABALHO PR�TICO 1 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Cria��o de um Multiplexador com sa�da de 9 bits

-----------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MUX IS 
	PORT (
		rp_in: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		dir_addr_in: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		irp_in: IN STD_LOGIC;
		ind_addr_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0);	
		
		abus_out: OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE ARCH OF MUX IS
BEGIN

	abus_out <= irp_in & ind_addr_in WHEN dir_addr_in = "0000000" ELSE rp_in & dir_addr_in;

END ARCH;