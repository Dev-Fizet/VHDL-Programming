LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY car IS

	PORT (
		clk, RESET: in STD_LOGIC;-- 
		Leds : out STD_LOGIC_VECTOR(2 downto 0);
		sensor_line_left,sensor_line_mid,sensor_line_right ,sensor_obstacle,sensor_obstacle_left,sensor_obstacle_right: in STD_LOGIC; --Sensor
		Motor_EN_A,Motor_EN_B,op_test: out STD_LOGIC;
		Init_Motor_A,Init_Motor_B :out STD_LOGIC_VECTOR(1 downto 0)); --Salida

END;

ARCHITECTURE Config OF car IS
	CONSTANT pulso_maximo : NATURAL := 2500000*8;  -- Timer principal
	--CONSTANT pulso_maximo : NATURAL := 1;  -- Timer 1s = 1 Hz
	SIGNAL op : STD_LOGIC;
	TYPE state_type IS (UNO, DOS, TRES,TRES_1,Move_Car_Left,Move_Car_Right,CUATRO,Follow_Line_Init,Follow_Line_Dir_Left,Follow_Line_Dir_Right); --States
	SIGNAL estado, estado_siguiente : state_type;
	
	signal cnt : unsigned(9 downto 0);
	signal control_pwm : integer;
	SIGNAL out_control_pwm : STD_LOGIC;
	

constant pulso_maximo_pwm: natural := 500*2; --450 Hz

CONSTANT pulso_maximo_timer : NATURAL := 25000*2;  -- Timer 1 ms = 1000 Hz
	SIGNAL op_timer : STD_LOGIC;
	signal contador_timer: std_logic_vector(9 downto 0);
SIGNAL reset_soft : STD_LOGIC;
SIGNAL init_car_follow_line : STD_LOGIC;
 signal op_pwm: std_logic;
 
BEGIN

