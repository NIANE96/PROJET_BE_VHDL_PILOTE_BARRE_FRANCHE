LIBRARY ieee;
USE ieee.std_logic_1164.all; 
Use ieee.std_logic_unsigned.all;

LIBRARY work;

ENTITY boutton_poussoir is 
	PORT
	(
 clk, ARst_N, bp_babord, bp_tribord, bp_stby : in std_logic;
 code_fonction : out std_logic_vector (3 downto 0); 
 led_babord, led_stby,led_tribord  : out std_logic ; 
 out_bip,bp_stby_fm : out std_logic
	);
END boutton_poussoir;

ARCHITECTURE arch of boutton_poussoir is 
type etat is (veille, babord_verin, tribord_verin, pilote_autom, tribord_bip, babord_bip, mode_incr_1, mode_incr_10, mode_decr_1, mode_decr_10);
signal mode : etat;
signal clk_100Hz, clk_50Hz, clk_1HZ, fin_tempo : std_logic;
signal val_tempo, BP : std_logic;
signal cpt : std_logic_vector (27 downto 0);
signal cpt_50 : std_logic_vector (5 downto 0);
signal duree_tempo : std_logic_vector (7 downto 0);
signal bip_simple,bip_double,fin_bip,bip :std_logic;
signal compt_bip: integer range 0 to 200;


signal r0_input : std_logic;
signal r1_input : std_logic;

BEGIN 

p_rising_edge_detector : process(clk,ARst_N)
begin
  if(ARst_N='0') then
    r0_input <= '0';
    r1_input <= '0';
  elsif(rising_edge(clk)) then
    r0_input <= bp_stby;
    r1_input <= r0_input;
  end if;
end process p_rising_edge_detector;
bp_stby_fm <= not r1_input and r0_input;

process (clk, ARst_N)
begin
	if ARst_N = '0' then
		mode <= veille;
    elsif clk'event and clk = '1' then

     case mode is 
		when veille => 
			if (bp_tribord = '0') then mode <= tribord_verin;
			elsif (bp_babord = '0') then mode <= babord_verin;
			elsif (bp_stby = '0') then mode <= pilote_autom;
			end if;  
					   
		when tribord_verin => 
			if (bp_tribord = '1') then mode <= veille;
			end if;
					
		when babord_verin => 
		    if (bp_babord = '1') then mode <= veille;
		    end if;
					
		when pilote_autom => 
			if (bp_stby = '0') then mode <= veille;
					   --elsif (bp_FM = '1') then mode <= veille;
			elsif (bp_tribord = '0') then mode <= tribord_bip;
			elsif (bp_babord = '0')  then mode <= babord_bip;
			end if;  
										   
		when tribord_bip => 
			if (bp_tribord = '1') then mode <= mode_incr_1;
			elsif (fin_tempo = '1' and bp_tribord = '0') then mode <= mode_incr_10;
			end if; 
					   
		when babord_bip => 
			if (bp_babord = '1') then mode <= mode_decr_1;
			elsif (fin_tempo = '1' and bp_babord = '0') then mode <= mode_decr_10;
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

 process ( mode)
begin
case mode is
when veille => code_fonction<="0000";
			  led_stby<=clk_1Hz;

when tribord_verin => code_fonction<="0001";
			  led_tribord<=clk_50Hz;

when babord_verin => code_fonction<="0010";
			  led_babord<=clk_50Hz;
when pilote_autom => code_fonction<="0011";
			  led_stby<='1';
when mode_incr_1 => code_fonction<="0100";
			  val_tempo <= '0';
			  bip_simple<= '1';
			  led_tribord<=clk_50Hz;

when mode_incr_10 => code_fonction<="0101";
			  val_tempo <= '0';
			  bip_double<= '1';
			  led_tribord<=clk_50Hz;

when mode_decr_10 => code_fonction<="0110";
			  val_tempo <= '0';
			  bip_double<= '1';
			  led_babord<=clk_50Hz;


when mode_decr_1 => code_fonction<="0111";
			  val_tempo <= '0';
			  bip_simple<= '1';
			  led_babord<=clk_50Hz;
			  when others =>

end case;
end process;

freq_100:	process(clk,ARst_N)
	BEGIN
		if ARst_N= '0' then
			cpt <= (others => '0');
			 clk_100Hz <= '0';
		elsif clk'event and clk='1' then
			cpt <= cpt + "1";
			if cpt =  249999 then
				clk_100Hz <= not clk_100Hz;
				cpt<= (others => '0');
			end if;
		end if;
	end process freq_100;


freq_1:	process(clk_100Hz,ARst_N)
	BEGIN
		if ARst_N= '0' then
			cpt_50 <= (others => '0');
			 clk_50Hz <= '0';
		elsif clk_100Hz'event and clk_100Hz='1' then
			clk_50Hz <= not clk_50Hz;
			cpt_50 <= cpt_50 + "1";
			if cpt_50 =  49 then
				clk_1Hz <= not clk_1Hz;
				cpt_50<= (others => '0');
			end if;
		end if;	
	end process freq_1;
	
-- g�n�ration clk_1Hz et clk_50Hz 
		

-- tempo_2s 

tempo:process (ARst_N, clk)
	BEGIN
		if ARst_N = '0' then 
			duree_tempo<= (others => '0'); fin_tempo <= '0';
		elsif clk'event and clk='1' then
			if val_tempo = '1' then
			duree_tempo <= duree_tempo+1;
				if duree_tempo = 400 then duree_tempo <= (others => '0');
				fin_tempo <= '1';
				end if;
			else duree_tempo <= (others => '0') ; fin_tempo <= '0';
			end if;
		end if;
end process tempo;

-- g�n�ration du bip et double bip
process (ARst_N, bip_simple,bip_double, clk_100Hz)
variable etat_bip : integer range 0 to 2;
begin
	if ARst_N ='0' or (bip_simple='0' and bip_double='0') then
	etat_bip:= 0;
	compt_bip <= 0; 
	fin_bip <='0';
	bip<='0';
	elsif clk_100Hz'event and clk_100Hz='1' then
	case etat_bip is
	when 0 =>
		if bip_simple='1' or bip_double='1' then 
		etat_bip:=1;
		end if;
	when 1 =>
		compt_bip<=compt_bip+1;
		if bip_simple='1' then
			if compt_bip >=30 then compt_bip<=0; fin_bip <='1';
			etat_bip:=2; bip <='0';
			end if;
		end if;
		if bip_double='1' then
			if compt_bip >=90 then compt_bip<=0; fin_bip <='1';
			etat_bip:=2; bip <='0';
			end if;
		end if;
		if (compt_bip >= 1 and compt_bip <= 30) or (compt_bip >= 60 and compt_bip <= 90) then
		bip <='1';
		else bip<='0';
		end if;
	when 2 =>
		if bip_simple='0' and bip_double='0' then 
		etat_bip:=0;
		end if;
	end case;
	end if;
end process double_bip;

out_bip<=bip;				
		
END arch;