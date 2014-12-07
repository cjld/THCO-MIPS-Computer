----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:11 12/01/2014 
-- Design Name: 
-- Module Name:    transfer - Behavioral 
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

entity transfer is
port(
	instruction_in : in std_logic_vector(15 downto 0);
	imm : out std_logic_vector(15 downto 0);
	rx : out std_logic_vector(3 downto 0);
	ry : out std_logic_vector(3 downto 0);
	rz : out std_logic_vector(3 downto 0);
	write_back : out std_logic;
	back_data: out std_logic_vector(1 downto 0);
	b_or_imm : out std_logic;
	--t_en : out std_logic;
	a_pc : out std_logic;
	--t_choose : out std_logic;
	alu_op : out std_logic_vector(3 downto 0);
	pc_en : out std_logic;
	j_en : out std_logic;
	is_int : out std_logic;
	if_mem : out std_logic;
	mem_read : out std_logic;
	mem_write : out std_logic
);

end transfer;

architecture Behavioral of transfer is

signal sign_bit : std_logic;
signal exten_sign : std_logic_vector(15 downto 0);
signal imm2 : std_logic_vector(3 downto 0);
signal rxyz : std_logic_vector(11 downto 0);
signal r10, r7, r4, empty : std_logic_vector(3 downto 0);
signal sp, ra, ih, t : std_logic_vector(3 downto 0);
signal ftte, fztz, fstz, fftz : std_logic_vector(11 downto 0);
signal last2, last2_2, last3, last5 : std_logic_vector(3 downto 0);
signal sg1, sg2 : std_logic_vector(1 downto 0);
signal a_pc_0 : std_logic;
signal intr : std_logic;
begin
	----- get imm
	with instruction_in(15 downto 11) select
		sign_bit <= instruction_in(10) when "00010",
						instruction_in(7) when "01001" | "01100" | "00100" | "00101" | "10010" | "01010" | "11010",
						instruction_in(4) when "10011" | "11011",
						instruction_in(3) when "01000" | "11111",
						'0' when others;
						
	exten_sign <= (others => sign_bit);
	imm2 <= "1000" when instruction_in(4 downto 2) = "000"
				else "0" & instruction_in(4 downto 2);
	with instruction_in(15 downto 11) select
		imm <= exten_sign(15 downto 11) & instruction_in(10 downto 0) when "00010",
				 exten_sign(15 downto 8) & instruction_in(7 downto 0) when "01001" | "01100" | "00100" | "00101" | "10010" | "01010" | "11010" | "01101",
				 exten_sign(15 downto 5) & instruction_in(4 downto 0) when "10011" | "11011",
				 "000000000000" & imm2 when "00110",
				 exten_sign(15 downto 4) & instruction_in(3 downto 0) when "01000" | "11111",
				 (others => '0') when others;
	----- get rx ry and rz
	empty <= "1111";
	r10 <= "0" & instruction_in(10 downto 8);
	r7 <= "0" & instruction_in(7 downto 5);
	r4 <= "0" & instruction_in(4 downto 2);
	ih <= "1000";
	sp <= "1001";
	ra <= "1010";
	t <= "1011";
	with instruction_in(15 downto 11) select
		rxyz <= 	r10 & empty & r10 when "01001", -- ADDIU
					r10 & empty & r7 when "01000", -- ADDIU3
					r10 & r7 & r4 when "11100", -- ADDU, SUBU
					r10 & empty & empty when "00100", -- BEQZ
					r10 & empty & empty when "00101", -- BNEZ
					r10 & empty & r7 when "10011", -- LW
					sp & empty & r10 when "10010", -- LW_SP
					r7 & empty & r10 when "01111", -- MOVE
					r7 & empty & r10 when "00110", -- SLL, SRA
					r10 & empty & empty when "01010", -- SLTI
					r10 & r7 & empty when "11011", -- SW
					sp & r10 & empty when "11010", -- SW_SP
					empty & empty & r10 when "01101", -- LI
					ftte when "01100",
					fztz when "11110",
					fftz when "11101",
					(others => '1') when others; -- INT
	with instruction_in(10 downto 8) select
		ftte <= sp & empty & sp when "011", -- ADDSP
				  r10 & empty & sp when "100", -- MTSP
				  t & empty & empty when "000" | "001", -- BTEQZ BTNEZ
				  (others => '1') when others;
	
	fztz <= ih & empty & r10 when instruction_in(0) = '0' -- MFIH
		else r10 & empty & ih; -- MTIH
		
	with instruction_in(7 downto 0) select
		fstz <= r10 & empty & ra when "11000000", -- JALR
				  r10 & empty & empty when "00000000", --JR
				  ra & empty & empty when "00100000", --JRRA
				  empty & empty & r10 when "01000000", --MFPC
				  (others => '1') when others;
	
	with instruction_in(4 downto 0) select
		fftz <=  fstz when "00000",
					r10 & r7 & r10 when "01100" | "01101", -- AND OR
					r10 & r7 & empty when "01010", --CMP
					(others => '1') when others;
	rx <= rxyz(11 downto 8);
	ry <= rxyz(7 downto 4);
	rz <= rxyz(3 downto 0);
	
	----- control signal

	is_int <= '1' when instruction_in(15 downto 11) = "11111"
							else '0';
	
	j_en <= '1' when (instruction_in(15 downto 11) = "11101" and instruction_in(7 downto 0) = "11000000")
					else '0';

	pc_en <= '1' when (instruction_in(15 downto 11) = "11101" and instruction_in(7 downto 0) = "01000000")
					else '0';
					
	with instruction_in(7 downto 0) select
		a_pc_0 <= '1' when "11000000" | "00000000" | "00100000",
					 '0' when others;
					 
	with instruction_in(15 downto 11) select
		a_pc <=  a_pc_0 when "11101",
				 '1' when "00100" | "00101",
					'0' when others;

	write_back <= '0' when rxyz(3 downto 0) = empty
					else '1'; 
						
	b_or_imm <= '1' when rxyz(7 downto 4) = empty
								or instruction_in(15 downto 11) = "11011"
								or instruction_in(15 downto 11) = "11010"
						 else '0';
	
