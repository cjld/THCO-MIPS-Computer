----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:07:23 12/06/2014 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
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

entity VGA is
	Port (
			clk	:	in std_logic;
			rst	:	in std_logic;
			
			led: out std_logic_vector(15 downto 0);
			switch: in std_logic_vector(15 downto 0);
			
			read_mem_done: in std_logic;
			vga_refresh_run: out std_logic;
			
			mem_addr: out std_logic_vector(15 downto 0);
			mem_data: in std_logic_vector(15 downto 0);
			
			hs,vs : out STD_LOGIC;
			r,g,b : out STD_LOGIC_VECTOR(2 downto 0)
		);
end VGA;

architecture Behavioral of VGA is
	signal read_addr, next_addr, tmp_addr: std_logic_vector(15 downto 0);
	
	signal clk_2 : std_logic;
	signal vx, tvx : std_logic_vector(9 downto 0);
	signal vy, tvy : std_logic_vector(9 downto 0);

begin

	mem_addr <= read_addr;
	--next_addr <= read_addr + '1';
	
	--led(3 downto 0) <= vx(3 downto 0);
	--led(7 downto 4) <= vy(3 downto 0);
	--led(8) <= read_mem_done;
	--led(9) <= my_done;
	--led(15 downto 10) <= read_addr(5 downto 0);
	--led(7 downto 0) <= mem_data(7 downto 0);
	
	--tvx <= "1000000000" when (vx = 60) else (vx - 60);
	tvx <= vx - 59;
	tvy <= (vy - 99) when (tvx = 512) else (vy - 100);
	--tvy <= vy - 100;
	tmp_addr(6 downto 0) <= tvx(8 downto 2);
	tmp_addr(12 downto 7) <= tvy(7 downto 2);
	tmp_addr(15 downto 13) <= "111";
	next_addr <= tmp_addr;-- + '1';
	vga_refresh_run <= '1' when (vy >= 100) and ( vy < 100 + 256) else '0';

	process(clk, rst)
	begin
		if (rst = '0') then
			read_addr(15 downto 13) <= "111";
			read_addr(12 downto 0) <= (others => '0');
			vx <= (others => '0');
			vy <= (others => '0');
			--vs <= '1';
			--hs <= '1';
			led(15) <= '0';
		elsif (clk'event and clk = '1') then
			if (read_mem_done = '1') then
				if ((vx >= 60) and (vx < 60 + 512) and (vy >= 100) and ( vy < 100 + 256)) then
					read_addr <= next_addr;
					r <= mem_data(8 downto 6);
					g <= mem_data(5 downto 3);
					b <= mem_data(2 downto 0);
				else
					r <= "000";
					g <= "000";
					b <= "000";
					if (vx = 799) then
						if (vy = 524) then
							read_addr(15 downto 13) <= "111";
							read_addr(12 downto 0) <= (others => '0');
						end if;
					end if;
				end if;
				
				
				if (vx = 799) then
					vx <= (others => '0');
					if (vy = 524) then
						vy <= (others => '0');
					else
						vy <= vy + 1;
					end if;
				else 
					vx <= vx + 1;
				end if;
				
				if (vx >= 656 and vx<752) then
					hs <= '0';
				else 
					hs <= '1';
				end if;
				
				if (vy >= 490 and vy < 492) then
					vs <= '0';
				else 
					vs <= '1';
				end if;
			
			end if;
			
		end if;
	end process;

end Behavioral;

