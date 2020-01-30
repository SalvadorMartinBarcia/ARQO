--------------------------------------------------------------------------------
-- Procesador MIPS con pipeline curso Arquitectura 2019-2020
--
-- (INCLUIR AQUI LA INFORMACION SOBRE LOS AUTORES)
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity processor is
   port(
      Clk         : in  std_logic; -- Reloj activo en flanco subida
      Reset       : in  std_logic; -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr      : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn    : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr      : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn      : out std_logic;                     -- Habilitacion lectura
      DWrEn      : out std_logic;                     -- Habilitacion escritura
      DDataOut   : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn    : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processor;
----------------------------------------------------------------------------------------------------------------------------------------------
architecture rtl of processor is 
	component control_unit
		port(
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
	end component;
	 
	component alu_control
		port(
		ALUOp  : in std_logic_vector (2 downto 0); -- Codigo de control desde la unidad de control
		Funct  : in std_logic_vector (5 downto 0); -- Campo "funct" de la instruccion
		-- Salida de control para la ALU:
		ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
		);
	end component;
	
	component reg_bank
		port(
		Clk   : in std_logic; -- Reloj activo en flanco de subida
		Reset : in std_logic; -- Reset asíncrono a nivel alto
		A1    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd1
		Rd1   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd1
		A2    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Rd2
		Rd2   : out std_logic_vector(31 downto 0); -- Dato del puerto Rd2
		A3    : in std_logic_vector(4 downto 0);   -- Dirección para el puerto Wd3
		Wd3   : in std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
		We3   : in std_logic -- Habilitación de la escritura de Wd3
		);
	end component;
	
	component alu
		port(
		OpA     : in  std_logic_vector (31 downto 0); -- Operando A
		OpB     : in  std_logic_vector (31 downto 0); -- Operando B
		Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
		Result  : out std_logic_vector (31 downto 0); -- Resultado
		ZFlag   : out std_logic                       -- Flag Z
		);
	end component;
	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	signal sys_OpCode: std_logic_vector (5 downto 0);
	signal sys_Branch : std_logic;
	signal sys_Jump  : std_logic; 
	signal sys_MemToReg : std_logic;
	signal sys_MemWrite : std_logic;
	signal sys_MemRead  : std_logic;
	signal sys_ALUSrc : std_logic;
	signal sys_ALUOp  : std_logic_vector (2 downto 0);
	signal sys_RegWrite : std_logic;
	signal sys_RegDst   : std_logic;
	
	signal sys_Zflag   : std_logic;
	
	signal sys_rs: std_logic_vector (4 downto 0);
	signal sys_rt: std_logic_vector (4 downto 0);
	signal sys_rd: std_logic_vector (4 downto 0);
	signal sys_A3: std_logic_vector (4 downto 0);
	signal sys_funct: std_logic_vector (5 downto 0);
	signal sys_immediate: std_logic_vector (15 downto 0);
	signal sys_immediate_extended: std_logic_vector (31 downto 0);
	signal sys_immediate_shifted: std_logic_vector (31 downto 0);
	signal sys_Branch_address: std_logic_vector (31 downto 0);
	signal sys_PCp4_Branch: std_logic_vector (31 downto 0);
	signal sys_PCNext: std_logic_vector (31 downto 0);
	signal sys_immJ: std_logic_vector (25 downto 0);
	
	signal sys_alu_control: std_logic_vector (3 downto 0);
		
	signal PC: std_logic_vector(31 downto 0);	
	signal PCp4: std_logic_vector(31 downto 0);
	
	signal Jump_address: std_logic_vector(31 downto 0);
	signal sys_Rd1: std_logic_vector(31 downto 0);
	signal sys_Rd2: std_logic_vector(31 downto 0);
	signal sys_Wd3: std_logic_vector(31 downto 0);
	signal sys_OpB: std_logic_vector(31 downto 0);
	signal sys_Res: std_logic_vector(31 downto 0);
begin

--Port Map de la unidad de control
i_control_unit: control_unit
port map(
	OpCode => sys_OpCode,
	Branch => sys_Branch,
	Jump => sys_Jump,
	MemToReg => sys_MemToReg,
	MemWrite => sys_MemWrite,
	MemRead => sys_MemRead,
	ALUSrc => sys_ALUSrc,
	ALUOp => sys_ALUOp,
	RegWrite => sys_RegWrite,
	RegDst => sys_RegDst
	
);
--PortMap del reg_bank
i_reg_bank: reg_bank
port map(
	Clk => Clk,
	Reset => Reset,
	A1 => sys_rs,
	Rd1 => sys_Rd1,
	A2 => sys_rt,
	Rd2 => sys_Rd2,
	A3 => sys_A3,
	Wd3 => sys_Wd3,
	We3 => sys_RegWrite	
);
--PortMap de la alu_control
i_alu_control: alu_control
port map(
	ALUOp => sys_ALUOp,
	Funct => sys_funct,
	ALUControl => sys_alu_control	
);	
--PortMap de la alu
i_alu: alu
port map(
	OpA => sys_Rd1,
	OpB => sys_OpB,
	Control => sys_alu_control,
	Result => sys_Res,
	ZFlag => sys_Zflag	
);
---------------------------------------------------------------------------------------------------------------------------------------
sys_Branch_address <= PCp4 + sys_immediate_shifted;
DRdEn <= sys_MemRead;
DWrEn <= sys_MemWrite;
DDataOut <= sys_Rd2;
DAddr <= sys_Res;
sys_OpCode <= IDataIn(31 downto 26);
sys_funct <= IDataIn(5 downto 0);
sys_rs <= IDataIn(25 downto 21);
sys_rt <= IDataIn(20 downto 16);
sys_rd <= IDataIn(15 downto 11);
sys_immediate <= IDataIn(15 downto 0);
sys_immJ <= IDataIn(25 downto 0);
PCp4 <= PC + 4;
Jump_address <= PCp4(31 downto 28) & sys_immJ & "00";
sys_immediate_extended(15 downto 0) <= sys_immediate;
sys_immediate_extended(31 downto 16) <= (others => sys_immediate(15));

sys_immediate_shifted(17 downto 0) <= sys_immediate & "00";
IAddr <=PC;
sys_immediate_shifted(31 downto 18) <= (others => sys_immediate(15));
---------------------------------------------------------------------------------------------------------------------------------------
sys_A3 <= sys_rd when sys_RegDst = '1' else
		  sys_rt when sys_RegDst = '0' else
		  "00000";
		  
sys_OpB <= sys_immediate_extended when sys_ALUSrc = '1' else
		  sys_Rd2 when sys_ALUSrc = '0';

sys_Wd3 <= DDataIn when sys_MemToReg = '1' else
		  sys_Res when sys_MemToReg = '0';
		  
sys_PCp4_Branch <= sys_Branch_address when (sys_Branch and sys_Zflag) = '1' else
		  PCp4 when (sys_Branch and sys_Zflag) = '0';
		  
		  
sys_PCNext <= Jump_address when sys_Jump = '1' else
			 sys_PCp4_Branch when sys_Jump = '0';
		  
---------------------------------------------------------------------------------------------------------------------------------------
process(Clk, Reset)
begin
	if Reset = '1' then
		PC <= (others => '0');
	elsif rising_edge(Clk) then
		PC <= sys_PCNext;
		
	end if;
end process;

end architecture;

