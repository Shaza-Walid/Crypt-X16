library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Combinational Logic Unit (CLU)
-- Integrates Control_Logic, ALU, Shifter, LUT, and MUX

entity CLU is
    port (
	A_BUS  : in  std_logic_vector(15 downto 0); -- First operand
	B_BUS  : in  std_logic_vector(15 downto 0); -- Second operand
    CTRL   : in  std_logic_vector(3 downto 0);  -- Control signal (operation selector)
	RESULT : out std_logic_vector(15 downto 0)  -- Final output
    );
end entity;

architecture rtl of CLU is

    -- Internal Control Signals
    signal ALUctrl    : std_logic_vector(2 downto 0);
    signal SHIFTctrl  : std_logic_vector(1 downto 0);
    signal MUXctrl    : std_logic_vector(1 downto 0);

    -- Internal Data Signals (Outputs from sub-units)
    signal ALUout    : std_logic_vector(15 downto 0);
    signal SHIFTout  : std_logic_vector(15 downto 0);
    signal LUTout    : std_logic_vector(15 downto 0);

begin

    -- 1. Control Logic
    -- Takes 4-bit CTRL and tells the other units what to do
    CTRL_inst: entity work.Control_Logic
        port map (
            CTRL  	   => CTRL,
            ALU_Ctrl   => ALUctrl,
            SHIFT_Ctrl => SHIFTctrl,
            MUX_SEL    => MUXctrl
        );

    -- 2. ALU
    ALU_inst: entity work.ALU
        port map (
            ABUS    => A_BUS,
            BBUS    => B_BUS,
            ALUctrl => ALUctrl,
            ALUOUT  => ALUout
        );

    -- 3. Shifter
    SHIFTER_inst: entity work.shifter
        port map (
            SHIFTINPUT => B_BUS,
            SHIFT_Ctrl => SHIFTctrl,
            SHIFTOUT   => SHIFTout
        );

    -- 4. Nonlinear Lookup (LUT)
    LUT_inst: entity work.non_linear_lookup
        port map (
            LUTIN  => A_BUS,
            LUTOUT => LUTout
        );

    -- 5. Multiplexer (MUX)
    MUX_inst: entity work.MUX
        port map (
            ALU_OUT   => ALUout,
            SHIFT_OUT => SHIFTout,
            LUT_OUT   => LUTout,
            SEL       => MUXctrl,
            MUX_OUT   => RESULT
        );

end architecture;