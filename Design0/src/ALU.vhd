library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ALU module
-- operations: ADD SUB AND OR XOR NOT MOV NOP

entity ALU is
    port (
        ABUS    : in  std_logic_vector(15 downto 0);
        BBUS    : in  std_logic_vector(15 downto 0);
        ALUctrl : in  std_logic_vector(3 downto 0);
        ALUOUT  : out std_logic_vector(15 downto 0)
    );
end entity ALU;

architecture rtl of ALU is
begin

   with ALUctrl select 
     ALUOUT <= std_logic_vector(signed(ABUS) + signed(BBUS)) when "0000",
               std_logic_vector(signed(ABUS) - signed(BBUS)) when "0001",
               ABUS AND BBUS                                 when "0010",
               ABUS OR BBUS                                  when "0011",
               ABUS XOR BBUS                                 when "0100",
               NOT ABUS                                      when "0101",
               ABUS                                          when "0110",
               (others => '0')                               when others;


end architecture rtl;
