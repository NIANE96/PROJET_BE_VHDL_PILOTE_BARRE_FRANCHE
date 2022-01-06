Library	ieee;
use	ieee.std_logic_1164.all;


package composant is

-- declaration de la composant compteur_n
component compteur_n is 
generic ( modulo : integer := 255); -- N=8 bits nombre de bits 2^8=255

port	( CLK, reset_n, reset : in std_logic;
	      Q : out std_logic_vector (7 downto 0));
end component ;

-- declaration de la composant comparateur_freq
component comparateur_freq is
port	( CLK, reset_n : in std_logic;
	  e_compteur_n, FREQ : in std_logic_vector (7 downto 0);
	  Q: out std_logic);
end component;

-- declaration de la composant comparateur_duty
component comparateur_duty is
port	( CLK , reset_n : in std_logic;
	  e_compteur_n, DUTY_CYCLE : in std_logic_vector (7 downto 0);
	  Q: out std_logic);
end component;

-- declaration de la composant pwm_final
Component pwm_final is
port	( CLK, reset_n : in std_logic;
	  FREQ, DUTY_CYCLE : in std_logic_vector (7 downto 0);
	  PWM_OUT : out std_logic);
End Component;

end composant;