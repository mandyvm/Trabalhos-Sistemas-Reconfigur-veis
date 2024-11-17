-- TRABALHO PR�TICO 2 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar um PC_reg conforme documenta��o

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY PC_reg IS
	PORT (
		--entradas
		nrst : IN STD_LOGIC; --entrada de reset ass�ncrono
		clk_in : IN STD_LOGIC; --entrada de clock para incremento e carga dos registradores.
		addr_in : IN STD_LOGIC_VECTOR(10 DOWNTO 0); --entrada de dados para carga no registrador PC
		abus_in : IN STD_LOGIC_VECTOR(8 DOWNTO 0); --entrada de endere�amento para PCL e para o registrador PCLATH
		dbus_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --entrada de dados para escrita em PCL e PCLATH
		inc_pc : IN STD_LOGIC; --entrada de habilita��o para incremento
		load_pc : IN STD_LOGIC; --entrada de habilita��o para carga.
		wr_en : IN STD_LOGIC; --entrada de habilita��o para escrita nos registradores.
		rd_en : IN STD_LOGIC; -- entrada de habilita��o para leitura
		stack_push : IN STD_LOGIC; -- entrada de habilita��o para colocar valores na pilha.
		stack_pop : IN STD_LOGIC; -- entrada de habilita��o para retirar valores da pilha.

		--sa�das
		nextpc_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0); --sa�da do valor a ser carregado no contador (entrada do registrador PC
		dbus_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) --sa�da de dados lidos com habilita��o atrav�s de rd_en e endere�amento por abus_in

	);
END ENTITY;

ARCHITECTURE ARCH OF PC_reg IS
    TYPE stack_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(12 DOWNTO 0);
	SIGNAL stack_reg : stack_type;
    
    SIGNAL PC : STD_LOGIC_VECTOR(12 downto 0);
    SIGNAL PCLATH : STD_LOGIC_VECTOR(7 downto 0);
    
BEGIN
    PROCESS(nrst, clk_in)
    BEGIN
    
        IF nrst = '0' THEN
            stack_reg <= (OTHERS => (OTHERS => '0'));
            PC <= (OTHERS => '0');
            PCLATH <= (OTHERS => '0');
            
        ELSIF rising_edge(clk_in) THEN
            IF inc_pc = '1' THEN 
                PC <= PC + 1;
                
            ELSIF load_pc = '1' THEN
                PC(12 downto 11) <= PCLATH(4 downto 3);
                PC(10 downto 0) <= addr_in;
                
            ELSIF wr_en = '1' THEN
                IF  abus_in(6 DOWNTO 0) = "0000010" THEN
                    PC(7 DOWNTO 0) <= dbus_in;
                    PC(12 DOWNTO 8) <= PCLATH(4 DOWNTO 0);
                    
                ELSIF abus_in(6 DOWNTO 0) = "0001010" THEN
                    PCLATH <= dbus_in;
                END IF;
                
            END IF;
            
        END IF;
    END PROCESS;

    dbus_out <=
				PC(7 DOWNTO 0) WHEN rd_en = '1' AND abus_in(6 DOWNTO 0) = "0000010" ELSE
				PCLATH WHEN rd_en = '1' AND abus_in(6 DOWNTO 0) = "0001010" ELSE
				"ZZZZZZZZ";
		 
    nextpc_out <= stack_reg(0) WHEN stack_pop = '1' ELSE
				  PC + 1 WHEN inc_pc = '1' ELSE
				  PCLATH(4 DOWNTO 3) & addr_in WHEN load_pc = '1' ELSE
				  PCLATH(4 DOWNTO 0) & dbus_in WHEN wr_en = '1' ELSE
				  PC;
end ARCH;