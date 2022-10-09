
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p13 IS

	PORT (
		clk, RESET, STOP, DIR : IN STD_LOGIC;
		X,Y : in STD_LOGIC_vector(3 downto 0);
		Z : OUT STD_LOGIC_vector(3 downto 0)
		); 

END;

ARCHITECTURE Config OF p13 IS        
	CONSTANT pulso_maximo : NATURAL := 25000000*2;  
	SIGNAL op : STD_LOGIC;
	
   signal contador: std_logic_vector(3 downto 0); --Counter of 3bit 0-7 = 8 positions
	
BEGIN
	PROCESS (CLK) --Timer 
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo/2) - 1) THEN
			op <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo - 1) THEN
			op <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo) THEN
			op <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	


	process(op,reset,stop) --Counter
	begin
	if reset='0' then contador <=(others => '0'); else 
	if stop='1' then contador <= contador; 
	elsif op'event and op='1' then 
	if dir='1' then contador <= std_logic_vector(contador+1);
	else contador <= std_logic_vector(contador-1);
	end if;
	end if;
	end if;
	end process;
	
	with contador select
	 
	 Z <=       not(X)+not(Y)when "0000", -- 0
				   not(X)-not(Y) when "0001", -- 1
				   not(X)-4 when "0010", -- 2
				   not(X)-1 when "0011", -- 3
				   not(Y)-1 when "0100", -- 4
				   not(X)+1 when "0101", -- 5
				   not(Y)+1 when "0110", -- 6
				   not(X)-2 when "0111", -- 7
				   not(Y)-2 when "1000", -- 8
				   not(X)+2 when "1001", -- 9
				   not(Y)+2 when "1010", -- 10
				   not(X)-3 when "1011", -- 11
				   not(Y)-3 when "1100", -- 12
				   not(X)+3 when "1101", -- 13
				   not(Y)+3 when "1110", -- 14
				   not(X)+4 when "1111"; -- 15
	 
				  
				  

	END Config;