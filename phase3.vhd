----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:21:29 12/02/2014 
-- Design Name: 
-- Module Name:    phase3 - Behavioral 
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

entity phase3 is
    Port ( 
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  is_done : in std_logic;  
			  if_mem_in : in STD_LOGIC;
			  if_mem_out : out STD_LOGIC;
			  mem_read_in : in std_logic;
			  mem_read_out: out std_logic;
			  mem_write_in: in std_logic;
			  mem_write_out: out std_logic;
			  if_writeback_in : in STD_LOGIC;
			  if_writeback_out : out STD_LOGIC;
			  
			  back_reg_in : in STD_LOGIC_VECTOR (3 downto 0);
			  back_reg_out : out STD_LOGIC_VECTOR (3 downto 0);
			  
			  --instruction_in : in std_logic_vector(15 downto 0);
			  --instruction_out : in std_logic_vector(15 downto 0);
			  
			  alu_output_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  alu_output_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  A_value_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  A_value_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  B_value_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  B_value_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  back_data_in : in std_logic_vector(1 downto 0);
			  back_data_out : out std_logic_vector(1 downto 0)
			  
			 );
			  
end phase3;

architecture Behavioral of phase3 is
		
		signal if_mem : std_logic;
		signal mem_read : std_logic;
		signal mem_write : std_logic;
		signal if_writeback : std_logic;
		signal alu_output : STD_LOGIC_VECTOR (15 downto 0);
		signal back_reg : STD_LOGIC_VECTOR (3 downto 0);
		signal A_value : STD_LOGIC_VECTOR (15 downto 0);
		signal B_value : STD_LOGIC_VECTOR (15 downto 0);
		signal back_data : std_logic_vector(1 downto 0);
		
begin

	if_writeback_out <= if_writeback;
	if_mem_out <= if_mem;
	mem_read_out <= mem_read;
	mem_write_out <= mem_write;
	alu_output_out <= alu_output;
	A_value_out <= A_value;
	B_value_out <= B_value;
	back_reg_out <= back_reg;
	back_data_out <= back_data;
	
	Transmit : process (clk,rst,enable)
	begin
		if (rst = '0') then
			alu_output <= (others => '0');
			if_writeback <= '0';
			if_mem <= '0';
			mem_read <='0';
			mem_write <='0';
			back_reg <= (others => '0');
			A_value <= (others => '0');
			B_value <= (others => '0');
			back_data <= (others => '0');
		elsif (enable = '0' or is_done = '0') then
		elsif (clk'event and clk = '1') then
			if_writeback <= if_writeback_in;
			if_mem <= if_mem_in;
			mem_read <= mem_read_in;
			mem_write <= mem_write_in;
			back_reg <= back_reg_in;
			alu_output <= alu_output_in;
			A_value <= A_value_in;
			B_value <= B_value_in;
			back_data <= back_data_in;
		end if;
		
	end process;
	
end Behavioral;

