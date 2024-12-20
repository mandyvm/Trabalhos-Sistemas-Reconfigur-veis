-- TRABALHO PR�TICO 1 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar uma unidade l�gica aritm�tica que faz opera��es l�gicas e aritm�ticas em palavras de 8bits.
--						Ser�o ao todo 16 tipos de opera��es. 

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;



ENTITY ALU IS 
	PORT (
		a_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- entrada 'a' de dados
		b_in: IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- entrada 'b' de dados
		c_in: IN STD_LOGIC; -- carry in
		op_sel: IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- entrada para selecionar a opera��o a ser usada
		bit_sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- entrada de sele��o de bit (opera��es como BC e BS)

		
		r_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --sa�da para o resultado 
		c_out: OUT STD_LOGIC; -- carry out
		dc_out: OUT STD_LOGIC; -- sa�da digit carry/borrow 
							   -- na soma: � o vai um
							   -- na subtra��o: � o pegar emprestado
		z_out: OUT STD_LOGIC -- sa�da zero, caso o resultado for zero
	);
END ENTITY;

----------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE ARCH_ALU OF ALU IS

	SIGNAL aux : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	SIGNAL a : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL b : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	SIGNAL op_bcs: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL z_bcs : 	STD_LOGIC;
	
	SIGNAL aux_n: STD_LOGIC_VECTOR(4 DOWNTO 0);
	
BEGIN
	a <= '0' & a_in;
	b <= '0' & b_in;

	WITH bit_sel SELECT
			
			 op_bcs <= "11111110" WHEN "000",
					"11111101" WHEN "001",
					"11111011" WHEN "010",
					"11110111" WHEN "011",
					"11101111" WHEN "100",
					"11011111" WHEN "101",
					"10111111" WHEN "110",
					"01111111" WHEN "111";	
	WITH bit_sel SELECT
			z_bcs <= a_in(0) WHEN "000", 
			         a_in(1) WHEN "001", 
			         a_in(2) WHEN "010", 
			         a_in(3) WHEN "011", 
			         a_in(4) WHEN "100", 
			         a_in(5) WHEN "101", 
			         a_in(6) WHEN "110", 
			         a_in(7) WHEN "111";
		------------------------------------------------------------
	
	WITH op_sel SELECT
	
			 aux <=  ('0' & a_in) XOR ('0' & b_in) WHEN "0000", --XOR 
				     ('0' & a_in) OR ('0' & b_in) WHEN "0001",-- OR 
				     '0' & (a_in AND b_in) WHEN "0010", -- AND 
				     "000000000" WHEN "0011", --  limpa
				
				     ('0' & a_in) + ('0' & b_in) WHEN "0100", -- ADD
			         ('0' & a_in) - ('0' & b_in) WHEN "0101", -- SUB
			    
				     ('0' & a_in) + 1 WHEN "0110", --incremento
			         ('0' & a_in) - 1 WHEN "0111", --decremento
			    
			         '0' & a_in WHEN "1000", -- passa a
			         '0' & b_in WHEN "1001", -- passa b
			    
			         NOT ('0' & a_in) WHEN "1010", -- complemento
			    
			         '0' & a_in(3 DOWNTO 0) & a_in(7 DOWNTO 4) WHEN "1011", --swap
			    
			         '0' & a_in OR (NOT op_bcs) WHEN "1100", -- BS ajusta em '1' o bit apontado por bit_sel
			         '0' & a_in AND op_bcs WHEN "1101", -- BC limpa o bit apontado por bit_sel				

				
				     '0' & c_in & a_in(7 DOWNTO 1) WHEN "1110", -- rota��o direita com carry (RR)
				     '0' & a_in(6 DOWNTO 0) & c_in WHEN "1111"; -- rota��o esquerda com carry (RL)
				     
				
	r_out <= aux(7 DOWNTO 0);
				
	z_out <= z_bcs WHEN op_sel = "1101" OR op_sel = "1100" ELSE
			'1' WHEN aux(7 DOWNTO 0) = "00000000" ELSE 
			'0';
		---------------------------------------------------------------------------			
	
	-- SA�DAS	
		WITH op_sel SELECT	
	c_out <= aux(8) WHEN "0100" , -- carry em add
				 aux(7) WHEN "0101"  , -- carry em sub	         
				 a_in(0) WHEN "1110" , -- carry em RR
				 a_in(7) WHEN "1111" , -- carry em RL
				 '0' WHEN OTHERS;
				 
		
	aux_n <= ('0' & a(3 DOWNTO 0)) + ('0' & b(3 DOWNTO 0)) WHEN op_sel = "0100" ELSE 
		    ('0' & a(3 DOWNTO 0)) - ('0' & b(3 DOWNTO 0)) WHEN op_sel = "0101" ELSE 
		      "00000";
		          
	dc_out <= aux_n(4);	 
	

END ARCH_ALU;



