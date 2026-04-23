library ieee;
use ieee.std_logic_1164.all;

entity shifter_tb is
end shifter_tb;

architecture sim of shifter_tb is

	--defining the signals
	signal SHIFTINPUT : std_logic_vector(15 downto 0);
	signal SHIFT_Ctrl : std_logic_vector(1 downto 0);
	signal SHIFTOUT   : std_logic_vector(15 downto 0);

	begin
		 
		UUT : entity work.shifter(rtl)
			port map(
			    SHIFTINPUT => SHIFTINPUT,
			    SHIFT_Ctrl => SHIFT_Ctrl,
			    SHIFTOUT   => SHIFTOUT
			);
	
		process
		begin
		    SHIFTINPUT <= x"1234";
		    
		    -- Test ROR8
		    SHIFT_Ctrl <= "00";
		    wait for 10 ns;
		    assert SHIFTOUT = x"3412" report "ROR8 Failed" severity error;
		
		    -- Test ROR4
		    SHIFT_Ctrl <= "01";
		    wait for 10 ns;
		    assert SHIFTOUT = x"4123" report "ROR4 Failed" severity error;
		
		    -- Test SLL8
		    SHIFT_Ctrl <= "10";
		    wait for 10 ns;
		    assert SHIFTOUT = x"3400" report "SLL8 Failed" severity error;
		
		    -- Test Others (Invalid)
		    SHIFT_Ctrl <= "11";
		    wait for 10 ns;
		    assert SHIFTOUT = x"0000" report "Others/Clear Failed" severity error;
		
		    report "Shifter tests completed." severity note;
		    wait;
		end process;
	
end architecture;