----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:59:09 12/04/2014 
-- Design Name: 
-- Module Name:    top_cpu - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_cpu is
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
		ram1_en, ram1_oe, ram1_we	:	out std_logic
);
end top_cpu;

architecture Behavioral of top_cpu is
component pc
	port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		is_done : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		pc_plus : out std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0)
	);

end component;

component phase1
	port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		is_done : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		instruction_in : in std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0);
		instruction_out : out std_logic_vector(15 downto 0)
	);
end component;

component transfer
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
		if_mem : out std_logic;
		mem_read : out std_logic;
		mem_write : out std_logic
	);
end component;

component registers
	port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		data : in std_logic_vector(15 downto 0);
		rx : in std_logic_vector(3 downto 0);
		ry : in std_logic_vector(3 downto 0);
		back_reg : in std_logic_vector(3 downto 0);
		pc : in std_logic_vector(15 downto 0);
		pc_en : in std_logic;
		A : out std_logic_vector(15 downto 0);
		B : out std_logic_vector(15 downto 0);
		zero_en: out std_logic;
		t_en : in std_logic;
		t_data : in std_logic_vector
	);
end component;

component branch
	port(
		pc : in std_logic_vector(15 downto 0);
		imm : in std_logic_vector(15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		A : in std_logic_vector(15 downto 0);
		zero_en : in std_logic;
		pc_next : out std_logic_vector(15 downto 0)
	);
end component;

component phase2
	port(
		clk : in std_logic;
		rst : in std_logic;
		enable : in std_logic;
		is_done : in std_logic;
		pc_in : in std_logic_vector(15 downto 0);
		pc_out : out std_logic_vector(15 downto 0);
		instruction_in : in std_logic_vector(15 downto 0);
		instruction_out : out std_logic_vector(15 downto 0);
		A_in : in std_logic_vector(15 downto 0);
		B_in : in std_logic_vector(15 downto 0);
		A_out: out std_logic_vector(15 downto 0);
		B_out: out std_logic_vector(15 downto 0);
		imm_in : in std_logic_vector(15 downto 0);
		imm_out : out std_logic_vector(15 downto 0);
		back_reg_in : in std_logic_vector(3 downto 0);
		back_reg_out : out std_logic_vector(3 downto 0);
		rx_in : in std_logic_vector(3 downto 0);
		rx_out : out std_logic_vector(3 downto 0);
		ry_in : in std_logic_vector(3 downto 0);
		ry_out : out std_logic_vector(3 downto 0);
		write_back_in : in std_logic;
		write_back_out : out std_logic;
		b_or_imm_in : in std_logic;
		b_or_imm_out : out std_logic;
		alu_op_in: in std_logic_vector(3 downto 0);
		alu_op_out: out std_logic_vector(3 downto 0);
		back_data_in : in std_logic_vector(1 downto 0);
		back_data_out : out std_logic_vector(1 downto 0);
		if_mem_in : in std_logic;
		if_mem_out : out std_logic;
		mem_read_in : in std_logic;
		mem_read_out : out std_logic;
		mem_write_in : in std_logic;
		mem_write_out : out std_logic
	);
end component;

component alu
	port(
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
end component;

component phase3
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		enable : in STD_LOGIC;
		is_done : in std_logic;
		if_mem_in : in STD_LOGIC;
		if_mem_out : out STD_LOGIC;
		mem_read_in : in std_logic;
		mem_read_out : out std_logic;
		mem_write_in : in std_logic;
		mem_write_out : out std_logic;
		if_writeback_in : in STD_LOGIC;
		if_writeback_out : out STD_LOGIC;
			  
		back_reg_in : in STD_LOGIC_VECTOR (3 downto 0);
		back_reg_out : out STD_LOGIC_VECTOR (3 downto 0);
			  
		alu_output_in : in  STD_LOGIC_VECTOR (15 downto 0);
		alu_output_out : out  STD_LOGIC_VECTOR (15 downto 0);
		A_value_in : in  STD_LOGIC_VECTOR (15 downto 0);
		A_value_out : out  STD_LOGIC_VECTOR (15 downto 0);
		B_value_in : in  STD_LOGIC_VECTOR (15 downto 0);
		B_value_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  
		back_data_in : in std_logic_vector(1 downto 0);
		back_data_out : out std_logic_vector(1 downto 0)
	);
end component;

component IO
	port(
		pc, addr, data : in  STD_LOGIC_vector(15 downto 0);
		is_read, is_write : in  STD_LOGIC;
		is_sp, is_sp_label : in  STD_LOGIC;
		need_int : in  STD_LOGIC;
		
		out_cmd, out_data: out std_logic_vector(15 downto 0);
		is_done: out std_logic;
		clk_auto, rst, clk_man, clk_auto_11 : in std_logic;
		
--		led	:	out std_logic_vector (15 downto 0);
--		switch 	:	in std_logic_vector (15 downto 0);
		
	   data_ready, tbre, tsre : in  STD_LOGIC;
	   rdn, wrn : out  STD_LOGIC;
		
		ram2_data	:	inout std_logic_vector(15 downto 0);
		ram2_addr	:	out std_logic_vector(17 downto 0);
		ram2_en, ram2_oe, ram2_we	:	out std_logic;
		
		ram1_data	:	inout std_logic_vector(15 downto 0);
		ram1_addr	:	out std_logic_vector(17 downto 0);
		ram1_en, ram1_oe, ram1_we	:	out std_logic
	);
end component;

component IOpass
	port(
        addr : in  STD_LOGIC_vector(15 downto 0);
        data : in  STD_LOGIC_vector(15 downto 0);
        is_read, is_write : in  STD_LOGIC;
        is_sp, is_sp_label : out  STD_LOGIC;
        need_int : out  STD_LOGIC
	);
end component;

component phase4
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		enable : in STD_LOGIC;
		is_done : in std_logic;
		mem_output_in : in STD_LOGIC_VECTOR(15 downto 0);
		mem_output_out : out STD_LOGIC_VECTOR(15 downto 0);
			  
		if_writeback_in : in STD_LOGIC;
		if_writeback_out : out STD_LOGIC;
			  
		back_reg_in : in STD_LOGIC_VECTOR (3 downto 0);
		back_reg_out : out STD_LOGIC_VECTOR (3 downto 0);
       
		alu_output_in : in  STD_LOGIC_VECTOR (15 downto 0);
		alu_output_out : out  STD_LOGIC_VECTOR (15 downto 0);
			  
		back_data_in : in std_logic_vector(1 downto 0);
		back_data_out : out std_logic_vector(1 downto 0)
	);
