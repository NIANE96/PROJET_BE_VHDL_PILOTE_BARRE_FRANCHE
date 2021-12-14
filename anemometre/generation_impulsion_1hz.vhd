Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity generation_impulsion_1hz is
    generic (
         freq_in: integer := 50E6;
         freq_out: integer := 1E3                 
    );
port( 
    clk : in  std_logic;
    ARst_N : in  std_logic;
    Rst : in  std_logic;
    clk_1Hz : out std_logic
);
end generation_impulsion_1hz;
-----fin entity-------------------------------------------------------------


--- debut  architecture pour détecté un front montant -----
architecture architecture_G_impul_1hz of generation_impulsion_1hz is

    constant val_to_compare: integer := (freq_in/(freq_out)-1); ---val_to_compare = freq_in/(freq_out) - 1------------------------
    constant N: integer := integer(ceil(log2(real(val_to_compare)))); ----N=lnA/ln2 => log2A une fonction existant en vhdl et ceil pour arrondire en haut et fllor en bas comme en c programming
    signal cmpt : std_logic_vector(N-1 downto 0);
BEGIN
	process(clk, ARst_N)
	begin
        if (ARst_N = '0') then clk_1hz <= '0';
        elsif (clk'event and clk = '1') then
			if (Rst = '1') then
				clk_1hz <= '0';
            else
				cmpt <= cmpt + 1;
				clk_1Hz <= '0';
				if cmpt >= val_to_compare then -------(50e6/x+1) = 1hz => x = 50e6 - 1 = 49999999 --------
					cmpt <= (others => '0');
					clk_1Hz <= '1'; 
				end if;
            end if;
        end if;    
	end process;
end architecture_G_impul_1hz;