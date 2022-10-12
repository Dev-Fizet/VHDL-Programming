LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY p6 IS

	PORT (
		clk, RESET, STOP, DIR : in STD_LOGIC;
		Entradas : in STD_LOGIC_VECTOR(8 DOWNTO 0); --Salida
		Salidas: out STD_LOGIC_VECTOR(5 DOWNTO 0)); --Salida

END;

ARCHITECTURE Config OF p6 IS
	CONSTANT pulso_maximo : NATURAL := 25000000;  -- Timer 1s = 1 Hz
	SIGNAL op : STD_LOGIC;
	TYPE state_type IS (UNO, DOS, TRES);
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
	     when UNO => if STOP='1' then estado_siguiente <=UNO;    -- State Actual
		              elsif DIR='1' then estado_siguiente <= DOS; -- Next State
						  else estado_siguiente <= TRES;              -- Last State
 						  end if;
		  when DOS => if STOP='1' then estado_siguiente <=DOS;    -- State Actual
		              elsif DIR='1' then estado_siguiente <= TRES;-- Next State
						  else estado_siguiente <= UNO;               -- Last State
						  end if;			  
	     when TRES => if STOP='1' then estado_siguiente <=TRES;  -- State Actual
		              elsif DIR='1' then estado_siguiente <= UNO; -- Next State
						  else estado_siguiente <= DOS;               -- Last State
						  end if;			  
	     
	end case;
end process estados_motor;

salida:process(estado)
      begin
		-- ¡¡Note!!  The bottons are normal HIGH and when is pressed change to LOW
		case estado is      --State 1 => 2 NOR of 4 in 
		    when UNO    =>  Salidas(0)<=(not Entradas(3) and not Entradas(2) and not Entradas(1) and not Entradas(0));
			                 Salidas(1)<=(not Entradas(7) and not Entradas(6) and not Entradas(5) and not Entradas(4));
								  --State 2 => 3 NAND of 3 in
			 when DOS    =>  Salidas(0)<= ( Entradas(2) or  Entradas(1) or  Entradas(0));
								  Salidas(1)<= ( Entradas(5) or  Entradas(4) or  Entradas(3));
								  Salidas(2)<= ( Entradas(8) or  Entradas(7) or  Entradas(6));
			                 --State 3 => 6 NOT 
			 when TRES   =>  Salidas(0)<= Entradas(0);
			                 Salidas(1)<= Entradas(1);
								  Salidas(2)<= Entradas(2);
								  Salidas(3)<= Entradas(3);
								  Salidas(4)<= Entradas(4);
								  Salidas(5)<= Entradas(5);
		end case;
end process salida;

END Config;