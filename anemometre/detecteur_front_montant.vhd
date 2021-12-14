Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity detecteur_front_montant is
port( 
    clk : in  std_logic;
    ARst_N : in  std_logic;
    En : in std_logic;
    front_montant : out std_logic
);
end detecteur_front_montant;
-----fin entity-------------------------------------------------------------


--- debut  architecture pour détecté un front montant --------------------
architecture architecture_D_FM of detecteur_front_montant is
signal r0_input : std_logic;
signal r1_input : std_logic;
begin
p_rising_edge_detector : process(clk,ARst_N)
begin
  if(ARst_N='0') then
    r0_input <= '0';
    r1_input <= '0';
  elsif(rising_edge(clk)) then
    r0_input <= En;
    r1_input <= r0_input;
  end if;
end process p_rising_edge_detector;
front_montant <= not r1_input and r0_input;
end architecture_D_FM;