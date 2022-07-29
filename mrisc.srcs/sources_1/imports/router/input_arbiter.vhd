----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/12/2016 03:40:41 PM
-- Design Name: 
-- Module Name: arbiter - Behavioral
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

entity input_arbiter is

generic(
    x_init      : natural := 0;
    y_init      : natural := 0;
    img_width   : natural;
    img_height  : natural;
    n_frames    : natural;
    n_steps     : natural;
    pix_depth   : natural
);

port(
    --clk : in std_logic;
    --reset : in std_logic;
    -- from/to input_selector
    --in_sel_trigger : out std_logic;-- signal to trigger input_selector capture
    --sel_trigger_ack: in std_logic; -- signal from the input_selector to indicate it acquired the desired input
    --
    --next_busy : in std_logic;
    -- 
    --t_PM_req : in std_logic;
    --t_PE_req : in std_logic;
    --t_N_req : in std_logic;
    --t_S_req : in std_logic;
    --t_E_req : in std_logic;
    --t_W_req : in std_logic;
    --
    --t_L_busy : out std_logic;
    --t_N_busy : out std_logic;
    --t_S_busy : out std_logic;
    --t_E_busy : out std_logic;
    --t_W_busy : out std_logic;
    --
    --sel_dir  : out std_logic_vector(5 downto 0) -- selected direction, hotspot codification
    clk : in std_logic;
    reset : in std_logic;
    -- from/to arbiter
    --in_sel_trigger : in std_logic;-- signal from arbiter to trigger the capture
    --sel_dir  : in std_logic_vector(5 downto 0); -- selected direction, hotspot codification: PM,PE,N,S,E,W
    -- Pixel Memory target ports - the PM sends values using these ports.
    t_PM_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_PM_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_PM_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_PM_step   : in std_logic_vector(n_steps-1 downto 0);
    t_PM_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_PM_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_PM_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_PM_fb     : in std_logic; -- message forward/backward
    t_PM_req    : in std_logic; -- message request
    --t_PM_busy   : out std_logic; -- router is busy
    t_PM_ack    : out std_logic; -- message acknowledge        
    -- New Local target ports - the PE requests values using these ports.
    t_PE_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_PE_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_PE_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_PE_step   : in std_logic_vector(n_steps-1 downto 0);
    t_PE_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_PE_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_PE_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_PE_fb     : in std_logic; -- message forward/backward
    t_PE_req    : in std_logic; -- message request
    --t_PE_busy   : out std_logic; -- router is busy
    t_PE_ack    : out std_logic; -- message acknowledge        
    -- North target ports    
    t_N_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_N_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_N_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_N_step   : in std_logic_vector(n_steps-1 downto 0);
    t_N_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_N_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_N_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_N_fb     : in std_logic; -- message forward/backward
    t_N_req    : in std_logic; -- message request
    --t_N_busy   : out std_logic; -- router is busy
    t_N_ack    : out std_logic; -- message acknowledge    
    -- South target ports
    t_S_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_S_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_S_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_S_step   : in std_logic_vector(n_steps-1 downto 0);
    t_S_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_S_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_S_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_S_fb     : in std_logic; -- message forward/backward
    t_S_req    : in std_logic; -- message request
    --t_S_busy   : out std_logic; -- router is busy
    t_S_ack    : out std_logic; -- message acknowledge    
    -- East target ports
    t_E_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_E_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_E_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_E_step   : in std_logic_vector(n_steps-1 downto 0);
    t_E_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_E_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_E_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_E_fb     : in std_logic; -- message forward/backward
    t_E_req    : in std_logic; -- message request
    --t_E_busy   : out std_logic; -- router is busy
    t_E_ack    : out std_logic; -- message acknowledge
    -- west target ports
    t_W_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    t_W_x_dest : in std_logic_vector(img_width-1 downto 0);
    t_W_y_dest : in std_logic_vector(img_height-1 downto 0);
    t_W_step   : in std_logic_vector(n_steps-1 downto 0);
    t_W_frame  : in std_logic_vector(n_frames-1 downto 0);
    t_W_x_orig : in std_logic_vector(img_width-1 downto 0);
    t_W_y_orig : in std_logic_vector(img_height-1 downto 0);
    t_W_fb     : in std_logic; -- message forward/backward
    t_W_req    : in std_logic; -- message request
    --t_W_busy   : out std_logic; -- router is busy
    t_W_ack    : out std_logic; -- message acknowledge
    -- output selected message
    out_new     : inout std_logic;--originally out
    dec_ack     : in  std_logic;
    out_pixel   : out std_logic_vector(pix_depth-1 downto 0);
    out_x_dest  : out std_logic_vector(img_width-1 downto 0);
    out_y_dest  : out std_logic_vector(img_height-1 downto 0);
    out_step    : out std_logic_vector(n_steps-1 downto 0);
    out_frame   : out std_logic_vector(n_frames-1 downto 0);
    out_x_orig  : out std_logic_vector(img_width-1 downto 0);
    out_y_orig  : out std_logic_vector(img_height-1 downto 0);
    out_fb      : out std_logic        
    
);

