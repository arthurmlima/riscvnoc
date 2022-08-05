----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/29/2019 07:35:14 PM
-- Design Name: 
-- Module Name: wrapper_EB_DEC - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;




entity S_wrapper_EB_DEC is
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural;
    subimg_width    : natural;
    subimg_height   : natural;
    buffer_length   : natural
);
  Port (
clk                        : in std_logic ;
reset                        : in std_logic ;
--------Handshakes da entrada do EB
--P_S_valid_CF_EB              : in    std_logic; -- indica msg dispon?vel pra enviar ao EB
P_S_ready_EB_CF              : out   std_logic; -- indica que o EB pode receber a mensagem 
P_S_stall_in_EB              : in    std_logic ; --- indica que o processo deve ser stall para que exista sincronia dos elementos -> no CF
P_S_stall_out_EB             : inout std_logic;  -- indica que o '''
---------handshakes na sa?da do decoder
P_S_out_send                 : out  std_logic;
--P_S_ready_CF_DEC             : in std_logic;
P_S_stall_out_DEC            : inout std_logic ;
P_S_stall_in_DEC             : in std_logic ;
-------------------------------------------
--P_S_in_ack : in std_logic;

P_S_data_in_pixel     : in std_logic_vector(pix_depth-1 downto 0);
P_S_data_in_x_dest    : in std_logic_vector(img_width-1 downto 0);
P_S_data_in_y_dest    : in std_logic_vector(img_height-1 downto 0);
P_S_data_in_step      : in std_logic_vector(n_steps-1 downto 0);
P_S_data_in_frame     : in std_logic_vector(n_frames-1 downto 0);
P_S_data_in_x_orig    : in std_logic_vector(img_width-1 downto 0);
P_S_data_in_y_orig    : in std_logic_vector(img_height-1 downto 0);
P_S_data_in_fb        : in std_logic;
 
P_S_data_out_pixel     : out std_logic_vector(pix_depth-1 downto 0);    
P_S_data_out_x_dest    : out std_logic_vector(img_width-1 downto 0);    
P_S_data_out_y_dest    : out std_logic_vector(img_height-1 downto 0);   
P_S_data_out_step      : out std_logic_vector(n_steps-1 downto 0);      
P_S_data_out_frame     : out std_logic_vector(n_frames-1 downto 0);     
P_S_data_out_x_orig    : out std_logic_vector(img_width-1 downto 0);    
P_S_data_out_y_orig    : out std_logic_vector(img_height-1 downto 0);   
P_S_data_out_fb        : out std_logic   ;
--Wrapper_S_ready_EB_CF  : in std_logic;
P_S_out_direction      : out std_logic_vector(5 downto 0);
P_S_ack                : out std_logic;
P_S_req                : in std_logic
   
  
   );
end S_wrapper_EB_DEC;

architecture Behavioral of S_wrapper_EB_DEC is


signal	   w_S_ready_DEC_EB             :  std_logic; -- sinal indica se o decoder est? pronto para receber a mensagem 

signal     w_S_x_dest                   :  std_logic_vector(img_width-1 downto 0);
signal     w_S_y_dest                   :  std_logic_vector(img_height-1 downto 0);
signal     w_S_x_orig                   :  std_logic_vector(img_width-1 downto 0);
signal     w_S_y_orig                   :  std_logic_vector(img_height-1 downto 0);
signal     w_S_fb                       :  std_logic;
signal     w_S_out_send                 :  std_logic;
signal     w_S_ready_CF_DEC             :  std_logic;
signal     w_S_out_direction            :  std_logic_vector(5 downto 0);

SIGnal     w_S_valid_EB_DEC   :  std_logic;
SIGnal     w_S_out_new_EB_DEC  :  std_logic;
      
begin

Inst_dec : entity work.S_dec

generic map(
                                    x_init          => x_init       ,
                                    y_init          => y_init       ,
                                    img_width       => img_width    ,
                                    img_height      => img_height   ,
                                    n_frames        => n_frames     ,
                                    n_steps         => n_steps      ,
                                    pix_depth       => pix_depth    ,
                                    subimg_width    => subimg_width ,
                                    subimg_height   => subimg_height,
                                    buffer_length   => buffer_length
                                    )

port map (


clk                   =>  clk ,
rst                   => reset ,



S_stall_out_DEC      =>   P_S_stall_out_DEC ,
S_stall_in_DEC       =>   P_S_stall_in_DEC  ,

S_in_x_dest          =>  w_S_x_dest,
S_in_y_dest          =>  w_S_y_dest,
S_in_x_orig          =>  w_S_x_orig,
S_in_y_orig          =>  w_S_y_orig,
S_in_fb              =>  w_S_fb    ,

S_out_direction      =>  P_S_out_direction,

S_out_send           => P_S_out_send   ,


S_ready_DEC_EB       => w_S_ready_DEC_EB,
S_valid_EB_DEC       => w_S_valid_EB_DEC,
S_out_new_EB_DEC     => w_S_out_new_EB_DEC

);

Inst_elastic_buffer : entity work.S_elastic_buffer

generic map(
                                    x_init          => x_init       ,
                                    y_init          => y_init       ,
                                    img_width       => img_width    ,
                                    img_height      => img_height   ,
                                    n_frames        => n_frames     ,
                                    n_steps         => n_steps      ,
                                    pix_depth       => pix_depth    ,
                                    subimg_width    => subimg_width ,
                                    subimg_height   => subimg_height,
                                    buffer_length   => buffer_length
                                    )
port map (


clk                     =>     clk , 
rst                     =>     reset ,       
          
S_valid_EB_DEC         =>     w_S_valid_EB_DEC,
S_ready_DEC_EB         =>     w_S_ready_DEC_EB,
  
S_out_new_EB_DEC     => w_S_out_new_EB_DEC,  

--S_ready_EB_CF          =>  P_S_ready_EB_CF,
    
S_stall_in_EB          => P_S_stall_in_EB,
S_stall_out_EB         => P_S_stall_out_EB,

                       
S_data_in_pixel        =>    P_S_data_in_pixel  ,
S_data_in_x_dest       =>    P_S_data_in_x_dest ,
S_data_in_y_dest       =>    P_S_data_in_y_dest ,
S_data_in_step         =>    P_S_data_in_step   ,
S_data_in_frame        =>    P_S_data_in_frame  ,
S_data_in_x_orig       =>    P_S_data_in_x_orig,
S_data_in_y_orig       =>    P_S_data_in_y_orig,
S_data_in_fb           =>    P_S_data_in_fb    ,            

S_data_out_pixel       =>     P_S_data_out_pixel ,
S_data_out_x_dest      =>     w_S_x_dest,
S_data_out_y_dest      =>     w_S_y_dest,
S_data_out_step        =>     P_S_data_out_step  ,
S_data_out_frame       =>     P_S_data_out_frame ,
S_data_out_x_orig      =>     w_S_x_orig,
S_data_out_y_orig      =>     w_S_y_orig,
S_data_out_fb          =>     w_S_fb  ,
--S_ready_CF_EB          =>     Wrapper_S_ready_EB_CF,

S_ack               =>      P_S_ack,
S_req               =>      P_S_req




   


);





     P_S_data_out_x_dest <= w_S_x_dest;
     P_S_data_out_y_dest <= w_S_y_dest;
     
     P_S_data_out_x_orig <= w_S_x_orig;
     P_S_data_out_y_orig <= w_S_y_orig;
     P_S_data_out_fb     <= w_S_fb    ;
     
 
   
end Behavioral;
