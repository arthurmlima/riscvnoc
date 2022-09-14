library ieee;
use ieee.std_logic_1164.all;


entity tb_out_pm_controller is
generic(
    pix_depth      : natural := 16;


    img_width	   : natural := 8;
    img_height 	   : natural := 8;
    subimg_width 	:natural := 20;
    subimg_height	:natural := 20;
    n_steps 	   : natural := 5;
    n_frames   	   : natural := 8;
    x_init          : integer := 0;
    y_init          : integer := 0

);
end tb_out_pm_controller;

architecture tb of tb_out_PM_controller is
signal clk                :  std_logic:='0';                                                           
signal reset                :  std_logic;                                                                                         
signal oc_PM_pixel        :std_logic_vector(pix_depth-1 downto 0);                  
signal oc_PM_x_dest       :std_logic_vector(img_width-1 downto 0);                  
signal oc_PM_y_dest       :std_logic_vector(img_height-1 downto 0);                 
signal oc_PM_step         :std_logic_vector(n_steps-1 downto 0);                    
signal oc_PM_frame        :std_logic_vector(n_frames-1 downto 0);                   
signal oc_PM_x_orig       :std_logic_vector(img_width-1 downto 0);                  
signal oc_PM_y_orig       :std_logic_vector(img_height-1 downto 0);                 
signal oc_PM_fb           :std_logic; -- message forward/backward                   
signal oc_PM_new_msg      :std_logic:='0';                                               
signal oc_PM_ack        :  std_logic:='0';                                                                                                                                                                                         
signal i_PM_pixel      : std_logic_vector(pix_depth-1 downto 0);                  
signal i_PM_x_dest     : std_logic_vector(img_width-1 downto 0);                  
signal i_PM_y_dest     : std_logic_vector(img_height-1 downto 0);                 
signal i_PM_step       : std_logic_vector(n_steps-1 downto 0);                    
signal i_PM_frame      : std_logic_vector(n_frames-1 downto 0);                   
signal i_PM_x_orig     : std_logic_vector(img_width-1 downto 0);                  
signal i_PM_y_orig     : std_logic_vector(img_height-1 downto 0);                 
signal i_PM_fb         : std_logic; -- message forward/backward                   
signal i_PM_req        :  std_logic:='0';                                             
signal i_PM_ack        : std_logic:='0';                                            
signal input_deadlockPM        : std_logic;                                            
signal oc_free        : std_logic;                                            

begin
    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.out_pm_controller 
    generic map
    (
     pix_depth     =>  pix_depth      ,
     img_width	   =>  img_width	    ,
     img_height    =>  img_height 	,
     n_steps 	   =>  n_steps 	    ,
     n_frames      =>  n_frames   	
    )
    port map(
 input_deadlockPM=>input_deadlockPM,
 oc_free=>oc_free,   
clk            => clk            ,
reset          => reset          ,
oc_PM_pixel    => oc_PM_pixel    ,
oc_PM_x_dest   => oc_PM_x_dest   ,
oc_PM_y_dest   => oc_PM_y_dest   ,
oc_PM_step     => oc_PM_step     ,
oc_PM_frame    => oc_PM_frame    ,
oc_PM_x_orig   => oc_PM_x_orig   ,
oc_PM_y_orig   => oc_PM_y_orig   ,
oc_PM_fb       => oc_PM_fb       ,
oc_PM_new_msg  => oc_PM_new_msg  ,
oc_PM_ack      => oc_PM_ack      ,
i_PM_pixel     => i_PM_pixel     ,
i_PM_x_dest    => i_PM_x_dest    ,
i_PM_y_dest    => i_PM_y_dest    ,
i_PM_step      => i_PM_step      ,
i_PM_frame     => i_PM_frame     ,
i_PM_x_orig    => i_PM_x_orig    ,
i_PM_y_orig    => i_PM_y_orig    ,
i_PM_fb        => i_PM_fb        ,
i_PM_req       => i_PM_req       ,
i_PM_ack       => i_PM_ack       

    );

process 
begin
clk <= not(clk);
wait for 10 ns;
end process;


process 
begin 

wait for 100 ns;


oc_PM_new_msg<='1';
wait until (oc_PM_ack='1' and rising_edge(clk)) ;
oc_PM_new_msg<='0';

wait until (oc_PM_ack='0' and rising_edge(clk)) ;


oc_PM_new_msg<='1';
wait until (oc_PM_ack='1' and rising_edge(clk)) ;
oc_PM_new_msg<='0';

wait until (oc_PM_ack='0' and rising_edge(clk)) ;

oc_PM_new_msg<='1';
wait until (oc_PM_ack='1' and rising_edge(clk)) ;
oc_PM_new_msg<='0';

wait until (oc_PM_ack='0' and rising_edge(clk)) ;

oc_PM_new_msg<='1';
wait until (oc_PM_ack='1' and rising_edge(clk)) ;
oc_PM_new_msg<='0';

wait until (oc_PM_ack='0' and rising_edge(clk)) ;



end process;


process 
begin 
wait for 120 ns;

wait until (i_PM_req='1' and rising_edge(clk)) ;
i_PM_ack<='1';
wait until (i_PM_req='0' and rising_edge(clk)) ;
i_PM_ack<='0';

wait until (i_PM_req='1' and rising_edge(clk)) ;
i_PM_ack<='1';
wait until (i_PM_req='0' and rising_edge(clk)) ;
i_PM_ack<='0';


wait until (i_PM_req='1' and rising_edge(clk)) ;
i_PM_ack<='1';
wait until (i_PM_req='0' and rising_edge(clk)) ;
i_PM_ack<='0';


wait until (i_PM_req='1' and rising_edge(clk)) ;
i_PM_ack<='1';
wait until (i_PM_req='0' and rising_edge(clk)) ;
i_PM_ack<='0';



end process;

 
end tb ;
