LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

use ieee.math_real.all;
 
ENTITY tb_fast_log_v1 IS
END tb_fast_log_v1;
 
ARCHITECTURE behavior OF tb_fast_log_v1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fast_log_v1
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         x : IN  std_logic_vector(15 downto 0);
         y : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal x : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal y : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
	constant N_BIT : integer := 16;
	constant N_BIT_FRAC : integer := 6;
	constant SCALE : real := 2.0 ** real(N_BIT_FRAC);
	
	signal x_r, y_r : real;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fast_log_v1 PORT MAP (
          rst => rst,
          clk => clk,
          x => x,
          y => y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
 
	x <= std_logic_vector(to_unsigned(integer(round(x_r * SCALE)), N_BIT));
	y_r <= real(to_integer(signed(y))) / SCALE;
	
	-- Stimulus process
	stim_proc: process
	begin
		rst <= '1';
		-- hold reset state for 7 ns.
		wait for 7 ns;
		rst <= '0';
		
		x_r <= 49.25;
		wait until rising_edge(clk);
		x_r <= 12.0;
		wait until rising_edge(clk);
		x_r <= 0.5;
		wait until rising_edge(clk);




      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
