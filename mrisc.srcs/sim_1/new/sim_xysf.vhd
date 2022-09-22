----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2022 04:03:40 PM
-- Design Name: 
-- Module Name: sim_xysf - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim_xysf is
 generic (
     pix_depth       : natural := 16;
    addr_size        : natural := 9;
     addra           : natural := 10;
    mem_size         : natural := 10;
    img_width	     : natural := 8;
    img_height 	     : natural := 20;
    subimg_width 	 : natural := 10;
    subimg_height	 : natural := 10;
    n_steps 	     : natural := 5;
    n_frames   	     : natural := 8;
    x_init             : natural:=0;
    y_init           : natural:=0;
    a_steps	         : natural:=2;
    a_frames   	     : natural:=1
    
     );
end sim_xysf;

architecture Behavioral of sim_xysf is
signal    signal_t_PM_pixel            :       std_logic_vector(pix_depth-1 downto 0);
signal    signal_t_PM_x_dest           :       std_logic_vector(img_width-1 downto 0);
signal    signal_t_PM_y_dest           :       std_logic_vector(img_height-1 downto 0);
signal    signal_t_PM_step             :       std_logic_vector(n_steps-1 downto 0);
signal    signal_t_PM_frame            :       std_logic_vector(n_frames-1 downto 0);
signal    signal_t_PM_x_orig           :       std_logic_vector(img_width-1 downto 0);
signal    signal_t_PM_y_orig           :       std_logic_vector(img_height-1 downto 0);
signal    signal_t_PM_fb               :       std_logic; -- identify if the it is a set_pixel or a set_pixel message.  
signal    signal_t_PM_req              :       std_logic:='0';
signal    signal_t_PM_ack              :       std_logic;

signal    signal_i_PM_pixel            :       std_logic_vector(pix_depth-1 downto 0);
signal    signal_i_PM_x_dest           :       std_logic_vector(img_width-1 downto 0);
signal    signal_i_PM_y_dest           :       std_logic_vector(img_height-1 downto 0);
signal    signal_i_PM_step             :       std_logic_vector(n_steps-1 downto 0);
signal    signal_i_PM_frame            :       std_logic_vector(n_frames-1 downto 0);
signal    signal_i_PM_x_orig           :       std_logic_vector(img_width-1 downto 0);
signal    signal_i_PM_y_orig           :       std_logic_vector(img_height-1 downto 0);
signal    signal_i_PM_fb               :       std_logic; -- identify if the it is a set_pixel or a set_pixel message.  
signal    signal_i_PM_req              :       std_logic;
signal    signal_i_PM_ack              :       std_logic:='0';
signal    signal_wr_pm                 :       std_logic:='0';


signal    signal_input_riscv_pixel   :       std_logic_vector(pix_depth-1 downto 0);
signal    signal_input_riscv_x_dest  :       std_logic_vector(img_width-1 downto 0);
signal    signal_input_riscv_y_dest  :       std_logic_vector(img_width-1 downto 0);
signal    signal_input_riscv_steps   :       std_logic_vector(n_steps-1 downto 0);
signal    signal_input_riscv_frames  :       std_logic_vector(n_frames-1 downto 0);
signal    signal_input_riscv_req     :       std_logic;

signal x_img : unsigned(n_steps-1 downto 0);
signal y_img : unsigned(n_steps-1 downto 0);

signal aux1:std_logic:='0';
signal aux2:std_logic:='0';
    
type proc_router is (forward, write_mode, normal_mode,handshake);  -- Define the states
type proc_riscv is (forward, write_mode, normal_mode,handshake);  -- Define the states
signal mode_router : proc_router:= forward;    -- 
signal mode_riscv  : proc_riscv:= forward;     --  

signal tileheight  : unsigned(addr_size-1 downto 0);

signal c_x      : unsigned(addr_size-1 downto 0);
signal c_y      : unsigned(addr_size-1 downto 0);

signal r_x      : unsigned(addr_size-1 downto 0);
signal r_y      : unsigned(addr_size-1 downto 0);

