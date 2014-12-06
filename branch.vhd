----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:10:34 12/02/2014 
-- Design Name: 
-- Module Name:    branch - Behavioral 
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

entity branch is
port (
	pc : in std_logic_vector(15 downto 0);
	pc1 : in std_logic_vector(15 downto 0);
	imm : in std_logic_vector(15 downto 0);
	instruction	:	in std_logic_vector (15 downto 0);
	A : in std_logic_vector(15 downto 0);
	pc_next : out std_logic_vector(15 downto 0)
);
end branch;

architecture Behavioral of branch is
signal pc_imm1 : std_logic_vector(15 downto 0);
signal pc_imm2 : std_logic_vector(15 downto 0);
signal zero_en : std_logic;
begin
	zero_en <= '0' when a = "0000000000000000"
					else '1';
			
	with instruction(7 downto 0) select
		pc_imm1 <=  a when "11000000" | "00000000" | "00100000",
						pc when others;	
	
	with instruction(10 downto 8) & zero_en select
		pc_imm2 <= (pc1 + imm) when "0000" | "0011",
						pc when others;
						
	with instruction(15 downto 11) & zero_en select
		pc_next <= (pc1 + imm) when "001000" | "001011" | "000100" | "000101",
					pc_imm1 when "111010" | "111011",
					pc_imm2 when "011000" | "011001",
					pc when others;
end Behavioral;

