--------------------------------------------------------------------------------
-- Bloque de control para la ALU. Arq0 2019-2020.
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES, Quitar este mensaje)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_control is
   port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
      Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
   );
end alu_control;

architecture rtl of alu_control is
   
begin

	process (Funct, ALUOp)
	begin
		case ALUOp is
			when "000" => ALUControl <= "0000"; -- ADD
			when "001" => ALUControl <= "0001"; -- SUB
			when "010" => case Funct is
							 when "100101"  => ALUControl <= "0111"; -- OR
							 when "100110"  => ALUControl <= "0110"; -- XOR
							 when "100100"  => ALUControl <= "0100"; -- AND
							 when "100010"  => ALUControl <= "0001"; -- SUB
							 when "100000"  => ALUControl <= "0000"; -- ADD
							 when others => ALUControl <= (others => '1'); -- Nada
						 end case;
			when "011" => ALUControl <= "1010"; -- SLTI
			when "100" => ALUControl <= "1101"; -- S16
			when others => ALUControl <= (others => '1'); -- Nada
		end case;
	end process;


end architecture;
