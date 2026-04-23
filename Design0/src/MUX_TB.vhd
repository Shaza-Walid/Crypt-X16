library ieee;
use ieee.std_logic_1164.all;

entity MUX_TB is
end entity;

architecture sim of MUX_TB is

    signal LUT_OUT	: std_logic_vector(15 downto 0) := x"1111";
    signal ALU_OUT	: std_logic_vector(15 downto 0) := x"2222";
    signal SHIFT_OUT: std_logic_vector(15 downto 0) := x"3333";
    signal SEL		: std_logic_vector(1 downto 0);
    signal MUX_OUT	: std_logic_vector(15 downto 0);

begin
    
    UUT: entity work.MUX
        port map(
            LUT_OUT   => LUT_OUT,
            ALU_OUT   => ALU_OUT,
            SHIFT_OUT => SHIFT_OUT,
            SEL       => SEL,
            MUX_OUT   => MUX_OUT
        );
        
    sim: process
    begin
        -- Test 0: Default/Invalid Case
        SEL <= "00";
        wait for 20 ns;    
        assert MUX_OUT = x"0000" report "Default MUX Case Failed" severity error;
        
        -- Test 1: ALU Selection
        SEL <= "01";
        wait for 20 ns;
        assert MUX_OUT = x"2222" report "ALU Selection Failed" severity error;
    
        -- Test 2: Shifter Selection
        SEL <= "10";
        wait for 20 ns;
        assert MUX_OUT = x"3333" report "Shifter Selection Failed" severity error;
    
        -- Test 3: LUT Selection
        SEL <= "11";
        wait for 20 ns;
        assert MUX_OUT = x"1111" report "LUT Selection Failed" severity error;
        
        report "MUX tests completed successfully." severity note;
        wait;
    end process;
                    
end architecture;