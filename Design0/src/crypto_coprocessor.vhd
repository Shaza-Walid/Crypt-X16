library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Top Level Cryptographic Coprocessor

entity crypto_coprocessor is
    port (
        clock  : in std_logic;
        reset  : in std_logic;
        CTRL   : in std_logic_vector(3 downto 0);
        Ra     : in std_logic_vector(3 downto 0);
        Rb     : in std_logic_vector(3 downto 0);
        Rd     : in std_logic_vector(3 downto 0)
    );
end entity crypto_coprocessor;

architecture rtl of crypto_coprocessor is

    component register_file is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            RdWEn  : in  std_logic;
            RES    : in  std_logic_vector(15 downto 0);
            Ra     : in  std_logic_vector(3 downto 0);
            Rb     : in  std_logic_vector(3 downto 0);
            Rd     : in  std_logic_vector(3 downto 0);
            SRCa   : out std_logic_vector(15 downto 0);
            SRCb   : out std_logic_vector(15 downto 0)
        );
    end component;

    component CLU is
        port (
            A_BUS  : in  std_logic_vector(15 downto 0);
            B_BUS  : in  std_logic_vector(15 downto 0);
            CTRL   : in  std_logic_vector(3 downto 0);
            RESULT : out std_logic_vector(15 downto 0)
        );
    end component;

    signal write_en   : std_logic;
    signal src_a      : std_logic_vector(15 downto 0);
    signal src_b      : std_logic_vector(15 downto 0);
    signal result     : std_logic_vector(15 downto 0);
    signal ctrl_reg   : std_logic_vector(3 downto 0);
    signal rd_reg     : std_logic_vector(3 downto 0);

begin

    -- TODO: port map register_file
    -- TODO: port map structural_VHDL
    -- TODO: input register process (latch CTRL and Rd on clock edge)
    -- TODO: write_en logic (disable on NOP)

end architecture rtl;