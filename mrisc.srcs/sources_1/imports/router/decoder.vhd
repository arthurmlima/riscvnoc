-- file: pixel_mem.vhd
-- description: pixel array per processing element
-- pixel indexing - x coordinate: column
--		  - y coordinate: row
--                - intermediary image index: step
--                - current frame: frame

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is

generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural;
    subimg_width    : natural;
    subimg_height   : natural
);

port(

	clk : in std_logic;
	reset : in std_logic;
	--
	--busy       : out std_logic; -- to the arbiter
	--next_busy  : in std_logic; -- from the output controller
	--
	in_new     : in std_logic; -- signal from the input_selector, informing that a new message is ready to be decoded.
	dec_ack    : out std_logic;
	-- 
    in_pixel   : in std_logic_vector(pix_depth-1 downto 0);
    in_x_dest  : in std_logic_vector(img_width-1 downto 0);
    in_y_dest  : in std_logic_vector(img_height-1 downto 0);
    in_step    : in std_logic_vector(n_steps-1 downto 0);
    in_frame   : in std_logic_vector(n_frames-1 downto 0);
    in_x_orig  : in std_logic_vector(img_width-1 downto 0);
    in_y_orig  : in std_logic_vector(img_height-1 downto 0);
    in_fb      : in std_logic;
    --
    out_pixel   : out std_logic_vector(pix_depth-1 downto 0);
    out_x_dest  : out std_logic_vector(img_width-1 downto 0);
    out_y_dest  : out std_logic_vector(img_height-1 downto 0);
    out_step    : out std_logic_vector(n_steps-1 downto 0);
    out_frame   : out std_logic_vector(n_frames-1 downto 0);
    out_x_orig  : out std_logic_vector(img_width-1 downto 0);
    out_y_orig  : out std_logic_vector(img_height-1 downto 0);
    out_fb      : out std_logic;
    out_send    : out std_logic;
    in_ack      : in std_logic;
    out_direction : out std_logic_vector(5 downto 0)
    
);
end entity decoder;

architecture behavioral of decoder is

    --signal out_direction : std_logic_vector(5 downto 0);--hotspot: PixMem, PE, N, S, E, W
    
    --signal pixel : natural := 0;
    signal x_dest: natural := 0;
    signal y_dest: natural := 0;
    signal x_dest_orig: natural := 0;
    signal y_dest_orig: natural := 0;
    --signal step  : natural := 0;
    --signal frame : natural := 0;
    signal x_orig: natural := 0;
    signal y_orig: natural := 0;
    --signal fb    : std_logic := '0';
    
    constant x_end : natural := x_init + subimg_width-1; -- end of region
    constant y_end : natural := y_init + subimg_height-1; -- end of region
    
    signal x_diff : integer;-- := x_dest-x_init; -- distance to destiny
    signal y_diff : integer;-- := y_dest-y_init; -- distance to destiny
    
    signal NW : std_logic := '0';
    signal SW : std_logic := '0';
    signal NE : std_logic := '0';
    signal SE : std_logic := '0';
    
    signal counter : natural := 0;
    
begin
    
    x_dest <= to_integer(unsigned(in_x_dest));
    y_dest <= to_integer(unsigned(in_y_dest));
    x_orig <= to_integer(unsigned(in_x_orig));
    y_orig <= to_integer(unsigned(in_y_orig));
    x_diff <= x_dest-x_init;
    y_diff <= y_dest-y_init;    

process(clk,reset) is
begin
    if(reset='1')then
        out_direction <= "000000";
        out_pixel   <= (others => '0');
        out_x_dest  <= (others => '0');
        out_y_dest  <= (others => '0');
        out_step    <= (others => '0');
        out_frame   <= (others => '0');
        out_x_orig  <= (others => '0');
        out_y_orig  <= (others => '0');
        out_fb      <= '0';
        out_send    <= '0';
        dec_ack     <= '0';
    else
       if(rising_edge(clk))then
       case counter is 
       when 0 =>
            if(in_ack='0' and in_new= '1')then
                --if(in_new='1')then
                   if(in_fb='0')then
                        --out_send <= '0';
                        --dec_ack <= '0';
                           if( (x_dest>=x_init)and(x_dest<=x_end)and(y_dest>=y_init)and(y_dest<=y_end) )then--I -- if the destination is inside the local region
