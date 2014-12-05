----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Randon
-- 
-- Create Date:    21:56:25 11/02/2014 
-- Design Name: 
-- Module Name:    serial_port - Behavioral 
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

entity SerialPort is
    Port ( clk, clk_11, rst, is_read, enable : in  STD_LOGIC;
		   
		   input_data: in STD_LOGIC_VECTOR (7 downto 0);
		   output_data: out STD_LOGIC_VECTOR (7 downto 0);
		   
		   is_done: out std_logic;
		   
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : out  STD_LOGIC);
end SerialPort; 

architecture Behavioral of SerialPort is
	
	type state is (rdnA,rdnB,rdnC,wrn_zero,wrnA,wrnB,wrnC,wrnD,idle);
	signal curr_state : state;
	signal clk_fp: std_logic;
	signal clk_count: STD_LOGIC_VECTOR(2 downto 0);
	
begin

--	process(clk)
--	begin
--		if (clk'event and clk = '1') then
--			clk_count <= clk_count + '1';
--		end if;
--	end process;
	--clk_fp <= clk_count(2);
	clk_fp <= clk_11;

	main: process(rst,clk,clk_fp,enable,is_read)
	begin
		if (enable = '0') then
			rdn <= '1'; 
			wrn <= '1';
			curr_state <= idle;
			is_done <= '0';
		elsif (rst = '0') then
--			ram1EN <= '1';
--			ram1OE <= '1';
--			ram1WE <= '1';
			is_done <= '0';
			if (is_read = '1') then
				curr_state <= rdnA;
			else
				curr_state <= wrn_zero;
			end if;
		elsif (clk_fp'event and clk_fp = '1') then
			case curr_state is
			
			when rdnA =>
				--output_data <= "00000000";
				rdn <= '1';
				ram1data <= "ZZZZZZZZ";
				curr_state <= rdnB;
			when rdnB =>
				--output_data <= "00000001";
				if (data_ready = '1') then 
					rdn <= '0';
					curr_state <= rdnC;
				else 
					--curr_state <= rdnA;
				end if;
			when rdnC =>
				output_data <= ram1data;
				curr_state <= idle;
				
			when wrn_zero =>
				--output_data <= "00000011";
				rdn <= '1'; 
				wrn <= '1';
				curr_state <= wrnA;
			when wrnA =>
				--output_data <= "00000111";
				ram1data <= input_data;
				wrn <= '0';
				curr_state <= wrnB;
			when wrnB =>
				--output_data <= "00001111";
				wrn <= '1';
				curr_state <= wrnC; 
			when wrnC =>
				--output_data <= "00011111";
				if (tbre = '1') then
					curr_state <= wrnD;
				end if;
			when wrnD =>
				--output_data <= "00111111";
				if (tsre = '1') then
					curr_state <= idle;
				end if;
			when idle =>
				is_done <= '1';
			end case;
		end if;
	end process;
	
end Behavioral;
