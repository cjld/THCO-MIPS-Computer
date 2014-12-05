----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:34:07 12/04/2014 
-- Design Name: 
-- Module Name:    write_back - Behavioral 
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

entity write_back is
port(
		alu_result : in std_logic_vector(15 downto 0);
		mem_data : in std_logic_vector(15 downto 0);
		back_data : in std_logic_vector(1 downto 0);
		data : out std_logic_vector(15 downto 0)
	);

end write_back;

architecture Behavioral of write_back is

begin
	data <= mem_data when back_data = "11"
						else alu_result;

end Behavioral;

