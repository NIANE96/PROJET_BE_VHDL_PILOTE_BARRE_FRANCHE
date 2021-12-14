library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_unsigned.all; 


entity avalon_anemo is 
port ( 
clk, write_n, reset_n : in std_logic; 
writedata : in std_logic_vector (31 downto 0); 
in_freq_anemo : in std_logic;
readdata : out std_logic_vector (31 downto 0); 
address: std_logic_vector (1 downto 0) 
); 
end entity; 



architecture arch_an of avalon_anemo is

    signal i_continu         : std_logic;
    signal i_start_stop      : std_logic;
    signal i_data_valid      : std_logic;
	 signal i_clk_1Hz         : std_logic;
	 signal i_ARst_N          : std_logic;
    signal i_data_anemometre : std_logic_vector(7 downto 0);

component anemometre
port(
    clk : in std_logic;
    ARst_N  : in std_logic;
    clk_1Hz : out std_logic;
    in_f_anemo : in std_logic;
    continu : in  std_logic;
    start_stop : in std_logic;
    data_valid : out std_logic;
    data_anemometre : out std_logic_vector(7 downto 0)
);
end  component;

begin
    ano : anemometre
	 port map(
	   clk=>clk, ARst_N=>i_ARst_N,
		continu=>i_continu,
		clk_1Hz=>i_clk_1Hz,
		start_stop=>i_start_stop,
		data_valid=>i_data_valid,
		data_anemometre=>i_data_anemometre,
		in_f_anemo => in_freq_anemo
	   );


-- écriture registres 

registers: process (clk, reset_n)
begin
	if reset_n = '0' then
	i_continu <= '0';
	i_start_stop <= '0';
	i_ARst_N <= '0';
	elsif clk'event and clk = '1' then
		if write_n = '0' then
			if address = "00" then
			i_ARst_N <= writedata (0);
			i_continu <= writedata (1);
			i_start_stop <= writedata (2);
			end if;
		end if;
	end if;
end process registers;
 
-- lecture registres 
--process_Read: 
--PROCESS(address, i_data_valid,i_data_anemometre)  
--BEGIN 
-- case address is 
--  when "01" =>  readdata <= X"0000"&"000" & i_data_valid & i_data_anemometre; 
--  when others => readdata <= (others => '0');    
-- end case; 
--END PROCESS process_Read ; 

readdata <= x"0000000" & "000" &i_continu when address = "00" else x"00000" & "000" & i_data_valid &i_data_anemometre;
 
end architecture;