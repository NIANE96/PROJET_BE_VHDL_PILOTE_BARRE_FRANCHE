
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity generation_bip is
    port (
        clk : in std_logic;
        ARst_N : in std_logic;
        bip_simple, bip_double : in std_logic;
        out_bip, fin_bip : out std_logic
    );
end generation_bip;

architecture rtl of generation_bip is
    --signal cmpt_bip : std_logic_vector (7 downto 0);
    signal f_bip, s_bip : std_logic;

    type etat_bip is (sans_bip, mode_interm, mode_simple_bip, mode_double_bip);
    signal mode_bip : etat_bip;
begin
    process (clk, ARst_N)
    begin

        if (ARst_N = '0') then
            mode_bip <= sans_bip;

        elsif clk'event and clk = '1' then
            case mode_bip is 
              when sans_bip => 
                   if (bip_simple = '1' or bip_double = '1') then mode_bip <= mode_interm;
                   end if;

              when mode_interm => 

--------------- Début mode simple bip-----------------------------
                   if (bip_simple = '1') 
                   then 
                         f_bip <= '1';
                         s_bip <= '0';
                         mode_bip <= mode_simple_bip;
--------------- Fin mode simple bip-------------------------------
                   
--------------- Début mode double bip-----------------------------
                   elsif (bip_double='1')
                   then 
                        f_bip <='1';
                        s_bip <= '0';
                        mode_bip <= mode_double_bip;
                   end if;
--------------- Fin mode simple bip-------------------------------
 
                         
--------------- teste return mode sans bip-----------------------------
              when mode_double_bip => 
                   if (f_bip='1') then 
                     mode_bip <= sans_bip;
                   end if;
              when mode_simple_bip => 
                   if (f_bip='1') then 
                     mode_bip <= sans_bip;
                   end if;
                   when others => 
            end case; 
        end if;
    end process;
    out_bip <= s_bip;
    --compteur_bip <= cmpt_bip;
    fin_bip  <= f_bip;
end architecture;