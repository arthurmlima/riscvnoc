-- file: pixel_mem.vhd
-- description: pixel array per processing element
-- pixel indexing - x coordinate: column
--		  - y coordinate: row
--                - intermediary image index: step
--                - current frame: frame

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity channel_scheduler is

generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural;
    buffer_length   : natural
);

port(

	clk : in std_logic;
	reset : in std_logic;
	--
	--out_busy       : out std_logic; -- to the arbiter
	--next_busy  : in std_logic; -- from the output controller
	--
	
    in_pixel     : in std_logic_vector(pix_depth-1 downto 0);
    in_x_dest    : in std_logic_vector(img_width-1 downto 0);
    in_y_dest    : in std_logic_vector(img_height-1 downto 0);
    in_step      : in std_logic_vector(n_steps-1 downto 0);
    in_frame     : in std_logic_vector(n_frames-1 downto 0);
    in_x_orig    : in std_logic_vector(img_width-1 downto 0);
    in_y_orig    : in std_logic_vector(img_height-1 downto 0);
    in_fb        : in std_logic;
	in_send      : in std_logic; -- signal from the decoder informing there is a new message to be sent
	out_ack      : inout std_logic;
	in_direction : in std_logic_vector(5 downto 0);
    --
    -- Pixel Memory Connection
    i_PM_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PM_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PM_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PM_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PM_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PM_fb     : out std_logic; -- identify if the it is a set_pixel or a set_pixel message.
    i_PM_new_msg: inout std_logic;
    i_PM_ack    : in std_logic;
    -- Processing Element connection
    i_PE_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PE_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PE_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PE_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PE_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PE_fb     : out std_logic; -- identify if the it is a set_pixel or a set_pixel message.
    i_PE_new_msg: inout std_logic;
    i_PE_ack    : in std_logic;
    --i_L_req    : out std_logic; -- message request
    --i_L_ack    : in std_logic; -- message acknowledge         
    -- North connection
    i_N_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_N_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_N_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_N_step   : out std_logic_vector(n_steps-1 downto 0);
    i_N_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_N_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_N_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_N_fb     : out std_logic; -- message forward/backward
    i_N_new_msg: inout std_logic;
    i_N_ack    : in  std_logic;
    --i_N_req    : out std_logic; -- message request
    --i_N_busy   : in std_logic; -- router is busy
    --i_N_ack    : in std_logic; -- message acknowledge     
    -- South connections
    i_S_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_S_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_S_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_S_step   : out std_logic_vector(n_steps-1 downto 0);
    i_S_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_S_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_S_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_S_fb     : out std_logic; -- message forward/backward
    i_S_new_msg: inout std_logic;
    i_S_ack    : in  std_logic;
    --i_S_req    : out std_logic; -- message request
    --i_S_busy   : in std_logic; -- router is busy
    --i_S_ack    : in std_logic; -- message acknowledge  
    -- East connections
    i_E_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_E_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_E_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_E_step   : out std_logic_vector(n_steps-1 downto 0);
    i_E_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_E_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_E_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_E_fb     : out std_logic; -- message forward/backward
    --i_E_req    : out std_logic; -- message request
    --i_E_busy   : in std_logic; -- router is busy
    i_E_new_msg: inout std_logic;
    i_E_ack    : in std_logic; -- message acknowledge
      
    -- West
    i_W_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_W_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_W_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_W_step   : out std_logic_vector(n_steps-1 downto 0);
    i_W_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_W_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_W_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_W_fb     : out std_logic; -- message forward/backward
    i_W_new_msg: inout std_logic;
    i_W_ack    : in std_logic
    --i_W_req    : out std_logic; -- message request
    --i_W_busy   : in std_logic; -- router is busy
    --i_W_ack    : in std_logic -- message acknowledge      
            
);
end entity channel_scheduler;

architecture behavioral of channel_scheduler is

--type ifx_t is
--record
--  data                        : std_logic_vector(127 downto 0);
--  address                     : std_logic_vector (19 downto 0); 
--  WrReq                       : std_logic;-- 
--  RdReq                       : std_logic; --
--end record;
--type Array_ifx_t is array (0 to 2) of ifx_t;

