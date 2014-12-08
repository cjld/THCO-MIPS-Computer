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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
			  curr_key : out STD_LOGIC_VECTOR(4 downto 0);
			  --led : out STD_LOGIC_VECTOR(3 downto 0);
			  is_press : out STD_LOGIC
          );
end keyboard;

architecture Behavioral of keyboard is
	type state is (zero,data_ready,data_reading,data_check,data_end);
	signal data, clk, clk1, clk2, odd_check : std_logic;
	signal data_arr : std_logic_vector(7 downto 0);
	signal curr_state : state;
	signal int : integer;
	signal press : std_logic;
	signal prev_data : STD_LOGIC_VECTOR(7 downto 0);

begin
	
	clk1 <= ps2clk when rising_edge(clk_auto);
	clk2 <= clk1 when rising_edge(clk_auto);
	clk  <= (not clk1) and clk2;
	data <= ps2data_in when rising_edge(clk_auto);
	odd_check <= data_arr(0) xor data_arr(1) xor data_arr(2) xor data_arr(3) xor data_arr(4) xor data_arr(5) xor data_arr(6) xor data_arr(7);
	is_press <= press;

	process (clk_auto,rst)
	begin
		if (rst = '0') then
			curr_state <= zero;
			int <= 0;
			prev_data <= "11110000";
		elsif (clk_auto'event and clk_auto = '1') then
			case curr_state is
				when zero =>
					curr_state <= data_ready;
					int <= 0;
				when data_ready =>
					if (clk = '1') then
						if (data = '0') then
							curr_state <= data_reading;
						end if;
					end if;
				when data_reading =>
					if (clk = '1') then
						data_arr(int) <= data;
						if (int < 7) then
							int <= int + 1;
						else
							curr_state <= data_check;
						end if;
					end if;
				when data_check =>
					if (clk = '1') then
						if ((odd_check xor data) = '1') then -- if odd_check sucesses , it's ok
							--led <= "00000001";
							curr_state <= data_end;
						else	-- not right
							curr_state <=zero;
						end if;
					end if;
				when data_end =>
					if (clk = '1') then
						if (data = '1') then
				--			led <= data_arr(7 downto 4);
							if (prev_data = "11110000" or data_arr = "11110000") then
								press <= '0';
							else 
								press <= '1';
							end if;
							prev_data <= data_arr;
						end if;
						curr_state <= zero;
					end if;
				when others =>
					curr_state <= zero;
			end case;
		end if;
	end process;
	
	with prev_data select
		curr_key <= 
			"00001" when "00011100" , 		--A
			"00010" when "00110010" , 		--B
			"00011" when "00100001" , 		--C
			"00100" when "00100011" , 		--D
			"00101" when "00100100" , 		--E
			"00110" when "00101011" , 		--F
			"00111" when "00110100" , 		--G
			"01000" when "00110011" , 		--H
			"01001" when "01000011" , 		--I
			"01010" when "00111011" , 		--J
			"01011" when "01000010" , 		--K
			"01100" when "01001011" , 		--L
			"01101" when "00111010" , 		--M
			"01110" when "00110001" , 		--N
			"01111" when "01000100" , 		--O
			"10000" when "01001101" , 		--P
			"10001" when "00010101" , 		--Q
			"10010" when "00101101" , 		--R
			"10011" when "00011011" , 		--S
			"10100" when "00101100" , 		--T
			"10101" when "00111100" , 		--U
			"10110" when "00101010" , 		--V
			"10111" when "00011101" , 		--W
			"11000" when "00100010" , 		--X
			"11001" when "00110101" , 		--Y
			"11010" when "00011010" , 		--Z
			"00000" when others;
			
end Behavioral;

