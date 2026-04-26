library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Input Register (matches Figure 1 architecture)
-- Registers CTRL only. Ra, Rb, Rd go directly to the register file.
-- RdWEn is '0' (suppress write-back) when:
--   * registered CTRL = "0111" (NOP), or
--   * reset is currently asserted.

entity input_register is
    port (
        clock    : in  std_logic;
        reset    : in  std_logic;
        CTRL_IN  : in  std_logic_vector(3 downto 0);
        CTRL_OUT : out std_logic_vector(3 downto 0);
        RdWEn    : out std_logic
    );
end entity input_register;

architecture rtl of input_register is

    signal CTRL_reg : std_logic_vector(3 downto 0) := "0111"; -- power-on NOP

begin

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                CTRL_reg <= "0111";  -- force NOP during reset
            else
                CTRL_reg <= CTRL_IN;
            end if;
        end if;
    end process;

    CTRL_OUT <= CTRL_reg;

    -- Disable write-back for NOP or while reset is asserted
    RdWEn <= '0' when (CTRL_reg = "0111" or reset = '1') else '1';

end architecture rtl;