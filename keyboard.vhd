----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:00:02 12/06/2014 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
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

entity keyboard is
    Port ( clk_auto : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ps2clk : in  STD_LOGIC;
           ps2data_in : in  STD_LOGIC;
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end keyboard;

architecture Behavioral of keyboard is
	type state is (data_ready,data_reading,data_check,data_end);
	signal data, clk, clk1,clk2 : std_logic;
	signal curr_state : state;
	signal int : integer;

begin
	
	clk1 <= ps2clk when rising_edge(clk_auto);
	clk2 <= clk1 when rising_edge(clk_auto);
	clk  <= (not clk1) and clk2;
	data <= ps2data_in when rising_edge(clk_auto);

	process (clk,rst)
	begin
		if (rst = '0') then
			curr_state <= data_ready;
			int <= 0;
		elsif (clk'event and clk = 0) then
			case curr_state :
				when data_ready =>
					if (data = '0') then
						curr_state <= data_reading;
					end if;
				when data_reading =>
					led(int) <= data;
					if (int < 7) then
						int <= int + 1;
					else
						curr_state <= data_check;
					end if;
				when data_check =>
					-- if odd_check sucesses , it's ok
					curr_state <= data_end;
					-- else
					-- not right
				when data_end =>
					null;
				when others =>
					null;
			end case;
		end if;
	end process;
	
end Behavioral;

