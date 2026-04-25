library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_TB is
end entity;

architecture sim of register_file_TB is

    signal clock 		: std_logic := '0';
    signal reset 		: std_logic := '0';
    signal RdWEn 		: std_logic := '0';
    signal RES   		: std_logic_vector(15 downto 0) := (others => '0');
    signal Ra, Rb, Rd 	: std_logic_vector(3 downto 0) := (others => '0');
    signal SRCa, SRCb 	: std_logic_vector(15 downto 0);

    constant T : time := 10 ns; 

begin

    UUT: entity work.register_file
        port map (
            clock => clock, reset => reset, RdWEn => RdWEn,
            RES => RES, Ra => Ra, Rb => Rb, Rd => Rd,
            SRCa => SRCa, SRCb => SRCb
        );

    -- Standard Clock Process
    process begin
        clock <= '0'; wait for T/2;
        clock <= '1'; wait for T/2;
    end process;

    -- Stimulus Process
    process begin
        -- Initial Reset (Crucial for Sequential Logic)
        reset <= '1'; wait for 20 ns;
        reset <= '0'; wait for 5 ns; -- Offset to falling edge for stability

        -- Test 1: Write to R1
        RdWEn <= '1'; Rd <= x"1"; RES <= x"C505"; wait for 10 ns;
        
        -- Test 2: Write to R4
        Rd <= x"4"; RES <= x"1186"; wait for 10 ns;
        RdWEn <= '0'; -- Stop writing

        -- Test 3: Read R1 and R4 (Asynchronous)
        Ra <= x"1"; Rb <= x"4"; wait for 10 ns;
        assert SRCa = x"C505" report "Register File: Read R1 Failed" severity error;
        assert SRCb = x"1186" report "Register File: Read R4 Failed" severity error;

        -- Test 4: Write Disable Test (Try to overwrite R1)
        RdWEn <= '0'; Rd <= x"1"; RES <= x"DEAD"; wait for 10 ns;
        Ra <= x"1"; wait for 5 ns;
        assert SRCa = x"C505" report "Register File: Write Disable (NOP) Failed" severity error;

        -- Test 5: Final Reset
        reset <= '1'; wait for 10 ns;
        assert SRCa = x"0000" report "Register File: Reset Failed" severity error;

        report "All Register File tests completed successfully." severity note;
        wait;
    end process;

end architecture;