Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity registre_BD is
    generic (
        N   : integer := 8                                  -- Constante qui defini la largeur du compteur sur N bits
    );
port( 
    ARst_N : in std_logic; 
    clk : in std_logic;                          -- Horloge
    En  : in std_logic;
    E   : in std_logic_vector(N-1 downto 0);                          -- Remise à 0 de façon synchrone
    SRst: in std_logic;
    Q	: out std_logic_vector(N-1 downto 0)
);
end registre_BD;
-----fin entity-------------------------------------------------------------


--- debut  architecture pour un registre (bascule D ) -----
architecture architecture_BD of registre_BD is

    
BEGIN
	process(clk, ARst_N)
	begin
        if ARst_N = '0' then
           Q <= (others => '0');
        elsif (clk'event and clk = '1') then -- mise à jour des signaux à la fin du process
			   if (SRst = '1') then
			   Q <= (others => '0');
			   else
				if En = '1' then
					Q <= E;
				end if;
		      end if;
            
        end if;
	end process;
end architecture_BD;