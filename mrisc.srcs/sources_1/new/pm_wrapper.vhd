----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/25/2022 11:27:55 PM
-- Design Name: 
-- Module Name: pm_wrapper - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity pm_wrapper is
generic(
    pix_depth        : natural;
    addr_size        : natural;
    mem_size         : natural;
    img_width	     : natural ;
    img_height 	     : natural ;
    subimg_width 	 : natural; 
    subimg_height	 : natural ;
    n_steps 	     : natural ;
    n_frames   	     : natural 
);
port(
  clk   : in std_logic;
  reset   : in std_logic;
    
  input_data   : in std_logic_vector(63   downto 0);
  input_ack   : out std_logic:='0';
  
  input_riscv_data  : in std_logic_vector(63   downto 0);
  input_riscv_ack   : out std_logic;
  
  
  output_data   : out std_logic_vector(63   downto 0);
  output_ack   : in std_logic:='0'
  );
  
end pm_wrapper;

architecture Behavioral of pm_wrapper is


component rams_tdp_rf_rf is
generic(
     addr_size   : natural;
     mem_size    : natural;
    pix_depth  	     : natural
);
port(

        clka    : in  std_logic;
        clkb    : in  std_logic;
        ena     : in  std_logic;
        enb     : in  std_logic;
        wea     : in  std_logic;
        web     : in  std_logic;
        addra   : in  std_logic_vector(addr_size-1 downto 0);
        addrb   : in  std_logic_vector(addr_size-1 downto 0);
        dia     : in  std_logic_vector(pix_depth-1 downto 0);
        dib     : in  std_logic_vector(pix_depth-1 downto 0);
        doa     : out std_logic_vector(pix_depth-1 downto 0);
        dob     : out std_logic_vector(pix_depth-1 downto 0);
        doa_ok  : out std_logic;
        dob_ok  : out std_logic 

);    
end component rams_tdp_rf_rf;
   
signal    clka    :  std_logic;
signal    clkb    :  std_logic;
signal    ena     :  std_logic;
signal    enb     :  std_logic;
signal    wea     :  std_logic;
signal    web     :  std_logic;
signal    addra   :  std_logic_vector(addr_size-1 downto 0);
signal    addrb   :  std_logic_vector(addr_size-1 downto 0);
signal    dia     :  std_logic_vector(pix_depth-1 downto 0);
signal    dib     :  std_logic_vector(pix_depth-1 downto 0);
signal    doa     :  std_logic_vector(pix_depth-1 downto 0);
signal    dob     :  std_logic_vector(pix_depth-1 downto 0);
signal    doa_ok  :  std_logic;
signal    dob_ok  :  std_logic ;
        
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


signal    signal_input_riscv_pixel     :       std_logic_vector(pix_depth-1 downto 0);
signal    signal_input_riscv_address   :       std_logic_vector(addr_size-1 downto 0);
signal    signal_input_riscv_req       :       std_logic;




signal aux1:std_logic:='0';
signal aux2:std_logic:='0';
    
type proc_router is (forward, write_mode, normal_mode,handshake);  -- Define the states
type proc_riscv is (forward, write_mode, normal_mode,handshake);  -- Define the states
signal mode_router : proc_router:= forward;    -- 
signal mode_riscv  : proc_riscv:= forward;     --  

begin

output_data  <= signal_i_PM_pixel & signal_i_PM_x_dest & signal_i_PM_y_dest & signal_i_PM_step &  signal_i_PM_frame &  signal_i_PM_x_orig &  signal_i_PM_y_orig &  signal_i_PM_fb &  signal_i_PM_req & output_ack  ;

signal_t_PM_pixel   <=input_data(pix_depth + img_width + img_width +  n_steps+ n_frames + img_width+ img_width  +2  downto  img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 +1); 
signal_t_PM_x_dest  <=input_data(img_width + img_width +  n_steps+ n_frames + img_width+ img_width +2 downto img_width +  n_steps+ n_frames + img_width+ img_width +2 +1);                                          
signal_t_PM_y_dest  <=input_data(img_width +  n_steps+ n_frames + img_width+ img_width +2 downto n_steps+ n_frames + img_width+ img_width +2+1);                                                               
signal_t_PM_step    <=input_data(n_steps+ n_frames + img_width+ img_width +2 downto n_frames+img_width+img_width +2 +1);                                                                                 
signal_t_PM_frame   <=input_data(n_frames + img_width+ img_width +2 downto img_width+img_width +2+1);                                                                                                       
signal_t_PM_x_orig  <=input_data(img_width+ img_width +2   downto img_width +2+1);                                                                                                                        
signal_t_PM_y_orig  <=input_data(img_width +2  downto +2+1);                                                                                                                                         
signal_t_PM_fb      <=input_data(1+1);                                                                                                                                                              
signal_t_PM_req     <=input_data(1);
 
signal_input_riscv_pixel    <= input_riscv_data(pix_depth+addr_size+1+1-1 downto addr_size+1+1 ); 
signal_input_riscv_address  <= input_riscv_data(addr_size+1+1-1 downto 1+1); 
signal_input_riscv_req      <= input_riscv_data(1); 
 