end component;

component write_back
	port(
		alu_result : in std_logic_vector(15 downto 0);
		mem_data : in std_logic_vector(15 downto 0);
		back_data : in std_logic_vector(1 downto 0);
		data : out std_logic_vector(15 downto 0)
	);
end component;

component forwarding
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
end component;

signal enable_all, data_pause, pause, is_sp, is_sp_label, need_int, is_done : std_logic;
signal pc_next, pc_plus, pc0, pc1, pc2 : std_logic_vector(15 downto 0);
signal instruction0, instruction1, instruction2 : std_logic_vector(15 downto 0);
signal imm1, imm2 : std_logic_vector(15 downto 0);
signal rx1, ry1, rz1, rx2, ry2 : std_logic_vector(3 downto 0);
signal a, a1, b1, a2, b2, a_2, b_2,  a3, b3 : std_logic_vector(15 downto 0);
signal write_back1, write_back2, write_back3, write_back4 : std_logic;
signal back_data1, back_data2, back_data3, back_data4: std_logic_vector(1 downto 0);
signal back_reg1, back_reg2, back_reg3, back_reg4 : std_logic_vector(3 downto 0);
signal data : std_logic_vector(15 downto 0);
signal b_or_imm1, b_or_imm2 : std_logic;
signal alu_op1, alu_op2 : std_logic_vector(3 downto 0);
signal alu_output1, alu_output2 , alu_output3: std_logic_vector(15 downto 0);
signal if_mem1, if_mem2, if_mem3, mem_read1, mem_read2, mem_read3, mem_write1, mem_write2, mem_write3 : std_logic;
signal mem_out1, mem_out2: std_logic_vector(15 downto 0);
signal a_pc, pc_en, zero_en, t_en : std_logic;
signal t_data : std_logic_vector(15 downto 0);

signal clk_count: std_logic;
signal rst_1 : std_logic;