end input_arbiter;

architecture Behavioral of input_arbiter is

    --signal busy : std_logic := '0';
    signal counter : natural := 0; -- we will use a Round-Robin arbiter
    signal counter1 : natural := 0; -- we will use a Round-Robin arbiter
    signal requests : std_logic_vector(5 downto 0);
    signal sel_dir : std_logic_vector(5 downto 0);
    signal in_sel_trigger : std_logic;-- signal from arbiter to trigger the capture
    signal state : natural := 0;
    
begin
     
    --t_L_busy <= busy;
    --t_N_busy <= busy;
    --t_S_busy <= busy;
    --t_E_busy <= busy;
    --t_W_busy <= busy;
    
    requests <= (t_PM_req & t_PE_req & t_N_req & t_S_req & t_E_req & t_W_req); 

process(reset, dec_ack)
begin
    if (reset = '1')then
        counter <= 1;
    elsif (falling_edge(dec_ack)) then
        if (counter = 6) then
            counter <= 1;
        else
            counter <= counter + 1;
        end if;
    end if;
end process;
    
process(clk,reset)
begin
   if (reset = '1')then
        --busy <= '0';
        sel_dir <= "000000"; -- non-defined direction
        --counter <= 1;
        counter1 <= 1;
        state <= 0;
        in_sel_trigger <= '0';
        
        out_pixel  <= (others => '0');
        out_x_dest <= (others => '0');
        out_y_dest <= (others => '0');
        out_step   <= (others => '0');
        out_frame  <= (others => '0');
        out_x_orig <= (others => '0');
        out_y_orig <= (others => '0');
        out_fb     <= '0';
        t_PM_ack   <= '0';
        t_PE_ack   <= '0';
        t_N_ack    <= '0';
        t_S_ack    <= '0';
        t_E_ack    <= '0';
        t_W_ack    <= '0';   
             
        out_new    <= '0';        
    else
        if(rising_edge(clk))then
        case state is
        when 0 =>
            --if(next_busy='0')then -- the next block is busy, so do not get values inside.
            if(dec_ack='0' and out_new='0')then
                --out_new <= '0';
                case counter is
                    when 1 =>
                       -- out_new <= '1';
                        --counter <= 2;
                        in_sel_trigger <= '1';
                        if(t_PE_req='1')then
                            sel_dir <= "010000";
                            --busy <= '1';
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';
                            
                            out_pixel  <= t_PE_pixel;       
                            out_x_dest <= t_PE_x_dest;
                            out_y_dest <= t_PE_y_dest;
                            out_step   <= t_PE_step;
                            out_frame  <= t_PE_frame;
                            out_x_orig <= t_PE_x_orig;
                            out_y_orig <= t_PE_y_orig;
                            out_fb     <= t_PE_fb;
                            t_PE_ack   <= '1';
                            out_new    <= '1';           
                            state      <= 1;                 
                        elsif(t_N_req='1')then
                            sel_dir <= "001000";
                            --busy <= '1';
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';
                            
                            out_pixel  <= t_N_pixel;
                            out_x_dest <= t_N_x_dest;
                            out_y_dest <= t_N_y_dest;
                            out_step   <= t_N_step;
                            out_frame  <= t_N_frame;
                            out_x_orig <= t_N_x_orig;
                            out_y_orig <= t_N_y_orig;
                            out_fb     <= t_N_fb;
                            t_N_ack    <= '1';
                            out_new    <= '1';  
                            state      <= 1;                          
                        elsif(t_S_req='1')then
                            sel_dir <= "000100";
                            --busy <= '1';
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';
                            
                            out_pixel  <= t_S_pixel;
                            out_x_dest <= t_S_x_dest;
                            out_y_dest <= t_S_y_dest;
                            out_step   <= t_S_step;
                            out_frame  <= t_S_frame;
                            out_x_orig <= t_S_x_orig;
                            out_y_orig <= t_S_y_orig;
                            out_fb     <= t_S_fb;
                            t_S_ack    <= '1';
                            out_new    <= '1';           
                            state      <= 1;                 
                        elsif(t_E_req='1')then
                            sel_dir <= "000010";
                            --busy <= '1';
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';
                            
                            out_pixel  <= t_E_pixel;
                            out_x_dest <= t_E_x_dest;
                            out_y_dest <= t_E_y_dest;
                            out_step   <= t_E_step;
                            out_frame  <= t_E_frame;
                            out_x_orig <= t_E_x_orig;
                            out_y_orig <= t_E_y_orig;
                            out_fb     <= t_E_fb;
                            t_E_ack    <= '1';
                            out_new    <= '1';    
                            state      <= 1;                        
                        elsif(t_W_req='1')then
                            sel_dir <= "000001";
                            --busy <= '1';
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';
                            
                            out_pixel  <= t_W_pixel;
                            out_x_dest <= t_W_x_dest;
                            out_y_dest <= t_W_y_dest;
                            out_step   <= t_W_step;
                            out_frame  <= t_W_frame;
                            out_x_orig <= t_W_x_orig;
                            out_y_orig <= t_W_y_orig;
                            out_fb     <= t_W_fb;
                            t_W_ack    <= '1';
                            out_new    <= '1';    
                            state      <= 1;                        
                        elsif(t_PM_req='1')then
                            sel_dir <= "100000";
                            --counter <= counter + 1;
                            --in_sel_trigger <= '1';

                            out_pixel  <= t_PM_pixel;
                            out_x_dest <= t_PM_x_dest;
                            out_y_dest <= t_PM_y_dest;
                            out_step   <= t_PM_step;
                            out_frame  <= t_PM_frame;
                            out_x_orig <= t_PM_x_orig;
                            out_y_orig <= t_PM_y_orig;
                            out_fb     <= t_PM_fb;
                            t_PM_ack   <= '1';
                            out_new    <= '1';  
                            state      <= 1;                          
                        end if;
                    
