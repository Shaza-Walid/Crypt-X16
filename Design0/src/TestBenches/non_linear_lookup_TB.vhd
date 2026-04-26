library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity non_linear_lookup_TB is
end entity;

architecture sim of non_linear_lookup_TB is

    -- Signals to connect to DUT
    signal ABUS   : std_logic_vector(15 downto 0);
    signal RESULT : std_logic_vector(15 downto 0);

	begin
	
	    --Instantiate DUT
	    uut:entity work.non_linear_lookup
	        port map (LUTIN => ABUS,LUTOUT => RESULT);
	
	    --Stimulus process
	    stimulus : process
	    begin
			-- Test Case 1: ABUS = 0xABCD
			-- lower = 0xCD = 1100|1101
			-- S_Box1(1100)=1010, S_Box2(1101)=0100 ? lut_out=0xA4
			-- upper = 0xAB passthrough ? expected 0xABA4
			ABUS <= x"ABCD"; wait for 10 ns;
			assert RESULT = x"ABA4" report "TC1 FAILED" severity ERROR;
			
			-- Test Case 2: ABUS = 0x1234
			-- lower = 0x34 = 0011|0100
			-- S_Box1(0011)=1100, S_Box2(0100)=1011 ? lut_out=0xCB
			-- expected 0x12CB
			ABUS <= x"1234"; wait for 10 ns;
			assert RESULT = x"12CB" report "TC2 FAILED" severity ERROR;
			
			-- Test Case 3: ABUS = 0xFFFF
			-- lower = 0xFF = 1111|1111
			-- S_Box1(1111)=0000, S_Box2(1111)=0110 ? lut_out=0x06
			-- expected 0xFF06
			ABUS <= x"FFFF"; wait for 10 ns;
			assert RESULT = x"FF06" report "TC3 FAILED" severity ERROR;
			
			-- Test Case 4: ABUS = 0x0000
			-- lower = 0x00 = 0000|0000
			-- S_Box1(0000)=0001, S_Box2(0000)=1111 ? lut_out=0x1F
			-- expected 0x001F
			ABUS <= x"0000"; wait for 10 ns;
			assert RESULT = x"001F" report "TC4 FAILED" severity ERROR;
			
			-- Test Case 5: ABUS = 0x5A3C
			-- lower = 0x3C = 0011|1100
			-- S_Box1(0011)=1100, S_Box2(1100)=0011 ? lut_out=0xC3
			-- expected 0x5AC3
			ABUS <= x"5A3C"; wait for 10 ns;
			assert RESULT = x"5AC3" report "TC5 FAILED" severity ERROR;
			
			report "All LUT tests completed." severity NOTE;
			wait;
	    end process;

end architecture;