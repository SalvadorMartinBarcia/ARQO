--------------------------------------------------------------------------------
-- Unidad de control principal del micro. Arq0 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_unit is
   port (
      -- Entrada = codigo de operacion en la instruccion:
      OpCode  : in  std_logic_vector (5 downto 0);
      -- Seniales para el PC
      Branch : out  std_logic; -- 1 = Ejecutandose instruccion branch
	  Jump  : out  std_logic; -- 1 = Ejecutandose instruccion jump
      -- Seniales relativas a la memoria
      MemToReg : out  std_logic; -- 1 = Escribir en registro la salida de la mem.
      MemWrite : out  std_logic; -- Escribir la memoria
      MemRead  : out  std_logic; -- Leer la memoria
      -- Seniales para la ALU
      ALUSrc : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
      ALUOp  : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
      -- Seniales para el GPR
      RegWrite : out  std_logic; -- 1=Escribir registro
      RegDst   : out  std_logic  -- 0=Reg. destino es rt, 1=rd
   );
end control_unit;

architecture rtl of control_unit is

   -- Tipo para los codigos de operacion:
   subtype t_opCode is std_logic_vector (5 downto 0);

   -- Codigos de operacion para las diferentes instrucciones:
   constant OP_RTYPE  : t_opCode := "000000";
   constant OP_BEQ    : t_opCode := "000100";
   constant OP_SW     : t_opCode := "101011";
   constant OP_LW     : t_opCode := "100011";
   constant OP_LUI    : t_opCode := "001111";

begin
	process (OpCode)
	begin
		case OpCode is  -- Cambiar ALUOp prob(?)
				when "000000"  => RegDst <= '1';  -- R-type
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '0';
								  ALUOp <= "010";
								  MemWrite <= '0';
								  ALUSrc <= '0';
								  RegWrite <= '1';
								  Jump <= '0';

				when "001000"  => RegDst <= '0';  -- ADDI
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '0';
								  ALUOp <= "000";
								  MemWrite <= '0';
								  ALUSrc <= '1';
								  RegWrite <= '1';
								  Jump <= '0';

				when "100011"  => RegDst <= '0'; -- LW
								  Branch <= '0';
								  MemRead <= '1';
								  MemToReg <= '1';
								  ALUOp <= "000";
								  MemWrite <= '0';
								  ALUSrc <= '1';
								  RegWrite <= '1';
								  Jump <= '0';

				when "101011"  => RegDst <= '-'; -- SW
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '-';
								  ALUOp <= "000";
								  MemWrite <= '1';
								  ALUSrc <= '1';
								  RegWrite <= '0';
								  Jump <= '0';

				when "001010"  => RegDst <= '0'; -- SLTI
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '0';
								  ALUOp <= "011";
								  MemWrite <= '0';
								  ALUSrc <= '1';
								  RegWrite <= '1';
								  Jump <= '0';

				when "000100"  => RegDst <= '-'; -- BEQ
								  Branch <= '1';
								  MemRead <= '0';
								  MemToReg <= '-';
								  ALUOp <= "001";
								  MemWrite <= '0';
								  ALUSrc <= '0';
								  RegWrite <= '0';
								  Jump <= '0';

				when "000010"  => RegDst <= '-'; -- J
								  Branch <= '-';
								  MemRead <= '-';
								  MemToReg <= '-';
								  ALUOp <= "---";
								  MemWrite <= '0';
								  ALUSrc <= '-';
								  RegWrite <= '0';
								  Jump <= '1';

				when "001111"  => RegDst <= '0'; -- LUI
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '0';
								  ALUOp <= "100";
								  MemWrite <= '0';
								  ALUSrc <= '1';
								  RegWrite <= '1';
								  Jump <= '0';

				when others => RegDst <= '0'; -- NOP
								  Branch <= '0';
								  MemRead <= '0';
								  MemToReg <= '0';
								  ALUOp <= "000";
								  MemWrite <= '0';
								  ALUSrc <= '0';
								  RegWrite <= '0';
								  Jump <= '0';
		end case;

	end process;

end architecture;
