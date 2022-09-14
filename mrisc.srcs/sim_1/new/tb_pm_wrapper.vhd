library ieee;
use ieee.std_logic_1164.all;


entity tb_pm_wrapper is
generic(
    pix_depth      : natural := 16;
    addr_size      : natural := 9;
    mem_size       : natural := 10;
    img_width	   : natural := 8;
    img_height 	   : natural := 8;
    subimg_width 	:natural := 20;
    subimg_height	:natural := 20;
    n_steps 	   : natural := 5;
    n_frames   	   : natural := 8;
    x_init        :natural:=0;
    y_init        :natural:=0
    
    
);
end tb_pm_wrapper;

architecture tb of tb_pm_wrapper is
signal clk                      :    std_logic := '0';

signal input_req_in                :    std_logic:='0';
signal input_ack_in                :    std_logic:='0';                                  

signal input_ack                :    std_logic:='0';
signal input_req                :    std_logic:='0';

signal output_req_out               :    std_logic:='0';
signal output_ack_out               :    std_logic:='0';

signal reset                    :    std_logic:='0';
signal input_data               :    std_logic_vector(63   downto 0):=(others => '0');

signal input_riscv_data         :    std_logic_vector(63   downto 0):=(others => '0');
signal input_riscv_ack          :    std_logic:='0';
signal output_data              :    std_logic_vector(63   downto 0):=(others => '0');


signal oc_PM_pixel_in        : std_logic_vector(pix_depth-1 downto 0);                   
signal oc_PM_x_dest_in     : std_logic_vector(img_width-1 downto 0);                   
signal oc_PM_y_dest_in     : std_logic_vector(img_height-1 downto 0);                  
signal oc_PM_step_in         : std_logic_vector(n_steps-1 downto 0);                     
signal oc_PM_frame_in        : std_logic_vector(n_frames-1 downto 0);                    
signal oc_PM_x_orig_in     : std_logic_vector(img_width-1 downto 0);                   
signal oc_PM_y_orig_in     : std_logic_vector(img_height-1 downto 0);                  
signal oc_PM_fb_in     : std_logic; -- message forward/backward                    
signal oc_PM_new_msg_in     : std_logic:='0';                                           
signal oc_PM_ack_in     : std_logic:='0';                                                                                   
signal i_PM_pixel_in    :  std_logic_vector(pix_depth-1 downto 0);                   
signal i_PM_x_dest_in    :  std_logic_vector(img_width-1 downto 0);                   
signal i_PM_y_dest_in    :  std_logic_vector(img_height-1 downto 0);                  
signal i_PM_step_in    :  std_logic_vector(n_steps-1 downto 0);                     
signal i_PM_frame_in    :  std_logic_vector(n_frames-1 downto 0);                    
signal i_PM_x_orig_in    :  std_logic_vector(img_width-1 downto 0);                   
signal i_PM_y_orig_in    :  std_logic_vector(img_height-1 downto 0);                  
signal i_PM_fb_in    :  std_logic; -- message forward/backward                    
signal i_PM_req_in    :  std_logic:='0';                                         
signal i_PM_ack_in    :  std_logic:='0' ;                                           


signal oc_PM_pixel_out                    :           std_logic_vector(pix_depth-1 downto 0);                   
signal oc_PM_x_dest_out                   :           std_logic_vector(img_width-1 downto 0);                   
signal oc_PM_y_dest_out                   :           std_logic_vector(img_height-1 downto 0);                  
signal oc_PM_step_out                     :           std_logic_vector(n_steps-1 downto 0);                     
signal oc_PM_frame_out                    :           std_logic_vector(n_frames-1 downto 0);                    
signal oc_PM_x_orig_out                   :           std_logic_vector(img_width-1 downto 0);                   
signal oc_PM_y_orig_out                   :           std_logic_vector(img_height-1 downto 0);                  
signal oc_PM_fb_out                       :           std_logic; -- message forward/backward                    
signal oc_PM_new_msg_out                  :           std_logic:='0';                                           
signal oc_PM_ack_out                      :           std_logic:='0';                                                                                   
signal i_PM_pixel_out                     :           std_logic_vector(pix_depth-1 downto 0);                   
signal i_PM_x_dest_out                    :           std_logic_vector(img_width-1 downto 0);                   
signal i_PM_y_dest_out                    :           std_logic_vector(img_height-1 downto 0);                  
signal i_PM_step_out                      :           std_logic_vector(n_steps-1 downto 0);                     
signal i_PM_frame_out                     :           std_logic_vector(n_frames-1 downto 0);                    
signal i_PM_x_orig_out                    :           std_logic_vector(img_width-1 downto 0);                   
signal i_PM_y_orig_out                    :           std_logic_vector(img_height-1 downto 0);                  
signal i_PM_fb_out                        :           std_logic; -- message forward/backward                    
signal i_PM_req_out                       :           std_logic:='0';                                         
signal i_PM_ack_out                       :           std_logic:='0';                       