inst_pm: rams_tdp_rf_rf
    generic map(
    pix_depth   =>   pix_depth  ,
    addr_size    =>   addr_size   ,
    mem_size     =>   mem_size 
    )
    port map(          
clka    =>clk  ,
clkb    =>clk  ,
ena     =>ena   ,
enb     =>enb   ,
wea     =>wea   ,
web     =>web   ,
addra   =>addra ,
addrb   =>addrb ,
dia     =>dia   ,
dib     =>dib   ,
doa     =>doa   ,
dob     =>dob   ,
doa_ok  =>doa_ok,
dob_ok  =>dob_ok
  );  

enb<='1'; 
web<='1';     

ena<='1'; 
wea<='0';    
process(clk,reset) is
variable aux1 : std_logic := '0';
variable aux2 : std_logic := '0';
begin
    if(reset='1')then
        signal_i_PM_pixel   <= (others => '0');
        signal_i_PM_x_dest  <= (others => '0');
        signal_i_PM_y_dest  <= (others => '0');
        signal_i_PM_step    <= (others => '0');
        signal_i_PM_frame   <= (others => '0');
        signal_i_PM_x_orig  <= (others => '0');
        signal_i_PM_y_orig  <= (others => '0');
        signal_i_PM_fb      <= '0';  
        signal_i_PM_req <= '0';
        input_ack <= '0';
        mode_router <= forward;

    elsif(rising_edge(clk))then
        case mode_router is
            when forward =>
                if(signal_t_PM_req='1')then

                            signal_i_PM_pixel      <= (others => '0');
                            signal_i_PM_x_dest     <= (others => '0');
                            signal_i_PM_y_dest     <= (others => '0');
                            signal_i_PM_step       <= (others => '0');
                            signal_i_PM_frame      <= (others => '0');
                            signal_i_PM_x_orig     <= (others => '0');
                            signal_i_PM_y_orig     <= (others => '0');
                            signal_i_PM_fb         <= '0';
                            signal_i_PM_req        <= '0';
                            input_ack              <= '0';                           
                            addra<= '0' & signal_t_PM_y_dest;                                               
                            mode_router<=normal_mode;
                end if;
             
             
                    
             when normal_mode =>
             if(signal_i_PM_ack='0'and signal_t_PM_req='1')then
                          if(doa_ok='1')then
                                signal_i_PM_pixel<=doa;
                                signal_i_PM_x_dest <=  signal_t_PM_x_dest ;
                                signal_i_PM_y_dest <=  signal_t_PM_y_dest ;
                                signal_i_PM_step   <=  signal_t_PM_step   ;
                                signal_i_PM_frame  <=  signal_t_PM_frame  ;
                                signal_i_PM_x_orig <=  signal_t_PM_x_orig ;
                                signal_i_PM_y_orig <=  signal_t_PM_y_orig ;
                                signal_i_PM_fb<='1';      
                               -- ena<='0';          
                                signal_i_PM_req        <= '1';
                                input_ack              <= '1';                           

                                mode_router<=handshake;                        
                          end if;
                  end if;

               

                
             when handshake =>
             if(output_ack='1')then
              aux1 := '1';
              signal_i_PM_req              <='0';
           

            end if;
            
              if(signal_t_PM_req='0')then
              aux2          := '1';
              input_ack     <= '0';           
             end if;
             
             if(aux1 = '1' and aux2 = '1')then
             
                    signal_i_PM_pixel      <= (others => '0');
                    signal_i_PM_x_dest     <= (others => '0');
                    signal_i_PM_y_dest     <= (others => '0');
                    signal_i_PM_step       <= (others => '0');
                    signal_i_PM_frame      <= (others => '0');
                    signal_i_PM_x_orig     <= (others => '0');
                    signal_i_PM_y_orig     <= (others => '0');
                    signal_i_PM_fb         <= '0';
                    signal_i_PM_req        <= '0';
             
             aux1:='0'; 
             aux2:='0';
             mode_router <= forward;
 
             end if;
            
                    
            when others =>
            
        end case;
    end if;

end process;
  
  
  
-- RISC PIXEL MEMORY ACCESS               
process(clk,reset) is
begin
    if(reset='1')then
    elsif(rising_edge(clk))then
        case mode_riscv is
            when forward =>
                if(signal_input_riscv_req='1')then
                           -- enb<='1'; 
                           -- web<='1';
                            input_riscv_ack <= '1';                           
                            addrb<= signal_input_riscv_address;
                            dib<=signal_input_riscv_pixel;
                            mode_riscv<=write_mode;
                end if;
             
                                 
             when write_mode =>
                          if(dob_ok='1')then
                             --   enb<='0'; 
                             --   web<='0';                               
                                input_riscv_ack<= '1';
                                mode_riscv<=handshake;                        
                          end if;
                              
             when handshake =>
                         if(signal_input_riscv_req='0')then
                                input_riscv_ack              <= '0';
                                mode_riscv             <=  forward;
                         end if;
                    
            when others =>
            
        end case;
    end if;

end process;


end Behavioral;
