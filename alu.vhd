----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Li Riling
-- 
-- Create Date:    18:30:16 12/01/2014 
-- Design Name: 
-- Module Name:    alu_part - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( 
			  A : in  STD_LOGIC_VECTOR (15 downto 0);
           	B_in : in  STD_LOGIC_VECTOR (15 downto 0);
			  imm_in : in STD_LOGIC_VECTOR (15 downto 0);
			  B_or_imm : in STD_LOGIC;
           	alu_op : in  STD_LOGIC_VECTOR (3 downto 0);
           	output : out  STD_LOGIC_VECTOR (15 downto 0);
           	back_data : in std_logic_vector(1 downto 0);
			  t_result : out  STD_LOGIC_VECTOR (15 downto 0);
			  t_en : out STD_LOGIC
			);
end alu;

architecture Behavioral of alu is

	signal eq,lessS,B  :  STD_LOGIC_VECTOR (15 downto 0);
	signal intA,intB :  integer;
	signal result : std_logic_vector(15 downto 0);

begin
	--case alu_op:
	--0000 -> add
	--0001 -> sub
	--0010 -> and
	--0011-> or
	--0100 -> equal 0 unequal 1
	--0101 -> judge less than(signed) 1 else 0
	--0110 -> sll
	--0111 -> sra
	--1000 -> move
	B <= B_in when B_or_imm = '0' else imm_in;
	intA <= conv_integer(A);
	intB <= conv_integer(B);
	eq <= "0000000000000000" when (A = B) else "0000000000000001";
	lessS <= "0000000000000001" when ((A(15) = '1' and B(15)='0') or (A(15)=B(15) and (intA<intB))) else (others => '0');
	
	with alu_op select
		result <=
			A + B when "0000",
			A - B when "0001",
			A and B when "0010",
			A or B when "0011",
			to_stdlogicvector(to_bitvector(A) sll conv_integer(B)) when "0110",
			to_stdlogicvector(to_bitvector(A) sra conv_integer(B)) when "0111",
			B when "1000",
			(others => '0') when others;

	with back_data select
		output <= A when "00",
				  B when "01",
				  result when others;
	with alu_op select
		t_result <=
			eq when "0100",
			lessS when "0101",
			(others => '0') when others;
	
	with alu_op select
		t_en <= '1' when "0100" | "0101",
					'0' when others;
end Behavioral;

