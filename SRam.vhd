----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Randon
-- 
-- Create Date:    20:10:47 12/04/2014 
-- Design Name: 
-- Module Name:    SRam - Behavioral 
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

entity SRam is
	port (
		clk_high, rst	:	in std_logic;

		ram_en, ram_we, ram_oe	:	out std_logic;
		ram_addr	:	out std_logic_vector (17 downto 0);
		ram_data 	:	inout std_logic_vector (15 downto 0);

		ram_data_in	:	in std_logic_vector (15 downto 0);
		ram_addr_ro	:	in std_logic_vector (15 downto 0); -- read only memory
		ram_addr_wr	:	in std_logic_vector (15 downto 0); -- read and write memory
		ram_data_out_ro,
		ram_data_out_wr	:	out std_logic_vector (15 downto 0);
		ram_done: out std_logic; 

		wr_en, rd_en	:	in std_logic -- read and write enable [0 : read] [1 : write]
	);
end entity ; -- SRam

architecture main of SRam is

	type SWITCH_STATE is (
		RO,
		IDLE1,
		WR,
		IDLE2
	);

	--signal switch_flag	:	in std_logic := '0'; -- [0 : ro] [1 : wr]
	signal switch_flag, tmp2	:	SWITCH_STATE := RO;
	signal data_ro, data_wr	:	std_logic_vector (15 downto 0); -- data buffer

	signal we 	:	std_logic := '1';
	signal oe 	:	std_logic := '1';

	signal we_tmp, oe_tmp	, r_done:	std_logic;
	signal tmp_state : std_logic_vector(1 downto 0);

begin

	ram_en <= '0';
	ram_oe <= oe;
	ram_we <= we;

	we_tmp <= '0' when wr_en = '1'
		else '1';
	oe_tmp <= '0' when rd_en = '1'
		else '1';

	ram_data <= ram_data_in when we = '0'
		else (others => 'Z');
	r_done <= '1' when (wr_en = '0' and rd_en = '0') else '0';
	tmp2 <= RO when (wr_en = '0' and rd_en = '0') else WR;
	with tmp_state select
		ram_addr <=
			"00" & ram_addr_ro when "00",
			"00" & ram_addr_wr when "11",
			(others => '1') when others;

	ram_data_out_ro <= data_ro;
	ram_data_out_wr <= data_wr;

	memory_write_and_read : process( clk_high, rst )
	begin
		if rst = '0' then
			switch_flag <= RO;
			oe <= '1';
			we <= '1';
			ram_done <= '1';
		elsif clk_high'event and clk_high = '0' then
			
			case( switch_flag ) is
				when RO => -- read only
					tmp_state <= "00";
					oe <= '0';
					switch_flag <= IDLE1;
					ram_done <= '0';
				when IDLE1 => 
					tmp_state <= "10";
					data_ro <= ram_data;
					oe <= '1';
					switch_flag <= tmp2;
					ram_done <= r_done;
				when WR => -- write & read
					tmp_state <= "11";
					we <= we_tmp;
					oe <= oe_tmp;
					switch_flag <= IDLE2;
				when IDLE2 => 
					tmp_state <= "01";
					data_wr <= ram_data;
					oe <= '1';
					we <= '1';
					switch_flag <= RO;
					ram_done <= '1';

				when others =>
					oe <= '1';
					we <= '1';
					switch_flag <= RO;
			end case ;
		end if ;

	end process ; -- memory_write_and_read

end architecture ; -- main