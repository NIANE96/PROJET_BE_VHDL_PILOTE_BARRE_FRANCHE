Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

---debut entity----------------------------------------------------------------------------------------------------------------
entity BasculeD is
    generic (
        N   : integer := 8 -- Constante qui defini la largeur du compteur sur N bits
    );
port( 
    clk : in  std_logic;
    en : in std_logic;
    D : in std_logic;
    ARst_N : in std_logic;
    Q	: out std_logic
);
end BasculeD;

architecture arc of BasculeD is 
begin
 process (clk, ARst_N)
 begin
 if (ARst_N = '0') then Q <= '0';
 elsif rising_edge (clk) then
	if en = '1' then
		Q <= D;
	end if;
 end if;
 end process;
end arc; 