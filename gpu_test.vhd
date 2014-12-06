----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:02:03 12/06/2014 
-- Design Name: 
-- Module Name:    gpu_test - Behavioral 
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

entity gpu_test is
port(
		clk : in std_logic;
		rst : in std_logic;
		clk_man, clk_auto_11 : in std_logic;
		
		led	:	out std_logic_vector (15 downto 0);
		switch 	:	in std_logic_vector (15 downto 0);
		
	   data_ready, tbre, tsre : in  STD_LOGIC;
	   rdn, wrn : out  STD_LOGIC;
		
		ram2_data	:	inout std_logic_vector(15 downto 0);
		ram2_addr	:	out std_logic_vector(17 downto 0);
		ram2_en, ram2_oe, ram2_we	:	out std_logic;
		
		ram1_data	:	inout std_logic_vector(15 downto 0);
		ram1_addr	:	out std_logic_vector(17 downto 0);
		ram1_en, ram1_oe, ram1_we	:	out std_logic;
		
		hs,vs : out STD_LOGIC;
		r,g,b : out STD_LOGIC_VECTOR(2 downto 0)
);
end gpu_test;

architecture Behavioral of gpu_test is


component IO
Port ( 
	pc, addr, data : in  STD_LOGIC_vector(15 downto 0);
	is_read, is_write : in  STD_LOGIC;
	is_sp, is_sp_label, need_vga : in  STD_LOGIC;
	need_int : in  STD_LOGIC;
	
	out_cmd, out_data: out std_logic_vector(15 downto 0);
	is_done: out std_logic;
	
	
		clk_auto, rst, clk_man, clk_auto_11 : in std_logic;
		
		led	:	out std_logic_vector (15 downto 0);
		switch 	:	in std_logic_vector (15 downto 0);
		
		-- ´®¿Ú
	    data_ready, tbre, tsre : in  STD_LOGIC;
	    rdn, wrn : out  STD_LOGIC;
		
		ram2_data	:	inout std_logic_vector(15 downto 0);
		ram2_addr	:	out std_logic_vector(17 downto 0);
		ram2_en, ram2_oe, ram2_we	:	out std_logic;
		
		ram1_data	:	inout std_logic_vector(15 downto 0);
		ram1_addr	:	out std_logic_vector(17 downto 0);
		ram1_en, ram1_oe, ram1_we	:	out std_logic;
		
		hs,vs : out STD_LOGIC;
		r,g,b : out STD_LOGIC_VECTOR(2 downto 0)
	
);
end component;

	signal is_done, my_clk: std_logic;
	signal out_cmd, out_data: std_logic_vector(15 downto 0);
	signal clk_count: std_logic_vector(16 downto 0);
	signal vga_open: std_logic;

begin
	my_clk <= clk;

	led(15) <= vga_open;
	led(14) <= is_done;
	led(13 downto 0) <= clk_count(13 downto 0);

	process(my_clk, rst)
	begin
		if (rst = '0') then
			clk_count <= (others => '0');
			vga_open <= '0';
		elsif (my_clk'event and my_clk = '1') then
			if (is_done = '1') then
				vga_open <= '0';
			elsif (clk_count > switch) then
				vga_open <= '1';
				clk_count <= (others => '0');
			else
				clk_count <= clk_count + '1';
			end if;
		end if;
	end process;

	IO_port: IO port map(
		pc => (others => '0'),
		addr => (others => '0'),
		data => (others => '0'),
		is_read => '0', 
		is_write => '0',
		is_sp => '0',
		is_sp_label => '0',
		need_vga => '1',
		need_int => '0',
		
		out_cmd => out_cmd,
		out_data => out_data,
		is_done => is_done,
		clk_auto => my_clk,--clk_count(2),
		clk_man => clk_man,
		rst => rst,
		clk_auto_11 => clk_auto_11,
		
		--led => led,
		switch => switch,
		
	   data_ready => data_ready,
		tbre => tbre, 
		tsre => tsre,
	   rdn => rdn, 
		wrn => wrn,
		
		ram2_data => ram2_data,
		ram2_addr => ram2_addr,
		ram2_en => ram2_en,
		ram2_oe => ram2_oe, 
		ram2_we => ram2_we,
		
		ram1_data => ram1_data,
		ram1_addr => ram1_addr,
		ram1_en => ram1_en, 
		ram1_oe => ram1_oe,
		ram1_we => ram1_we,
		
		hs => hs, vs => vs,
		r=>r ,g=>g, b=>b
	);

end Behavioral;

