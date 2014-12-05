----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:24:44 12/01/2014 
-- Design Name: 
-- Module Name:    Ram - Behavioral 
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

entity Ram is
port(
		clk, rst : in std_logic;
		
		-- 1 for read, 0 for write
		is_read: in std_logic;
		
		-- 1 enable, 0 disable
		enable: in std_logic;
		
		-- input from here
		input_addr:	in std_logic_vector(17 downto 0);
		input_data: in std_logic_vector(15 downto 0);
		
		-- read data from here
		data	:	inout std_logic_vector(15 downto 0);
		
		-- don't touch
		addr	:	out std_logic_vector(17 downto 0);
		en, oe, we	:	out std_logic
);
end Ram;

architecture Behavioral of Ram is
begin

		en <= (not enable) or (not rst);
		we <= is_read or (not enable) or not clk;
		oe <= (not is_read) or (not enable) or not clk;
		addr <= input_addr;
		data <= input_data when (is_read = '0') else (others => 'Z');

end Behavioral;

