--******************************************************
--génère le rapport cyclique
--******************************************************
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

Entity comparateur_duty is
port	( CLK , reset_n : in std_logic;
          e_compteur_n, DUTY_CYCLE : in std_logic_vector (7 downto 0);
          Q : out std_logic);
End comparateur_duty;

Architecture arch_comparateur_duty of comparateur_duty is

Signal sig_Q : std_logic;

Begin

Process (CLK,reset_n )
	Begin
		if reset_n ='0' then sig_Q <= '0';
		elsif(CLK'event and CLK='1') then
			if e_compteur_n < DUTY_CYCLE then sig_Q <='1';
			else sig_Q <= '0';
			end if;
		end if;
	End Process;
	
Q <= sig_Q;

End arch_comparateur_duty;