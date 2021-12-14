Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;

Library work;
Use work.composant.all;

Entity pwm_final is

port	( CLK, reset_n 	   : in std_logic;
          FREQ, DUTY_CYCLE : in std_logic_vector (7 downto 0);
	  PWM_OUT	   : out std_logic);
End pwm_final;

Architecture arch_pwm_final of pwm_final is
Signal sig_cpt   : std_logic_vector (7 downto 0);
Signal sig_reset : std_logic;
Signal sig_pwm   : std_logic;

-- declaration de la composant compteur_n
component compteur_n 
generic( modulo : integer := 255); -- N=8 bits nombre de bits 2^8=255

port( CLK, reset_n, reset : in std_logic;
	  Q s             : out std_logic_vector (7 downto 0));
end component ;
----end component compteur_n---

-- declaration de la composant comparateur_freq
component comparateur_freq
port	( CLK, reset_n       : in std_logic;
	  e_compteur_n, FREQ : in std_logic_vector (7 downto 0);
	  Q	             : out std_logic);
end component;
-- end de la composant comparateur_freq

-- declaration de la composant comparateur_duty
component comparateur_duty
port	( CLK , reset_n 	   : in std_logic;
	  e_compteur_n, DUTY_CYCLE : in std_logic_vector (7 downto 0);
	  Q	                   : out std_logic);
end component;
-- end de la composant comparateur_duty

Begin
compteur : compteur_n
port map(CLK=>CLK, reset_n=>reset_n, reset=>sig_reset, Q=>sig_cpt );

cmp_freq : comparateur_freq
port map(CLK=>CLK, reset_n=>reset_n, e_compteur_n=>sig_cpt, FREQ=>FREQ, Q=>sig_reset);

comparateur_cpt_duty : comparateur_duty
port map(CLK=>CLK, reset_n=>reset_n, e_compteur_n=>sig_cpt, DUTY_CYCLE=>DUTY_CYCLE, Q=>sig_pwm);

PWM_OUT <=  sig_pwm;
End arch_pwm_final;