PROCESS (CLK) --Timer Time
		VARIABLE pulso : NATURAL RANGE 0 TO pulso_maximo_timer;
	BEGIN
		IF (CLK'Event AND CLK = '1' AND pulso < (pulso_maximo_timer/2) - 1) THEN
			op_timer <= '1';
			pulso := pulso + 1;--Init of the timer 0 to 24,999,999 ticks Out=ON
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo_timer - 1) THEN
			op_timer <= '0';
			pulso := pulso + 1; --Init of the timer 25,000,000 to 49,999,999 tick Out= OFF
		ELSIF (CLK'Event AND CLK = '1' AND pulso < pulso_maximo_timer) THEN
			op_timer <= '1';
			pulso := 0; --Init of reset timer in 50,000,000 ticks Out= ON and reset count of pulso
		END IF;
	END PROCESS;
	
	process(op_timer,reset_soft,contador_timer)
	begin
	if reset_soft='0' then contador_timer <=(others => '0');
	elsif op_timer'event and op_timer='1' then contador_timer <=  std_logic_vector(contador_timer+1); 
	else 
	end if;
	end process;

	op_test <= op_timer;
 

process(clk) --Timer PWM
	variable pulso: natural range 0 to pulso_maximo_pwm;
	begin
	if(CLK'Event and CLK='1' and pulso < (pulso_maximo_pwm/10)-1) then op_pwm<='1'; pulso :=pulso+1;
	elsif(CLK'Event and CLK='1' and pulso < pulso_maximo_pwm -1) then op_pwm<='0'; pulso :=pulso+1;
	elsif (CLK'Event and CLK='1' and pulso < pulso_maximo_pwm) then op_pwm<='1'; pulso :=0;
	end if;
	end process;
	
	contador: process(op_pwm,reset) begin
	if reset='0' then cnt <= (others => '0');
	elsif (op_pwm'Event and op_pwm='1') then 
	      if cnt=110 then cnt <=(others => '0');
	      else
	         cnt <= cnt+1;
	      end if;
		end if;
	end process;
	
	out_control_pwm <= '1' when (cnt < (control_pwm)) else '0';


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
  
	arranque_motor:process(op,reset,init_car_follow_line)
	begin
	
	   if reset='0' then estado <= UNO; init_car_follow_line<='0';
		elsif op='1' and op'event then estado <= estado_siguiente;
		end if;
		
	end process arranque_motor;		

   estados_motor:process(estado,sensor_obstacle,sensor_line_left,sensor_line_mid,sensor_line_right,contador_timer,clk)
	begin
	case estado is      --The sensor mid are LOW when are detecting an obstacle
	                    -- The sensor are HIGH when are detecting the line
							  --This State its for check if there are a objet or there are a line 
							  --If there are an obstacle the sensor change of LOW and the state change at de stato DOS
	     when UNO => --if sensor_obstacle='1' then 
--		              estado_siguiente <=UNO; 
--		             
--						  else estado_siguiente <= DOS; 
						  if (sensor_line_left='0' and sensor_line_mid= '1' and sensor_line_right ='0') then 
						  estado_siguiente <=Follow_Line_Init;
 						  end if;
--						  end if;
		  when DOS => --This State  move the car in reverse for one little moment and after the change to other case
		              if sensor_obstacle='0' then estado_siguiente <=DOS; 
		              else estado_siguiente <= TRES; 
			           end if;
			             
		              --This State check the direction for Turn the car in function at the sensor 
				        --The sensor of obstacle left and right are config for detec all the time with state HIGH and when not detect Change de value to LOW
				        --We made this for robot antiobstacle		  
	     when TRES =>    if sensor_obstacle_left='1' and sensor_obstacle_right='0' then estado_siguiente <= Move_Car_Left;
		               elsif sensor_obstacle_left='0' and sensor_obstacle_right='1' then estado_siguiente <= Move_Car_Right;
							elsif sensor_obstacle_left='0' and sensor_obstacle_right='0' then estado_siguiente <= UNO;
							elsif sensor_obstacle_left='1' and sensor_obstacle_right='1' then estado_siguiente <= UNO;
		               end if;
							
		 when TRES_1 => estado_siguiente <=TRES; 
		               if sensor_obstacle='1' then estado_siguiente <= CUATRO;
		               end if;					
						
			when Move_Car_Left => estado_siguiente <=Move_Car_Left; 
		               if sensor_obstacle='1' then estado_siguiente <= UNO;
		               end if;	
							
         when Move_Car_Right => estado_siguiente <=Move_Car_Right; 
		               if sensor_obstacle='1' then estado_siguiente <= UNO;
		               end if;	
							
	      when CUATRO =>estado_siguiente <=UNO;reset_soft<='0';
			                         --Sensor Line are in HIGH when detect a line
			when Follow_Line_Init => estado_siguiente <=Follow_Line_Init;
			                         
--			                         if sensor_line_left='0' and sensor_line_right='0' then
--			                         estado_siguiente <= Follow_Line_Init;
--											 elsif sensor_line_left='1' and sensor_line_right='0' then 
--											 estado_siguiente <= Follow_Line_Dir_Right;
--											 elsif sensor_line_right='1' and sensor_line_left='0'  then
--											 estado_siguiente <= Follow_Line_Dir_Left;
--											 end if;
						  	
			when Follow_Line_Dir_Left => estado_siguiente <=Follow_Line_Dir_Left;
	                                   if sensor_obstacle='1'
											     then estado_siguiente <= Follow_Line_Init;
												  end if;
         when Follow_Line_Dir_Right =>estado_siguiente <=Follow_Line_Dir_Right;
	                                   if sensor_obstacle='1'
											     then estado_siguiente <= Follow_Line_Init;
												  end if;		
			
	end case;
end process estados_motor;
 
salida:process(estado)
      begin
		-- ¡¡Note!!  The bottons are normal HIGH and when is pressed change to LOW
		case estado is      --100 faster 50 low
		                    --This State it's for Drive Normal 
		    when UNO    =>  Motor_EN_A <=out_control_pwm; Init_Motor_A<= "01";
								  Motor_EN_B <=out_control_pwm; Init_Motor_B<= "01";
								  leds<="010";
								  control_pwm<=35;
								
								  -- This State it's for Drive en Reverse
			 when DOS    =>  Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								  Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
			                 leds<="101";
								  control_pwm<=35;
						        
								  --This State it's for check the direction to turn the car and the car stay in stop mode
			 when TRES   =>  Motor_EN_A <=out_control_pwm; Init_Motor_A<= "11";
								  Motor_EN_B <=out_control_pwm; Init_Motor_B<= "11";
								  control_pwm<=0;
			                 leds<="000";
								  
								  --This State it's for move the wheels at right direction
			 when TRES_1   =>  Motor_EN_A <=out_control_pwm; Init_Motor_A<= "11";
								  Motor_EN_B <=out_control_pwm; Init_Motor_B<= "11";
								  control_pwm<=100;
			                 leds<="000";	
				
         when Move_Car_Left =>Motor_EN_A <=out_control_pwm; Init_Motor_A<= "01";
								      Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
								    control_pwm<=58;
			                    leds<="110";	
							
         when Move_Car_Right => Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								        Motor_EN_B <=out_control_pwm; Init_Motor_B<= "01";
								        control_pwm<=58;
			                       leds<="011";	
									
								  
							  
								  
			 when CUATRO   =>leds<="101";	 control_pwm<=35;
                          Motor_EN_A <=out_control_pwm; Init_Motor_A<= "01";
								  Motor_EN_B <=out_control_pwm; Init_Motor_B<= "01"; 			 
								  
		                           --Part of Follow Line		
					                  						
          when Follow_Line_Init   =>leds<="101";	 init_car_follow_line<='1'; 
			                           if sensor_line_left='0' and sensor_line_right='0' then
			                           control_pwm<=25;	
			                           Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								            Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
												
												elsif sensor_line_left='1'  and sensor_line_right='0'then
												 control_pwm<=40;	
			                           Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								            Motor_EN_B <=out_control_pwm; Init_Motor_B<= "01";
												
												elsif  sensor_line_right='1' and sensor_line_left='0' then
												control_pwm<=40;	
			                           Motor_EN_A <=out_control_pwm; Init_Motor_A<= "01";
								            Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
												
												elsif sensor_line_left='1' and sensor_line_right='1' then
												control_pwm<=25;	
			                           Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								            Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
												
												else 
												control_pwm<=25;	
			                           Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								            Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
												end if;

          when Follow_Line_Dir_Left   =>leds<="011";	 control_pwm<=40;	
												    Motor_EN_A <=out_control_pwm; Init_Motor_A<= "01";
								                Motor_EN_B <=out_control_pwm; Init_Motor_B<= "10";
          when Follow_Line_Dir_Right   =>leds<="110";	 control_pwm<=40;		
	                                     
											       Motor_EN_A <=out_control_pwm; Init_Motor_A<= "10";
								                Motor_EN_B <=out_control_pwm; Init_Motor_B<= "01";		 
								  
		end case;
end process salida;


 
END Config;