----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:14 12/04/2014 
-- Design Name: 
-- Module Name:    phase1 - Behavioral 
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

entity phase1 is
port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		is_done : in std_logic;
		is_interrupt : in std_logic;
		is_end : out std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		instruction_in : in std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0);
		instruction_out : out std_logic_vector(15 downto 0)
	);
end phase1;

architecture Behavioral of phase1 is
signal interrupt : std_logic_vector(3 downto 0); 
signal pc : std_logic_vector(15 downto 0);
signal instruction : std_logic_vector(15 downto 0);
begin

	pc_out <= pc;
	instruction_out <= instruction;

	--0110111010111111 LI R6 BF
	--0011011011000000 SLL R6 R6 0
	--0100111000010000 ADDIU R6 00010000
	--0110010011000000 MTSP R6
	--1110111001000000 MFPC R6
	--1101011000000000 SW_SP R6 0
	--0110001111111111 ADDSP FF
	--0110111000000000 LI R6 imm
	--1101011000000000 SW_SP R6 0
	--0110111000000111 LI R6 07
	--1110111000000000 JR R6


	process(clk)
	begin
		if (rst = '0') then
			pc <= (others => '0');
			instruction <= (others => '0');
			interrupt <= (others => '0');
			is_end <= '1';
		elsif (clk'event and clk = '1')then
			if (enable = '1' and is_done = '1')then
				if (is_interrupt = '1')then
					case interrupt is 
						when "0000" =>
							interrupt <= "0001";
							pc <= pc_in - 1;
							instruction <= "0110111010111111";
							is_end <= '0';
						when "0001" =>
							interrupt <= "0010";
							pc <= pc_in - 1;
							instruction <= "0011011011000000";
							is_end <= '0';
						when "0010" =>
							interrupt <= "0011";
							pc <= pc_in - 1;
							instruction <= "0100111000010000";
							is_end <= '0';
						when "0011" =>
							interrupt <= "0100";
							pc <= pc_in - 1;
							instruction <= "0110010011000000";
							is_end <= '0';
						when "0100" =>
							interrupt <= "0101";
							pc <= pc_in - 1;
							instruction <= "1110111001000000";
							is_end <= '0';
						when "0101" =>
							interrupt <= "0110";
							pc <= pc_in - 1;
							instruction <= "1101011000000000";
							is_end <= '0';
						when "0110" =>
							interrupt <= "0111";
							pc <= pc_in - 1;
							instruction <= "0110001111111111";
							is_end <= '0';
						when "0111" =>
							interrupt <= "1000";
							pc <= pc_in - 1;
							instruction <= "0110111000000000";
							is_end <= '0';
						when "1000" =>
							interrupt <= "1001";
							pc <= pc_in - 1;
							instruction <= "1101011000000000";
							is_end <= '0';
						when "1001" =>
							interrupt <= "1010";
							pc <= pc_in - 1;
							instruction <= "0110111000000111";
							is_end <= '0';
						when "1010" =>
							interrupt <= "0000";
							pc <= pc_in - 1;
							instruction <= "1110111000000000";
							is_end <= '1';
						when others =>
							interrupt <= "0000";
							pc <= (others => '0');
							instruction <= (others => '0');
							is_end <= '1';
					end case;
				else
					pc <= pc_in;
					instruction <= instruction_in;
					is_end <= '1';
				end if;
			end if;
		end if;
	end process;
end Behavioral;