--                    when 2 =>
--                        if(dec_ack='1')then
--                            out_new <= '0';
--                            counter <= counter + 1;
--                        end if;
                    when 2 =>
                        --out_new <= '1';
                        --counter <= 3;
                        in_sel_trigger <= '1';                    
                        if(t_N_req='1')then
                        sel_dir <= "001000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                        out_pixel  <= t_N_pixel;
                        out_x_dest <= t_N_x_dest;
                        out_y_dest <= t_N_y_dest;
                        out_step   <= t_N_step;
                        out_frame  <= t_N_frame;
                        out_x_orig <= t_N_x_orig;
                        out_y_orig <= t_N_y_orig;
                        out_fb     <= t_N_fb;
                        t_N_ack    <= '1';
                        out_new    <= '1';  
                        state      <= 1;                      
                    elsif(t_S_req='1')then
                        sel_dir <= "000100";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_S_pixel;
                        out_x_dest <= t_S_x_dest;
                        out_y_dest <= t_S_y_dest;
                        out_step   <= t_S_step;
                        out_frame  <= t_S_frame;
                        out_x_orig <= t_S_x_orig;
                        out_y_orig <= t_S_y_orig;
                        out_fb     <= t_S_fb;
                        t_S_ack    <= '1';
                        out_new    <= '1';      
                        state      <= 1;                  
                    elsif(t_E_req='1')then
                        sel_dir <= "000010";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_E_pixel;
                        out_x_dest <= t_E_x_dest;
                        out_y_dest <= t_E_y_dest;
                        out_step   <= t_E_step;
                        out_frame  <= t_E_frame;
                        out_x_orig <= t_E_x_orig;
                        out_y_orig <= t_E_y_orig;
                        out_fb     <= t_E_fb;
                        t_E_ack    <= '1';
                        out_new    <= '1';       
                        state      <= 1;                 
                    elsif(t_W_req='1')then
                        sel_dir <= "000001";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_W_pixel;
                        out_x_dest <= t_W_x_dest;
                        out_y_dest <= t_W_y_dest;
                        out_step   <= t_W_step;
                        out_frame  <= t_W_frame;
                        out_x_orig <= t_W_x_orig;
                        out_y_orig <= t_W_y_orig;
                        out_fb     <= t_W_fb;
                        t_W_ack    <= '1';
                        out_new    <= '1';   
                        state      <= 1;                     
                    elsif(t_PM_req='1')then
                        sel_dir <= "100000";
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';   
                        
                        out_pixel  <= t_PM_pixel;
                        out_x_dest <= t_PM_x_dest;
                        out_y_dest <= t_PM_y_dest;
                        out_step   <= t_PM_step;
                        out_frame  <= t_PM_frame;
                        out_x_orig <= t_PM_x_orig;
                        out_y_orig <= t_PM_y_orig;
                        out_fb     <= t_PM_fb;
                        t_PM_ack   <= '1';
                        out_new    <= '1';           
                        state      <= 1;                                  
                    elsif(t_PE_req='1')then
                        sel_dir <= "010000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                        out_pixel  <= t_PE_pixel;
                        out_x_dest <= t_PE_x_dest;
                        out_y_dest <= t_PE_y_dest;
                        out_step   <= t_PE_step;
                        out_frame  <= t_PE_frame;
                        out_x_orig <= t_PE_x_orig;
                        out_y_orig <= t_PE_y_orig;
                        out_fb     <= t_PE_fb;
                        t_PE_ack   <= '1';
                        out_new    <= '1';         
                        state      <= 1;               
                    end if;

