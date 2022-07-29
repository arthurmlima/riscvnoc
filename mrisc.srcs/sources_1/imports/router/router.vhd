-- Router 
-- Version 1.0
-- This a bufferless router with lockable requests (using the 'busy' signal)
-- This version is able to receive requests from PE to access PM (write and read)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity router is

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

port(
	clk : in std_logic;
    reset : in std_logic;
    ------------------------------------------------------------
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
    
    i_PM_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PM_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PM_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PM_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PM_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PM_fb     : out std_logic; -- message forward/backward
    i_PM_req    : inout std_logic; -- message request
    --t_PM_busy   : out std_logic; -- router is busy
    i_PM_ack    : in std_logic; -- message acknowledge  
     
    -- New Local target ports - the PE requests values using these ports.
    i_PE_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PE_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PE_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PE_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PE_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PE_fb     : out std_logic; -- message forward/backward
    i_PE_req    : inout std_logic; -- message request
   --iPEN_busy   : in std_logic; -- router is busy
    i_PE_ack    : in std_logic; -- message acknowledge  
        
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
    ------------------------------------------------------------
    -- North connections
    i_N_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_N_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_N_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_N_step   : out std_logic_vector(n_steps-1 downto 0);
    i_N_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_N_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_N_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_N_fb     : out std_logic; -- message forward/backward
    i_N_req    : inout std_logic; -- message request
   --i_N_busy   : in std_logic; -- router is busy
    i_N_ack    : in std_logic; -- message acknowledge  
     
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
    -------------------------------------------------------------
    -- South connections
    i_S_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_S_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_S_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_S_step   : out std_logic_vector(n_steps-1 downto 0);
    i_S_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_S_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_S_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_S_fb     : out std_logic; -- message forward/backward
    i_S_req    : inout std_logic; -- message request
    --i_S_busy   : in std_logic; -- router is busy
    i_S_ack    : in std_logic; -- message acknowledge  
     
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
    ---------------------------------------------------------------
    -- East connections
    i_E_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_E_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_E_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_E_step   : out std_logic_vector(n_steps-1 downto 0);
    i_E_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_E_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_E_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_E_fb     : out std_logic; -- message forward/backward
    i_E_req    : inout std_logic; -- message request
    --i_E_busy   : in std_logic; -- router is busy
    i_E_ack    : in std_logic; -- message acknowledge  
    
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
    -----------------------------------------------------------------
    -- West
    i_W_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_W_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_W_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_W_step   : out std_logic_vector(n_steps-1 downto 0);
    i_W_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_W_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_W_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_W_fb     : out std_logic; -- message forward/backward
    i_W_req    : inout std_logic; -- message request
    --i_W_busy   : in std_logic; -- router is busy
    i_W_ack    : in std_logic; -- message acknowledge  
     
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
    t_W_ack    : out std_logic -- message acknowledge        
        	
);

end entity router;

architecture behavioral of router is
	--------------------------------------------------------------
	-- Input Selector component
component input_arbiter
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
    clk : in std_logic;
    reset : in std_logic;
    -- from/to arbiter
    --in_sel_trigger : in std_logic;-- signal from arbiter to trigger the capture
    --sel_dir  : in std_logic_vector(5 downto 0); -- selected direction, hotspot codification
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
    out_new     : inout std_logic;
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
end component;


component decoder
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
	in_new     : in std_logic; -- signal from the input_selector, informing that a new message is ready to be decoded.
	dec_ack    : out std_logic;
	--next_busy  : in std_logic; -- from the output controller
    in_pixel   : in std_logic_vector(pix_depth-1 downto 0);
    in_x_dest  : in std_logic_vector(img_width-1 downto 0);
    in_y_dest  : in std_logic_vector(img_height-1 downto 0);
    in_step    : in std_logic_vector(n_steps-1 downto 0);
    in_frame   : in std_logic_vector(n_frames-1 downto 0);
    in_x_orig  : in std_logic_vector(img_width-1 downto 0);
    in_y_orig  : in std_logic_vector(img_height-1 downto 0);
    in_fb      : in std_logic;
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
end component;

--component output_controller
component channel_scheduler
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
	in_direction : in std_logic_vector(5 downto 0);
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
    --
    -- Pixel Memory Connection
    --mem_busy      : in std_logic;
    --mem_ack       : in std_logic;
    --adc_lock  : out std_logic;
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

end component;

component out_pm_controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);

