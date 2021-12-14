-- fixe la fréquence de la pwm (divide de freq)
--*****************************************************
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

Entity compteur_n is
generic ( modulo : integer := 255);
port	(CLK, reset_n, reset : in std_logic;
	 Q : out std_logic_vector (7 downto 0));
End compteur_n;

Architecture arch_compteur_n of compteur_n is
Signal sig_Q : std_logic_vector(7 downto 0);
Begin
Process (clk, reset_n)
	Begin
		if reset_n='0' then sig_Q <= (others =>'0');
		elsif(CLK'event and CLK='1') then
			if reset='1' then sig_Q <= (others =>'0');
			elsif sig_Q = modulo then sig_Q <= (others =>'0');
			else sig_Q <= sig_Q+1;
			end if;
		end if;
	End Process;
Q<=sig_Q;
End arch_compteur_n;