--                                if(in_fb='0')then --forward message, asks for a pixel value
                                    out_direction <= "100000"; -- route to Pixel Memory
                                    out_pixel   <= in_pixel;
                                    out_x_dest  <= in_x_dest;
                                    out_y_dest  <= in_y_dest;
                                    out_step    <= in_step;
                                    out_frame   <= in_frame;
                                    out_x_orig  <= in_x_orig;
                                    out_y_orig  <= in_y_orig;
                                    out_fb      <= in_fb;
                                    out_send    <= '1';
                                    dec_ack <= '1';
--                                else -- fb='1' -- backward message
--                                    out_direction <= "010000"; -- route to Processing Element
--                                    out_pixel   <= in_pixel;
--                                    out_x_dest  <= in_x_dest;
--                                    out_y_dest  <= in_y_dest;
--                                    out_step    <= in_step;
--                                    out_frame   <= in_frame;
--                                    out_x_orig  <= in_x_orig;
--                                    out_y_orig  <= in_y_orig;
--                                    out_fb      <= in_fb;
--                                    out_send    <= '1'; 
--                                    dec_ack <= '1';                           
--                                end if;
                                   
                           elsif( (x_dest>=x_init)and(x_dest<=x_end) )then -- route in Y (North/South)
                               -- the above condition says that the message is in the same X range of the local tile
                               -- define now if route North or South
                               if( y_dest<y_init )then -- route North
                                   out_direction <= "001000";
                                   out_pixel   <= in_pixel;
                                   out_x_dest  <= in_x_dest;
                                   out_y_dest  <= in_y_dest;
                                   out_step    <= in_step;
                                   out_frame   <= in_frame;
                                   out_x_orig  <= in_x_orig;
                                   out_y_orig  <= in_y_orig;
                                   out_fb      <= in_fb;
                                   out_send    <= '1';  
                                   dec_ack <= '1';                                    
                               else -- route South
                                    out_direction <= "000100";    
                                    out_pixel   <= in_pixel;      
                                    out_x_dest  <= in_x_dest;     
                                    out_y_dest  <= in_y_dest;     
                                    out_step    <= in_step;       
                                    out_frame   <= in_frame;      
                                    out_x_orig  <= in_x_orig;     
                                    out_y_orig  <= in_y_orig;     
                                    out_fb      <= in_fb;         
                                    out_send    <= '1';   
                                    dec_ack <= '1';                                       
                               end if;
                           elsif( (y_dest>=y_init)and(y_dest<=y_end) )then -- route in X (East/West)
                                -- the above condition says that the message is in the same Y range of the local tile
                                -- define now if route East or West
                                if( x_dest<x_init)then -- route West
                                    out_direction <= "000001";   
                                    out_pixel   <= in_pixel;     
                                    out_x_dest  <= in_x_dest;    
                                    out_y_dest  <= in_y_dest;    
                                    out_step    <= in_step;      
                                    out_frame   <= in_frame;     
                                    out_x_orig  <= in_x_orig;    
                                    out_y_orig  <= in_y_orig;    
                                    out_fb      <= in_fb;        
                                    out_send    <= '1';      
                                    dec_ack <= '1';                                    
                                else -- route East
                                    out_direction <= "000010";       
                                    out_pixel   <= in_pixel;         
                                    out_x_dest  <= in_x_dest;        
                                    out_y_dest  <= in_y_dest;        
                                    out_step    <= in_step;          
                                    out_frame   <= in_frame;         
                                    out_x_orig  <= in_x_orig;        
                                    out_y_orig  <= in_y_orig;        
                                    out_fb      <= in_fb;            
                                    out_send    <= '1';          
                                    dec_ack <= '1';                                    
                                end if;
                           elsif( (x_dest<x_init)and(y_dest<y_init) )then -- North-West region
                                --define now if route North or West first
                                if(NW='0')then-- route North
                                    out_direction <= "001000";
                                    out_pixel   <= in_pixel;
                                    out_x_dest  <= in_x_dest;
                                    out_y_dest  <= in_y_dest;
                                    out_step    <= in_step;
                                    out_frame   <= in_frame;
                                    out_x_orig  <= in_x_orig;
                                    out_y_orig  <= in_y_orig;
                                    out_fb      <= in_fb;
                                    out_send    <= '1';      
                                    dec_ack <= '1';                           
                                else-- route West
                                    out_direction <= "000001";   
                                    out_pixel   <= in_pixel;     
                                    out_x_dest  <= in_x_dest;    
                                    out_y_dest  <= in_y_dest;    
                                    out_step    <= in_step;      
                                    out_frame   <= in_frame;     
                                    out_x_orig  <= in_x_orig;    
                                    out_y_orig  <= in_y_orig;    
                                    out_fb      <= in_fb;        
                                    out_send    <= '1';      
                                    dec_ack <= '1';                          
                                end if;
                                NW <= not(NW);
                           elsif( (x_dest<x_init)and(y_dest>y_end) )then -- South-West region
                                -- define now if route South or West first
                                if(SW='0')then-- route South
                                    out_direction <= "000100";    
                                    out_pixel   <= in_pixel;      
                                    out_x_dest  <= in_x_dest;     
                                    out_y_dest  <= in_y_dest;     
                                    out_step    <= in_step;       
                                    out_frame   <= in_frame;      
                                    out_x_orig  <= in_x_orig;     
                                    out_y_orig  <= in_y_orig;     
                                    out_fb      <= in_fb;         
                                    out_send    <= '1';      
                                    dec_ack <= '1';                                 
                                else-- route West
                                    out_direction <= "000001";   
                                    out_pixel   <= in_pixel;     
                                    out_x_dest  <= in_x_dest;    
                                    out_y_dest  <= in_y_dest;    
                                    out_step    <= in_step;      
                                    out_frame   <= in_frame;     
                                    out_x_orig  <= in_x_orig;    
                                    out_y_orig  <= in_y_orig;    
                                    out_fb      <= in_fb;        
                                    out_send    <= '1';         
                                    dec_ack <= '1';                       
                                end if;       
                                SW <= not(SW);                    
                           elsif( (x_dest>x_end)and(y_dest<y_init) )then -- North-East region
                                -- define now if route North or East first
                                if(NE='0')then-- route North
                                    out_direction <= "001000";
                                    out_pixel   <= in_pixel;
                                    out_x_dest  <= in_x_dest;
                                    out_y_dest  <= in_y_dest;
                                    out_step    <= in_step;
                                    out_frame   <= in_frame;
                                    out_x_orig  <= in_x_orig;
                                    out_y_orig  <= in_y_orig;
                                    out_fb      <= in_fb;
                                    out_send    <= '1';                                 
                                    dec_ack <= '1';
                                else-- route East
                                    out_direction <= "000010";       
                                    out_pixel   <= in_pixel;         
                                    out_x_dest  <= in_x_dest;        
                                    out_y_dest  <= in_y_dest;        
                                    out_step    <= in_step;          
                                    out_frame   <= in_frame;         
                                    out_x_orig  <= in_x_orig;        
                                    out_y_orig  <= in_y_orig;        
                                    out_fb      <= in_fb;            
                                    out_send    <= '1';    
                                    dec_ack <= '1';                              
                                end if;
                                NE <= not(NE);
                           elsif( (x_dest>x_end)and(y_dest>y_end) )then -- South-East region
                                -- define now if route South or East first
                                if(SE='0')then-- route South
                                    out_direction <= "000100";    
                                    out_pixel   <= in_pixel;      
                                    out_x_dest  <= in_x_dest;     
                                    out_y_dest  <= in_y_dest;     
                                    out_step    <= in_step;       
                                    out_frame   <= in_frame;      
                                    out_x_orig  <= in_x_orig;     
                                    out_y_orig  <= in_y_orig;     
                                    out_fb      <= in_fb;         
                                    out_send    <= '1';              
                                    dec_ack <= '1';                         
                                else-- route East
                                    out_direction <= "000010";       
                                    out_pixel   <= in_pixel;         
                                    out_x_dest  <= in_x_dest;        
                                    out_y_dest  <= in_y_dest;        
                                    out_step    <= in_step;          
                                    out_frame   <= in_frame;         
                                    out_x_orig  <= in_x_orig;        
                                    out_y_orig  <= in_y_orig;        
                                    out_fb      <= in_fb;            
                                    out_send    <= '1';          
                                    dec_ack <= '1';                        
                                end if;
                                SE <= not(SE);
                           end if;
                       else--------------- FB = 1 = backward message
                        --out_send <= '0';

                          if( (x_orig>=x_init)and(x_orig<=x_end)and(y_orig>=y_init)and(y_orig<=y_end) )then--I -- if the destination is inside the local region