--                    when 4 =>
--                        if(dec_ack='1')then
--                            out_new <= '0';
--                            --counter <= counter + 1;
--                        end if;                    

                    when 3 =>
                        --out_new <= '1';
                        --counter <= 4;
                        in_sel_trigger <= '1';                    
                        if(t_S_req='1')then
                        sel_dir <= "000100";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_S_pixel;
                        out_x_dest <= t_S_x_dest;
                        out_y_dest <= t_S_y_dest;
                        out_step   <= t_S_step;
                        out_frame  <= t_S_frame;
                        out_x_orig <= t_S_x_orig;
                        out_y_orig <= t_S_y_orig;
                        out_fb     <= t_S_fb;
                        t_S_ack    <= '1';
                        out_new    <= '1';    
                        state      <= 1;                    
                    elsif(t_E_req='1')then
                        sel_dir <= "000010";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_E_pixel;
                        out_x_dest <= t_E_x_dest;
                        out_y_dest <= t_E_y_dest;
                        out_step   <= t_E_step;
                        out_frame  <= t_E_frame;
                        out_x_orig <= t_E_x_orig;
                        out_y_orig <= t_E_y_orig;
                        out_fb     <= t_E_fb;
                        t_E_ack    <= '1';
                        out_new    <= '1';        
                        state      <= 1;                
                    elsif(t_W_req='1')then
                        sel_dir <= "000001";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_W_pixel;
                        out_x_dest <= t_W_x_dest;
                        out_y_dest <= t_W_y_dest;
                        out_step   <= t_W_step;
                        out_frame  <= t_W_frame;
                        out_x_orig <= t_W_x_orig;
                        out_y_orig <= t_W_y_orig;
                        out_fb     <= t_W_fb;
                        t_W_ack    <= '1';
                        out_new    <= '1';            
                        state      <= 1;            
                    elsif(t_PM_req='1')then
                        sel_dir <= "100000";
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1'; 
                        
                        out_pixel  <= t_PM_pixel;
                        out_x_dest <= t_PM_x_dest;
                        out_y_dest <= t_PM_y_dest;
                        out_step   <= t_PM_step;
                        out_frame  <= t_PM_frame;
                        out_x_orig <= t_PM_x_orig;
                        out_y_orig <= t_PM_y_orig;
                        out_fb     <= t_PM_fb;
                        t_PM_ack   <= '1';
                        out_new    <= '1';        
                        state      <= 1;                                       
                    elsif(t_PE_req='1')then
                        sel_dir <= "010000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                        out_pixel  <= t_PE_pixel;
                        out_x_dest <= t_PE_x_dest;
                        out_y_dest <= t_PE_y_dest;
                        out_step   <= t_PE_step;
                        out_frame  <= t_PE_frame;
                        out_x_orig <= t_PE_x_orig;
                        out_y_orig <= t_PE_y_orig;
                        out_fb     <= t_PE_fb;
                        t_PE_ack   <= '1';
                        out_new    <= '1';         
                        state      <= 1;               
                    elsif(t_N_req='1')then
                        sel_dir <= "001000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_N_pixel;
                        out_x_dest <= t_N_x_dest;
                        out_y_dest <= t_N_y_dest;
                        out_step   <= t_N_step;
                        out_frame  <= t_N_frame;
                        out_x_orig <= t_N_x_orig;
                        out_y_orig <= t_N_y_orig;
                        out_fb     <= t_N_fb;
                        t_N_ack    <= '1';
                        out_new    <= '1';       
                        state      <= 1;                 
                    end if;

