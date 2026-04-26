library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Logic is
    port (
        CTRL      	  : in  std_logic_vector(3 downto 0); -- From Input Register
        ALU_Ctrl      : out std_logic_vector(2 downto 0); -- To ALU (3 bits)
        SHIFT_Ctrl    : out std_logic_vector(1 downto 0); -- To Shifter (2 bits)
        MUX_SEL       : out std_logic_vector(1 downto 0)  -- To MUX (2 bits)
    );
end entity Control_Logic;

architecture rtl of Control_Logic is
begin
    -- This process decodes the "What" and "Where" 
    process(CTRL)
    begin
        -- Default assignments to avoid latches
        ALU_Ctrl   <= "000";
        SHIFT_Ctrl <= "00";
        MUX_SEL    <= "00";

        if CTRL(3) = '0' then
            -- ALU Operations (0000 to 0111)
            -- As per TA instructions: ALU gets only the lower 3 bits
            ALU_Ctrl <= CTRL(2 downto 0);
            MUX_SEL  <= "01"; -- Route ALU to Result
            
        else
            -- Dedicated Security/Shift Operations (1000 to 1011)
            case CTRL is
                when "1000" => -- ROR8
                    SHIFT_Ctrl <= "00";
                    MUX_SEL    <= "10";
                when "1001" => -- ROR4
                    SHIFT_Ctrl <= "01";
                    MUX_SEL    <= "10";
                when "1010" => -- SLL8
                    SHIFT_Ctrl <= "10";
                    MUX_SEL    <= "10";
                when "1011" => -- Nonlinear LUT
                    MUX_SEL    <= "11";
                when others => 
                    -- NOP / Invalid Case
                    MUX_SEL    <= "00"; -- Result will be 0x0000
            end case;
        end if;
    end process;
end architecture;