--	t_en <= '1' when instruction_in(15 downto 11) = "01010" --SLTI
--						or (instruction_in(15 downto 11) = "11101" and instruction_in(4 downto 0) = "01010") --CMP
--					else '0';
--	
--	t_choose <= '0' when instruction_in(15 downto 11) = "01010" --SLTI
--						else '1';
	
	sg1 <= "00" when instruction_in(4 downto 0) = "00000"
						else "10";
	
	sg2 <= "00" when instruction_in(10 downto 8) = "100"
						else "10";
						
	with instruction_in(15 downto 11) select
		back_data <= "11" when "10011" | "10010", -- LW, LWSP
						 "00"	when "01111" | "11110", -- MOVE, MFIH, MTIH
						 sg1 	when "11101", -- JALR, MFPC
						 sg2 	when "01100", -- MTSP
						 "01" when "01101", -- LI
						 "10" when others;
						 
	if_mem <= '1' when instruction_in(15 downto 11) = "10011"
							or instruction_in(15 downto 11) = "10010"
							or instruction_in(15 downto 11) = "11011"
							or instruction_in(15 downto 11) = "11010"
						else '0';
	mem_read <= '1' when instruction_in(15 downto 11) = "10011"
							or instruction_in(15 downto 11) = "10010"
							else '0';
	mem_write <= '1' when instruction_in(15 downto 11) = "11011"
							or instruction_in(15 downto 11) = "11010"
							else '0';
	----- control op
	last2 <= "0000" when instruction_in(1 downto 0) = "01"
					else "0001";
		
	with instruction_in(4 downto 0) select
		last5 <= "0010" when "01100", --AND
					"0011" when "01101", -- OR
					"0100" when "01010", -- CMP
					"1111" when others; -- JALR, JR, JRRA, MFPC
					
	last3 <= "0001" when instruction_in(10 downto 8)= "011" 
					else "0000";
	
	last2_2 <= "0110" when instruction_in(1 downto 0) = "00"
					else "0111";
					
	with instruction_in(15 downto 11) select
		alu_op <= "0000" when "01001" | "01000" | "10011" | "10010" | "11011" | "11010", --ADDIU, ADDIU3, LW, LW_SP, SW, SW_SP 
				last2 when "11100", -- ADDU SUBU
				last5 when "11101",
				last2_2 when "00110", --SLL, SRA
				last3 when "01100", --ADDSP, BTEQZ, BTNEZ, MTSP
				"0101" when "01010", -- SLTI 
				"1111" when others; -- B, BEQZ, BNEZ, LI, MFIH, MTIH, MOVE, NOP
	
end Behavioral;
