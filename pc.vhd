----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:30:05 12/04/2014 
-- Design Name: 
-- Module Name:    pc - Behavioral 
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc is
port(
	clk : in std_logic;
	rst : in std_logic;
	enable : in std_logic;
	is_done : in std_logic;
	is_interrupt : in std_logic;
	pc_in : in std_logic_vector(15 downto 0);
	pc_plus : out std_logic_vector(15 downto 0);
	pc_out : out std_logic_vector(15 downto 0)
	);
end pc;

architecture Behavioral of pc is
signal pc0, pc1 : std_logic_vector(15 downto 0);
begin
	
	pc_out <= pc0;
	pc_plus <= pc1; 
	process(clk, rst)
	begin
		if (rst = '0')then
			pc0 <= (others => '0');
			pc1 <= (others => '0');
		elsif (clk'event and clk = '1')then
			if (enable = '1' and is_done = '1' and is_interrupt = '0')then
				pc0 <= pc_in;
				pc1 <= pc_in + 1;
			end if;
		end if;
	end process;
	
end Behavioral;