signal input_data_in               :    std_logic_vector(63   downto 0):=(others => '0');
                                                                                      
signal output_ack_in               :    std_logic:='0';                                  
signal output_data_in              :    std_logic_vector(63   downto 0):=(others => '0');
      
      
      
                                                                                     
signal input_ack_out                :    std_logic:='0';                                  
signal input_data_out               :    std_logic_vector(63   downto 0):=(others => '0');
                                                                                      
signal output_data_out              :    std_logic_vector(63   downto 0):=(others => '0');                              


begin
input_req_in<= input_data_in(1);
output_req_out<= output_data_out(1);


output_data_in  <=  i_PM_pixel_in &  i_PM_x_dest_in &  i_PM_y_dest_in &  i_PM_step_in &   i_PM_frame_in &   i_PM_x_orig_in &   i_PM_y_orig_in &   i_PM_fb_in &   i_PM_req_in & output_ack_in  ;

oc_PM_pixel_in <=input_data_in(pix_depth + img_width + img_width +  n_steps+ n_frames + img_width+ img_width  +2  downto  img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 +1); 
oc_PM_x_dest_in <=input_data_in(img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 downto img_width +  n_steps+ n_frames + img_width+ img_width +2 +1);                                          
oc_PM_y_dest_in <=input_data_in(img_width +  n_steps+ n_frames + img_width+ img_width +2 downto n_steps+ n_frames + img_width+ img_width +2+1);                                                               
oc_PM_step_in   <=input_data_in(n_steps+ n_frames + img_width+ img_width +2 downto n_frames+img_width+img_width +2 +1);                                                                                 
oc_PM_frame_in  <=input_data_in(n_frames + img_width+ img_width +2 downto img_width+img_width +2+1);                                                                                                       
oc_PM_x_orig_in <=input_data_in(img_width+ img_width +2   downto img_width +2+1);                                                                                                                        
oc_PM_y_orig_in <=input_data_in(img_width +2  downto +2+1);                                                                                                                                         
oc_PM_fb_in     <=input_data_in(1+1);                                                                                                                                                              
oc_PM_new_msg_in <=input_data_in(1);



output_data_out  <=  i_PM_pixel_out &  i_PM_x_dest_out &  i_PM_y_dest_out &  i_PM_step_out &   i_PM_frame_out &   i_PM_x_orig_out &   i_PM_y_orig_out &   i_PM_fb_out &   i_PM_req_out & output_ack_out  ;

