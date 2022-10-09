
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p11 IS

	PORT (
		clk, RESET, STOP, DIR : IN STD_LOGIC;
		LED : OUT STD_LOGIC
		); 

END;

ARCHITECTURE Config OF p11 IS
	CONSTANT pulso_maximo : NATURAL := 2*25000000;  -- Timer 2s = 0.5 Hz
	SIGNAL op : STD_LOGIC;
	
	CONSTANT pulso_maximo1 : NATURAL := 31888*2;  -- Timer  783.991 Hz -G
	SIGNAL op1 : STD_LOGIC;
	
	CONSTANT pulso_maximo2 : NATURAL := 35793*2;  -- Timer  698.456 Hz -F
	SIGNAL op2 : STD_LOGIC;
	
	CONSTANT pulso_maximo3 : NATURAL := 37923*2;  -- Timer  659.225 Hz -E
	SIGNAL op3 : STD_LOGIC;
	
	CONSTANT pulso_maximo4 : NATURAL := 42566*2;  -- Timer  587.33 Hz -D
	SIGNAL op4 : STD_LOGIC;
	
	CONSTANT pulso_maximo5 : NATURAL := 47778*2;  -- Timer  523.251 Hz -C
	SIGNAL op5 : STD_LOGIC;
	
	CONSTANT pulso_maximo6 : NATURAL := 50619*2;  -- Timer  493.883 Hz -B
	SIGNAL op6 : STD_LOGIC;
	
	CONSTANT pulso_maximo7 : NATURAL := 56818*2;  -- Timer  440 Hz -A
	SIGNAL op7 : STD_LOGIC;

	
	
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
  
	
	
	
	PROCESS (CLK) --Timer G
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
  
	
	
	
	
	
	PROCESS (CLK) --Timer F
	
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo2;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo2/2) - 1) THEN
			op2 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo2 - 1) THEN
			op2 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo2) THEN
			op2 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	
	
	
	
	PROCESS (CLK) --Timer E
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo3;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo3/2) - 1) THEN
			op3 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo3 - 1) THEN
			op3 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo3) THEN
			op3 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	
	
	
	PROCESS (CLK) --Timer D
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo4;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo4/2) - 1) THEN
			op4 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo4 - 1) THEN
			op4 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo4) THEN
			op4 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	
	
	
	
	
	PROCESS (CLK) --Timer C
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo5;
		
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo5/2) - 1) THEN
			op5 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo5 - 1) THEN
			op5 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo5) THEN
			op5 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
  
	
	
	PROCESS (CLK) --Timer B
	VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo6;
    BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo6/2) - 1) THEN
			op6 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo6 - 1) THEN
			op6 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo6) THEN
			op6 <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
	
	
   PROCESS (CLK) --Timer A
	VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo7;
    BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo7/2) - 1) THEN
			op7 <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo7 - 1) THEN
			op7 <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo7) THEN
			op7 <= '1';
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
	
	with contador select
	 
	 Led <=   '0' when "000", -- Silent
				  op1 when "001", -- G
				  op2 when "010", -- F
				  op3 when "011", -- E
				  op4 when "100", -- D
				  op5 when "101", -- C
				  op6 when "110", -- B
				  op7 when "111"; -- A

	END Config;