--constant IFX_T_0S : ifx_t := (data => (others =>'0'),
--                              address => (others=>'0'),
--                              WrReq => '0',
--                              RdReq => '0');

--signal pair_in : Array_ifx_t:= (others => IFX_T_0S);

type pix_message is
record
    busy      : std_logic; -- not part of the message, but flags if this position is clean or not.
    pixel     : std_logic_vector(pix_depth-1 downto 0);
    x_dest    : std_logic_vector(img_width-1 downto 0);
    y_dest    : std_logic_vector(img_height-1 downto 0);
    step      : std_logic_vector(n_steps-1 downto 0);
    frame     : std_logic_vector(n_frames-1 downto 0);
    x_orig    : std_logic_vector(img_width-1 downto 0);
    y_orig    : std_logic_vector(img_height-1 downto 0);
    fb        : std_logic;
    --send      : std_logic; -- signal from the decoder informing there is a new message to be sent
    direction : std_logic_vector(5 downto 0);    
end record;
type message_storage is array(0 to (buffer_length-1)) of pix_message;
constant pix_message_clean : pix_message := (busy => '0',
                                             pixel => (others =>'0'),
                                             x_dest => (others =>'0'),
                                             y_dest => (others =>'0'),
                                             step => (others =>'0'),
                                             frame => (others =>'0'),
                                             x_orig => (others =>'0'),
                                             y_orig => (others =>'0'),
                                             fb => '0',
                                             direction => (others =>'0'));
                                             
signal storage : message_storage := (others => pix_message_clean);
	-- BRAM
    attribute rom_style : string;
    attribute rom_style of storage       : signal is "block"; -- block for BRAM / distributed for LUT

signal wr_ptr : natural := 0;
signal rd_ptr : natural := 0;
signal rd_ptr_temp : natural := 0;
signal msg_out : std_logic := '0';
--signal flags : std_logic_vector( (buffer_length-1)downto 0);
type flag_type is array(0 to (buffer_length-1)) of std_logic_vector(6 downto 0);-- 1 (busy), 6 (direction)
signal flags : flag_type;

signal free_buffer : std_logic_vector((buffer_length-1) downto 0);
signal new_wr : natural := 0;
signal gambiarra : natural := 0;

signal state : natural := 0;

signal out_message : pix_message := pix_message_clean;
signal sent_PM : std_logic := '0';
signal sent_PE : std_logic := '0';
signal sent_N  : std_logic := '0';
signal sent_S  : std_logic := '0';
signal sent_E  : std_logic := '0';
signal sent_W  : std_logic := '0';

signal busy : std_logic_vector(5 downto 0);

signal counter : natural := 0;

function rd_ptr_updateBKP(flags_v:flag_type; busy:std_logic_vector; rd_ptr_temp:natural) return natural is
    variable counter : natural := 0;
    variable result : natural := 0;
    variable match : std_logic := '0';
--    variable used : std_logic := '0';
    variable direction : std_logic_vector(5 downto 0) := "000000";
    variable tmp_flag : std_logic_vector(5 downto 0) := "000000";
    begin
        --scan flags_v until finds a match
        for counter in rd_ptr_temp to (buffer_length-1) loop
            if(flags_v(counter)(6)='1')then
            
                direction := (flags_v(counter)(5 downto 0));
                tmp_flag := direction and (not(busy));
                if( (tmp_flag(5) or tmp_flag(4) or tmp_flag(3) or tmp_flag(2) or tmp_flag(1) or tmp_flag(0))='1')then
                    result := counter + 1;
                    --match := '1';
                    exit;
                end if;
            
            end if;
        end loop;

    return result;
end function rd_ptr_updateBKP;

function wr_ptr_updateBKP(flags_v:flag_type; wr_ptr:natural) return natural is
    variable counter : natural := 0;
    variable result : natural := 0;
    variable used : std_logic := '0';
    
    begin
    
        for counter in (buffer_length-1) downto wr_ptr loop
            if(flags_v(counter)(6)='0')then
                result := counter;
            end if;
        end loop;
        

    return result;
end function wr_ptr_updateBKP;

function wr_ptr_update(flags_v:flag_type; wr_ptr:natural) return natural is
    variable counter : integer := buffer_length-1;
    variable result : natural := 0;
    variable used : std_logic := '0';
    
    begin
        
        while counter >= wr_ptr loop
            if(flags_v(counter)(6)='0')then
                result := counter;
            end if;
            counter := counter - 1;
        end loop;
        

    return result;
