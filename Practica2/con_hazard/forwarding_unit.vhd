--------------------------------------------------------------------------------
-- Bloque de adelantamiento de datos
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES, Quitar este mensaje)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity forwarding_unit is
   port (
      -- Entradas:
      A1      : in std_logic_vector (4 downto 0); -- Direccion del registro A1 del banco de registros
      A2      : in std_logic_vector (4 downto 0); -- Direccion del registro A2 del banco de registros
      A3_MEM  : in std_logic_vector (4 downto 0); -- Direccion del registro en el que se escribe en la fase MEM
      A3_WB   : in std_logic_vector (4 downto 0); -- Direccion del registro en el que se escribe en la fase WB
      We_MEM  : in std_logic; -- Write enable del banco de registros en la fase MEM
      We_WB   : in std_logic; -- Write enable del banco de registros en la fase WB
      -- Salida de adelantamiento de datos:
      OpA_Mux : out std_logic_vector (1 downto 0); -- Multiplexor del operador A de la ALU
      OpB_Mux : out std_logic_vector (1 downto 0) -- Multiplexor del operador B de la ALU
      );
end forwarding_unit;

architecture rtl of forwarding_unit is
begin

OpA_Mux <= "10" when (We_MEM = '1') and (A1 = A3_MEM) and (A3_MEM /= "00000") else
  			 "01" when (We_WB = '1') and (A1 = A3_WB) and (A3_WB /= "00000") else
         "00";

OpB_Mux <= "10" when (We_MEM = '1') and (A2 = A3_MEM) and (A3_MEM /= "00000") else
 			 "01" when (We_WB = '1') and (A2 = A3_WB) and (A3_WB /= "00000") else
       "00";


end architecture;
