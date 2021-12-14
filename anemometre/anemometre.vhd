library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity anemometre is
port(
    clk : in std_logic;
    ARst_N  : in std_logic;
    clk_1Hz : out std_logic;
    in_f_anemo : in std_logic;
    continu : in  std_logic;
    start_stop : in std_logic;
    data_valid : out std_logic;
    data_anemometre : out std_logic_vector(7 downto 0)
    --Debug1 : out std_logic_vector(7 downto 0);
    --Debug2 : out std_logic_vector(7 downto 0)
);
end anemometre;

architecture description_anemometre of anemometre is
    constant N : integer := 8;
    signal tmp_clk_1hz : std_logic;
    signal tmp_front_montant : std_logic;
    signal tmp_Q : std_logic_vector(N-1 downto 0);
    signal tmp_data_anemometre : std_logic_vector(N-1 downto 0);
    signal tmp_Q_reg : std_logic_vector(N-1 downto 0);
    
    signal tmp_enable : std_logic;
    signal tmp_not_enable : std_logic;
    signal tmp_in_f_anemo : std_logic;
    signal enable : std_logic;
    signal tmp_SRst : std_logic;

    

----creation de notre component d�tecteur front montant-----
component detecteur_front_montant
port(
    clk : in  std_logic;
    ARst_N : in  std_logic;
    En : in  std_logic;
    front_montant : out std_logic);
end component;
----fin component d�tecteur front montant---


----creation de notre component de signal 1hz-----
component generation_impulsion_1hz
generic (
    freq_in : integer := 50e6; --50e6;
    freq_out : integer := 10E3 -- Constante qui defini la largeur du compteur sur N bits
);
port(clk : in std_logic;
     ARst_N : in  std_logic;
     Rst : in  std_logic;
     clk_1Hz: out std_logic);
end component;
----fin component signal_1hz---


----declaration de notre component compteur----
component Cnt
generic (
    N   : integer := 8                                  -- Constante qui defini la largeur du compteur sur N bits
);

port(
    ARst_N  : in    std_logic;                          -- Remise � 0 de fa�on asynchrone active niveau bas
    Clk     : in    std_logic;                          -- Horloge
    SRst    : in    std_logic;                          -- Remise � 0 de fa�on synchrone
    En      : in    std_logic;   
    Q : out std_logic_vector(N -1 downto 0)
);
end  component;
----fin  component compteur---


----declaration de notre component register bascule D----
component registre_BD
generic (
    N   : integer := 8                                 -- Constante qui defini la largeur du compteur sur N bits
);
port( 
    ARst_N : in std_logic; 
    clk : in std_logic;                                -- Horloge
    En : in std_logic;
    E: in std_logic_vector(N-1 downto 0);              -- Remise � 0 de fa�on synchrone
    SRst: in std_logic;
    Q : out std_logic_vector(N-1 downto 0)
);
end  component;
----fin  component compteur---

----declaration de notre component MAE ----
component mae
    generic (
        N   : integer := 8                                 -- Constante qui defini la largeur du compteur sur N bits
    );
    port( 
    clk : in  std_logic;
    ARst_N : in  std_logic;
    continu : in  std_logic;
    start_stop : in std_logic;
    data_valid : in std_logic;
    enable : out std_logic
    );
    end  component;
    ----fin  component MAE---


----declaration de notre component BasculeD ----
component BasculeD
    generic (
        N   : integer := 8                                 -- Constante qui defini la largeur du compteur sur N bits
    );
    port( 
    ARst_N : in std_logic;
    clk : in  std_logic;
    En, D : in std_logic;
    Q	: out std_logic
    );
    end  component;
    ----fin  component BasculeD---

begin
    detect_front : detecteur_front_montant
	port map(clk=>clk, ARst_N=>ARst_N, En=>in_f_anemo, front_montant=>tmp_front_montant);

    gen_impul : generation_impulsion_1hz
	port map(clk=>clk, ARst_N=>ARst_N, Rst=>tmp_not_enable, clk_1Hz=>tmp_clk_1hz);
	
	cpt : Cnt
	port map(clk=>clk, SRst=>tmp_SRst, ARst_N=>ARst_N, En=>tmp_front_montant, Q => tmp_Q); 

    reg : registre_BD
	port map(E=>tmp_Q, ARst_N=>ARst_N, clk=>clk, SRst=>'0', Q => data_anemometre, En => tmp_clk_1hz); 

    machine_etat : mae
	port map(start_stop=>start_stop, continu=>continu, clk=>clk, ARst_N=>ARst_N, data_valid=>tmp_clk_1hz, enable=>tmp_enable); 
	
	basc : BasculeD
	port map(en=>'1', D => tmp_clk_1hz, ARst_N=>ARst_N, clk=>clk, Q => data_valid); 
	
	clk_1Hz <= tmp_clk_1hz;
	--Debug1 <= tmp_Q;
	--Debug2 <= tmp_data_anemometre;
	tmp_not_enable <= not (tmp_enable);
	tmp_SRst <= tmp_not_enable or tmp_clk_1hz ;
	--tmp_in_f_anemo <= tmp_enable and in_f_anemo ;
	
	
end architecture;