signal sa_f : unsigned(addr_size-1 downto 0);
signal sa_s  : unsigned(addr_size-1 downto 0);

signal su_x      : unsigned(addr_size-1 downto 0);
signal su_y      : unsigned(addr_size-1 downto 0);
signal su_f      : unsigned(addr_size-1 downto 0);
signal su_s      : unsigned(addr_size-1 downto 0);

signal xysf      : unsigned(addr_size-1 downto 0);




signal c_x_1      : unsigned(addr_size-1 downto 0);
signal c_y_1      : unsigned(addr_size-1 downto 0);

signal r_x_1      : unsigned(addr_size-1 downto 0);
signal r_y_1      : unsigned(addr_size-1 downto 0);

signal sa_f_1     : unsigned(addr_size-1 downto 0);
signal sa_s_1     : unsigned(addr_size-1 downto 0);

signal su_x_1      : unsigned(addr_size-1 downto 0);
signal su_y_1      : unsigned(addr_size-1 downto 0);
signal su_f_1      : unsigned(addr_size-1 downto 0);
signal su_s_1      : unsigned(addr_size-1 downto 0);

signal xysf_1      : unsigned(addr_size-1 downto 0);
    
signal j : unsigned(5 downto 0):= "000000";
signal i : unsigned(5 downto 0):= "000000";
begin


tileheight<=to_unsigned(img_height,addr_size);

-- constante init                                      
c_x<=to_unsigned(x_init  ,addr_size);
c_y<=to_unsigned(y_init,addr_size);

-- contante frame
sa_f<=to_unsigned(a_frames,addr_size);
sa_s<=to_unsigned(a_steps,addr_size);





----------------------------------------------------------------------------------------------------------
su_x<=resize(unsigned(signal_input_riscv_x_dest),addr_size);
su_y<=resize(unsigned(signal_input_riscv_y_dest),addr_size);

su_f<=resize(unsigned(signal_input_riscv_frames),addr_size);
su_s<=resize(unsigned(signal_input_riscv_steps),addr_size);

r_x <= resize(su_x-c_x,addr_size);
r_y <= resize(su_y-c_y,addr_size);

xysf<=resize(tileheight*sa_s*sa_f*r_x + sa_s*sa_f*r_y +sa_f*su_s + su_f,addr_size);
----------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

su_x_1<=resize(unsigned(signal_t_PM_x_dest),addr_size);
su_y_1<=resize(unsigned(signal_t_PM_y_dest),addr_size);

su_f_1<=resize(unsigned(signal_t_PM_step),addr_size);
su_s_1<=resize(unsigned(signal_t_PM_frame),addr_size);

r_x_1 <= resize(su_x_1-c_x,addr_size);
r_y_1 <= resize(su_y_1-c_y,addr_size);

xysf_1<=resize(sa_s*sa_f*(su_x_1-c_x) + tileheight*sa_s*sa_f*(su_y_1-c_y) +sa_f*su_s_1 + su_f_1,addr_size);
----------------------------------------------------------------------------------------------------------
signal_t_PM_frame<=std_logic_vector(to_unsigned(0,signal_t_PM_frame'length));
signal_t_PM_step<=std_logic_vector(to_unsigned(0,signal_t_PM_step'length));

process is 

begin
for i in 0 to 1 loop
    for j in 0 to 9 loop
    signal_input_riscv_x_dest<= std_logic_vector(to_unsigned(i,signal_input_riscv_x_dest'length));
    signal_input_riscv_y_dest<=std_logic_vector(to_unsigned(j,signal_input_riscv_y_dest'length));
wait for 100 ns;
    end loop;
end loop;
			
end process;
process is 

begin
for i in 0 to 9 loop
    for j in 0 to 9 loop
    signal_t_PM_x_dest<= std_logic_vector(to_unsigned(j,signal_t_PM_x_dest'length));
    signal_t_PM_y_dest<=std_logic_vector(to_unsigned(i,signal_t_PM_y_dest'length));
wait for 100 ns;
    end loop;
end loop;
end process;






end Behavioral;
