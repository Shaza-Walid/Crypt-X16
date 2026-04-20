		  library ieee;
use ieee.std_logic_1164.all;

entity shifter_tb is
end shifter_tb;

architecture test of shifter_tb is

component shifter
    generic (
        N : integer := 16
    );
    port(
        SHIFTINPUT : in  std_logic_vector(15 downto 0);
        SHIFT_Ctrl : in  std_logic_vector(3 downto 0);
        SHIFTOUT   : out std_logic_vector(15 downto 0)
    );
end component;

signal SHIFTINPUT : std_logic_vector(15 downto 0);
signal SHIFT_Ctrl : std_logic_vector(3 downto 0);
signal SHIFTOUT   : std_logic_vector(15 downto 0);

begin

	   UUT:shifter
port map(
    SHIFTINPUT => SHIFTINPUT,
    SHIFT_Ctrl => SHIFT_Ctrl,
    SHIFTOUT   => SHIFTOUT
);

process
begin

    SHIFTINPUT <= x"1234";
    
    SHIFT_Ctrl <= "1000";
    wait for 20 ns;

    SHIFT_Ctrl <= "1001";
    wait for 20 ns;

    SHIFT_Ctrl <= "1010";
    wait for 20 ns;

    wait;

end process;

end test;