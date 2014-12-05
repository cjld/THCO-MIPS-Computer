----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:41:10 12/05/2014 
-- Design Name: 
-- Module Name:    pause_control - Behavioral 
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

entity pause_control is
port(
		data_pause : in std_logic;
		mem_pause : in std_logic;
		sp_pause : in std_logic;
		cpu_pause : out std_logic
);

end pause_control;

architecture Behavioral of pause_control is
	
begin
	cpu_pause <= '1' when data_pause = '1' or mem_pause = '1' or sp_pause = '1'
							else '0';

end Behavioral;

