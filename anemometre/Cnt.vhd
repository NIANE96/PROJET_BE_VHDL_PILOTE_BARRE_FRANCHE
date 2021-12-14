library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Cnt is
    generic (
        N : integer := 8                                  -- Constante qui defini la largeur du compteur sur N bits
    );
    port (
        ARst_N : in std_logic; 
        clk : in std_logic;                          -- Horloge
        SRst : in std_logic;                          -- Remise à 0 de façon synchrone
        En : in std_logic;                          -- '1' --> autorise le comptage
        Q : out std_logic_vector(N - 1 downto 0)    -- Sortie du compteur sur N bits
    );
end entity Cnt;

architecture rtl of Cnt is
    signal sQ : std_logic_vector(N - 1 downto 0);
begin
    
    pCnt: process(clk, ARst_N)
    begin
        if ARst_N = '0' then
            sQ <= (others => '0');
        elsif rising_edge(clk) then
            if SRst = '1' then
                sQ <= (others => '0');
            else
                if En = '1' then
                   sQ <= sQ + 1;
                end if;
            end if;
        end if;
    end process pCnt;
    Q <= sQ;
end architecture rtl;