port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_PM_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_PM_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_PM_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_PM_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_PM_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_PM_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_PM_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_PM_fb     : in std_logic; -- message forward/backward
    oc_PM_new_msg: in std_logic;
    oc_PM_ack    : out  std_logic;
    -- connections to the next router
    i_PM_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PM_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PM_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PM_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PM_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PM_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PM_fb     : out std_logic; -- message forward/backward
    i_PM_req    : inout std_logic;
    i_PM_ack    : in  std_logic   
    
);

end component;

component out_PE_controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);
port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_PE_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_PE_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_PE_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_PE_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_PE_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_PE_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_PE_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_PE_fb     : in std_logic; -- message forward/backward
    oc_PE_new_msg: in std_logic;
    oc_PE_ack    : out  std_logic;
    -- connections to the next router
    i_PE_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_PE_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_PE_step   : out std_logic_vector(n_steps-1 downto 0);
    i_PE_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_PE_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_PE_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_PE_fb     : out std_logic; -- message forward/backward
    i_PE_req    : inout std_logic;
    i_PE_ack    : in  std_logic   
      
);
end component;

component out_North_controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);
port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_N_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_N_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_N_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_N_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_N_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_N_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_N_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_N_fb     : in std_logic; -- message forward/backward
    oc_N_new_msg: in std_logic;
    oc_N_ack    : out  std_logic;
    -- connections to the next router
    i_N_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_N_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_N_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_N_step   : out std_logic_vector(n_steps-1 downto 0);
    i_N_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_N_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_N_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_N_fb     : out std_logic; -- message forward/backward
    i_N_req    : inout std_logic;
    i_N_ack    : in  std_logic   
    
);
end component;

component out_South_controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);
port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_S_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_S_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_S_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_S_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_S_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_S_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_S_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_S_fb     : in std_logic; -- message forward/backward
    oc_S_new_msg: in std_logic;
    oc_S_ack    : out  std_logic;
    -- connections to the next router
    i_S_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_S_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_S_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_S_step   : out std_logic_vector(n_steps-1 downto 0);
    i_S_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_S_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_S_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_S_fb     : out std_logic; -- message forward/backward
    i_S_req: inout std_logic;
    i_S_ack    : in  std_logic   
    
);
end component;

component out_East_Controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);
port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_E_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_E_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_E_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_E_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_E_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_E_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_E_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_E_fb     : in std_logic; -- message forward/backward
    oc_E_new_msg: in std_logic;
    oc_E_ack    : out  std_logic;
    -- connections to the next router
    i_E_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_E_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_E_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_E_step   : out std_logic_vector(n_steps-1 downto 0);
    i_E_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_E_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_E_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_E_fb     : out std_logic; -- message forward/backward
    i_E_req: inout std_logic;
    i_E_ack    : in  std_logic   
    
);
end component;

component out_West_controller
generic(
    x_init          : integer := 0;
    y_init          : integer := 0;
    img_width       : natural;
    img_height      : natural;
    n_frames        : natural;
    n_steps         : natural;
    pix_depth       : natural
);
port(
	clk : in std_logic;
	reset : in std_logic;
	-- connections with the output controller
    oc_W_pixel  : in std_logic_vector(pix_depth-1 downto 0);
    oc_W_x_dest : in std_logic_vector(img_width-1 downto 0);
    oc_W_y_dest : in std_logic_vector(img_height-1 downto 0);
    oc_W_step   : in std_logic_vector(n_steps-1 downto 0);
    oc_W_frame  : in std_logic_vector(n_frames-1 downto 0);
    oc_W_x_orig : in std_logic_vector(img_width-1 downto 0);
    oc_W_y_orig : in std_logic_vector(img_height-1 downto 0);
    oc_W_fb     : in std_logic; -- message forward/backward
    oc_W_new_msg: in std_logic;
    oc_W_ack    : out  std_logic;
    -- connections to the next router
    i_W_pixel  : out std_logic_vector(pix_depth-1 downto 0);
    i_W_x_dest : out std_logic_vector(img_width-1 downto 0);
    i_W_y_dest : out std_logic_vector(img_height-1 downto 0);
    i_W_step   : out std_logic_vector(n_steps-1 downto 0);
    i_W_frame  : out std_logic_vector(n_frames-1 downto 0);
    i_W_x_orig : out std_logic_vector(img_width-1 downto 0);
    i_W_y_orig : out std_logic_vector(img_height-1 downto 0);
    i_W_fb     : out std_logic; -- message forward/backward
    i_W_req: inout std_logic;
    i_W_ack    : in  std_logic   
    
);
end component;