end function wr_ptr_update;

function rd_ptr_update(flags_v:flag_type; busy:std_logic_vector; rd_ptr_temp:natural) return natural is
    variable counter : natural := rd_ptr_temp;
    variable result : natural := 0;
    variable match : std_logic := '0';
--    variable used : std_logic := '0';
    variable direction : std_logic_vector(5 downto 0) := "000000";
    variable tmp_flag : std_logic_vector(5 downto 0) := "000000";
    variable limiter : natural := 0;
    constant MAX_IT : natural := buffer_length;
    
    begin
    
  ------------------

  ------------------
        --scan flags_v until finds a match
        while (counter <=(buffer_length-1)) and limiter <MAX_IT loop
          if(flags_v(counter)(6)='1')then
        
                direction := (flags_v(counter)(5 downto 0));
                tmp_flag := direction and (not(busy));
                if( (tmp_flag(5) or tmp_flag(4) or tmp_flag(3) or tmp_flag(2) or tmp_flag(1) or tmp_flag(0))='1')then
                    result := counter + 1;
                    --match := '1';
                    exit;
                end if;
        
            end if;          
            counter := counter+1;  
            limiter := limiter + 1;
        end loop;

    return result;
end function rd_ptr_update;

function log2_unsigned ( x : natural ) return natural is
        variable temp : natural := x ;
        variable n : natural := 0 ;
    begin
        while temp > 1 loop
            temp := temp / 2 ;
            n := n + 1 ;
        end loop ;
        return n ;
    end function log2_unsigned ;

function update_wr(free_buffer:std_logic_vector) return natural is
    variable one_hot : std_logic_vector((buffer_length-1)downto 0);
    variable result : natural := 0;
    --variable log : natural := 0;
begin
    -- first compute the two complement
    one_hot := (free_buffer and std_logic_vector(unsigned(not((free_buffer)))+1));
    result := log2_unsigned(to_integer(unsigned(one_hot)));
    --result := log2_unsigned(0);
    
    --return (result+1);
    return result;
end function update_wr;



begin
    --
--    GEN_REG: 
--    for I in 0 to 3 generate
--        REGX : REG port map
--        (DIN(I), CLK, RESET, DOUT(I));
--    end generate GEN_REG;
--a <= std_logic_vector(unsigned(not(a)) + 1);
    gen_flags:
        for i in 0 to (buffer_length-1) generate
            flags(i) <= storage(i).busy & storage(i).direction;
        end generate gen_flags;
   
   gen_free_buffer:
        for i in 0 to (buffer_length-1) generate
            free_buffer((buffer_length-1)-i) <= storage(i).busy;
        end generate gen_free_buffer;
   
    --busy <= i_PM_ack & i_PE_ack & i_N_ack & i_S_ack & i_E_ack & i_W_ack;
    busy <= (i_PM_ack) & (i_PE_ack) & (i_N_ack) & (i_S_ack)& (i_E_ack) & (i_W_ack);
   