begin
	led(0) <= clk_man;
	led(15 downto 12) <= instruction0(3 downto 0);
	led(11 downto 1) <= alu_output3(10 downto 0);
	enable_all <= '1';
	
	process(clk_man, rst)
	begin
		if (rst = '0') then
			clk_count <= '0';
			rst_1 <= '0';
		elsif (clk_man'event and clk_man = '1') then
			clk_count <= not clk_count;
		end if;
	end process;
	
	process(clk_count)
	begin
		if(clk_count'event and clk_count = '1')then
			if (rst_1 = '0')then
				rst_1 <= '1';
			end if;
		end if;
	end process;
	
	pc_port: pc port map(
		clk => clk_count,
		rst => rst,
		enable => pause,
		is_done => is_done,
		pc_in => pc_next,
		pc_plus => pc_plus,
		pc_out => pc0
	);

	phase1_port: phase1 port map(
		clk => clk_count,
		rst => rst,
		enable => pause,
		is_done => is_done,
		pc_in => pc_plus,
		pc_out => pc1,
		instruction_in => instruction0,
		instruction_out => instruction1
	);

	transfer_port: transfer port map(
		instruction_in => instruction1,
		imm => imm1,
		rx => rx1,
		ry => ry1,
		rz => rz1,
		write_back => write_back1,
		back_data => back_data1,
		b_or_imm => b_or_imm1,
		a_pc => a_pc,
		alu_op => alu_op1,
		pc_en => pc_en,
		if_mem => if_mem1,
		mem_read => mem_read1,
		mem_write => mem_write1
	);

	registers_port: registers port map(
		clk => clk_man,
		rst => rst,
		enable => write_back4,
		data =>  data,
		rx => rx1,
		ry => ry1,
		back_reg => back_reg4,
		pc => pc1,
		pc_en => pc_en,
		A => a1,
		B => b1,
		zero_en => zero_en,
		t_en => t_en,
		t_data => t_data	
	);

	branch_port: branch port map(
		pc => pc_plus,
		imm => imm1,
		instruction	=> instruction1,
		A => a,
		zero_en => zero_en,
		pc_next => pc_next
	);

	phase2_port: phase2 port map(
		clk => clk_count,
		rst => rst,
		enable => enable_all,
		is_done => is_done,
		pc_in => pc1,
		pc_out => pc2,
		instruction_in => instruction1,
		instruction_out => instruction2,
		A_in => a1,
		B_in => b1,
		A_out => a2,
		B_out => b2,
		imm_in => imm1,
		imm_out => imm2,
		back_reg_in => back_reg1,
		back_reg_out => back_reg2,
		rx_in => rx1,
		rx_out => rx2,
		ry_in => ry1,
		ry_out => ry2,
		write_back_in => write_back1,
		write_back_out => write_back2,
		b_or_imm_in => b_or_imm1,
		b_or_imm_out => b_or_imm2,
		alu_op_in => alu_op1,
		alu_op_out => alu_op2,
		back_data_in => back_data1,
		back_data_out => back_data2,
		if_mem_in => if_mem1,
		if_mem_out => if_mem2,
		mem_read_in => mem_read1,
		mem_read_out => mem_read2,
		mem_write_in => mem_write1,
		mem_write_out => mem_write2
	);

	alu_port: alu port map(
		A => a_2,
        B_in => b_2,
		imm_in => imm2,
		B_or_imm => b_or_imm2,
        alu_op => alu_op2,
        output => alu_output1,
        back_data => back_data2,
		t_result => t_data,
		t_en => t_en	
	);
	
	phase3_port: phase3 port map(
		clk => clk_count,
		rst => rst,
		enable => enable_all,
		is_done => is_done,
		if_mem_in => if_mem2,
		if_mem_out => if_mem3,
		mem_read_in => mem_read2,
		mem_read_out => mem_read3,
		mem_write_in => mem_write2,
		mem_write_out => mem_write3,
		if_writeback_in => write_back2,
		if_writeback_out => write_back3,
		back_reg_in => back_reg2,
		back_reg_out => back_reg3,
		alu_output_in => alu_output1,
		alu_output_out => alu_output2,
		A_value_in => a2,
		A_value_out => a3,
		B_value_in => b2,
		B_value_out => b3,
		back_data_in => back_data2,
		back_data_out => back_data3	
	);
		
	IOpass_port: IOpass port map(
		addr => alu_output2,
		data => b3,
		is_read => mem_read3,
		is_write => mem_write3,
		is_sp => is_sp,
		is_sp_label => is_sp_label,
		need_int => need_int
	);
	
	IO_port: IO port map(
		pc => pc0,
		addr => alu_output2,
		data => b3,
		is_read => mem_read3, 
		is_write => mem_write3,
		is_sp => is_sp,
		is_sp_label => is_sp_label,
		need_int => need_int,
		
		out_cmd => instruction0,
		out_data => mem_out1,
		is_done => is_done,
		clk_auto => clk_man,
		clk_man => clk_man,
		rst => rst_1,
		clk_auto_11 => clk_auto_11,
		
--		led => led,
--		switch 	:	in std_logic_vector (15 downto 0);
		
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
		ram1_we => ram1_we
	);
	
	phase4_port: phase4 port map(
		clk => clk_count,
		rst => rst,
		enable => enable_all,
		is_done => is_done,
		mem_output_in =>mem_out1,
		mem_output_out =>mem_out2,
		if_writeback_in => write_back3,
		if_writeback_out => write_back4,
		back_reg_in => back_reg3,
		back_reg_out => back_reg4,
		alu_output_in => alu_output2,
		alu_output_out => alu_output3,
		back_data_in => back_data3,
		back_data_out => back_data4
	);

	write_back_port: write_back port map(
		alu_result => alu_output3, 
		mem_data => mem_out2,
		back_data => back_data4,
		data => data
	);

	forwarding_port: forwarding port map(
		a_pc => a_pc,
		back_reg0 => back_reg2,
		back_reg1 => back_reg3,
		back_reg2 => back_reg4,
		if_mem0 => if_mem2,
		if_mem1 => if_mem3,
		sum0 => alu_output1,
		sum => alu_output2,
		back_data => data,
		a0 => a1,
		rx0 => rx1,
		ry0 => ry1,
		rx => rx2,
		ry => ry2,
		a_in => a2,
		b_in => b2,
		write_back0 => write_back2,
		write_back1 => write_back3,
		write_back2 => write_back4,
		a0_out => a,
		a_out => a_2,
		b_out => b_2,
		pause => data_pause
	);
	
end Behavioral;