-- signals to connect the Pixel Memory
-- not needed yet
------------------------------------------------------------------------------------------
-- signals to connect the Arbiter
    signal in_sel_trigger : std_logic;
    --signal next_busy : std_logic:='0';
    signal sel_dir  : std_logic_vector(5 downto 0); 
-------------------------------------------------------------------------------------------   
-- signals to connect to the Input Selector
    --signal in_sel_trigger : std_logic;-- signal from arbiter to trigger the capture
    --signal sel_dir  : std_logic_vector(4 downto 0); -- selected direction, hotspot codification
    -- output selected message
    signal in_new     : std_logic;
    signal dec_ack    : std_logic;
    signal out_pixel   : std_logic_vector(pix_depth-1 downto 0);
    signal out_x_dest  : std_logic_vector(img_width-1 downto 0);
    signal out_y_dest  : std_logic_vector(img_height-1 downto 0);
    signal out_step    : std_logic_vector(n_steps-1 downto 0);
    signal out_frame   : std_logic_vector(n_frames-1 downto 0);
    signal out_x_orig  : std_logic_vector(img_width-1 downto 0);
    signal out_y_orig  : std_logic_vector(img_height-1 downto 0);
    signal out_fb      : std_logic;       

    signal dec_pixel   : std_logic_vector(pix_depth-1 downto 0);
    signal dec_x_dest  : std_logic_vector(img_width-1 downto 0);
    signal dec_y_dest  : std_logic_vector(img_height-1 downto 0);
    signal dec_step    : std_logic_vector(n_steps-1 downto 0);
    signal dec_frame   : std_logic_vector(n_frames-1 downto 0);
    signal dec_x_orig  : std_logic_vector(img_width-1 downto 0);
    signal dec_y_orig  : std_logic_vector(img_height-1 downto 0);
    signal dec_fb      : std_logic;  
    signal dec_send    : std_logic;    
    signal dec_out_direction : std_logic_vector(5 downto 0);
    
    --signal o_contr_busy: std_logic;

    -----------------------------------------------
    -- signals for the output_controller
    signal oc_PM_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_PM_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_PM_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_PM_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_PM_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_PM_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_PM_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_PM_fb     :  std_logic; -- identify if the it is a set_pixel or a set_pixel message.
    signal oc_PM_req    :  std_logic; -- message request
    signal oc_PM_new_msg:  std_logic;
    signal oc_PM_ack    : std_logic; -- message acknowledge    
    -- Processing Element connection
    signal oc_PE_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_PE_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_PE_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_PE_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_PE_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_PE_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_PE_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_PE_fb     :  std_logic; -- identify if the it is a set_pixel or a set_pixel message.
    signal oc_PE_req    :  std_logic; -- message request
    signal oc_PE_new_msg:  std_logic;
    signal oc_PE_ack    : std_logic; -- message acknowledge         
    -- North connection
    signal oc_N_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_N_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_N_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_N_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_N_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_N_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_N_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_N_fb     :  std_logic; -- message forward/backward
    signal oc_N_req    :  std_logic; -- message request
    --signal oc_N_busy   : std_logic; -- router is busy
    signal oc_N_new_msg: std_logic;
    signal oc_N_ack    : std_logic; -- message acknowledge     
    -- South connections
    signal oc_S_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_S_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_S_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_S_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_S_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_S_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_S_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_S_fb     :  std_logic; -- message forward/backward
    signal oc_S_req    :  std_logic; -- message request
    --signal oc_S_busy   : std_logic; -- router is busy
    signal oc_S_new_msg: std_logic;
    signal oc_S_ack    : std_logic; -- message acknowledge  
    -- East connections
    signal oc_E_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_E_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_E_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_E_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_E_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_E_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_E_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_E_fb     :  std_logic; -- message forward/backward
    signal oc_E_req    :  std_logic; -- message request
    --signal oc_E_busy   : std_logic; -- router is busy
    signal oc_E_new_msg: std_logic;
    signal oc_E_ack    : std_logic; -- message acknowledge  
    -- West
    signal oc_W_pixel  :  std_logic_vector(pix_depth-1 downto 0);
    signal oc_W_x_dest :  std_logic_vector(img_width-1 downto 0);
    signal oc_W_y_dest :  std_logic_vector(img_height-1 downto 0);
    signal oc_W_step   :  std_logic_vector(n_steps-1 downto 0);
    signal oc_W_frame  :  std_logic_vector(n_frames-1 downto 0);
    signal oc_W_x_orig :  std_logic_vector(img_width-1 downto 0);
    signal oc_W_y_orig :  std_logic_vector(img_height-1 downto 0);
    signal oc_W_fb     :  std_logic; -- message forward/backward
    signal oc_W_req    :  std_logic; -- message request
    --signal oc_W_busy   : std_logic; -- router is busy
    signal oc_W_new_msg: std_logic;
    signal oc_W_ack    : std_logic; -- message acknowledge      
    
    signal oc_dec_ack  : std_logic;
    -----------------------------------------------
    
    
    
