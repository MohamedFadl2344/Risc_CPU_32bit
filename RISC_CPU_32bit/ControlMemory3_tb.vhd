-- RISC_CPU_32BIT Project Testbench
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ControlMemory_tb is
end ControlMemory_tb;

architecture TB_ARCH of ControlMemory_tb is
  signal clk : std_logic := '0';
  signal rst_n : std_logic := '0';
  signal ADDR_tb : std_logic_vector(3 downto 0) := (others => '0');
  signal DOUT_tb : std_logic_vector(18 downto 0);

  component ControlMemory
    generic (
      K : integer := 19;  -- number of bits per word (data size)
      W : integer := 4    -- number of address bits (address size)
    );
    port (
      clk, rst_n : in std_logic;
      ADDR : in std_logic_vector(W-1 downto 0);
      DOUT : out std_logic_vector(K-1 downto 0)
    );
  end component;

  -- Wave Configuration
  signal wave_cfg : std_logic_vector(4 downto 0) := "10000";

begin

  -- Instantiate the ControlMemory entity
  UUT: ControlMemory
    generic map (
      K => 19,
      W => 4
    )
    port map (
      clk => clk,
      rst_n => rst_n,
      ADDR => ADDR_tb,
      DOUT => DOUT_tb
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
    rst_n <= '0'; -- Assert reset
    wait for 10 ns;
    rst_n <= '1'; -- Deassert reset
    wait for 10 ns;

    -- Test reading from different addresses
    ADDR_tb <= "0000"; -- Read from address 0
    wait for 10 ns;

    ADDR_tb <= "0001"; -- Read from address 1
    wait for 10 ns;

    ADDR_tb <= "0010"; -- Read from address 2
    wait for 10 ns;

    ADDR_tb <= "0100"; -- Read from address 4
    wait for 10 ns;

    ADDR_tb <= "0101"; -- Read from address 5
    wait for 10 ns;

    -- Add more test cases as needed

    wait;
  end process stimulus_process;

  -- Wave process
  wave_process: process
  begin
    wait until rising_edge(clk);
    wave_cfg <= wave_cfg(3 downto 0) & '0';

    case wave_cfg is
      when "10000" =>
        report "Wave Configuration: clk";
      when "01000" =>
        report "Wave Configuration: rst_n";
      when "00100" =>
        report "Wave Configuration: ADDR_tb";
      when "00010" =>
        report "Wave Configuration: DOUT_tb";
      when "00001" =>
        report "Wave Configuration: End of Simulation";
        wait;
      when others =>
        null;
    end case;

    wait for 5 ns;
  end process wave_process;

end TB_ARCH;

