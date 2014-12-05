----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:14 12/04/2014 
-- Design Name: 
-- Module Name:    phase1 - Behavioral 
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

entity phase1 is
port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		is_done : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		instruction_in : in std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0);
		instruction_out : out std_logic_vector(15 downto 0)
	);
end phase1;

architecture Behavioral of phase1 is
signal pc : std_logic_vector(15 downto 0);
signal instruction : std_logic_vector(15 downto 0);
begin

	pc_out <= pc;
	instruction_out <= instruction;

	process(clk)
	begin
		if (rst = '0') then
			pc <= (others => '0');
			instruction <= (others => '0');
		elsif (clk'event and clk = '1')then
			if (enable = '1' and is_done = '1')then
				pc <= pc_in;
				instruction <= instruction_in;
			end if;
		end if;
	end process;
end Behavioral;