begin


    
input_arbiter_inst : input_arbiter
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
    clk => clk,
    reset => reset,
    --in_sel_trigger => in_sel_trigger,
    --sel_dir    => sel_dir   ,

    t_PM_pixel  => t_PM_pixel ,
    t_PM_x_dest => t_PM_x_dest,
    t_PM_y_dest => t_PM_y_dest,
    t_PM_step   => t_PM_step  ,
    t_PM_frame  => t_PM_frame ,
    t_PM_x_orig => t_PM_x_orig,
    t_PM_y_orig => t_PM_y_orig,
    t_PM_fb     => t_PM_fb    ,
    t_PM_req    => t_PM_req   ,
    t_PM_ack    => t_PM_ack   ,

    t_PE_pixel  => t_PE_pixel  ,
    t_PE_x_dest => t_PE_x_dest ,
    t_PE_y_dest => t_PE_y_dest ,
    t_PE_step   => t_PE_step   ,
    t_PE_frame  => t_PE_frame  ,
    t_PE_x_orig => t_PE_x_orig ,
    t_PE_y_orig => t_PE_y_orig ,
    t_PE_fb     => t_PE_fb     ,
    t_PE_req    => t_PE_req    ,
    t_PE_ack    => t_PE_ack,

    t_N_pixel  => t_N_pixel ,
    t_N_x_dest => t_N_x_dest,
    t_N_y_dest => t_N_y_dest,
    t_N_step   => t_N_step  ,
    t_N_frame  => t_N_frame ,
    t_N_x_orig => t_N_x_orig,
    t_N_y_orig => t_N_y_orig,
    t_N_fb     => t_N_fb    ,
    t_N_req    => t_N_req   ,
    --t_N_busy   => t_N_busy  ,
    t_N_ack    => t_N_ack   ,

    t_S_pixel  => t_S_pixel ,
    t_S_x_dest => t_S_x_dest,
    t_S_y_dest => t_S_y_dest,
    t_S_step   => t_S_step  ,
    t_S_frame  => t_S_frame ,
    t_S_x_orig => t_S_x_orig,
    t_S_y_orig => t_S_y_orig,
    t_S_fb     => t_S_fb    ,
    t_S_req    => t_S_req   ,
    --t_S_busy   => t_S_busy  ,
    t_S_ack    => t_S_ack   ,

    t_E_pixel  => t_E_pixel ,
    t_E_x_dest => t_E_x_dest,
    t_E_y_dest => t_E_y_dest,
    t_E_step   => t_E_step  ,
    t_E_frame  => t_E_frame ,
    t_E_x_orig => t_E_x_orig,
    t_E_y_orig => t_E_y_orig,
    t_E_fb     => t_E_fb    ,
    t_E_req    => t_E_req   ,
    --t_E_busy   => t_E_busy  ,
    t_E_ack    => t_E_ack   ,

    t_W_pixel  => t_W_pixel ,
    t_W_x_dest => t_W_x_dest,
    t_W_y_dest => t_W_y_dest,
    t_W_step   => t_W_step  ,
    t_W_frame  => t_W_frame ,
    t_W_x_orig => t_W_x_orig,
    t_W_y_orig => t_W_y_orig,
    t_W_fb     => t_W_fb    ,
    t_W_req    => t_W_req   ,
    --t_W_busy   => t_W_busy  ,
    t_W_ack    => t_W_ack   ,

    out_new    => in_new,
    dec_ack    => dec_ack,
    out_pixel  => out_pixel ,
    out_x_dest => out_x_dest,
    out_y_dest => out_y_dest,
    out_step   => out_step  ,
    out_frame  => out_frame ,
    out_x_orig => out_x_orig,
    out_y_orig => out_y_orig,
    out_fb     => out_fb    

);    

