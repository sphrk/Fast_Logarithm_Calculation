library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity fast_log_v1 is
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
end fast_log_v1;



architecture Behavioral of fast_log_v1 is
	
	type table_t is array(0 to N_BIT-1) of integer;
	-- constant N_BIT_FRAC : integer := 6
	constant EXPONENT_TABLE : table_t := (-266, -222, -177, -133, -89, -44, 0, 44, 89, 133, 177, 222, 266, 311, 355, 399);
	
	signal enc_out, exponent : std_logic_vector(LOG2_N_BIT-1 downto 0);
	
	signal E_Log2 : signed(N_BIT-1 downto 0);
begin
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
		
	process(rst, clk, enc_out)
	begin
		if rst = '1' then
			exponent <= (others => '0');
			E_Log2 <= (others => '0');
		elsif rising_edge(clk) then
			-- Register Encoder Output
			exponent <= enc_out;
			
			-- Get "exponent" Address Value From EXPONENT TALBE
			E_Log2 <= to_signed(EXPONENT_TABLE(to_integer(unsigned(exponent))), N_BIT);
			
		end if;
	end process;
	
	y <= std_logic_vector(E_Log2);
	
end Behavioral;

