-- TRABALHO PRÁTICO 2 DA DISCIPLINA DE SISTEMAS RECONFIGURÁVEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TERÇA-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar um Stack conforme documentação

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY Stack IS
    PORT (
    
    --entradas
        nrst : IN STD_LOGIC; -- entrada do reser assíncorono
        clk_in : IN STD_LOGIC; -- entrada de clock para escrita em registradores. 
        stack_in : IN STD_LOGIC_VECTOR(12 DOWNTO 0); -- entrada de dados da pilha
        stack_push : IN STD_LOGIC; -- entrada de habilitação para colocar valores na pilha
        stack_pop : IN STD_LOGIC; -- Entrada de habilitação para retirar valores na pilha
        
    --saídas    
        stack_out : OUT STD_LOGIC_VECTOR(12 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE ARCH OF Stack IS
    		TYPE stack_type IS ARRAY(0 to 7) OF STD_LOGIC_VECTOR(12 DOWNTO 0);
		    SIGNAL stack_reg : stack_type;
BEGIN
    PROCESS(nrst, clk_in)
    BEGIN
        IF nrst = '0' THEN
            stack_reg <= (others => (others => '0'));
            
        ELSIF rising_edge(clk_in) THEN
            IF stack_pop = '1' THEN   
                stack_reg(7) <=(others => '0');
                stack_reg(0 to 6) <= stack_reg (1 to 7);
                
            ELSIF stack_push = '1' THEN
                stack_reg(0) <= stack_in;
                stack_reg(1 to 7) <= stack_reg (0 to 6);
                
            END IF;   
        END IF;
    END PROCESS;    
                

    stack_out <= stack_reg(0);
end ARCH;