decoder_inst : decoder
generic map(
    x_init          => x_init,
    y_init          => y_init,
    img_width       => img_width ,
    img_height      => img_height,
    n_frames        => n_frames  ,
    n_steps         => n_steps   ,
    pix_depth       => pix_depth,
    subimg_width    => subimg_width,
    subimg_height   => subimg_height
    )
port map(
	clk        =>    clk       ,
	reset      =>    reset     ,
	--next_busy  =>    o_contr_busy,
	in_new     =>    in_new    ,
	dec_ack    =>    dec_ack,
    in_pixel   =>    out_pixel  ,
    in_x_dest  =>    out_x_dest ,
    in_y_dest  =>    out_y_dest ,
    in_step    =>    out_step   ,
    in_frame   =>    out_frame  ,
    in_x_orig  =>    out_x_orig ,
    in_y_orig  =>    out_y_orig ,
    in_fb      =>    out_fb     ,
    out_pixel  =>    dec_pixel ,
    out_x_dest =>    dec_x_dest,
    out_y_dest =>    dec_y_dest,
    out_step   =>    dec_step  ,
    out_frame  =>    dec_frame ,
    out_x_orig =>    dec_x_orig,
    out_y_orig =>    dec_y_orig,
    out_fb     =>    dec_fb    ,
    out_send   =>    dec_send,
    in_ack     =>    oc_dec_ack,
    out_direction => dec_out_direction  
);

--output_controller_inst : output_controller
channel_scheduler_inst : channel_scheduler
generic map(
    x_init          => x_init,
    y_init          => y_init,
    img_width       => img_width ,
    img_height      => img_height,
    n_frames        => n_frames  ,
    n_steps         => n_steps   ,
    pix_depth       => pix_depth,
    buffer_length   => buffer_length
    )
port map(

	clk => clk,
	reset => reset,
	--
	--out_busy     => o_contr_busy,
	--
	
    in_pixel     => dec_pixel,
    in_x_dest    => dec_x_dest,
    in_y_dest    => dec_y_dest,
    in_step      => dec_step,
    in_frame     => dec_frame,
    in_x_orig    => dec_x_orig,
    in_y_orig    => dec_y_orig,
    in_fb        => dec_fb,
	in_send      => dec_send,
	out_ack      => oc_dec_ack,
	in_direction => dec_out_direction,
    --
    -- Pixel Memory Connection
    i_PM_pixel   => oc_PM_pixel  ,
    i_PM_x_dest  => oc_PM_x_dest ,
    i_PM_y_dest  => oc_PM_y_dest ,
    i_PM_step    => oc_PM_step   ,
    i_PM_frame   => oc_PM_frame  ,
    i_PM_x_orig  => oc_PM_x_orig ,
    i_PM_y_orig  => oc_PM_y_orig ,
    i_PM_fb      => oc_PM_fb     ,
    i_PM_new_msg => oc_PM_new_msg,
    i_PM_ack     => oc_PM_ack    ,
    --i_PM_ack     => '1',
    -- Processin => oc_PMrocessin,
    i_PE_pixel   => oc_PE_pixel  ,
    i_PE_x_dest  => oc_PE_x_dest ,
    i_PE_y_dest  => oc_PE_y_dest ,
    i_PE_step    => oc_PE_step   ,
    i_PE_frame   => oc_PE_frame  ,
    i_PE_x_orig  => oc_PE_x_orig ,
    i_PE_y_orig  => oc_PE_y_orig ,
    i_PE_fb      => oc_PE_fb     ,
    i_PE_new_msg => oc_PE_new_msg,
    i_PE_ack     => oc_PE_ack    ,

    -- North connection
    i_N_pixel  => oc_N_pixel,
    i_N_x_dest => oc_N_x_dest,
    i_N_y_dest => oc_N_y_dest,
    i_N_step   => oc_N_step,
    i_N_frame  => oc_N_frame,
    i_N_x_orig => oc_N_x_orig,
    i_N_y_orig => oc_N_y_orig,
    i_N_fb     => oc_N_fb,
    i_N_new_msg=> oc_N_new_msg,
    i_N_ack    => oc_N_ack,
    --i_N_req    => oc_N_req,
    --i_N_busy   => 
    --i_N_ack    => 
    -- South connections
    i_S_pixel   => oc_S_pixel,
    i_S_x_dest  => oc_S_x_dest,
    i_S_y_dest  => oc_S_y_dest,
    i_S_step    => oc_S_step,
    i_S_frame   => oc_S_frame,
    i_S_x_orig  => oc_S_x_orig,
    i_S_y_orig  => oc_S_y_orig,
    i_S_fb      => oc_S_fb,
    i_S_new_msg => oc_S_new_msg,
    i_S_ack     => oc_S_ack,
    --i_S_req     => 
    --i_S_busy    => 
    --i_S_ack     => 
    -- East connections
    i_E_pixel   => oc_E_pixel,
    i_E_x_dest  => oc_E_x_dest,
    i_E_y_dest  => oc_E_y_dest,
    i_E_step    => oc_E_step,
    i_E_frame   => oc_E_frame,
    i_E_x_orig  => oc_E_x_orig,
    i_E_y_orig  => oc_E_y_orig,
    i_E_fb      => oc_E_fb,
    i_E_new_msg => oc_E_new_msg,
    i_E_ack     => oc_E_ack,
    --i_E_req     => oc_E_
    --i_E_busy    => 
    --i_E_ack     => 
    -- West
    i_W_pixel   => oc_W_pixel,
    i_W_x_dest  => oc_W_x_dest,
    i_W_y_dest  => oc_W_y_dest,
    i_W_step    => oc_W_step,
    i_W_frame   => oc_W_frame,
    i_W_x_orig  => oc_W_x_orig,
    i_W_y_orig  => oc_W_y_orig,
    i_W_fb      => oc_W_fb,
    i_W_new_msg => oc_W_new_msg,
    i_W_ack     => oc_W_ack
    --i_W_req     => 
    --i_W_busy    => 
    --i_W_ack     => 
            
);

