Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.std_logic_arith.all;
Use ieee.numeric_std.all;

Entity comparateur_freq is
port	( CLK, reset_n : in std_logic;
	  e_compteur_n, FREQ : in std_logic_vector (7 downto 0);
	  Q : out std_logic);
End comparateur_freq;

Architecture arch_comparateur_freq of comparateur_freq is
Signal sig_Q : std_logic;
Signal sig_FREQ : std_logic_vector (7 downto 0);
Begin
Process (clk, reset_n)
	Begin
		if reset_n ='0' then sig_Q <= '0';
		elsif(CLK'event and CLK='1') then
			if e_compteur_n = FREQ - 2 then sig_Q <= '1';
			else sig_Q <= '0';
			end if;
		end if;
	End Process;
Q <= sig_Q;
End arch_comparateur_freq;