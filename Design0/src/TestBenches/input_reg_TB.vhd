library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity input_register_TB is
end entity input_register_TB;

architecture sim of input_register_TB is

    signal clock    : std_logic := '0';
    signal reset    : std_logic := '0';
    signal CTRL_IN  : std_logic_vector(3 downto 0) := "0111";
    signal CTRL_OUT : std_logic_vector(3 downto 0);
    signal RdWEn    : std_logic;

begin

    clk_gen: process
    begin
        clock <= '0'; wait for 10 ns;
        clock <= '1'; wait for 10 ns;
    end process;

    UUT: entity work.input_register
        port map (
            clock    => clock,
            reset    => reset,
            CTRL_IN  => CTRL_IN,
            CTRL_OUT => CTRL_OUT,
            RdWEn    => RdWEn
        );

    stimulus: process
    begin

        -- ----------------------------------------------------------------
        -- Test 1: Power-on state -- register holds NOP, RdWEn must be low
        -- ----------------------------------------------------------------
        wait until rising_edge(clock);
        wait for 1 ns;
        ASSERT CTRL_OUT = "0111"
            REPORT "POWER-ON CTRL: expected NOP (0111)" SEVERITY ERROR;
        ASSERT RdWEn = '0'
            REPORT "POWER-ON RdWEn: expected 0 (NOP in reg)" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 2: Reset forces NOP regardless of CTRL_IN
        -- ----------------------------------------------------------------
        CTRL_IN <= "0000"; -- ADD
        reset   <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        ASSERT CTRL_OUT = "0111"
            REPORT "RESET CTRL: expected NOP (0111)" SEVERITY ERROR;
        ASSERT RdWEn = '0'
            REPORT "RESET RdWEn: expected 0 during reset" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 3: Normal latch -- ADD passes through, RdWEn goes high
        -- ----------------------------------------------------------------
        -- CTRL_IN still "0000", reset now '0'
        wait until rising_edge(clock);
        wait for 1 ns;

        ASSERT CTRL_OUT = "0000"
            REPORT "LATCH CTRL: expected ADD (0000)" SEVERITY ERROR;
        ASSERT RdWEn = '1'
            REPORT "LATCH RdWEn: expected 1 for ADD" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 4: NOP (CTRL="0111") disables write-enable
        -- ----------------------------------------------------------------
        CTRL_IN <= "0111";
        wait until rising_edge(clock);
        wait for 1 ns;

        ASSERT CTRL_OUT = "0111"
            REPORT "NOP CTRL: expected 0111" SEVERITY ERROR;
        ASSERT RdWEn = '0'
            REPORT "NOP RdWEn: expected 0 for NOP" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 5: Security op (CTRL[3]=1) still allows write-back
        -- ----------------------------------------------------------------
        CTRL_IN <= "1000"; -- ROR8
        wait until rising_edge(clock);
        wait for 1 ns;

        ASSERT CTRL_OUT = "1000"
            REPORT "ROR8 CTRL: expected 1000" SEVERITY ERROR;
        ASSERT RdWEn = '1'
            REPORT "ROR8 RdWEn: expected 1 (shift result should commit)" SEVERITY ERROR;

        -- ----------------------------------------------------------------
        -- Test 6: Reset mid-operation overrides CTRL_IN
        -- ----------------------------------------------------------------
        CTRL_IN <= "0011"; -- OR
        reset   <= '1';
        wait until rising_edge(clock);
        wait for 1 ns;
        reset <= '0';

        ASSERT CTRL_OUT = "0111"
            REPORT "MID-OP RESET: expected NOP in register" SEVERITY ERROR;
        ASSERT RdWEn = '0'
            REPORT "MID-OP RESET RdWEn: expected 0" SEVERITY ERROR;

        REPORT "All input_register tests completed." SEVERITY NOTE;
        WAIT;

    end process;

end architecture sim;