out_PE_controller_inst : out_PE_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_PE_pixel   => oc_PE_pixel,    
    oc_PE_x_dest  => oc_PE_x_dest,   
    oc_PE_y_dest  => oc_PE_y_dest,   
    oc_PE_step    => oc_PE_step,     
    oc_PE_frame   => oc_PE_frame,    
    oc_PE_x_orig  => oc_PE_x_orig,   
    oc_PE_y_orig  => oc_PE_y_orig,   
    oc_PE_fb      => oc_PE_fb,       
    oc_PE_new_msg => oc_PE_new_msg,  
    oc_PE_ack     => oc_PE_ack,      
    -- connections to the next router
    i_PE_pixel  => i_PE_pixel ,
    i_PE_x_dest => i_PE_x_dest,
    i_PE_y_dest => i_PE_y_dest,
    i_PE_step   => i_PE_step  ,
    i_PE_frame  => i_PE_frame ,
    i_PE_x_orig => i_PE_x_orig,
    i_PE_y_orig => i_PE_y_orig,
    i_PE_fb     => i_PE_fb    ,
    i_PE_req    => i_PE_req   ,
    i_PE_ack    => i_PE_ack   
    
);

out_North_controller_inst : out_North_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_N_pixel   => oc_N_pixel,    
    oc_N_x_dest  => oc_N_x_dest,   
    oc_N_y_dest  => oc_N_y_dest,   
    oc_N_step    => oc_N_step,     
    oc_N_frame   => oc_N_frame,    
    oc_N_x_orig  => oc_N_x_orig,   
    oc_N_y_orig  => oc_N_y_orig,   
    oc_N_fb      => oc_N_fb,       
    oc_N_new_msg => oc_N_new_msg,  
    oc_N_ack     => oc_N_ack,      
    -- connections to the next router
    i_N_pixel  => i_N_pixel,
    i_N_x_dest => i_N_x_dest,
    i_N_y_dest => i_N_y_dest,
    i_N_step   => i_N_step,
    i_N_frame  => i_N_frame,
    i_N_x_orig => i_N_x_orig,
    i_N_y_orig => i_N_y_orig,
    i_N_fb     => i_N_fb,
    i_N_req    => i_N_req,
    i_N_ack    => i_N_ack
    
);

