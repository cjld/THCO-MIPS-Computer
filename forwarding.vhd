----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:24:49 12/04/2014 
-- Design Name: 
-- Module Name:    forwarding - Behavioral 
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

entity forwarding is
port(
		a_pc : in std_logic;
		back_reg0 : in std_logic_vector(3 downto 0);
		back_reg1 : in std_logic_vector(3 downto 0);
		back_reg2 : in std_logic_vector(3 downto 0);
		if_mem0 : in std_logic;
		if_mem1 : in std_logic;
		sum0 : in std_logic_vector(15 downto 0);
		sum : in std_logic_vector(15 downto 0);
		back_data :  in std_logic_vector(15 downto 0);
		a0 : in std_logic_vector(15 downto 0);
		rx0 : in std_logic_vector(3 downto 0);
		ry0 : in std_logic_vector(3 downto 0);
		rx : in std_logic_vector(3 downto 0);
		ry : in std_logic_vector(3 downto 0);
		a_in : in std_logic_vector(15 downto 0);
		b_in : in std_logic_vector(15 downto 0);
		write_back0 : in std_logic;
		write_back1 : in std_logic;
		write_back2 : in std_logic;
		a0_out : out std_logic_vector(15 downto 0);
		a_out : out std_logic_vector(15 downto 0);
		b_out : out std_logic_vector(15 downto 0);
		pause: out std_logic
	);
end forwarding;

architecture Behavioral of forwarding is
signal afd : std_logic_vector(1 downto 0);
signal bfd : std_logic_vector(1 downto 0);
signal cfd : std_logic_vector(1 downto 0);
signal pause1 : std_logic;
signal pause2 : std_logic;
begin
	
	----- ALU <---- MEM/WB--------
	afd(0) <= '1' when (back_reg1 = rx and write_back1 = '1')
					else '0';
	afd(1) <= '1' when (back_reg2 = rx and write_back2 = '1')
					else '0';
	bfd(0) <= '1' when (back_reg1 = ry and write_back1 = '1')
					else '0';
	bfd(1) <= '1' when (back_reg2 = ry and write_back2 = '1')
					else '0';

	with afd select
		a_out <= sum when "01" | "11",
					back_data when "10",
					a_in when others;
	
	with bfd select
		b_out <= sum when "01" | "11",
					back_data when "10",
					b_in when others;
	
	pause1 <= '1' when(if_mem0 = '1' and (back_reg0 = rx0 or back_reg0 = ry0) and write_back0 = '1')
					else '0';
	
	----- IF <---- MEM/WB--------
	
	cfd(0) <= '1' when (back_reg0 = rx0 and write_back0 = '1' and a_pc = '1')
					else '0';
	cfd(1) <= '1' when (back_reg1 = rx0 and write_back1 = '1' and a_pc = '1')
					else '0';
	
	pause2 <= '1' when (cfd(0) = '1' and if_mem0 = '1')
						or (cfd(1) = '1' and if_mem1 = '1')
						else '0';
	
	with cfd select
		a0_out <= sum0 when "01" | "11",
					 sum when "10",
					 a0 when others;
					 
	pause <= '0' when pause1 = '1' or pause2 = '1'
						else '1';
end Behavioral;
