LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p6 IS

	PORT (
		clk, RESET, STOP, DIR : IN STD_LOGIC;
		DATO_MOTOR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); --Salida

END;

ARCHITECTURE Config OF p6 IS
	CONSTANT pulso_maximo : NATURAL := 250000;  -- Timer 1s = 1 Hz
	SIGNAL op : STD_LOGIC;
	TYPE state_type IS (UNO, DOS, TRES, CUATRO);
	SIGNAL estado, estado_siguiente : state_type;
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
   
	arranque_motor:process(op,reset)
	begin
	   if reset='0' then estado <= UNO;
		elsif op='1' and op'event then estado <= estado_siguiente;
		end if;
	end process arranque_motor;		

   estados_motor:process(estado,DIR,STOP)
	begin
	case estado is
	     when UNO => if STOP='0' then estado_siguiente <=UNO;
		              elsif DIR='1' then estado_siguiente <= DOS;
						  else estado_siguiente <= CUATRO;
						  end if;
		  when DOS => if STOP='0' then estado_siguiente <=DOS;
		              elsif DIR='1' then estado_siguiente <= TRES;
						  else estado_siguiente <= UNO;
						  end if;			  
	     when TRES => if STOP='0' then estado_siguiente <=TRES;
		              elsif DIR='1' then estado_siguiente <= CUATRO;
						  else estado_siguiente <= DOS;
						  end if;			  
	     when CUATRO => if STOP='0' then estado_siguiente <=CUATRO;
		              elsif DIR='1' then estado_siguiente <= UNO;
						  else estado_siguiente <= TRES;
						  end if;			  
	end case;
end process estados_motor;

salida:process(estado)
      begin
		case estado is 
		    when UNO =>    DATO_MOTOR<="1000";
			 when DOS =>    DATO_MOTOR<="0100";
			 when TRES =>   DATO_MOTOR<="0010";
			 when CUATRO => DATO_MOTOR<="0001";
		end case;
end process salida;

END Config;