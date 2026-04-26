library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shifter is
    generic (
        N : integer := 16
    );
    port (
	    SHIFTINPUT : in  std_logic_vector(N-1 downto 0);	
	    
		SHIFT_Ctrl : in  std_logic_vector(1 downto 0);
        SHIFTOUT   : out std_logic_vector(N-1 downto 0)
    );
end entity shifter;

architecture rtl of shifter is
begin

    process(SHIFTINPUT, SHIFT_Ctrl)
    begin

        case SHIFT_Ctrl is

            when "00" =>																  
                SHIFTOUT <= std_logic_vector(							  --- Rotate input right by 8 bits
                    rotate_right(unsigned(SHIFTINPUT), 8));

            when "01" =>
                SHIFTOUT <= std_logic_vector(						   	  --- Rotate input right by 4 bits
                    rotate_right(unsigned(SHIFTINPUT), 4));

            when "10" =>
                SHIFTOUT <= std_logic_vector(							  --- Shift input left by 8 bits 
                    shift_left(unsigned(SHIFTINPUT), 8));

            when others =>
                SHIFTOUT <= (others => '0');							  --- invalid SHIFT_Ctrl ----> clear output 

        end case;

    end process;

end architecture rtl;