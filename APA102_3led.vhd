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
signal   apasr     : std_logic_vector (31 downto 0) := (others=>'0'); -- default: head value
signal   apacnt    : integer range 0 to 31 := 0;
signal   apaclock  : std_logic := '0';

type apastates_type is (head, led1, led2, led3, tail);
signal apastate : apastates_type := head;

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
            if apacnt < 31 then
               apacnt <= apacnt+1;
               apasr  <= apasr(30 downto 0) & '0';
            else
               apacnt <= 0;
               case apastate is
                 when head => apasr    <= (others => '0');
                              apastate <= led1;
                 when led1 => apasr    <= x"ff101010"; -- led data
                              apastate <= led2;
                 when led2 => apasr    <= x"ff202020"; -- led data
                              apastate <= led3;
                 when led3 => apasr    <= x"ff303030"; -- led data
                              apastate <= tail;
                 when tail => apasr    <= (others => '1');
                              apastate <= head;
               end case;
            end if;
         end if;
      end if;
   end process;
         
   apasdo <= apasr(31);
   apaclk <= apaclock;
   
end Behavioral;