--                               if(in_fb='0')then --forward message, asks for a pixel value
--                                   out_direction <= "100000"; -- route to Pixel Memory
--                                   out_pixel   <= in_pixel;
--                                   out_x_dest  <= in_x_dest;
--                                   out_y_dest  <= in_y_dest;
--                                   out_step    <= in_step;
--                                   out_frame   <= in_frame;
--                                   out_x_orig  <= in_x_orig;
--                                   out_y_orig  <= in_y_orig;
--                                   out_fb      <= in_fb;
--                                   out_send    <= '1';
--                                   dec_ack <= '1';
--                               else -- fb='1' -- backward message
                                   out_direction <= "010000"; -- route to Processing Element
                                   out_pixel   <= in_pixel;
                                   out_x_dest  <= in_x_dest;
                                   out_y_dest  <= in_y_dest;
                                   out_step    <= in_step;
                                   out_frame   <= in_frame;
                                   out_x_orig  <= in_x_orig;
                                   out_y_orig  <= in_y_orig;
                                   out_fb      <= in_fb;
                                   out_send    <= '1';   
                                   dec_ack <= '1';                         
--                               end if;
                                  
                          elsif( (x_orig>=x_init)and(x_orig<=x_end) )then -- route in Y (North/South)
                              -- the above condition says that the message is in the same X range of the local tile
                              -- define now if route North or South
                              if( y_orig<y_init )then -- route North
                                  out_direction <= "001000";
                                  out_pixel   <= in_pixel;
                                  out_x_dest  <= in_x_dest;
                                  out_y_dest  <= in_y_dest;
                                  out_step    <= in_step;
                                  out_frame   <= in_frame;
                                  out_x_orig  <= in_x_orig;
                                  out_y_orig  <= in_y_orig;
                                  out_fb      <= in_fb;
                                  out_send    <= '1';     
                                  dec_ack <= '1';                                 
                              else -- route South
                                   out_direction <= "000100";    
                                   out_pixel   <= in_pixel;      
                                   out_x_dest  <= in_x_dest;     
                                   out_y_dest  <= in_y_dest;     
                                   out_step    <= in_step;       
                                   out_frame   <= in_frame;      
                                   out_x_orig  <= in_x_orig;     
                                   out_y_orig  <= in_y_orig;     
                                   out_fb      <= in_fb;         
                                   out_send    <= '1';         
                                   dec_ack <= '1';                                 
                              end if;
                          elsif( (y_orig>=y_init)and(y_orig<=y_end) )then -- route in X (East/West)
                               -- the above condition says that the message is in the same Y range of the local tile
                               -- define now if route East or West
                               if( x_orig<x_init)then -- route West
                                   out_direction <= "000001";   
                                   out_pixel   <= in_pixel;     
                                   out_x_dest  <= in_x_dest;    
                                   out_y_dest  <= in_y_dest;    
                                   out_step    <= in_step;      
                                   out_frame   <= in_frame;     
                                   out_x_orig  <= in_x_orig;    
                                   out_y_orig  <= in_y_orig;    
                                   out_fb      <= in_fb;        
                                   out_send    <= '1';           
                                   dec_ack <= '1';                               
                               else -- route East
                                   out_direction <= "000010";       
                                   out_pixel   <= in_pixel;         
                                   out_x_dest  <= in_x_dest;        
                                   out_y_dest  <= in_y_dest;        
                                   out_step    <= in_step;          
                                   out_frame   <= in_frame;         
                                   out_x_orig  <= in_x_orig;        
                                   out_y_orig  <= in_y_orig;        
                                   out_fb      <= in_fb;            
                                   out_send    <= '1';             
                                   dec_ack <= '1';                                 
                               end if;
                          elsif( (x_orig<x_init)and(y_orig<y_init) )then -- North-West region
                               --define now if route North or West first
                               if(NW='0')then-- route North
                                   out_direction <= "001000";
                                   out_pixel   <= in_pixel;
                                   out_x_dest  <= in_x_dest;
                                   out_y_dest  <= in_y_dest;
                                   out_step    <= in_step;
                                   out_frame   <= in_frame;
                                   out_x_orig  <= in_x_orig;
                                   out_y_orig  <= in_y_orig;
                                   out_fb      <= in_fb;
                                   out_send    <= '1';         
                                   dec_ack <= '1';                        
                               else-- route West
                                   out_direction <= "000001";   
                                   out_pixel   <= in_pixel;     
                                   out_x_dest  <= in_x_dest;    
                                   out_y_dest  <= in_y_dest;    
                                   out_step    <= in_step;      
                                   out_frame   <= in_frame;     
                                   out_x_orig  <= in_x_orig;    
                                   out_y_orig  <= in_y_orig;    
                                   out_fb      <= in_fb;        
                                   out_send    <= '1';     
                                   dec_ack <= '1';                           
                               end if;
                               NW <= not(NW);
                          elsif( (x_orig<x_init)and(y_orig>y_end) )then -- South-West region
                               -- define now if route South or West first
                               if(SW='0')then-- route South
                                   out_direction <= "000100";    
                                   out_pixel   <= in_pixel;      
                                   out_x_dest  <= in_x_dest;     
                                   out_y_dest  <= in_y_dest;     
                                   out_step    <= in_step;       
                                   out_frame   <= in_frame;      
                                   out_x_orig  <= in_x_orig;     
                                   out_y_orig  <= in_y_orig;     
                                   out_fb      <= in_fb;         
                                   out_send    <= '1';     
                                   dec_ack <= '1';                                  
                               else-- route West
                                   out_direction <= "000001";   
                                   out_pixel   <= in_pixel;     
                                   out_x_dest  <= in_x_dest;    
                                   out_y_dest  <= in_y_dest;    
                                   out_step    <= in_step;      
                                   out_frame   <= in_frame;     
                                   out_x_orig  <= in_x_orig;    
                                   out_y_orig  <= in_y_orig;    
                                   out_fb      <= in_fb;        
                                   out_send    <= '1';         
                                   dec_ack <= '1';                       
                               end if;       
                               SW <= not(SW);                    
                          elsif( (x_orig>x_end)and(y_orig<y_init) )then -- North-East region
                               -- define now if route North or East first
                               if(NE='0')then-- route North
                                   out_direction <= "001000";
                                   out_pixel   <= in_pixel;
                                   out_x_dest  <= in_x_dest;
                                   out_y_dest  <= in_y_dest;
                                   out_step    <= in_step;
                                   out_frame   <= in_frame;
                                   out_x_orig  <= in_x_orig;
                                   out_y_orig  <= in_y_orig;
                                   out_fb      <= in_fb;
                                   out_send    <= '1';                                 
                                   dec_ack <= '1';
                               else-- route East
                                   out_direction <= "000010";       
                                   out_pixel   <= in_pixel;         
                                   out_x_dest  <= in_x_dest;        
                                   out_y_dest  <= in_y_dest;        
                                   out_step    <= in_step;          
                                   out_frame   <= in_frame;         
                                   out_x_orig  <= in_x_orig;        
                                   out_y_orig  <= in_y_orig;        
                                   out_fb      <= in_fb;            
                                   out_send    <= '1';        
                                   dec_ack <= '1';                          
                               end if;
                               NE <= not(NE);
                          elsif( (x_orig>x_end)and(y_orig>y_end) )then -- South-East region
                               -- define now if route South or East first
                               if(SE='0')then-- route South
                                   out_direction <= "000100";    
                                   out_pixel   <= in_pixel;      
                                   out_x_dest  <= in_x_dest;     
                                   out_y_dest  <= in_y_dest;     
                                   out_step    <= in_step;       
                                   out_frame   <= in_frame;      
                                   out_x_orig  <= in_x_orig;     
                                   out_y_orig  <= in_y_orig;     
                                   out_fb      <= in_fb;         
                                   out_send    <= '1';    
                                   dec_ack <= '1';                                   
                               else-- route East
                                   out_direction <= "000010";       
                                   out_pixel   <= in_pixel;         
                                   out_x_dest  <= in_x_dest;        
                                   out_y_dest  <= in_y_dest;        
                                   out_step    <= in_step;          
                                   out_frame   <= in_frame;         
                                   out_x_orig  <= in_x_orig;        
                                   out_y_orig  <= in_y_orig;        
                                   out_fb      <= in_fb;            
                                   out_send    <= '1';    
                                   dec_ack <= '1';                              
                               end if;
                               SE <= not(SE);
                          end if;
                       
                       
                       end if;-- end fb
                   --end if;
                   counter <= 1;
               end if;--in ack=0 and in_new=1
           when 1 =>
                if(in_ack='1')then
                    dec_ack <= '0';
                    out_send <= '0';
                    counter <= 0;
                end if;
           when others =>
           
           end case;
        end if;
            
    end if;
end process;


end architecture behavioral;