oc_PM_pixel_out <=input_data_out(pix_depth + img_width + img_width +  n_steps+ n_frames + img_width+ img_width  +2  downto  img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 +1); 
oc_PM_x_dest_out <=input_data_out(img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 downto img_width +  n_steps+ n_frames + img_width+ img_width +2 +1);                                          
oc_PM_y_dest_out <=input_data_out(img_width +  n_steps+ n_frames + img_width+ img_width +2 downto n_steps+ n_frames + img_width+ img_width +2+1);                                                               
oc_PM_step_out <=input_data_out(n_steps+ n_frames + img_width+ img_width +2 downto n_frames+img_width+img_width +2 +1);                                                                                 
oc_PM_frame_out <=input_data_out(n_frames + img_width+ img_width +2 downto img_width+img_width +2+1);                                                                                                       
oc_PM_x_orig_out <=input_data_out(img_width+ img_width +2   downto img_width +2+1);                                                                                                                        
oc_PM_y_orig_out <=input_data_out(img_width +2  downto +2+1);                                                                                                                                         
oc_PM_fb_out <=input_data_out(1+1);                                                                                                                                                              
oc_PM_new_msg_out <=input_data_out(1);
oc_PM_ack_in <=input_data_in(0);


    -- connecting testbench signals with half_adder.vhd
    UUT : entity work.pm_wrapper 
    generic map
    (
     pix_depth     =>  pix_depth ,
     addr_size     =>  addr_size,
     mem_size      =>  mem_size,
     img_width	   =>  img_width,
     img_height    =>  img_height,
     subimg_width  =>  subimg_width,
     subimg_height  =>  subimg_height,
     n_steps 	   =>  n_steps,
     n_frames      =>  n_frames   	
    )
    port map(
    
      clk                =>clk                ,
      reset              =>reset              ,
      input_data         =>output_data_in         ,
      input_ack          =>output_ack_in          ,
     
      input_riscv_data   =>input_riscv_data   ,
      input_riscv_ack    =>input_riscv_ack    ,
      
      output_data        =>input_data_out        ,
      output_ack         =>input_ack_out         

    );

        UUT1 : entity work.out_pm_controller 
    generic map
    (
     x_init        => x_init        ,
     y_init        => y_init        ,
     img_width     => img_width     ,
     img_height    => img_height    ,
     n_frames      => n_frames      ,
     n_steps       => n_steps       ,
     pix_depth     => pix_depth            
    )
    port map(
    
    clk               =>  clk                    ,
	reset             =>  reset                  ,
	input_deadlockPM  =>  '0'       ,
    oc_PM_pixel       =>  oc_PM_pixel_out            ,
    oc_PM_x_dest      =>  oc_PM_x_dest_out           ,
    oc_PM_y_dest      =>  oc_PM_y_dest_out           ,
    oc_PM_step        =>  oc_PM_step_out             ,
    oc_PM_frame       =>  oc_PM_frame_out            ,
    oc_PM_x_orig      =>  oc_PM_x_orig_out           ,
    oc_PM_y_orig      =>  oc_PM_y_orig_out           ,
    oc_PM_fb          =>  oc_PM_fb_out               ,
    oc_PM_new_msg     =>  oc_PM_new_msg_out          ,
    oc_PM_ack         =>  input_ack_out              ,
    
    i_PM_pixel  => i_PM_pixel_out  ,
    i_PM_x_dest => i_PM_x_dest_out ,
    i_PM_y_dest => i_PM_y_dest_out ,
    i_PM_step   => i_PM_step_out   ,
    i_PM_frame  => i_PM_frame_out  ,
    i_PM_x_orig => i_PM_x_orig_out ,
    i_PM_y_orig => i_PM_y_orig_out ,
    i_PM_fb     => i_PM_fb_out     ,
    i_PM_req    => i_PM_req_out    ,
    i_PM_ack    => output_ack_out    

    );
    
        UUT2 : entity work.in_pm_controller 
    generic map
    (
     x_init        => x_init        ,
     y_init        => y_init        ,
     img_width     => img_width     ,
     img_height    => img_height    ,
     n_frames      => n_frames      ,
     n_steps       => n_steps       ,
     pix_depth     => pix_depth        
     
    )
    port map(
    
    clk               =>  clk                    ,
	reset             =>  reset                  ,
    oc_PM_pixel       =>  oc_PM_pixel_in            ,
    oc_PM_x_dest      =>  oc_PM_x_dest_in           ,
    oc_PM_y_dest      =>  oc_PM_y_dest_in           ,
    oc_PM_step        =>  oc_PM_step_in             ,
    oc_PM_frame       =>  oc_PM_frame_in            ,
    oc_PM_x_orig      =>  oc_PM_x_orig_in           ,
    oc_PM_y_orig      =>  oc_PM_y_orig_in           ,
    oc_PM_fb          =>  oc_PM_fb_in               ,
    oc_PM_new_msg     =>  oc_PM_new_msg_in          ,
    oc_PM_ack         =>  input_ack_in              ,
    
    i_PM_pixel  => i_PM_pixel_in  ,
    i_PM_x_dest => i_PM_x_dest_in ,
    i_PM_y_dest => i_PM_y_dest_in ,
    i_PM_step   => i_PM_step_in   ,
    i_PM_frame  => i_PM_frame_in  ,
    i_PM_x_orig => i_PM_x_orig_in ,
    i_PM_y_orig => i_PM_y_orig_in ,
    i_PM_fb     => i_PM_fb_in     ,
    i_PM_req    => i_PM_req_in    ,
    i_PM_ack    => output_ack_in    

    );
process 
begin
clk <= not(clk);
wait for 10 ns;
end process;


process 
begin 

wait for 100 ns;


input_data_in(1)<='1';
wait until (input_ack_in='1' and rising_edge(clk)) ;
input_data_in(1)<='0';

wait until (input_ack_in='0' and rising_edge(clk)) ;


input_data_in(1)<='1';
wait until (input_ack_in='1' and rising_edge(clk)) ;
input_data_in(1)<='0';

wait until (input_ack_in='0' and rising_edge(clk)) ;

input_data_in(1)<='1';
wait until (input_ack_in='1' and rising_edge(clk)) ;
input_data_in(1)<='0';

wait until (input_ack_in='0' and rising_edge(clk)) ;

input_data_in(1)<='1';
wait until (input_ack_in='1' and rising_edge(clk)) ;
input_data_in(1)<='0';

wait until (input_ack_in='0' and rising_edge(clk)) ;



end process;


process 
begin 
wait for 120 ns;

wait until (output_data_out(1)='1' and rising_edge(clk)) ;
output_ack_out<='1';
wait until (output_data_out(1)='0' and rising_edge(clk)) ;
output_ack_out<='0';

wait until (output_data_out(1)='1' and rising_edge(clk)) ;
output_ack_out<='1';
wait until (output_data_out(1)='0' and rising_edge(clk)) ;
output_ack_out<='0';


wait until (output_data_out(1)='1' and rising_edge(clk)) ;
output_ack_out<='1';
wait until (output_data_out(1)='0' and rising_edge(clk)) ;
output_ack_out<='0';


wait until (output_data_out(1)='1' and rising_edge(clk)) ;
output_ack_out<='1';
wait until (output_data_out(1)='0' and rising_edge(clk)) ;
output_ack_out<='0';



end process;

 
end tb ;
