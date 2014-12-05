----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:46:40 12/04/2014 
-- Design Name: 
-- Module Name:    vga_test - Behavioral 
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
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_test is
	Port (
			clk	:	in std_logic;
			rst	:	in std_logic;
			hs,vs : out STD_LOGIC;
			r,g,b : out STD_LOGIC_VECTOR(2 downto 0)
		);
end vga_test;

architecture Behavioral of vga_test is

	signal clk_2 : std_logic;
	signal vx : std_logic_vector(9 downto 0);
	signal vy : std_logic_vector(8 downto 0);
	signal count : std_logic_vector (24 downto 0);
	signal int : integer ;

begin
	process (clk,rst) 
	begin
		if (clk'event and clk = '1') then
			clk_2 <= not clk_2;
			count <= count + 1;
			int <= conv_integer(count(3 downto 0));
		end if;
	end process;

	process (clk_2,rst)
	begin
		if (rst = '0') then
			--vx <= (others => '0');
		elsif (clk_2'event and clk_2 = '1') then
			if (vx = 799) then
				vx <= (others => '0');
			else 
				vx <= vx + 1;
			end if;
		end if;
	end process;
	
	process (clk_2,rst)
	begin
		if (rst = '0') then
			--vy <= (others => '0');
		elsif (clk_2'event and clk_2 = '1') then
			if (vx = 799) then
				if (vy = 524) then
					--vy <= (others => '0');
				else 
					vy <= vy + 1;
				end if;
			end if;
		end if;
	end process;
	
	process (clk_2,rst)
	begin
		if (rst = '0') then
			hs <= '1';
		elsif (clk_2'event and clk_2 = '1') then
			if (vx >= 656 and vx<752) then
				hs <= '0';
			else 
				hs <= '1';
			end if;
		end if;
	end process;
	
	process (clk_2,rst)
	begin
		if (rst = '0') then
			vs <= '1';
		elsif (clk_2'event and clk_2 = '1') then
			if (vy >= 490 and vy < 492) then
				vs <= '0';
			else 
				vs <= '1';
			end if;
		end if;
	end process;
	
	process (clk_2,rst)
	begin 
		if (rst = '0') then
			r <= (others => '0');
			g <= (others => '0');
			b <= (others => '0');
		elsif (clk_2'event and clk_2 = '1') then
			if (vx > 540 or vy > 380 or vx < 100 or vy < 100) then
				r <= (others => '0');
				g <= (others => '0');
				b <= (others => '0');
			else 
				r <= count(2 downto 0);
				g <= count(3 downto 1);
				b <= count(4 downto 2);
			end if;
		end if;
	end process;
	
end Behavioral;

