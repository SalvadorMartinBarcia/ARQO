--------------------------------------------------------------------------------
-- Bloque de adelantamiento de datos
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES, Quitar este mensaje)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hazard_detection_unit is
   port (
      -- Entradas:
      Rs_ID      : in std_logic_vector (4 downto 0); -- Rs en la fase ID
      Rt_ID      : in std_logic_vector (4 downto 0); -- Rt en la fase ID
      Rt_EX  : in std_logic_vector (4 downto 0); -- Rt en la fase EX
      MemRead   : in std_logic; -- Flag de habilitacion de lectura de la memoria
      -- Salida de adelantamiento de datos:
      IF_ID_WE : out std_logic; -- Flag de habilitacion de escritura de la Fase IF/ID
      PC_WE : out std_logic; -- Flag de habilitacion de escritura del PC
	  Stall_Mux: out std_logic -- Multiplexor usado para generar la burbuja
      );
end hazard_detection_unit;

architecture rtl of hazard_detection_unit is
begin

IF_ID_WE <= '0' when (MemRead = '1' and ((Rt_EX = Rs_ID) or (Rt_EX = Rt_ID))) else
			'1';
			
PC_WE <= '0' when (MemRead = '1' and ((Rt_EX = Rs_ID) or (Rt_EX = Rt_ID))) else
	     '1';
			
Stall_Mux <= '0' when (MemRead = '1' and ((Rt_EX = Rs_ID) or (Rt_EX = Rt_ID))) else
			 '1';

end architecture;
