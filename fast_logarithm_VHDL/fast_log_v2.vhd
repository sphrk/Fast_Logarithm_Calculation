library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity fast_log_v2 is
	generic(
		N_BIT : integer := 16;
		LOG2_N_BIT : integer := 4
	);
    Port( 
		rst : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		x : in  STD_LOGIC_VECTOR (N_BIT-1 downto 0);
		y : out  STD_LOGIC_VECTOR (N_BIT-1 downto 0)
	);
end fast_log_v2;

architecture Behavioral of fast_log_v2 is
	type table_t is array(0 to N_BIT-1) of integer; -- (N_BIT-1 downto 0)
	
	-- constant N_BIT_FRAC : integer := 6
	constant EXPONENT_TABLE : table_t := (-266, -222, -177, -133, -89, -44, 0, 44, 89, 133, 177, 222, 266, 311, 355, 399);
	constant MANTISA_TABLE : table_t := (0, 4, 8, 11, 14, 17, 20, 23, 26, 29, 31, 33, 36, 38, 40, 42);
	
	signal enc_out, exponent : std_logic_vector(LOG2_N_BIT-1 downto 0);
	
	constant N_BIT_MANTISA : integer := 4; -- for LUT adders
	signal mux_out : std_logic_vector(N_BIT_MANTISA-1 downto 0);
	
	signal E_Log2, Log_1M, Log_x : signed(N_BIT-1 downto 0);
begin
	process(rst, clk, enc_out)
	begin
		if rst = '1' then
			exponent <= (others => '0');
			E_Log2 <= (others => '0');
			Log_1M <= (others => '0');
			Log_x <= (others => '0');
		elsif rising_edge(clk) then
			-- Register Encoder Output
			exponent <= enc_out;
			
			-- Get "exponent" Address Value From EXPONENT TALBE (E*Log(2))
			E_Log2 <= to_signed(EXPONENT_TABLE(to_integer(unsigned(exponent))), N_BIT);
			
			-- Get Multiplexer Output Address Value From MANTISA TABLE (Log(1.M))
			Log_1M <= to_signed(MANTISA_TABLE(to_integer(unsigned(mux_out))), N_BIT);
			
			Log_x <= E_Log2 + Log_1M;
		end if;
	end process;
	
	y <= std_logic_vector(Log_x);
	
	
	-- Find Most Significant 1 Bit (Exponent Value)
	enc_out <= 	
		"1111" when x(15) = '1' else
		"1110" when x(14) = '1' else
		"1101" when x(13) = '1' else
		"1100" when x(12) = '1' else
		"1011" when x(11) = '1' else
		"1010" when x(10) = '1' else
		"1001" when x(9) = '1' else
		"1000" when x(8) = '1' else
		"0111" when x(7) = '1' else
		"0110" when x(6) = '1' else
		"0101" when x(5) = '1' else
		"0100" when x(4) = '1' else
		"0011" when x(3) = '1' else
		"0010" when x(2) = '1' else
		"0001" when x(1) = '1' else
		"0000";
	
	with exponent select
		mux_out <= 
			x(14 downto 11)  when "1111",
			x(13 downto 10)  when "1110",
			x(12 downto 9)  when "1101",
			x(11 downto 8)  when "1100",
			x(10 downto 7)  when "1011",
			x(9 downto 6)  when "1010",
			x(8 downto 5)  when "1001",
			x(7 downto 4)  when "1000",
			x(6 downto 3)  when "0111",
			x(5 downto 2)  when "0110",
			x(4 downto 1)  when "0101",
			x(3 downto 0)  when "0100",
			x(2 downto 0) & "0" when "0011",
			x(1 downto 0) & "00" when "0010",
			x(0) & "000" when others;
		
	


end Behavioral;

