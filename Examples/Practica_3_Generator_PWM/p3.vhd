library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity p3 is

port(
clk,reset : in std_logic;
entrada: in std_logic_vector(9 downto 0);
salida: out std_logic);

end;

architecture Config of p3 is
signal cnt : unsigned(9 downto 0);
constant pulso_maximo: natural := 500;
--constant pulso_maximo: natural := 9250; --Frecuency base and contador = 2 and pulso maximo/10
signal op: std_logic;
begin
   process(CLK)
	variable pulso: natural range 0 to pulso_maximo;
	begin
	if(CLK'Event and CLK='1' and pulso < (pulso_maximo/10)-1) then op<='1'; pulso :=pulso+1;
	elsif(CLK'Event and CLK='1' and pulso < pulso_maximo -1) then op<='0'; pulso :=pulso+1;
	elsif (CLK'Event and CLK='1' and pulso < pulso_maximo) then op<='1'; pulso :=0;
	end if;
	end process;
	
	contador: process(op,reset,entrada) begin
	if reset='0' then cnt <= (others => '0');
	elsif (op'Event and op='1') then 
	      if cnt=110 then cnt <=(others => '0');
	      else
	         cnt <= cnt+1;
	      end if;
		end if;
	end process;
	
	salida <= '1' when (cnt < (unsigned(not entrada))) else '0';
	
           
end Config;
