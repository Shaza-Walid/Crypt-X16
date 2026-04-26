library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Logic_TB is
end entity;

architecture sim of Control_Logic_TB is
    signal CTRL  	  : std_logic_vector(3 downto 0);
    signal ALU_Ctrl   : std_logic_vector(2 downto 0);
    signal SHIFT_Ctrl : std_logic_vector(1 downto 0);
    signal MUX_SEL    : std_logic_vector(1 downto 0);

begin
    UUT: entity work.Control_Logic
        port map (
            CTRL   => CTRL,
            ALU_Ctrl   => ALU_Ctrl,
            SHIFT_Ctrl => SHIFT_Ctrl,
            MUX_SEL    => MUX_SEL
        );

    process
    begin
        -- Test 1: ALU SUB (0001)
        CTRL <= "0001"; wait for 10 ns;
        assert (ALU_Ctrl = "001" and MUX_SEL = "01") report "ALU Decode Fail" severity error;

        -- Test 2: ROR4 (1001)
        CTRL <= "1001"; wait for 10 ns;
        assert (SHIFT_Ctrl = "01" and MUX_SEL = "10") report "Shift Decode Fail" severity error;

        -- Test 3: LUT (1011)
        CTRL <= "1011"; wait for 10 ns;
        assert (MUX_SEL = "11") report "LUT MUX Select Fail" severity error;

        report "Control Logic Verification Complete." severity note;
        wait;
    end process;
end architecture;