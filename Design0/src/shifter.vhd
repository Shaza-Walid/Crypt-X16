library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	  
use ieee.numeric_std.all;


-- Shifter module
-- operations: ROR8 ROR4 SLL8

entity shifter is
    generic (
        N : integer := 16
    );
    port (
        SHIFTINPUT : in  std_logic_vector(N-1 downto 0);
        SHIFT_Ctrl : in  std_logic_vector(3 downto 0);
        SHIFTOUT   : out std_logic_vector(N-1 downto 0)
    );
end entity shifter;

architecture rtl of shifter is
begin

   case SHIFT_Ctrl is


	when "1000" =>
SHIFTOUT <= std_logic_vector(
rotate_right(unsigned(SHIFTINPUT),8));
	

when "1001" =>
SHIFTOUT <= std_logic_vector(
rotate_right(unsigned(SHIFTINPUT),4));

	
when "1010" =>
SHIFTOUT <= std_logic_vector(
shift_left(unsigned(SHIFTINPUT),8));


	when others =>
SHIFTOUT <= (others => '0');						 
	end case;

end architecture rtl;