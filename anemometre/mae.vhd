Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity mae is
    generic (
        N : integer := 8 -- Constante qui defini la largeur du compteur sur N bits
    );
port( 
    clk : in  std_logic;
    ARst_N : in  std_logic;
    continu : in  std_logic;
    start_stop : in std_logic;
    data_valid : in std_logic;
    enable : out std_logic
);
end mae;
-----fin entity-------------------------------------------------------------


--- debut  architecture pour une MAE -----
architecture architecture_MAE of mae is
-- déclaration des signaux

    type etat is (mode_repot, mode_acquisition);
    signal mode : etat;

BEGIN
    process (continu, start_stop, mode, clk, ARst_N)
    begin
        if ARst_N = '0' then
            mode <= mode_repot;
        elsif clk'event and clk = '1' then
            case mode is 
                when mode_repot => 
                   if ((start_stop = '1') or (continu = '1')) then mode <= mode_acquisition;
                   end if;  
                   
                when mode_acquisition => 
                   if ((data_valid = '1') and (continu = '0')) then mode <= mode_repot;
                   end if;
                   when others => 
             end case; 
        end if;
     end process;
     enable <= '1' when (mode = mode_acquisition) else '0';
end architecture_MAE;