out_South_controller_inst : out_South_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_S_pixel   => oc_S_pixel,    
    oc_S_x_dest  => oc_S_x_dest,   
    oc_S_y_dest  => oc_S_y_dest,   
    oc_S_step    => oc_S_step,     
    oc_S_frame   => oc_S_frame,    
    oc_S_x_orig  => oc_S_x_orig,   
    oc_S_y_orig  => oc_S_y_orig,   
    oc_S_fb      => oc_S_fb,       
    oc_S_new_msg => oc_S_new_msg,  
    oc_S_ack     => oc_S_ack,      
    -- connections to the next router
    i_S_pixel  => i_S_pixel,
    i_S_x_dest => i_S_x_dest,
    i_S_y_dest => i_S_y_dest,
    i_S_step   => i_S_step,
    i_S_frame  => i_S_frame,
    i_S_x_orig => i_S_x_orig,
    i_S_y_orig => i_S_y_orig,
    i_S_fb     => i_S_fb,
    i_S_req    => i_S_req,
    i_S_ack    => i_S_ack
    
);

out_East_controller_inst : out_East_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_E_pixel   => oc_E_pixel,    
    oc_E_x_dest  => oc_E_x_dest,   
    oc_E_y_dest  => oc_E_y_dest,   
    oc_E_step    => oc_E_step,     
    oc_E_frame   => oc_E_frame,    
    oc_E_x_orig  => oc_E_x_orig,   
    oc_E_y_orig  => oc_E_y_orig,   
    oc_E_fb      => oc_E_fb,       
    oc_E_new_msg => oc_E_new_msg,  
    oc_E_ack     => oc_E_ack,      
    -- connections to the next router
    i_E_pixel  => i_E_pixel,
    i_E_x_dest => i_E_x_dest,
    i_E_y_dest => i_E_y_dest,
    i_E_step   => i_E_step,
    i_E_frame  => i_E_frame,
    i_E_x_orig => i_E_x_orig,
    i_E_y_orig => i_E_y_orig,
    i_E_fb     => i_E_fb,
    i_E_req    => i_E_req,
    i_E_ack    => i_E_ack
    
);

out_West_controller_inst : out_West_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_W_pixel   => oc_W_pixel,    
    oc_W_x_dest  => oc_W_x_dest,   
    oc_W_y_dest  => oc_W_y_dest,   
    oc_W_step    => oc_W_step,     
    oc_W_frame   => oc_W_frame,    
    oc_W_x_orig  => oc_W_x_orig,   
    oc_W_y_orig  => oc_W_y_orig,   
    oc_W_fb      => oc_W_fb,       
    oc_W_new_msg => oc_W_new_msg,      
    oc_W_ack     => oc_W_ack,      
    -- connections to the next router
    i_W_pixel  => i_W_pixel,
    i_W_x_dest => i_W_x_dest,
    i_W_y_dest => i_W_y_dest,    
    i_W_step   => i_W_step,
    i_W_frame  => i_W_frame,
    i_W_x_orig => i_W_x_orig,
    i_W_y_orig => i_W_y_orig,
    i_W_fb     => i_W_fb,
    i_W_req    => i_W_req,
    i_W_ack    => i_W_ack
    
);

out_pm_controller_inst : out_pm_controller
generic map(
    x_init      => x_init,
    y_init      => y_init,
    img_width   => img_width ,
    img_height  => img_height,
    n_frames    => n_frames  ,
    n_steps     => n_steps   ,
    pix_depth   => pix_depth
    )
port map(
	clk => clk,
	reset => reset,
	-- connections with the output controller
    oc_PM_pixel   => oc_PM_pixel,    
    oc_PM_x_dest  => oc_PM_x_dest,   
    oc_PM_y_dest  => oc_PM_y_dest,   
    oc_PM_step    => oc_PM_step,     
    oc_PM_frame   => oc_PM_frame,    
    oc_PM_x_orig  => oc_PM_x_orig,   
    oc_PM_y_orig  => oc_PM_y_orig,   
    oc_PM_fb      => oc_PM_fb,       
    oc_PM_new_msg => oc_PM_new_msg,  
    oc_PM_ack     => oc_PM_ack,      
    -- connections to the next router
    i_PM_pixel  => i_PM_pixel,
    i_PM_x_dest => i_PM_x_dest,
    i_PM_y_dest => i_PM_y_dest,
    i_PM_step   => i_PM_step,
    i_PM_frame  => i_PM_frame,
    i_PM_x_orig => i_PM_x_orig,
    i_PM_y_orig => i_PM_y_orig,
    i_PM_fb     => i_PM_fb,
    i_PM_req    => i_PM_req,
    i_PM_ack    => i_PM_ack
    
);

end architecture behavioral;