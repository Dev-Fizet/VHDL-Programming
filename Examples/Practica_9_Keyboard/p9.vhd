library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity p1 is

port(
CLK,RST : in std_logic;
D: in std_logic_vector(9 downto 0);
Q: out std_logic_vector(9 downto 0));

end;

architecture Config of p1 is
constant pulso_maximo: natural := 50000000; --Frecuency of Clock FPGA Cyclone II 50Mhz
signal op: std_logic;
begin
   process(CLK) --Timer 
	variable pulso: natural range 0 to pulso_maximo;
	begin                                --24,999,999 
	if(CLK'Event and CLK='1' and pulso < (pulso_maximo/2)-1) then op <='1'; pulso :=pulso+1;--Init of the timer 0 to 24,999,999 ticks Out=ON
	elsif(CLK'Event and CLK='1' and pulso < pulso_maximo -1) then op<='0'; pulso :=pulso+1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
	elsif (CLK'Event and CLK='1' and pulso < pulso_maximo) then op<='1'; pulso :=0;         --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
	end if;
	end process;
	
	process(D)
	begin
	if RST='0' then Q <="0000000000"; --The bottons that we use are conected in Pull Up ,HIGH when is not pressed and LOW when in pressed for that we change the reset for 0 or LOW.
	elsif op'event and op='1' then Q<=D; end if; --The detecction of D only work when the are Op= 1 that is manage for the timer
	end process;
           
end Config;
