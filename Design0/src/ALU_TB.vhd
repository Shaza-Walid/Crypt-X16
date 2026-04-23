LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ALU_TB is
end entity;

architecture sim of ALU_TB is
    signal ABUS, BBUS, ALUOUT : std_logic_vector(15 downto 0);
    signal ALUctrl            : std_logic_vector(2 downto 0);

	begin
	    UUT: entity work.ALU
	        port map (
	            ABUS    => ABUS,
	            BBUS    => BBUS,
	            ALUctrl => ALUctrl,
	            ALUOUT  => ALUOUT
	        );
	
	    stimulus: process
	    begin
	        -- Test 1: ADD (000) => 0x0005 + 0x0003 = 0x0008
	        ABUS <= x"0005"; BBUS <= x"0003"; ALUctrl <= "000";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"0008" REPORT "ADD FAILED" SEVERITY ERROR;
	
	        -- Test 2: SUB (001) => 0x0010 - 0x0003 = 0x000D
	        ABUS <= x"0010"; BBUS <= x"0003"; ALUctrl <= "001";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"000D" REPORT "SUB FAILED" SEVERITY ERROR;
	
	        -- Test 3: AND (010) => 0xFF00 AND 0x0FF0 = 0x0F00
	        ABUS <= x"FF00"; BBUS <= x"0FF0"; ALUctrl <= "010";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"0F00" REPORT "AND FAILED" SEVERITY ERROR;
	
	        -- Test 4: OR (011) => 0xFF00 OR 0x00FF = 0xFFFF
	        ABUS <= x"FF00"; BBUS <= x"00FF"; ALUctrl <= "011";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"FFFF" REPORT "OR FAILED" SEVERITY ERROR;
	
	        -- Test 5: XOR (100) => 0xFFFF XOR 0x0F0F = 0xF0F0
	        ABUS <= x"FFFF"; BBUS <= x"0F0F"; ALUctrl <= "100";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"F0F0" REPORT "XOR FAILED" SEVERITY ERROR;
	
	        -- Test 6: NOT (101) => NOT 0x0000 = 0xFFFF
	        ABUS <= x"0000"; BBUS <= x"0000"; ALUctrl <= "101";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"FFFF" REPORT "NOT FAILED" SEVERITY ERROR;
	
	        -- Test 7: MOV (110) => pass ABUS through
	        ABUS <= x"ABCD"; BBUS <= x"0000"; ALUctrl <= "110";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"ABCD" REPORT "MOV FAILED" SEVERITY ERROR;
	
	        -- Test 8: NOP/others (111) => output zero
	        ABUS <= x"ABCD"; BBUS <= x"1234"; ALUctrl <= "111";
	        WAIT FOR 10 ns;
	        ASSERT ALUOUT = x"0000" REPORT "NOP FAILED" SEVERITY ERROR;
	
	        REPORT "All ALU tests completed." SEVERITY NOTE;
	        WAIT;
	    end process;

end architecture;