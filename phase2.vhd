----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:10:14 12/01/2014 
-- Design Name: 
-- Module Name:    Paser2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phase2 is
port(
	clk : in std_logic;
	rst : in std_logic;
	enable : in std_logic;
	is_done : in std_logic;
	pc_in : in std_logic_vector(15 downto 0);
	pc_out : out std_logic_vector(15 downto 0);
	instruction_in : in std_logic_vector(15 downto 0);
	instruction_out : out std_logic_vector(15 downto 0);
	A_in : in std_logic_vector(15 downto 0);
	B_in : in std_logic_vector(15 downto 0);
	A_out: out std_logic_vector(15 downto 0);
	B_out: out std_logic_vector(15 downto 0);
	imm_in : in std_logic_vector(15 downto 0);
	imm_out : out std_logic_vector(15 downto 0);
	back_reg_in : in std_logic_vector(3 downto 0);
	back_reg_out : out std_logic_vector(3 downto 0);
	rx_in : in std_logic_vector(3 downto 0);
	rx_out : out std_logic_vector(3 downto 0);
	ry_in : in std_logic_vector(3 downto 0);
	ry_out : out std_logic_vector(3 downto 0);
	write_back_in : in std_logic;
	write_back_out : out std_logic;
	b_or_imm_in : in std_logic;
	b_or_imm_out : out std_logic;
	alu_op_in: in std_logic_vector(3 downto 0);
	alu_op_out: out std_logic_vector(3 downto 0);
	back_data_in : in std_logic_vector(1 downto 0);
	back_data_out : out std_logic_vector(1 downto 0);
	if_mem_in : in std_logic;
	if_mem_out : out std_logic;
	mem_read_in : in std_logic;
	mem_read_out : out std_logic;
	mem_write_in : in std_logic;
	mem_write_out : out std_logic
);

end phase2;

architecture Behavioral of phase2 is
signal pc : std_logic_vector(15 downto 0);
signal instruction : std_logic_vector(15 downto 0);
signal A : std_logic_vector(15 downto 0);
signal B : std_logic_vector(15 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal write_back : std_logic;
signal b_or_imm : std_logic;
signal alu_op: std_logic_vector(3 downto 0);
signal back_data : std_logic_vector(1 downto 0);
signal back_reg : std_logic_vector(3 downto 0);
signal rx : std_logic_vector(3 downto 0);
signal ry : std_logic_vector(3 downto 0);
signal if_mem : std_logic;
signal mem_read : std_logic;
signal mem_write : std_logic;
begin
	pc_out <= pc;
	A_out <= A;
	B_out <= B;
	imm_out <= imm;
	write_back_out <= write_back;
	b_or_imm_out <= b_or_imm;
	alu_op_out <= alu_op;
	back_data_out <= back_data;
	back_reg_out <= back_reg;
	rx_out <= rx;
	ry_out <= ry;
	instruction_out <= instruction;
	if_mem_out <= if_mem;
	mem_read_out <= mem_read;
	mem_write_out <= mem_write;
	process(clk)
	begin
		if (rst = '0') then
			pc <= (others => '0');
			instruction <= (others => '0');
			A <= (others => '0');
			B <= (others => '0');
			imm <= (others => '0');
			write_back <= '0';
			b_or_imm <= '0';
			alu_op <= (others => '0');
			back_data <= (others => '0');
			back_reg <= (others => '0');
			rx <= (others => '0');
			ry <= (others => '0');
			if_mem <= '0';
			mem_read <= '0';
			mem_write <= '0';
		elsif (clk'event and clk = '1')then
			if (enable = '1' and is_done = '1') then
				pc <= pc_in;
				instruction <= instruction_in;
				A <= A_in;
				B <= B_in;
				imm <= imm_in;
				write_back <= write_back_in;
				b_or_imm <= b_or_imm_in;
				alu_op <= alu_op_in;
				back_data <= back_data_in;
				back_reg <= back_reg_in;
				rx <= rx_in;
				ry <= ry_in;
				if_mem <= if_mem_in;
				mem_read <= mem_read_in;
				mem_write <= mem_write_in;
			end if;
		end if;
	end process;
end Behavioral;
