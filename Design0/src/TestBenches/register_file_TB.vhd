library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_file_TB is
end entity register_file_TB;

architecture sim of register_file_TB is

    signal clock : std_logic := '0';
    signal reset : std_logic := '0';
    signal RdWEn : std_logic := '0';
    signal RES   : std_logic_vector(15 downto 0) := (others => '0');
    signal Ra    : std_logic_vector(3 downto 0)  := (others => '0');
    signal Rb    : std_logic_vector(3 downto 0)  := (others => '0');
    signal Rd    : std_logic_vector(3 downto 0)  := (others => '0');
    signal SRCa  : std_logic_vector(15 downto 0);
    signal SRCb  : std_logic_vector(15 downto 0);

begin

    -- 20 ns clock
    clk_gen: process
    begin
        clock <= '0'; wait for 10 ns;
        clock <= '1'; wait for 10 ns;
    end process;

    UUT: entity work.register_file
        port map (
            clock => clock,
            reset => reset,
            RdWEn => RdWEn,
            RES   => RES,
            Ra    => Ra,
            Rb    => Rb,
            Rd    => Rd,
            SRCa  => SRCa,
            SRCb  => SRCb
        );

    stimulus: process
    begin


        -- RESET: apply for one clock cycle
        -- ----------------------------------------------------------------
        reset <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        -- Test 1: Verify initial values after reset (async read)
        -- R0 = 0x0001, R1 = 0xC505
        -- ----------------------------------------------------------------
        Ra <= "0000"; Rb <= "0001";
        wait for 1 ns;
        ASSERT SRCa = x"0001"
            REPORT "RESET R0: expected 0x0001" SEVERITY ERROR;
        ASSERT SRCb = x"C505"
            REPORT "RESET R1: expected 0xC505" SEVERITY ERROR;

        -- R15 = 0xB000
        Ra <= "1111";
        wait for 1 ns;
        ASSERT SRCa = x"B000"
            REPORT "RESET R15: expected 0xB000" SEVERITY ERROR;

        -- Test 2: Write 0xABCD to R0, read back
        -- ----------------------------------------------------------------
        Rd <= "0000"; RES <= x"ABCD"; RdWEn <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        RdWEn <= '0';

        Ra <= "0000";
        wait for 1 ns;
        ASSERT SRCa = x"ABCD"
            REPORT "WRITE R0: expected 0xABCD" SEVERITY ERROR;

        -- Test 3: Write 0x1234 to R7, read back alongside R0
        -- ----------------------------------------------------------------
        Rd <= "0111"; RES <= x"1234"; RdWEn <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        RdWEn <= '0';

        Ra <= "0000"; Rb <= "0111";
        wait for 1 ns;
        ASSERT SRCa = x"ABCD"
            REPORT "DUAL READ Ra=R0: expected 0xABCD" SEVERITY ERROR;
        ASSERT SRCb = x"1234"
            REPORT "DUAL READ Rb=R7: expected 0x1234" SEVERITY ERROR;

        -- Test 4: Write-enable = 0 must not commit
        -- Attempt write to R1 with RdWEn='0' -- R1 should stay 0xC505
        -- ----------------------------------------------------------------
        Rd <= "0001"; RES <= x"DEAD"; RdWEn <= '0';
        wait until rising_edge(clock);
        wait for 1 ns;

        Ra <= "0001";
        wait for 1 ns;
        ASSERT SRCa = x"C505"
            REPORT "WRITE DISABLED R1: should still be 0xC505" SEVERITY ERROR;

        -- Test 5: Reset restores all registers to initial state
        -- ----------------------------------------------------------------
        reset <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        Ra <= "0000"; Rb <= "0111";
        wait for 1 ns;
        ASSERT SRCa = x"0001"
            REPORT "POST-RESET R0: expected 0x0001" SEVERITY ERROR;
        ASSERT SRCb = x"4706"
            REPORT "POST-RESET R7: expected 0x4706" SEVERITY ERROR;

        -- Test 6: Simultaneous write and read of same address
        -- Write 0x5555 to R3; read R3 (should see OLD value this cycle,
        -- new value appears after the write settles)
        -- ----------------------------------------------------------------
        Ra <= "0011";
        wait for 1 ns;
        ASSERT SRCa = x"4D05"
            REPORT "PRE-WRITE R3: expected initial 0x4D05" SEVERITY ERROR;

        Rd <= "0011"; RES <= x"5555"; RdWEn <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        RdWEn <= '0';

        Ra <= "0011";
        wait for 1 ns;
        ASSERT SRCa = x"5555"
            REPORT "POST-WRITE R3: expected 0x5555" SEVERITY ERROR;

        REPORT "All register_file tests completed." SEVERITY NOTE;
        WAIT;

    end process;

end architecture sim;