process(clk, reset) is
begin
    if(reset='1')then
        -- WRITE
        wr_ptr <= 0;
        out_ack <= '0';
        -- READ
        -- cleans the storage and the outputs
        storage <= (others => pix_message_clean);
        --wr_ptr <= 0;
        rd_ptr <= 0;
        rd_ptr_temp <= 0;
        msg_out <= '0';
        state <= 0;
            -- Pixel Memory Connection
        i_PM_pixel  <= (others => '0');
        i_PM_x_dest <= (others => '0');
        i_PM_y_dest <= (others => '0');
        i_PM_step   <= (others => '0');
        i_PM_frame  <= (others => '0');
        i_PM_x_orig <= (others => '0');
        i_PM_y_orig <= (others => '0');
        i_PM_fb     <= '0';
        i_PM_new_msg<= '0';
        --i_PM_ack    : in std_logic;
        -- Processing Element connection
        i_PE_pixel  <= (others => '0');
        i_PE_x_dest <= (others => '0');
        i_PE_y_dest <= (others => '0');
        i_PE_step   <= (others => '0');
        i_PE_frame  <= (others => '0');
        i_PE_x_orig <= (others => '0');
        i_PE_y_orig <= (others => '0');
        i_PE_fb     <= '0';
        i_PE_new_msg<= '0';
        --i_PE_ack    : in std_logic;
        --i_L_req    : out std_logic; -- message request
        --i_L_ack    : in std_logic; -- message acknowledge         
        -- North connection
        i_N_pixel  <= (others => '0');
        i_N_x_dest <= (others => '0');
        i_N_y_dest <= (others => '0');
        i_N_step   <= (others => '0');
        i_N_frame  <= (others => '0');
        i_N_x_orig <= (others => '0');
        i_N_y_orig <= (others => '0');
        i_N_fb     <= '0';
        i_N_new_msg<= '0';
        --i_N_ack    : in  std_logic;
        --i_N_req    : out std_logic; -- message request
        --i_N_busy   : in std_logic; -- router is busy
        --i_N_ack    : in std_logic; -- message acknowledge     
        -- South connections
        i_S_pixel  <= (others => '0');
        i_S_x_dest <= (others => '0');
        i_S_y_dest <= (others => '0');
        i_S_step   <= (others => '0');
        i_S_frame  <= (others => '0');
        i_S_x_orig <= (others => '0');
        i_S_y_orig <= (others => '0');
        i_S_fb     <= '0';
        i_S_new_msg<= '0';
        --i_S_ack    : in  std_logic;
        --i_S_req    : out std_logic; -- message request
        --i_S_busy   : in std_logic; -- router is busy
        --i_S_ack    : in std_logic; -- message acknowledge  
        -- East connections
        i_E_pixel  <= (others => '0');
        i_E_x_dest <= (others => '0');
        i_E_y_dest <= (others => '0');
        i_E_step   <= (others => '0');
        i_E_frame  <= (others => '0');
        i_E_x_orig <= (others => '0');
        i_E_y_orig <= (others => '0');
        i_E_fb     <= '0';
        --i_E_req  <= 
        --i_E_busy <= 
        i_E_new_msg<= '0';
        --i_E_ack    : in std_logic; -- message acknowledge
          
        -- West
        i_W_pixel  <= (others => '0');
        i_W_x_dest <= (others => '0');
        i_W_y_dest <= (others => '0');
        i_W_step   <= (others => '0');
        i_W_frame  <= (others => '0');
        i_W_x_orig <= (others => '0');
        i_W_y_orig <= (others => '0');
        i_W_fb     <= '0';
        i_W_new_msg<= '0';
        --i_W_ack    : in std_logic
        
    else
        if(rising_edge(clk))then
            --WRITE
            wr_ptr <= wr_ptr_update(flags, wr_ptr);
            --new_wr <= update_wr(free_buffer);
            --wr_ptr <= update_wr(free_buffer);

                    if(in_send='1' and out_ack <= '0')then
                        storage(wr_ptr).busy    <= '1';
                        storage(wr_ptr).pixel   <= in_pixel;
                        storage(wr_ptr).x_dest  <= in_x_dest;
                        storage(wr_ptr).y_dest  <= in_y_dest; 
                        storage(wr_ptr).step    <= in_step;
                        storage(wr_ptr).frame   <= in_frame;
                        storage(wr_ptr).x_orig  <= in_x_orig;
                        storage(wr_ptr).y_orig  <= in_y_orig;
                        storage(wr_ptr).fb      <= in_fb;
                        storage(wr_ptr).direction <= in_direction;
                        out_ack  <= '1';
                        --counter <= 1;
                    else
                        out_ack <= '0';
                    end if;
          
            -- READ
            -- the rd_ptr can only be updated if the output message has been successfully sent
      

