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

entity phase4 is
    Port ( 
			  clk : in STD_LOGIC;
			  rst : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  is_done : in std_logic;
			  mem_output_in : in std_logic_vector(15 downto 0);
			  mem_output_out : out std_logic_vector(15 downto 0);
			  
			  if_writeback_in : in STD_LOGIC;
			  if_writeback_out : out STD_LOGIC;
			  
			  back_reg_in : in STD_LOGIC_VECTOR (3 downto 0);
			  back_reg_out : out STD_LOGIC_VECTOR (3 downto 0);
       
			  alu_output_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  alu_output_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  back_data_in : in std_logic_vector(1 downto 0);
			  back_data_out : out std_logic_vector(1 downto 0)
			  
			 );
			  
end phase4;

architecture Behavioral of phase4 is
		
		signal alu_output : STD_LOGIC_VECTOR (15 downto 0);
		signal back_reg : STD_LOGIC_VECTOR (3 downto 0);
		signal mem_output : std_logic_vector(15 downto 0);
		signal if_writeback : std_logic;
		signal back_data : std_logic_vector(1 downto 0);
		
begin
	
	mem_output_out <= mem_output;
	alu_output_out <= alu_output;
	
	back_reg_out <= back_reg;
	back_data_out <= back_data;
	if_writeback_out <= if_writeback;
	
	Transmit : process (clk,rst,enable)
	begin
		if (rst = '0') then

			alu_output <= (others => '0');
			if_writeback <= '0';
			back_reg <= (others => '0');
			back_data <= (others => '0');
			mem_output <= (others => '0');
		elsif (enable = '0' or is_done = '0') then
		elsif (clk'event and clk = '1') then
			back_reg <= back_reg_in;
			back_data <= back_data_in;
			if_writeback <= if_writeback_in;
			
			mem_output <= mem_output_in;
			alu_output <= alu_output_in;
		end if;
		
	end process;
	
end Behavioral;

