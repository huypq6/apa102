LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY tb_APA102 IS
END tb_APA102;
 
ARCHITECTURE behavior OF tb_APA102 IS 
 
    COMPONENT APA102
    PORT( clk : IN  std_logic;
          apaclk : OUT  std_logic;
          apasdo : OUT  std_logic);
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal apaclk : std_logic;
   signal apasdo : std_logic;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: APA102 PORT MAP ( clk => clk, apaclk => apaclk, apasdo => apasdo);

   -- 50 MHz FPAG clock
   clk <= not clk after 10 ns;

END;