--                    when 6 =>
--                        if(dec_ack='1')then
--                            out_new <= '0';
--                            --counter <= counter + 1;
--                        end if;                    

                    when 4 =>
                        --out_new <= '1';
                        --counter <= 5;
                        in_sel_trigger <= '1';                    
                        if(t_E_req='1')then
                        sel_dir <= "000010";
                        --busy <= '1';
                       -- --counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_E_pixel;
                        out_x_dest <= t_E_x_dest;
                        out_y_dest <= t_E_y_dest;
                        out_step   <= t_E_step;
                        out_frame  <= t_E_frame;
                        out_x_orig <= t_E_x_orig;
                        out_y_orig <= t_E_y_orig;
                        out_fb     <= t_E_fb;
                        t_E_ack    <= '1';
                        out_new    <= '1';   
                        state      <= 1;                     
                    elsif(t_W_req='1')then
                        sel_dir <= "000001";
                        --busy <= '1';
                        ----counter <= counter + 1;
                       -- in_sel_trigger <= '1';
                        
                            out_pixel  <= t_W_pixel;
                        out_x_dest <= t_W_x_dest;
                        out_y_dest <= t_W_y_dest;
                        out_step   <= t_W_step;
                        out_frame  <= t_W_frame;
                        out_x_orig <= t_W_x_orig;
                        out_y_orig <= t_W_y_orig;
                        out_fb     <= t_W_fb;
                        t_W_ack    <= '1';
                        out_new    <= '1';          
                        state      <= 1;              
                    elsif(t_PM_req='1')then
                        sel_dir <= "100000";
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1'; 
                        
                        out_pixel  <= t_PM_pixel;
                        out_x_dest <= t_PM_x_dest;
                        out_y_dest <= t_PM_y_dest;
                        out_step   <= t_PM_step;
                        out_frame  <= t_PM_frame;
                        out_x_orig <= t_PM_x_orig;
                        out_y_orig <= t_PM_y_orig;
                        out_fb     <= t_PM_fb;
                        t_PM_ack   <= '1';
                        out_new    <= '1';       
                        state      <= 1;                                        
                    elsif(t_PE_req='1')then
                        sel_dir <= "010000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_PE_pixel;
                        out_x_dest <= t_PE_x_dest;
                        out_y_dest <= t_PE_y_dest;
                        out_step   <= t_PE_step;
                        out_frame  <= t_PE_frame;
                        out_x_orig <= t_PE_x_orig;
                        out_y_orig <= t_PE_y_orig;
                        out_fb     <= t_PE_fb;
                        t_PE_ack   <= '1';
                        out_new    <= '1';      
                        state      <= 1;                  
                    elsif(t_N_req='1')then
                        sel_dir <= "001000";
                        --busy <= '1';
                       -- --counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_N_pixel;
                        out_x_dest <= t_N_x_dest;
                        out_y_dest <= t_N_y_dest;
                        out_step   <= t_N_step;
                        out_frame  <= t_N_frame;
                        out_x_orig <= t_N_x_orig;
                        out_y_orig <= t_N_y_orig;
                        out_fb     <= t_N_fb;
                        t_N_ack    <= '1';
                        out_new    <= '1';     
                        state      <= 1;                   
                    elsif(t_S_req='1')then
                        sel_dir <= "000100";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_S_pixel;
                        out_x_dest <= t_S_x_dest;
                        out_y_dest <= t_S_y_dest;
                        out_step   <= t_S_step;
                        out_frame  <= t_S_frame;
                        out_x_orig <= t_S_x_orig;
                        out_y_orig <= t_S_y_orig;
                        out_fb     <= t_S_fb;
                        t_S_ack    <= '1';
                        out_new    <= '1';      
                        state      <= 1;                  
                    end if;

