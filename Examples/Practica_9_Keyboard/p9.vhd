library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity p9 is

port(
botones: in std_logic_vector(6 downto 0);
led: out std_logic_vector(2 downto 0));
end;

architecture Config of p9 is
begin

 with botones select
	 led <= "000" when not"0000000", --0
	        "001" when not"0000001", --1
			  "010" when not"0000010", --2
	        "011" when not"0000100", --3
			  "100" when not"0001000", --4
	        "101" when not"0010000", --5
			  "110" when not"0100000", --6
	        "111" when not"1000000",
			  "000" when others; --7
           
end Config;
