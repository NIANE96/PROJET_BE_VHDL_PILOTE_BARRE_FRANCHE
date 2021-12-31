library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity main is
port(
-----Les Entrées et les Sorties-------------------------------------------------------------
clk : in  std_logic;    --------- Horloge ------------
ARst_N : in  std_logic; --------- Remise à 0 de façon asynchrone active niveau bas----------
bp_babord, bp_tribord, bp_stby : in std_logic;
code_fonction : out std_logic_vector (3 downto 0);
out_bip : out std_logic;
led_babord, led_stby, led_tribord : out std_logic
);
end main;

architecture arch of main is
    signal tmp_BP_FM : std_logic;
    signal tmp_fin_bip : std_logic;
    signal tmp_bip_simple, tmp_bip_double : std_logic;
    
--------------creation de notre component détecteur front montant--------------------
component detecteur_front_montant
    port(
        clk : in  std_logic;
        ARst_N : in  std_logic;
        BP : in std_logic;
        BP_FM : out std_logic);
end component;
---------------fin component détecteur front montant----------------------------------

component btn_p
    port( 
        clk : in  std_logic;
        ARst_N : in  std_logic;
        bp_babord, bp_tribord, bp_stby, bp_FM, fin_bip : in std_logic;
        bip_simple, bip_double : out std_logic;
        code_fonction : out std_logic_vector (3 downto 0);
        led_babord, led_stby, led_tribord : out std_logic
    );

end component;

component generation_bip
    port( 
        clk : in std_logic;
        ARst_N : in std_logic;
        bip_simple, bip_double : in std_logic;
        out_bip, fin_bip : out std_logic
    );

end component;

begin
    detect_front : detecteur_front_montant
	port map(clk=>clk, ARst_N=>ARst_N, BP_FM=>tmp_BP_FM, BP=>bp_stby);
	
    reg : btn_p
    port map(ARst_N=>ARst_N, clk=>clk,
             bp_FM=>tmp_BP_FM,
             bp_babord=>bp_babord,
             bp_tribord=>bp_tribord,
             bp_stby=>bp_stby,
             fin_bip=>tmp_fin_bip,
             bip_simple=>tmp_bip_simple,
             bip_double=>tmp_bip_double,
             code_fonction=>code_fonction,
             led_stby =>led_stby,
             led_babord =>led_babord,
             led_tribord=>led_tribord);

    gen_bip : generation_bip
    port map(ARst_N=>ARst_N, clk=>clk, 
             bip_simple=>tmp_bip_simple,
             bip_double=>tmp_bip_double,
             out_bip=>out_bip, 
             fin_bip=>tmp_fin_bip);

end architecture;