--                    when 8 =>
--                        if(dec_ack='1')then
--                            out_new <= '0';
--                            --counter <= counter + 1;
--                        end if;                    

                    when 5 =>
                        --out_new <= '1';
                        --counter <= 6;
                        in_sel_trigger <= '1';                     
                        if(t_W_req='1')then
                        sel_dir <= "000001";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_W_pixel;
                        out_x_dest <= t_W_x_dest;
                        out_y_dest <= t_W_y_dest;
                        out_step   <= t_W_step;
                        out_frame  <= t_W_frame;
                        out_x_orig <= t_W_x_orig;
                        out_y_orig <= t_W_y_orig;
                        out_fb     <= t_W_fb;
                        t_W_ack    <= '1';
                        out_new    <= '1';           
                        state      <= 1;             
                    elsif(t_PM_req='1')then
                        sel_dir <= "100000";
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';     
                        
                        out_pixel  <= t_PM_pixel;
                        out_x_dest <= t_PM_x_dest;
                        out_y_dest <= t_PM_y_dest;
                        out_step   <= t_PM_step;
                        out_frame  <= t_PM_frame;
                        out_x_orig <= t_PM_x_orig;
                        out_y_orig <= t_PM_y_orig;
                        out_fb     <= t_PM_fb;
                        t_PM_ack   <= '1';
                        out_new    <= '1';      
                        state      <= 1;                                     
                    elsif(t_PE_req='1')then
                        sel_dir <= "010000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= counter + 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_PE_pixel;
                        out_x_dest <= t_PE_x_dest;
                        out_y_dest <= t_PE_y_dest;
                        out_step   <= t_PE_step;
                        out_frame  <= t_PE_frame;
                        out_x_orig <= t_PE_x_orig;
                        out_y_orig <= t_PE_y_orig;
                        out_fb     <= t_PE_fb;
                        t_PE_ack   <= '1';
                        out_new    <= '1';      
                        state      <= 1;                  
                    elsif(t_N_req='1')then
                        sel_dir <= "001000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                       -- --counter <= counter + 1;
                      --  in_sel_trigger <= '1';
                        
                            out_pixel  <= t_N_pixel;
                        out_x_dest <= t_N_x_dest;
                        out_y_dest <= t_N_y_dest;
                        out_step   <= t_N_step;
                        out_frame  <= t_N_frame;
                        out_x_orig <= t_N_x_orig;
                        out_y_orig <= t_N_y_orig;
                        out_fb     <= t_N_fb;
                        t_N_ack    <= '1';
                        out_new    <= '1';        
                        state      <= 1;                
                    elsif(t_S_req='1')then
                        sel_dir <= "000100";
                        --busy <= '1';
                        ----counter <= counter + 1;
                      --  --counter <= counter + 1;
                     --   in_sel_trigger <= '1';
                        
                            out_pixel  <= t_S_pixel;
                        out_x_dest <= t_S_x_dest;
                        out_y_dest <= t_S_y_dest;
                        out_step   <= t_S_step;
                        out_frame  <= t_S_frame;
                        out_x_orig <= t_S_x_orig;
                        out_y_orig <= t_S_y_orig;
                        out_fb     <= t_S_fb;
                        t_S_ack    <= '1';
                        out_new    <= '1';  
                        state      <= 1;                      
                    elsif(t_E_req='1')then
                        sel_dir <= "000010";
                        --busy <= '1';
                        ----counter <= counter + 1;
                      --  --counter <= counter + 1;
                      --  in_sel_trigger <= '1';
                        
                            out_pixel  <= t_E_pixel;
                        out_x_dest <= t_E_x_dest;
                        out_y_dest <= t_E_y_dest;
                        out_step   <= t_E_step;
                        out_frame  <= t_E_frame;
                        out_x_orig <= t_E_x_orig;
                        out_y_orig <= t_E_y_orig;
                        out_fb     <= t_E_fb;
                        t_E_ack    <= '1';
                        out_new    <= '1';  
                        state      <= 1;                      
                    end if;

