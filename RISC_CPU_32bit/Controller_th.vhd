-- Testbench for Controller
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller_tb is
end Controller_tb;

architecture TB_ARCH of Controller_tb is
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal opcode_tb : std_logic_vector(3 downto 0) := "0000";
  signal pcSrc_tb, pcWrite_tb, pcWriteCond_tb, IorD_tb, MemWrite_tb, IRWrite1_tb, IRWrite2_tb, MUXR1_tb,
         RegDST_tb, MemToReg_tb, RegWrite_tb, AluSrc2_tb, DIWrite_tb, CZNWrite_tb : std_logic;
  signal AluOp_tb : std_logic_vector(2 downto 0);
  signal controlmemData_tb : std_logic_vector(18 downto 0);
  signal nxtline_tb : std_logic_vector(3 downto 0);
  signal cardata_tb : std_logic_vector(3 downto 0);

  component Controller
    port (
      clk, reset: in std_logic;
      opcode: in std_logic_vector(3 downto 0);
      pcSrc, pcWrite, pcWriteCond, IorD, MemWrite, IRWrite1, IRWrite2, MUXR1,
      RegDST, MemToReg, RegWrite, AluSrc2, DIWrite, CZNWrite : out std_logic;
      AluOp : out std_logic_vector(2 downto 0);
      controlmemData : out std_logic_vector(18 downto 0);
      nxtline : out std_logic_vector(3 downto 0);
      cardata : out std_logic_vector(3 downto 0)
    );
  end component;

  -- Wave Configuration
  signal wave_cfg : std_logic_vector(7 downto 0) := "10000000";

begin

  -- Instantiate the Controller entity
  UUT: Controller
    port map (
      clk => clk,
      reset => reset,
      opcode => opcode_tb,
      pcSrc => pcSrc_tb,
      pcWrite => pcWrite_tb,
      pcWriteCond => pcWriteCond_tb,
      IorD => IorD_tb,
      MemWrite => MemWrite_tb,
      IRWrite1 => IRWrite1_tb,
      IRWrite2 => IRWrite2_tb,
      MUXR1 => MUXR1_tb,
      RegDST => RegDST_tb,
      MemToReg => MemToReg_tb,
      RegWrite => RegWrite_tb,
      AluSrc2 => AluSrc2_tb,
      DIWrite => DIWrite_tb,
      CZNWrite => CZNWrite_tb,
      AluOp => AluOp_tb,
      controlmemData => controlmemData_tb,
      nxtline => nxtline_tb,
      cardata => cardata_tb
    );

  -- Clock process
  clk_process: process
  begin
    while now < 100 ns loop  -- Simulate for 100 ns
      clk <= not clk; -- Toggle the clock
      wait for 5 ns;
    end loop;
    wait;
  end process clk_process;

  -- Stimulus process
  stimulus_process: process
  begin
    wait for 10 ns;  -- Initial wait before applying inputs

    opcode_tb  <= "0000"; -- Read from address 0
    wait for 10 ns;

    opcode_tb  <= "0001"; -- Read from address 1
    wait for 10 ns;

    opcode_tb  <= "0010"; -- Read from address 2
    wait for 10 ns;

    opcode_tb  <= "0100"; -- Read from address 4
    wait for 10 ns;

    opcode_tb  <= "0101"; -- Read from address 5
    wait for 10 ns;

    -- Add more test cases as needed

    wait;
  end process stimulus_process;

  -- Wave process
  wave_process: process
  begin
    wait until rising_edge(clk);
    wave_cfg <= wave_cfg(6 downto 0) & '0';

    case wave_cfg is
      when "10000000" =>
        report "Wave Configuration: clk";
      when "01000000" =>
        report "Wave Configuration: reset";
      when "00100000" =>
        report "Wave Configuration: opcode_tb";
      when "00010000" =>
        report "Wave Configuration: pcSrc_tb";
      when "00001000" =>
        report "Wave Configuration: pcWrite_tb";
      when "00000100" =>
        report "Wave Configuration: IorD_tb";
      when "00000010" =>
        report "Wave Configuration: MemWrite_tb";
      when "00000001" =>
        report "Wave Configuration: AluOp_tb";
      when others =>
        null;
    end case;

    wait for 5 ns;
  end process wave_process;

end TB_ARCH;

