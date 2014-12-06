----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:03:20 12/04/2014 
-- Design Name: 
-- Module Name:    IOpass - Behavioral 
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

entity IOpass is
    Port ( 
           addr : in  STD_LOGIC_vector(15 downto 0);
           data : in  STD_LOGIC_vector(15 downto 0);
           is_read, is_write : in  STD_LOGIC;
           is_sp, is_sp_label : out  STD_LOGIC;
           need_int : out  STD_LOGIC);
end IOpass;

architecture Behavioral of IOpass is
	signal my_is_sp: std_logic;
begin
	
	my_is_sp <= '1' when 
		(addr(15 downto 0) = "1011111100000000" and 
		(is_read = '1' or is_write = '1')) else '0';--BF00
	is_sp_label <= '1' when 
		(addr(15 downto 0) = "1011111100000001" and 
		(is_read = '1' or is_write = '1')) else '0';--BF01
		
	need_int <= my_is_sp or is_read or is_write;
	is_sp <= my_is_sp;
end Behavioral;