--                    when 10 =>
--                        if(dec_ack='1')then
--                            out_new <= '0';
--                            --counter <= counter + 1;
--                        end if;                    

                    when 6 =>
                        --out_new <= '1';
                        --counter <= 1;
                        in_sel_trigger <= '1';                     
                    if(t_PM_req='1')then
                        sel_dir <= "100000";
                        ----counter <= 1;
                        --in_sel_trigger <= '1';   
                        
                        out_pixel  <= t_PM_pixel;
                        out_x_dest <= t_PM_x_dest;
                        out_y_dest <= t_PM_y_dest;
                        out_step   <= t_PM_step;
                        out_frame  <= t_PM_frame;
                        out_x_orig <= t_PM_x_orig;
                        out_y_orig <= t_PM_y_orig;
                        out_fb     <= t_PM_fb;
                        t_PM_ack   <= '1';
                        out_new    <= '1';         
                        state      <= 1;                                    
                    elsif(t_PE_req='1')then
                        sel_dir <= "010000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_PE_pixel;
                        out_x_dest <= t_PE_x_dest;
                        out_y_dest <= t_PE_y_dest;
                        out_step   <= t_PE_step;
                        out_frame  <= t_PE_frame;
                        out_x_orig <= t_PE_x_orig;
                        out_y_orig <= t_PE_y_orig;
                        out_fb     <= t_PE_fb;
                        t_PE_ack   <= '1';
                        out_new    <= '1';          
                        state      <= 1;              
                    elsif(t_N_req='1')then
                        sel_dir <= "001000";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_N_pixel;
                        out_x_dest <= t_N_x_dest;
                        out_y_dest <= t_N_y_dest;
                        out_step   <= t_N_step;
                        out_frame  <= t_N_frame;
                        out_x_orig <= t_N_x_orig;
                        out_y_orig <= t_N_y_orig;
                        out_fb     <= t_N_fb;
                        t_N_ack    <= '1';
                        out_new    <= '1';          
                        state      <= 1;              
                    elsif(t_S_req='1')then
                        sel_dir <= "000100";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_S_pixel;
                        out_x_dest <= t_S_x_dest;
                        out_y_dest <= t_S_y_dest;
                        out_step   <= t_S_step;
                        out_frame  <= t_S_frame;
                        out_x_orig <= t_S_x_orig;
                        out_y_orig <= t_S_y_orig;
                        out_fb     <= t_S_fb;
                        t_S_ack    <= '1';
                        out_new    <= '1';               
                        state      <= 1;         
                    elsif(t_E_req='1')then
                        sel_dir <= "000010";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= 1;
                        --in_sel_trigger <= '1';
                        
                            out_pixel  <= t_E_pixel;
                    out_x_dest <= t_E_x_dest;
                    out_y_dest <= t_E_y_dest;
                    out_step   <= t_E_step;
                    out_frame  <= t_E_frame;
                    out_x_orig <= t_E_x_orig;
                    out_y_orig <= t_E_y_orig;
                    out_fb     <= t_E_fb;
                    t_E_ack    <= '1';
                    out_new    <= '1';            
                    state      <= 1;                 
                    elsif(t_W_req='1')then
                        sel_dir <= "000001";
                        --busy <= '1';
                        ----counter <= counter + 1;
                        ----counter <= 1;
                        --in_sel_trigger <= '1';      
                        
                            out_pixel  <= t_W_pixel;
                        out_x_dest <= t_W_x_dest;
                        out_y_dest <= t_W_y_dest;
                        out_step   <= t_W_step;
                        out_frame  <= t_W_frame;
                        out_x_orig <= t_W_x_orig;
                        out_y_orig <= t_W_y_orig;
                        out_fb     <= t_W_fb;
                        t_W_ack    <= '1';
                        out_new    <= '1';          
                        state      <= 1;                                
                    end if;


                    when others =>
                        sel_dir <= "000000";
                        --busy <= '0';
                        ----counter <= counter + 1;
                        --counter <= 1;
                        in_sel_trigger <= '0';
                end case;
--            else -- dec_ack = '1' or out_new = '1'
------------------------------------------------------------------------------            
--                 t_PM_ack <= '0';
--                 t_PE_ack <= '0';
--                 t_N_ack  <= '0';
--                 t_S_ack  <= '0';
--                 t_E_ack  <= '0';
--                 t_W_ack  <= '0';
--                 out_new  <= '0';
          end if;
          when 1 =>
                if(dec_ack='1')then
                    out_new <= '0';
                    t_PM_ack <= '0';
                    t_PE_ack <= '0';
                    t_N_ack  <= '0';
                    t_S_ack  <= '0';
                    t_E_ack  <= '0';
                    t_W_ack  <= '0';                    
                    state <= 0;
                end if;  
          when others =>
          
          end case;  
        end if;
    end if;
   
end process;

end Behavioral;
