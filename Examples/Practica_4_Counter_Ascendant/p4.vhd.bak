library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity p2 is

port(
CLK,reset : in std_logic;
Out_1: out std_logic);

end;

architecture Config of p2 is
constant pulso_maximo: natural := 9250; --Frecuency base and contador = 2 and pulso maximo/10
--constant pulso_maximo: natural := 10000;
signal op: std_logic;
signal temporal: std_logic;
signal contador: std_logic_vector(9 downto 0);


begin
   process(CLK) --Timer 
	variable pulso: natural range 0 to pulso_maximo;
	begin                               
	if(CLK'Event and CLK='1' and pulso < (pulso_maximo/10)-1) then op <='1'; pulso :=pulso+1;--Init of the timer 0 to 24,999,999 ticks Out=ON
	elsif(CLK'Event and CLK='1' and pulso < pulso_maximo -1) then op<='0'; pulso :=pulso+1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
	elsif (CLK'Event and CLK='1' and pulso < pulso_maximo) then op<='1'; pulso :=0;         --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
	end if;
	end process;
	
	divisor_frecuencia:process(reset,op)begin
	if (reset= '0') then temporal <= '0'; contador <= "0000000000";
	elsif (op'event and op='1') then 
	  if (contador=2) then temporal<= not(temporal); contador<="0000000000";
	  else
	     contador <= std_logic_vector(contador+1);
	  end if;
	end if;
	end process;
	out_1<= temporal;
end Config;
