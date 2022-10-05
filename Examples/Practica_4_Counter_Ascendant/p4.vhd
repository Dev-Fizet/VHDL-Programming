library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity p4 is

port(
clk,reset_n : in std_logic;
s: out std_logic_vector(9 downto 0)); --Salida

end;

architecture Config of p4 is
signal contador: std_logic_vector(9 downto 0);
constant pulso_maximo: natural := 1785714;
--constant pulso_maximo: natural := 10000;
signal op: std_logic;

begin
   process(CLK) --Timer 
	variable pulso: natural range 0 to pulso_maximo;
	begin                               
	if(CLK'Event and CLK='1' and pulso < (pulso_maximo/2)-1) then op <='1'; pulso :=pulso+1;--Init of the timer 0 to 24,999,999 ticks Out=ON
	elsif(CLK'Event and CLK='1' and pulso < pulso_maximo -1) then op<='0'; pulso :=pulso+1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
	elsif (CLK'Event and CLK='1' and pulso < pulso_maximo) then op<='1'; pulso :=0;         --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
	end if;
	end process;
	
	process(op,reset_n)
	begin
	if reset_n='0' then contador <=(others => '0');
	elsif op'event and op='1' then contador <= std_logic_vector(contador+1);
	end if;
	end process;
	
	s<= contador;

end Config;
