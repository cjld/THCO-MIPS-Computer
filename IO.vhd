----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Randon
-- 
-- Create Date:    04:20:03 12/04/2014 
-- Design Name: 
-- Module Name:    IO - Behavioral 
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

entity IO is

Port ( 
	pc, addr, data : in  STD_LOGIC_vector(15 downto 0);
	is_read, is_write : in  STD_LOGIC;
	is_sp, is_sp_label, need_vga : in  STD_LOGIC;
	need_int : in  STD_LOGIC;
	
	out_cmd, out_data: out std_logic_vector(15 downto 0);
	is_done: out std_logic;
	
		clock : in std_logic;
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
end IO;

architecture Behavioral of IO is

	 signal clk, is_get_cmd, my_done, my_rst, sram_rst: std_logic;
	 
	 signal ram1_enable, ram1_is_read: std_logic;
	 signal ram2_enable, ram2_is_read: std_logic;
	 signal ram1_input_addr: std_logic_vector(17 downto 0);
	 signal ram2_input_addr: std_logic_vector(17 downto 0);
	 signal ram1_input_data: std_logic_vector(15 downto 0);
	 signal ram2_input_data: std_logic_vector(15 downto 0);
	 signal ram1_bus, sp_output_data_ex: std_logic_vector(15 downto 0);
	 
	 signal sp_enable, sp_rst, sp_is_read: std_logic;
	 signal sp_input_data, sp_output_data: STD_LOGIC_VECTOR (7 downto 0);
	 signal sp_is_done, vga_refresh_done: std_logic;
	 
	 component Ram
		port(
				clk, rst : in std_logic;
				
				-- 1 for read, 0 for write
				is_read: in std_logic;
				
				-- 1 enable, 0 disable
				enable: in std_logic;
				
				-- input from here
				input_addr:	in std_logic_vector(17 downto 0);
				input_data: in std_logic_vector(15 downto 0);
				
				-- read data from here
				data	:	inout std_logic_vector(15 downto 0);
				
				-- don't touch
				addr	:	out std_logic_vector(17 downto 0);
				en, oe, we	:	out std_logic
		);
		
	 end component;
	 
	 component SerialPort
	 
		port ( 
			clk, clk_11, rst, is_read, enable : in  STD_LOGIC;

			input_data: in STD_LOGIC_VECTOR (7 downto 0);
			output_data: out STD_LOGIC_VECTOR (7 downto 0);
		    led: out std_logic_vector(15 downto 0);

			is_done: out std_logic;

			ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
			data_ready : in  STD_LOGIC;
			rdn : out  STD_LOGIC;
			tbre : in  STD_LOGIC;
			tsre : in  STD_LOGIC;
			wrn : out  STD_LOGIC
			);
	 end component;
	 
	component SRam is

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
	end component ; -- SRam
	
	component VGA is
	port (
			clk	:	in std_logic;
			rst	:	in std_logic;
			
			led: out std_logic_vector(15 downto 0);
			switch: in std_logic_vector(15 downto 0);
			
			read_mem_done: in std_logic;
			vga_refresh_run, vga_refresh_edge: out std_logic;
			
			mem_addr: out std_logic_vector(15 downto 0);
			mem_data: in std_logic_vector(15 downto 0);
			
			hs,vs : out STD_LOGIC;
			r,g,b : out STD_LOGIC_VECTOR(2 downto 0)
		);
	end component;
	
	signal ram_write, ram_read, ram2_done, 
		is_refrash_vga, vga_refresh_run, vga_rst, vga_refresh_edge,use_vga_addr: std_logic;
	signal out_ram_data, my_out_data, disp_mem_addr, ram_addr_ro, ram_data_out_ro
		: std_logic_vector(15 downto 0);
	signal ram1_addr_tmp : std_logic_vector(17 downto 0);
	
begin
	
	use_vga_addr <= is_refrash_vga and not vga_refresh_edge;
	
	ram1_addr(15 downto 0) <= pc;
	ram1_addr(17 downto 16) <= "00";
	
	ram1: Ram port map (
		clk => clk, rst => rst,
		is_read => ram1_is_read,
		enable => ram1_enable,
		input_addr => ram1_input_addr,
		input_data => ram1_input_data,
		data => ram1_bus,
		addr => ram1_addr_tmp,
		en => ram1_en, 
		oe => ram1_oe,
		we => ram1_we
	);
	
--	ram2: Ram port map (
--		clk => clk, rst => rst,
--		is_read => ram2_is_read,
--		enable => ram2_enable,
--		input_addr => ram2_input_addr,
--		input_data => ram2_input_data,
--		data => ram2_data,
--		addr => ram2_addr,
--		en => ram2_en, 
--		oe => ram2_oe,
--		we => ram2_we
--	);
	
	ram2: SRam port map(
		clk_high => clk, rst => sram_rst,

		ram_en => ram2_en, ram_we => ram2_we, ram_oe => ram2_oe,
		ram_addr => ram2_addr,
		ram_data => ram2_data,

		ram_data_in => data,
		ram_addr_ro => ram_addr_ro,
		ram_addr_wr	=> addr, --:	in std_logic_vector (15 downto 0); -- read and write memory
		ram_data_out_ro => ram_data_out_ro, 
		ram_data_out_wr	=> out_ram_data, --:	out std_logic_vector (15 downto 0);
		ram_done => ram2_done,

		wr_en => ram_write, rd_en => ram_read-- :	in std_logic -- read and write enable [0 : read] [1 : write]
	);
	
	serial_port: SerialPort port map (
			clk => clk, clk_11 => clk_auto_11,
			rst => sp_rst, is_read => sp_is_read, enable => sp_enable,

			input_data => sp_input_data,
			output_data => sp_output_data,
			--led => led,

			is_done => sp_is_done,

			ram1data => ram1_data(7 downto 0),
			data_ready => data_ready,
			rdn => rdn,
			tbre => tbre,
			tsre => tsre,
			wrn => wrn
	);
	my_vga: VGA port map(
			clk => clk,
			rst => vga_rst,
			
			led => led, switch => switch,
			
			read_mem_done => ram2_done,
			vga_refresh_run => vga_refresh_run,
			vga_refresh_edge => vga_refresh_edge,
			
			mem_addr => disp_mem_addr,
			mem_data => ram_data_out_ro,
			
			hs => hs,vs => vs,
			r => r, g => g, b => b
	);
	
	--ram1_data(15 downto 8) <= ram1_bus(15 downto 8);
	--ram1_data(7 downto 0) <= sp_bus when ram1_enable = '0' else ram1_bus(7 downto 0);
	sp_output_data_ex(15 downto 8) <= (others => '0');
	sp_output_data_ex(7 downto 0) <= sp_output_data;
	
	
	ram1_enable <= '0';
	
	my_out_data <= out_ram_data when (is_sp = '0')
			else sp_output_data_ex;
	out_data <=
		(others => '1') when (is_sp_label = '1') else my_out_data;
			
	ram_write <= (is_write and not is_sp) and not use_vga_addr;
	ram_read <= (is_read and not is_sp) and not use_vga_addr;

	sp_enable <= '1';
	sp_rst <= rst and is_sp and my_rst;
	sp_is_read <= is_read;
	sp_input_data <= data(7 downto 0);
	
	ram_addr_ro <= pc when (use_vga_addr = '0')
		else disp_mem_addr;
	
	is_done <=
		(ram2_done and my_done) when (is_sp = '1' or is_refrash_vga = '1') 
		else ram2_done;
		
	out_cmd <= ram_data_out_ro;

	clk <= clk_auto;-- when (switch(15) = '0') else clk_man;
	--led(0) <= my_done;
	--led(1) <= clk;
	
	vga_rst <= need_vga and rst;
	
	process(clk, rst)
	begin
		if (rst = '0') then
			my_done <= '0';
			my_rst <= '0';
			sram_rst <= '0';
			is_refrash_vga <= '0';
		elsif (clk'event and clk = '1') then
			if (vga_refresh_run = '1') then
				my_done <= '0';
				is_refrash_vga <= '1';
			elsif (my_rst = '0') then
				is_refrash_vga <= '0';
				my_rst <= '1';
				sram_rst <= '1';
				my_done <= '0';
			elsif (sp_is_done = '1') then
				is_refrash_vga <= '0';
				if (ram2_done = '1' and my_done = '1') then
					my_rst <= '0';
				end if;
				my_done <= '1';
			else
				is_refrash_vga <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;


