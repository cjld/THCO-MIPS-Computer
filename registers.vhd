----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:40:31 12/01/2014 
-- Design Name: 
-- Module Name:    register - Behavioral 
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

entity registers is
port(
	clk : in std_logic;
	rst : in std_logic;
	enable : in std_logic;
	data : in std_logic_vector(15 downto 0);
	rx : in std_logic_vector(3 downto 0);
	ry : in std_logic_vector(3 downto 0);
	back_reg : in std_logic_vector(3 downto 0);
	pc : in std_logic_vector(15 downto 0);
	pc_en : in std_logic;
	A : out std_logic_vector(15 downto 0);
	B : out std_logic_vector(15 downto 0);
	zero_en: out std_logic;
	t_en : in std_logic;
	t_data : in std_logic_vector(15 downto 0)
);
end registers;

architecture Behavioral of registers is
type reg_array	is array (integer range 0 to 15) of std_logic_vector(15 downto 0);
signal reg : reg_array;
signal t : std_logic;
begin

	A <= pc when pc_en = '1'
				else reg(conv_integer(rx));
	B <= reg(conv_integer(ry));
	zero_en <= '1' when reg(conv_integer(rx)) = 0
		else '0';
		
	process(clk)
	begin
		if (rst = '0') then
			for i in 0 to 15 loop
				reg(i) <= (others => '0');
			end loop;
		elsif (clk'event and clk = '1') then
			if (enable = '1')then
				reg(conv_integer(back_reg)) <= data;
			end if;
			if (t_en = '1') then
				reg(11) <= t_data;
			end if;
		end if;
	end process;
	
end Behavioral;