-- TRABALHO PR�TICO 2 DA DISCIPLINA DE SISTEMAS RECONFIGUR�VEIS
-- ALUNA: AMANDA VEIGA DE MOURA (737475)
-- TURMA: TER�A-FEIRA 20:50
-- 2024/2
-- OBJETIVO DO TRABALHO: Criar um Status conforme documenta��o

------------------------------------------------------------------------------------------------------------------------------
--bibliotecas


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity Status_reg is
    Port (
		
		--entradas
        nrst : in STD_LOGIC; -- entrada do reset ass�ncrono
        clk_in : in STD_LOGIC; -- entrada de clock para escrita no registrador
        abus_in : in STD_LOGIC_VECTOR(8 downto 0); -- entrada de endere�amento, o registrador deve ser escrito ou lido quando abus_in= "0000011"
        dbus_in : in STD_LOGIC_VECTOR(7 downto 0); -- entrada de dados para escrita no registrador
        wr_en : in STD_LOGIC; -- entrada de habilita��o para escrita. quando em n�vel l�gico alto, o registrador ser� escrito
        rd_en : in STD_LOGIC;-- entrada de habilita��o para leitura. deve corresponder ao registrador, exceto os birs 4 e 3. Quando desativada, ou o endere�o n�o corresponder, deve ficar em alta imped�ncia.("ZZZZZZZZ")
        
        z_in : in STD_LOGIC; -- entrada de dado para o bit 2 do regitrador, habilita em z_wr_en
        dc_in : in STD_LOGIC;-- entrada de dado para o bit 1 do regitrador, habilita em z_wr_en
        c_in : in STD_LOGIC;-- entrada de dado para o bit 0 do regitrador, habilita em z_wr_en
        z_wr_en : in STD_LOGIC; --Entrada para habilita��o da escrita no bit 2 do registrador
        dc_wr_en : in STD_LOGIC; -- Entrada para habilita��o da escrita no bit 2 do registrador
        c_wr_en : in STD_LOGIC; --Entrada para habilita��o da escrita no bit 2 do registrador
        
        --sa�das
        dbus_out : out STD_LOGIC_VECTOR(7 downto 0); --Sa�da de dados lidos com habilita��o atrav�s de rd_en e endere�amento por abus_in.
        irp_out : out STD_LOGIC; -- Sa�da correspondente ao bit 7 do registrador.
        rp_out : out STD_LOGIC_VECTOR(1 downto 0);--Sa�da correspondente aos bits 6 e 5 do registrador.
        z_out : out STD_LOGIC;--Sa�da correspondente ao bit 2 do registrador
        dc_out : out STD_LOGIC;--Sa�da correspondente ao bit 2 do registrador
        c_out : out STD_LOGIC  --Sa�da correspondente ao bit 2 do registrador
    );
end Status_reg;

architecture ARCH of Status_reg is
    signal s_reg : STD_LOGIC_VECTOR(7 downto 0); --auxiliar
begin
    process(clk_in, nrst)
    begin
        if nrst = '0' then 
            s_reg <= (others => '0');
        elsif rising_edge(clk_in) then
            if z_wr_en = '1' then
                s_reg(2) <= z_in; --entrada bit 2
            end if;
            if dc_wr_en = '1' then
                s_reg(1) <= dc_in; --entrada bit 1
            end if;
            if c_wr_en = '1' then
                s_reg(0) <= c_in;--entrada bit 0 
            elsif wr_en = '1' and abus_in(6 downto 0) = "0000011" then
                s_reg <= dbus_in;
            end if;
        end if;
    end process;

    dbus_out <= s_reg when (rd_en = '1' and abus_in(6 downto 0) = "0000011") else "ZZZZZZZZ";
    
    irp_out <= s_reg(7);-- bit 7
    rp_out <= s_reg(6 downto 5);-- bit 6 a 5
    
    z_out <= s_reg(2);-- bit 2
    dc_out <= s_reg(1);-- bit 1
    c_out <= s_reg(0);-- bit 0
    
end ARCH;
