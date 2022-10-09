
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p12 IS

	PORT (
		clk, RESET, STOP, DIR : IN STD_LOGIC;
		LED : OUT STD_LOGIC_vector(6 downto 0)
		); 

END;

ARCHITECTURE Config OF p12 IS        
	CONSTANT pulso_maximo : NATURAL := 25000000*2;  
	SIGNAL op : STD_LOGIC;
	
	CONSTANT pulso_maximo1 : NATURAL := 10000000;  -- Timer 5 Hz
	SIGNAL op1 : STD_LOGIC;
	
	
   signal contador: std_logic_vector(2 downto 0); --Counter of 3bit 0-7 = 8 positions
	
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
  
	

	PROCESS (CLK) --Timer 2
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo1;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo1/2) - 1) THEN
			op1 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo1 - 1) THEN
			op1 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo1) THEN
			op1 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	
	
	

	
	process(op,reset,stop) --Counter 
	begin
	if stop='0' then contador <= contador; else 
	if reset='0' then contador <=(others => '0');
	elsif op'event and op='1' then 
	if dir='1' then contador <= std_logic_vector(contador+1);
	else contador <= std_logic_vector(contador-1);
	end if;
	end if;
	end if;
	end process;
	
	
	  LED(6) <= op1 when contador="110" else '0';  
	  LED(5) <= op1 when contador="101" else '0';                            
	  LED(4) <= op1 when contador="100" else '0'; 
	  LED(3) <= op1 when contador="011" else '0'; 
	  LED(2) <= op1 when contador="010" else '0';                           
	  LED(1) <= op1 when contador="001" else '0';  
	  LED(0) <= op1 when contador="000" else '0'; 
				  
				  

	END Config;