LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p10 IS

	PORT (
		clk, RESET, STOP, DIR : IN STD_LOGIC;
		Display : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--Salida
		Act_Display : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); --Salida

END;

ARCHITECTURE Config OF p10 IS
	CONSTANT pulso_maximo : NATURAL := 2*25000000;  -- Timer 1s = 1 Hz
	SIGNAL op : STD_LOGIC;

	signal contador: std_logic_vector(3 downto 0); --Counter of 4bit 0-15 = 16 positions
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
  
	process(op,reset,stop)
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
	
	Act_Display<="0001";
	 with contador select
	 
	 Display <=      "01100011" when "0000", --00- C
						  "00010001" when "0001", --01- A
				        "11110101" when "0010", --02- R
						  "11110011" when "0011", --03- L
						  "00000011" when "0100", --04- O
				        "01001001" when "0101", --05- S
					 not "00000010" when "0110", --06- -
						  "01110001" when "0111", --07- F
						  "11011111" when "1000", --08- I
						  "00001001" when "1001", --09- G
				        "10111001" when "1010", --10- U
						  "01100001" when "1011", --11- E
						  "11110101" when "1100", --12- R
				        "00000011" when "1101", --13- O
						  "00010001" when "1110", --14- A
						  "00100101" when "1111"; --15- Z
	
	END Config;