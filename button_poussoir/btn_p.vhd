Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity btn_p is

port( 
    clk : in  std_logic;
    ARst_N : in  std_logic;
    bp_babord, bp_tribord, bp_stby, bp_FM, fin_bip : in std_logic;
    code_fonction : out std_logic_vector (3 downto 0);
    bip_simple, bip_double : out std_logic;
    led_babord, led_stby, led_tribord, debug : out std_logic
);
end btn_p;
-----fin entity----------------------------------------------------------------------------------------------------------------


--- debut  architecture pour une MAE -------------------------------------------------------------------------------------------
architecture arch_btn of btn_p is

---------déclaration des signaux------------------------------------------------------------------------------------------------
signal cmpt : std_logic_vector (5 downto 0);
signal tmp_cpt_50 : std_logic_vector (7 downto 0);
signal tmp_clk_50Hz, tmp_clk_1Hz, tmp_enable, fin_tempo : std_logic;


----------------Temporisateur_200ns ------------------------------------------------------------------------------------------------------
signal duree_tempo : std_logic_vector (7 downto 0);

    type etat is (veille, babord_verin, tribord_verin, pilote_autom, tribord_bip, babord_bip, mode_incr_1, mode_incr_10, mode_decr_1, mode_decr_10);
    signal mode : etat;

BEGIN
    process (clk, ARst_N)
    begin
        if ARst_N = '0' then
            mode <= veille;
            
            tmp_cpt_50 <= (others => '0');
            tmp_clk_50Hz <= '0';
		    duree_tempo<= (others => '0'); 
			fin_tempo <= '0';
		    
        elsif clk'event and clk = '1' then
-------------Generation 50Hz et 1Hz---------------------------------------------------------------------------------------------- 
			tmp_clk_50hz <= not tmp_clk_50hz;
			tmp_cpt_50 <= tmp_cpt_50 + "1";
			if tmp_cpt_50 =  1 then
				tmp_clk_1hz <= not tmp_clk_1hz;
				tmp_cpt_50<= (others => '0');
			end if;

------------Fin generation-----------------------------------------------------------------------------------------------------

------------Temporisateur de 200 nanosecondes ------------------------------------------------------------------------------------------------------
		if (tmp_enable = '1') then
			  duree_tempo <= duree_tempo + 1;
				if(duree_tempo = 5) then -- 200ns pour notre tempo
				  duree_tempo <= (others => '0'); 
				  fin_tempo <= '1';
				end if;
		else duree_tempo <= (others => '0') ; fin_tempo <= '0';
		end if;
----------Fin temporisateur---------------------------------------------------- 
            case mode is 
                when veille => 
                   if (bp_tribord = '1') then mode <= tribord_verin;
                   elsif (bp_babord = '1') then mode <= babord_verin;
                   elsif (bp_FM = '1') then mode <= pilote_autom;
                   end if;  
                   
                when tribord_verin => 
                   if (bp_tribord = '0') then mode <= veille;
                   end if;
                
                when babord_verin => 
                   if (bp_babord = '0') then mode <= veille;
                   end if;
                
                when pilote_autom => 
                   if (bp_FM = '1') then mode <= veille;
                   elsif (bp_tribord = '1') then mode <= tribord_bip;
                   elsif (bp_babord = '1')  then mode <= babord_bip;
                   end if;  
                                       
                when tribord_bip => 
                   fin_tempo <= '1';
                   tmp_enable <= '1';
                   if (bp_tribord = '0') then mode <= mode_incr_1;
                   elsif (fin_tempo = '1' and bp_tribord = '1') then mode <= mode_incr_10;
                   end if; 
                   
                when babord_bip => 
                   fin_tempo <= '1';
                   tmp_enable <= '1';
                   if (bp_babord = '0') then mode <= mode_decr_1;
                   elsif (fin_tempo = '1' and bp_babord = '1') then mode <= mode_decr_10;
                   end if; 
                    
                when mode_incr_1 => 
                   if (fin_bip = '1') then mode <= pilote_autom;
                   end if;  
                  
                when mode_incr_10 => 
                   if (fin_bip = '1') then mode <= pilote_autom;
                   end if;
                   
                when mode_decr_1 => 
                   if (fin_bip = '1') then mode <= pilote_autom;
                   end if;  
                  
                when mode_decr_10 => 
                   if (fin_bip = '1') then mode <= pilote_autom;
                   end if;             
                   when others => 
             end case; 
        end if;
     end process;
     
---------------SORTIES CODE DE FONCTION---------------------------------------------------------------------------------    
	code_fonction <= "0010" when (mode = tribord_verin)else 
                     "0001" when (mode = babord_verin) else
                     "0011" when (mode = pilote_autom) else
                     "0100" when (mode = mode_incr_1)  else 
                     "0101" when (mode = mode_incr_10) else
                     "0111" when (mode = mode_decr_1)  else
                     "0110" when (mode = mode_decr_10) else  "0000";
     
----------------SORTIES BIPS ------------------------------------------------------------------------------------------- 
    bip_simple <= '1' when (mode = mode_incr_1 or mode = mode_decr_1) else '0';
    bip_double <= '1' when (mode = mode_incr_10 or mode = mode_decr_10) else '0';
    
---------------SORTIES LEDS ---------------------------------------------------------------------------------------------
    led_stby <= tmp_clk_1hz when (mode = veille) else
               '1' when (mode = pilote_autom) else '0';            
    led_babord  <= tmp_clk_50hz when (mode = babord_verin or mode = mode_decr_1 or mode = mode_decr_10) else '0';     
    led_tribord <= tmp_clk_50hz when (mode = tribord_verin or mode = mode_incr_1 or mode = mode_incr_10)else '0';
    
end arch_btn;