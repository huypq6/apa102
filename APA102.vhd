library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity APA102 is
    Port ( clk : in  STD_LOGIC;   -- 50MHz
           apaclk : out  STD_LOGIC;
           apasdo : out  STD_LOGIC);
end APA102;

architecture Behavioral of APA102 is
constant presctop  : integer := (50000000/(2*500000))-1; -- apa clock enable = 1MHz
signal   prescaler : integer range 0 to presctop := 0;
signal   clken1MHz : std_logic := '0'; 
                                                      -- start   led     end    
constant apadata   : std_logic_vector (95 downto 0) := x"00000000ff00ff00ffffffff";
signal   apasr     : std_logic_vector (95 downto 0) := x"00000000ff00ff00ffffffff"; 
signal   apacnt    : integer range 0 to 95 := 0;
signal   apaclock  : std_logic := '0';
begin
   process begin
      wait until rising_edge(clk);
      if prescaler < presctop then
         prescaler <= prescaler+1;
         clken1MHz <= '0';
      else
         prescaler <= 0;
         clken1MHz <= '1';
      end if;
   end process;
   
   process begin
      wait until rising_edge(clk);
      if clken1MHz='1' then
         if apaclock = '0' then
            apaclock <= '1';
         else
            apaclock <= '0';
            if apacnt < 95 then
               apacnt <= apacnt+1;
               apasr  <= apasr(94 downto 0) & '0';
            else
               apacnt <= 0;
               apasr  <= apadata;
            end if;
         end if;
      end if;
   end process;
         
   apasdo <= apasr(95);
   apaclk <= apaclock;
   
end Behavioral;