----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:58:24 12/07/2014 
-- Design Name: 
-- Module Name:    intr_control - Behavioral 
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

entity intr_control is
port(
	is_end : in std_logic;
	imms : in std_logic_vector(15 downto 0);
	soft_interrupt : in std_logic;
	AA : in std_logic_vector(1 downto 0);
	BB : in std_logic_vector(1 downto 0);
	imm : out std_logic_vector(7 downto 0);
	is_interrupt : out std_logic
);
end intr_control;

architecture Behavioral of intr_control is
signal tt : std_logic;
signal hard_interrupt : std_logic;	
signal clock_interrupt : std_logic;
begin
	hard_interrupt <= (not AA(1)) and BB(1);
	clock_interrupt <= (not AA(0)) and BB(0);
	
	tt <= '1' when is_end = '0' else '0';
	
	is_interrupt <= '1' when soft_interrupt = '1' or hard_interrupt = '1' or clock_interrupt = '1'
						else tt;
	
	process(soft_interrupt, hard_interrupt, clock_interrupt)
	begin
		if (soft_interrupt = '1')then
			imm <= imms(7 downto 0);
		elsif (hard_interrupt = '1') then
			imm <= "00010000";
		elsif (clock_interrupt = '1') then
			imm <= "00100000";
		end if;
	end process;

end Behavioral;