--                    rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                    if(rd_ptr_temp>0 and msg_out='0')then
                    --if(msg_out='0')then
                    --if(gambiarra>0)then    
                        rd_ptr <= rd_ptr_temp-1;
                        out_message <= storage(rd_ptr);
                    
       
                        case out_message.direction is
                        
                        when "100000" => -- Pixel Memory
                            --if(i_PM_ack='0' and i_PM_new_msg='0')then
                                i_PM_pixel   <= out_message.pixel;
                                i_PM_x_dest  <= out_message.x_dest;
                                i_PM_y_dest  <= out_message.y_dest; 
                                i_PM_step    <= out_message.step;
                                i_PM_frame   <= out_message.frame;
                                i_PM_x_orig  <= out_message.x_orig;
                                i_PM_y_orig  <= out_message.y_orig;
                                i_PM_fb      <= out_message.fb;
                                i_PM_new_msg <= '1';
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when "010000" => -- Processing Element
                            --if(i_PE_ack='0' and i_PE_new_msg='0')then
                                i_PE_pixel   <= out_message.pixel; 
                                i_PE_x_dest  <= out_message.x_dest;
                                i_PE_y_dest  <= out_message.y_dest;
                                i_PE_step    <= out_message.step;  
                                i_PE_frame   <= out_message.frame; 
                                i_PE_x_orig  <= out_message.x_orig;
                                i_PE_y_orig  <= out_message.y_orig;
                                i_PE_fb      <= out_message.fb;    
                                i_PE_new_msg <= '1';
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when "001000" => -- North
                            --if(i_N_ack='0' and i_N_new_msg='0')then
                                i_N_pixel  <= out_message.pixel; 
                                i_N_x_dest <= out_message.x_dest;
                                i_N_y_dest <= out_message.y_dest;
                                i_N_step   <= out_message.step;  
                                i_N_frame  <= out_message.frame; 
                                i_N_x_orig <= out_message.x_orig;
                                i_N_y_orig <= out_message.y_orig;
                                i_N_fb     <= out_message.fb;    
                                i_N_new_msg <= '1';
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when "000100" => -- South
                            --if(i_S_ack='1' and i_S_new_msg='0')then
                                i_S_pixel  <= out_message.pixel; 
                                i_S_x_dest <= out_message.x_dest;
                                i_S_y_dest <= out_message.y_dest;
                                i_S_step   <= out_message.step;  
                                i_S_frame  <= out_message.frame; 
                                i_S_x_orig <= out_message.x_orig;
                                i_S_y_orig <= out_message.y_orig;
                                i_S_fb     <= out_message.fb;          
                                i_S_new_msg <= '1';
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when "000010" => -- East
                            --if(i_E_ack='1' and i_E_new_msg='0')then
                                i_E_pixel  <= out_message.pixel; 
                                i_E_x_dest <= out_message.x_dest;
                                i_E_y_dest <= out_message.y_dest;
                                i_E_step   <= out_message.step;  
                                i_E_frame  <= out_message.frame; 
                                i_E_x_orig <= out_message.x_orig;
                                i_E_y_orig <= out_message.y_orig;
                                i_E_fb     <= out_message.fb;    
                                i_E_new_msg <= '1';
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when "000001" => -- West
                            --if(i_W_ack='1' and i_W_new_msg='0')then
                                i_W_pixel  <= out_message.pixel; 
                                i_W_x_dest <= out_message.x_dest;
                                i_W_y_dest <= out_message.y_dest;
                                i_W_step   <= out_message.step;  
                                i_W_frame  <= out_message.frame; 
                                i_W_x_orig <= out_message.x_orig;
                                i_W_y_orig <= out_message.y_orig;
                                i_W_fb     <= out_message.fb;    
                                i_W_new_msg <= '1';    
                                --storage(rd_ptr).busy <= '0';
                                msg_out<='1';
                            --end if;
            
                        when others =>

                        end case;
                    
                    else
                        if(i_PM_ack = '1')then
                            i_PM_new_msg <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                                
        
                        elsif(i_PE_ack = '1')then
                            i_PE_new_msg <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                                    
        
                        elsif(i_N_ack = '1')then
                            i_N_new_msg  <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                                    
         
                        elsif(i_S_ack = '1')then
                            i_S_new_msg  <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                        
        
                        elsif(i_E_ack = '1')then
                            i_E_new_msg  <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                                        
          
                        elsif(i_W_ack = '1')then
                            i_W_new_msg  <= '0';
                            storage(rd_ptr) <= pix_message_clean; 
                            out_message <= pix_message_clean;
                            msg_out<='0';
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                        
                        else
                            rd_ptr_temp <= rd_ptr_update(flags, busy, rd_ptr_temp);
                        end if;             
                end if;
        end if;--clk
    end if;--reset
end process;    
    

end architecture behavioral;
