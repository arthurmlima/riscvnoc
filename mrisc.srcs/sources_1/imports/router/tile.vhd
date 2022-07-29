----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 01/24/2020 11:23:48 AM
-- Design Name: 
-- Module Name: tile - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tile is
generic(
    x_init              : integer := 0;
    y_init              : integer := 0;
    img_width           : natural;
    img_height          : natural;
    tile_width          : natural;
    tile_height         : natural;
    n_frames            : natural;
    n_steps             : natural;
    pix_depth           : natural;
    subimg_width        : natural;
    subimg_height       : natural;
    buffer_length       : natural;
    bit_width           : natural;
    memory_length       : natural;
    instruction_length  : natural;
    isf_opcode          : natural;
    regfile_size        : natural;
    isf_x               : natural;
    isf_y               : natural;
    isf_s               : natural;
    isf_f               : natural;
    isf_px              : natural;
    NOP                 : std_logic_vector(4-1 downto 0);
    GPX                 : std_logic_vector(4-1 downto 0);
    SPX                 : std_logic_vector(4-1 downto 0);
    ADD                 : std_logic_vector(4-1 downto 0);
    SUB                 : std_logic_vector(4-1 downto 0);
    MUL                 : std_logic_vector(4-1 downto 0);
    DIV                 : std_logic_vector(4-1 downto 0);
    AND1                : std_logic_vector(4-1 downto 0);
    OR1                 : std_logic_vector(4-1 downto 0);
    XOR1                : std_logic_vector(4-1 downto 0);
    NOT1                : std_logic_vector(4-1 downto 0);
    BGT                 : std_logic_vector(4-1 downto 0);
    BST                 : std_logic_vector(4-1 downto 0);
    BEQ                 : std_logic_vector(4-1 downto 0);
    JMP                 : std_logic_vector(4-1 downto 0);
    ENDPGR              : std_logic_vector(4-1 downto 0);
    addr_size           : natural
    );

port(
    clk : in STD_LOGIC;
    ----------------------------------------------------
    -- port to write pixel values from the AXI
    gen_port_in     : in std_logic_vector(1+1+1+32*5-1 downto 0);
    gen_port_out    : out std_logic_vector(1+1+32-1 downto 0);   
    
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
    
--    o_router_addr    : out unsigned(31 downto 0);
--    o_router_x       : out unsigned(31 downto 0);
--    o_router_y       : out unsigned(31 downto 0);
--    o_router_s       : out unsigned(31 downto 0);
--    o_router_f       : out unsigned(31 downto 0);
--    o_router_px      : out unsigned(31 downto 0);
    
--    o_x_out        : out UNSIGNED(2**bit_width-1 downto 0);
--    o_y_out        : out UNSIGNED(2**bit_width-1 downto 0);
--    o_f_out        : out UNSIGNED(2**bit_width-1 downto 0);
--    o_s_out        : out UNSIGNED(2**bit_width-1 downto 0);
--    o_px_out       : out UNSIGNED(2**bit_width-1 downto 0) ;
    
--    o_idec_x : out STD_LOGIC_VECTOR(isf_x-1 downto 0);                  
--    o_idec_y : out STD_LOGIC_VECTOR(isf_y-1 downto 0);                  
--    o_idec_f : out STD_LOGIC_VECTOR(isf_f-1 downto 0);                  
--    o_idec_s : out STD_LOGIC_VECTOR(isf_s-1 downto 0);                  
--    o_idec_px : out STD_LOGIC_VECTOR(isf_px-1 downto 0);                
--    o_instruction : out STD_LOGIC_VECTOR(instruction_length-1 downto 0);

--    o_PE_pixel      : out STD_LOGIC_VECTOR(pix_depth-1 downto 0); 
--    o_PE_x_dest     : out STD_LOGIC_VECTOR(img_width-1 downto 0); 
--    o_PE_y_dest     : out STD_LOGIC_VECTOR(img_height-1 downto 0);
--    o_PE_step       : out STD_LOGIC_VECTOR(n_steps-1 downto 0);   
--    o_PE_frame      : out STD_LOGIC_VECTOR(n_frames-1 downto 0);  
--    o_PE_x_orig     : out STD_LOGIC_VECTOR(img_width-1 downto 0); 
--    o_PE_y_orig     : out STD_LOGIC_VECTOR(img_height-1 downto 0);
    
--    o_opcode    : out STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
--    o_rs, o_rt, o_ula_out  : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0)
);

end tile;

architecture Behavioral of tile is
component pe_wrapper is
    generic (
            x_init : integer;
            y_init : integer;
            bit_width           : natural;
            memory_length       : natural;
            instruction_length  : natural;
            isf_opcode          : natural;
            regfile_size        : natural;
            isf_x               : natural;
            isf_y               : natural;
            isf_s               : natural;
            isf_f               : natural;
            isf_px              : natural;
            NOP                 : std_logic_vector(4-1 downto 0);
            GPX                 : std_logic_vector(4-1 downto 0);
            SPX                 : std_logic_vector(4-1 downto 0);
            ADD                 : std_logic_vector(4-1 downto 0);
            SUB                 : std_logic_vector(4-1 downto 0);
            MUL                 : std_logic_vector(4-1 downto 0);
            DIV                 : std_logic_vector(4-1 downto 0);
            AND1                : std_logic_vector(4-1 downto 0);
            OR1                 : std_logic_vector(4-1 downto 0);
            XOR1                : std_logic_vector(4-1 downto 0);
            NOT1                : std_logic_vector(4-1 downto 0);
            BGT                 : std_logic_vector(4-1 downto 0);
            BST                 : std_logic_vector(4-1 downto 0);
            BEQ                 : std_logic_vector(4-1 downto 0);
            JMP                 : std_logic_vector(4-1 downto 0);
            ENDPGR              : std_logic_vector(4-1 downto 0);
            addr_size           : natural;
            img_width           : natural;
            img_height          : natural;
            n_frames            : natural;
            n_steps             : natural;
            pix_depth           : natural
            );
    port(
        clk, reset : in STD_LOGIC;
        o_endpgr_flag : out STD_LOGIC;
    
    -- New Local target ports - the PE requests values using these ports.
        i_PE_pixel  : out STD_LOGIC_VECTOR(pix_depth-1 downto 0);
        i_PE_x_dest : out STD_LOGIC_VECTOR(img_width-1 downto 0);
        i_PE_y_dest : out STD_LOGIC_VECTOR(img_height-1 downto 0);
        i_PE_step   : out STD_LOGIC_VECTOR(n_steps-1 downto 0);
        i_PE_frame  : out STD_LOGIC_VECTOR(n_frames-1 downto 0);
        i_PE_x_orig : out STD_LOGIC_VECTOR(img_width-1 downto 0);
        i_PE_y_orig : out STD_LOGIC_VECTOR(img_height-1 downto 0);
        i_PE_fb     : out STD_LOGIC; -- message forward/backward
        i_PE_req    : inout STD_LOGIC; -- message request
       --iPEN_busy   : in std_logic; -- router is busy
        i_PE_ack    : in STD_LOGIC := '0'; -- message acknowledge  
            
        t_PE_pixel  : in STD_LOGIC_VECTOR(pix_depth-1 downto 0);
        t_PE_x_dest : in STD_LOGIC_VECTOR(img_width-1 downto 0);
        t_PE_y_dest : in STD_LOGIC_VECTOR(img_height-1 downto 0);
        t_PE_step   : in STD_LOGIC_VECTOR(n_steps-1 downto 0);
        t_PE_frame  : in STD_LOGIC_VECTOR(n_frames-1 downto 0);
        t_PE_x_orig : in STD_LOGIC_VECTOR(img_width-1 downto 0);
        t_PE_y_orig : in STD_LOGIC_VECTOR(img_height-1 downto 0);
        t_PE_fb     : in STD_LOGIC; -- message forward/backward
        t_PE_req    : in STD_LOGIC; -- message request
        --t_PE_busy   : out std_logic; -- router is busy
        t_PE_ack    : out STD_LOGIC; -- message acknowledge 
        
        s_reg_out : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        
        -- AXI/Instruction Memory interface
        i_axi_clk       : in STD_LOGIC;
        i_axi_we        : in STD_LOGIC;
        i_axi_addr      : in STD_LOGIC_VECTOR(31 downto 0);
        i_axi_data0     : in STD_LOGIC_VECTOR(31 downto 0);
        i_axi_data1     : in STD_LOGIC_VECTOR(31 downto 0);
        o_axi_imok      : out STD_LOGIC;
        
        o_idec_x : out STD_LOGIC_VECTOR(isf_x-1 downto 0);                  
        o_idec_y : out STD_LOGIC_VECTOR(isf_y-1 downto 0);                  
        o_idec_f : out STD_LOGIC_VECTOR(isf_f-1 downto 0);                  
        o_idec_s : out STD_LOGIC_VECTOR(isf_s-1 downto 0);                  
        o_idec_px : out STD_LOGIC_VECTOR(isf_px-1 downto 0);                
        o_instruction : out STD_LOGIC_VECTOR(instruction_length-1 downto 0);
        
        o_x_out        : out UNSIGNED(2**bit_width-1 downto 0);
        o_y_out        : out UNSIGNED(2**bit_width-1 downto 0);
        o_f_out        : out UNSIGNED(2**bit_width-1 downto 0);
        o_s_out        : out UNSIGNED(2**bit_width-1 downto 0);
        o_px_out       : out UNSIGNED(2**bit_width-1 downto 0);
        
        o_opcode    : out STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
        o_rs, o_rt, o_ula_out  : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0)
    );
end component pe_wrapper;

component px_mem_wrapper is
    generic (
            x_init          : natural;
            y_init          : natural;
            pix_depth       : natural;
            img_width       : natural;
            img_height      : natural;
            tile_width      : natural;
            tile_height     : natural;
            subimg_width    : natural;
            subimg_height   : natural;
            n_frames        : natural;
            n_steps         : natural;
            bit_width       : natural
            );
    port(
        clk, reset      : in STD_LOGIC;
        o_endpgr_flag   : out STD_LOGIC;
        i_s_sync        : in std_logic_vector(2**bit_width-1 downto 0);
    
        -- New Local target ports - the PE requests values using these ports.
        -- Directly connected with tile router
        i_PM_pixel  : out STD_LOGIC_VECTOR(pix_depth-1 downto 0);
        i_PM_x_dest : out STD_LOGIC_VECTOR(img_width-1 downto 0);
        i_PM_y_dest : out STD_LOGIC_VECTOR(img_height-1 downto 0);
        i_PM_step   : out STD_LOGIC_VECTOR(n_steps-1 downto 0);
        i_PM_frame  : out STD_LOGIC_VECTOR(n_frames-1 downto 0);
        i_PM_x_orig : out STD_LOGIC_VECTOR(img_width-1 downto 0);
        i_PM_y_orig : out STD_LOGIC_VECTOR(img_height-1 downto 0);
        i_PM_fb     : out STD_LOGIC; -- message forward/backward
        i_PM_req    : inout STD_LOGIC; -- message request
        i_PM_ack    : in STD_LOGIC := '0'; -- message acknowledge  
            
        t_PM_pixel  : in STD_LOGIC_VECTOR(pix_depth-1 downto 0);
        t_PM_x_dest : in STD_LOGIC_VECTOR(img_width-1 downto 0);
        t_PM_y_dest : in STD_LOGIC_VECTOR(img_height-1 downto 0);
        t_PM_step   : in STD_LOGIC_VECTOR(n_steps-1 downto 0);
        t_PM_frame  : in STD_LOGIC_VECTOR(n_frames-1 downto 0);
        t_PM_x_orig : in STD_LOGIC_VECTOR(img_width-1 downto 0);
        t_PM_y_orig : in STD_LOGIC_VECTOR(img_height-1 downto 0);
        t_PM_fb     : in STD_LOGIC; -- message forward/backward
        t_PM_req    : in STD_LOGIC; -- message request
        t_PM_ack    : out STD_LOGIC; -- message acknowledge        
        
        o_router_addr       : out unsigned(31 downto 0);
        o_router_x          : out unsigned(31 downto 0);
        o_router_y          : out unsigned(31 downto 0);
        o_router_s          : out unsigned(31 downto 0);
        o_router_f          : out unsigned(31 downto 0);
        o_router_px         : out unsigned(31 downto 0);
        ----------------------------------------------------
        -- port to write pixel values from the AXI
        i_axi_clk   : in std_logic;
        i_axi_en    : in std_logic;
        i_axi_we    : in std_logic;
    
        i_axi_x     : in unsigned(31 downto 0);
        i_axi_y     : in unsigned(31 downto 0);
        i_axi_s     : in unsigned(31 downto 0);
        i_axi_f     : in unsigned(31 downto 0);
        i_axi_px    : in unsigned(31 downto 0);
    
        o_rd_done   : out std_logic;
        o_axi_px    : out unsigned(31 downto 0)       
    );
end component px_mem_wrapper;

component router
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
    end component router;
    
    component router_new is
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
    
        clk          : in std_logic;
        reset          : in std_logic;
        
        
       -- R_Wrapper_PM_ready_EB_CF : in std_LOGIC;
       -- R_Wrapper_PE_ready_EB_CF : in std_LOGIC;
       -- R_Wrapper_N_ready_EB_CF  : in std_LOGIC;
      --  R_Wrapper_S_ready_EB_CF  : in std_LOGIC;
       -- R_Wrapper_W_ready_EB_CF  : in std_LOGIC;
       -- R_Wrapper_E_ready_EB_CF  : in std_LOGIC;
        
        
        t_PM_pixel     : in std_logic_vector(pix_depth-1 downto 0);
        t_PM_x_dest    : in std_logic_vector(img_width-1 downto 0);
        t_PM_y_dest    : in std_logic_vector(img_height-1 downto 0);
        t_PM_step      : in std_logic_vector(n_steps-1 downto 0);
        t_PM_frame     : in std_logic_vector(n_frames-1 downto 0);
        t_PM_x_orig    : in std_logic_vector(img_width-1 downto 0);
        t_PM_y_orig    : in std_logic_vector(img_height-1 downto 0);
        t_PM_fb        : in std_logic; -- identify if the it is a set_pixel or a set_pixel message.
       
        t_PM_req       : in std_logic;
        t_PM_ack       : out std_logic;
        IN_i_PM_busy   : inout std_logic;
        
        
        
        t_PE_pixel   : in std_logic_vector(pix_depth-1 downto 0);
        t_PE_x_dest  : in std_logic_vector(img_width-1 downto 0);
        t_PE_y_dest  : in std_logic_vector(img_height-1 downto 0);
        t_PE_step    : in std_logic_vector(n_steps-1 downto 0);
        t_PE_frame   : in std_logic_vector(n_frames-1 downto 0);
        t_PE_x_orig  : in std_logic_vector(img_width-1 downto 0);
        t_PE_y_orig  : in std_logic_vector(img_height-1 downto 0);
        t_PE_fb      : in std_logic; -- identify if the it is a set_pixel or a set_pixel message. 
        t_PE_req     : in std_logic;  
        t_PE_ack     : out std_logic;   
        IN_i_PE_busy : inout std_logic;
        
        t_N_pixel     : in   std_logic_vector(pix_depth-1 downto 0);
        t_N_x_dest    : in   std_logic_vector(img_width-1 downto 0);
        t_N_y_dest    : in   std_logic_vector(img_height-1 downto 0);
        t_N_step      : in   std_logic_vector(n_steps-1 downto 0);
        t_N_frame     : in   std_logic_vector(n_frames-1 downto 0);
        t_N_x_orig    : in   std_logic_vector(img_width-1 downto 0);
        t_N_y_orig    : in   std_logic_vector(img_height-1 downto 0);
        t_N_fb        : in   std_logic; -- message forward/backward
        t_N_req       : in std_logic;    
        t_N_ack       : out std_logic;
        IN_i_N_busy   : inout  std_logic;
        
        t_S_pixel      : in   std_logic_vector(pix_depth-1 downto 0);
        t_S_x_dest     : in   std_logic_vector(img_width-1 downto 0);
        t_S_y_dest     : in   std_logic_vector(img_height-1 downto 0);
        t_S_step       : in   std_logic_vector(n_steps-1 downto 0);
        t_S_frame      : in   std_logic_vector(n_frames-1 downto 0);
        t_S_x_orig     : in   std_logic_vector(img_width-1 downto 0);
        t_S_y_orig     : in   std_logic_vector(img_height-1 downto 0);
        t_S_fb         : in   std_logic; -- message forward/backward
        t_S_req        : in std_logic;    
        t_S_ack        : out std_logic;
        IN_i_S_busy    : inout std_logic;
        
        t_E_pixel      : in  std_logic_vector(pix_depth-1 downto 0);
        t_E_x_dest     : in  std_logic_vector(img_width-1 downto 0);
        t_E_y_dest     : in  std_logic_vector(img_height-1 downto 0);
        t_E_step       : in  std_logic_vector(n_steps-1 downto 0);
        t_E_frame      : in  std_logic_vector(n_frames-1 downto 0);
        t_E_x_orig     : in  std_logic_vector(img_width-1 downto 0);
        t_E_y_orig     : in  std_logic_vector(img_height-1 downto 0);
        t_E_fb         : in  std_logic; -- message forward/backward
        t_E_req        : in std_logic;
        t_E_ack        : out std_logic;
        IN_i_E_busy    : inout std_logic;
        
        t_W_pixel      : in  std_logic_vector(pix_depth-1 downto 0);
        t_W_x_dest     : in  std_logic_vector(img_width-1 downto 0);
        t_W_y_dest     : in  std_logic_vector(img_height-1 downto 0);
        t_W_step       : in  std_logic_vector(n_steps-1 downto 0);
        t_W_frame      : in  std_logic_vector(n_frames-1 downto 0);
        t_W_x_orig     : in  std_logic_vector(img_width-1 downto 0);
        t_W_y_orig     : in  std_logic_vector(img_height-1 downto 0);
        t_W_fb         : in  std_logic; -- message forward/backward    
        t_W_req        : in std_logic;
        t_W_ack        : out std_logic;
        IN_i_W_busy    : inout std_logic;
    
    
    
        i_PM_pixel     : out std_logic_vector(pix_depth-1 downto 0);
        i_PM_x_dest    : out std_logic_vector(img_width-1 downto 0);
        i_PM_y_dest    : out std_logic_vector(img_height-1 downto 0);
        i_PM_step      : out std_logic_vector(n_steps-1 downto 0);
        i_PM_frame     : out std_logic_vector(n_frames-1 downto 0);
        i_PM_x_orig    : out std_logic_vector(img_width-1 downto 0);
        i_PM_y_orig    : out std_logic_vector(img_height-1 downto 0);
        i_PM_fb        : out std_logic; -- identify if the it is a set_pixel or a set_pixel message.    
        i_PM_req       : inout std_logic;
        i_PM_ack       : in std_logic;
       -- O_i_PM_busy    : in std_logic;
        
        
        i_PE_pixel  : out std_logic_vector(pix_depth-1 downto 0);
        i_PE_x_dest : out std_logic_vector(img_width-1 downto 0);
        i_PE_y_dest : out std_logic_vector(img_height-1 downto 0);
        i_PE_step   : out std_logic_vector(n_steps-1 downto 0);
        i_PE_frame  : out std_logic_vector(n_frames-1 downto 0);
        i_PE_x_orig : out std_logic_vector(img_width-1 downto 0);
        i_PE_y_orig : out std_logic_vector(img_height-1 downto 0);
        i_PE_fb     : out std_logic; -- identify if the it is a set_pixel or a set_pixel message.
        i_PE_req    : inout std_logic;
        i_PE_ack    : in std_logic;
       -- O_i_PE_busy   : in std_logic;
        
        
        
        i_N_pixel   : out std_logic_vector(pix_depth-1 downto 0);
        i_N_x_dest  : out std_logic_vector(img_width-1 downto 0);
        i_N_y_dest  : out std_logic_vector(img_height-1 downto 0);
        i_N_step    : out std_logic_vector(n_steps-1 downto 0);
        i_N_frame   : out std_logic_vector(n_frames-1 downto 0);
        i_N_x_orig  : out std_logic_vector(img_width-1 downto 0);
        i_N_y_orig  : out std_logic_vector(img_height-1 downto 0);
        i_N_fb      : out std_logic; -- message forward/backward    
        i_N_req    : inout std_logic;
        i_N_ack    : in std_logic;
       -- O_i_N_busy    : in std_logic;
        
        i_S_pixel   : out std_logic_vector(pix_depth-1 downto 0);
        i_S_x_dest  : out std_logic_vector(img_width-1 downto 0);
        i_S_y_dest  : out std_logic_vector(img_height-1 downto 0);
        i_S_step    : out std_logic_vector(n_steps-1 downto 0);
        i_S_frame   : out std_logic_vector(n_frames-1 downto 0);
        i_S_x_orig  : out std_logic_vector(img_width-1 downto 0);
        i_S_y_orig  : out std_logic_vector(img_height-1 downto 0);
        i_S_fb      : out std_logic; -- message forward/backward 
        i_S_req    : inout std_logic;
        i_S_ack    : in std_logic;
        --O_i_S_busy    : in std_logic;
        
        
        
        i_E_pixel   : out std_logic_vector(pix_depth-1 downto 0);
        i_E_x_dest  : out std_logic_vector(img_width-1 downto 0);
        i_E_y_dest  : out std_logic_vector(img_height-1 downto 0);
        i_E_step    : out std_logic_vector(n_steps-1 downto 0);
        i_E_frame   : out std_logic_vector(n_frames-1 downto 0);
        i_E_x_orig  : out std_logic_vector(img_width-1 downto 0);
        i_E_y_orig  : out std_logic_vector(img_height-1 downto 0);
        i_E_fb      : out std_logic; -- message forward/backward
        i_E_req     : inout std_logic;
        i_E_ack     : in std_logic;
        --O_i_E_busy    : in std_logic;
        
        
        
        i_W_pixel   : out std_logic_vector(pix_depth-1 downto 0);
        i_W_x_dest  : out std_logic_vector(img_width-1 downto 0);
        i_W_y_dest  : out std_logic_vector(img_height-1 downto 0);
        i_W_step    : out std_logic_vector(n_steps-1 downto 0);
        i_W_frame   : out std_logic_vector(n_frames-1 downto 0);
        i_W_x_orig  : out std_logic_vector(img_width-1 downto 0);
        i_W_y_orig  : out std_logic_vector(img_height-1 downto 0);
        i_W_fb      : out std_logic; -- message forward/backward      
        i_W_req     : inout std_logic;
        i_W_ack     : in std_logic
       -- O_i_W_busy    : in  std_logic
        
        
        
    );
    end component router_new;

    -- AXI Signals
    signal done             : std_logic;
    signal rd_done          : std_logic;
    signal reset            : std_logic;     
    signal i_axi_clk        : std_logic;
    signal i_axi_en         : std_logic;
    signal i_axi_we         : std_logic;
    signal i_axi_x          : unsigned(31 downto 0);
    signal i_axi_y          : unsigned(31 downto 0);
    signal i_axi_s          : unsigned(31 downto 0);
    signal i_axi_f          : unsigned(31 downto 0);
    signal i_axi_px         : unsigned(31 downto 0);
    signal o_axi_px         : unsigned(31 downto 0);
    
    -- AXI Constants
    constant iclk_f         : integer   := 1;
    constant ien_f          : integer   := 1 + iclk_f;
    constant iwe_f          : integer   := 1 + ien_f;
    constant ix_f           : integer   := 32 + iwe_f;
    constant iy_f           : integer   := 32 + ix_f;
    constant is_f           : integer   := 32 + iy_f;
    constant if_f           : integer   := 32 + is_f;
    constant ipx_f          : integer   := 32 + if_f;
    
    constant done_f         : integer   := 1;
    constant rd_done_f      : integer   := 1 + done_f;
    constant opx_f          : integer   := 32 + rd_done_f;
    
    -- AXI/Instruction Memory interface signals
    signal im_axi_clk       : STD_LOGIC;
    signal im_axi_we        : STD_LOGIC;
    signal im_axi_addr      : STD_LOGIC_VECTOR(31 downto 0);
    signal im_axi_data0     : STD_LOGIC_VECTOR(31 downto 0);
    signal im_axi_data1     : STD_LOGIC_VECTOR(31 downto 0);
    signal o_axi_imok       : STD_LOGIC; 

    -- New Local target ports - the PE requests values using these ports.
    signal si_PE_pixel  :  STD_LOGIC_VECTOR(pix_depth-1 downto 0)   := (others => '0');
    signal si_PE_x_dest :  STD_LOGIC_VECTOR(img_width-1 downto 0)   := (others => '0');
    signal si_PE_y_dest :  STD_LOGIC_VECTOR(img_height-1 downto 0)  := (others => '0');
    signal si_PE_step   :  STD_LOGIC_VECTOR(n_steps-1 downto 0)     := (others => '0');
    signal si_PE_frame  :  STD_LOGIC_VECTOR(n_frames-1 downto 0)    := (others => '0');
    signal si_PE_x_orig :  STD_LOGIC_VECTOR(img_width-1 downto 0)   := (others => '0');
    signal si_PE_y_orig :  STD_LOGIC_VECTOR(img_height-1 downto 0)  := (others => '0');
    signal si_PE_fb     :  STD_LOGIC := '0'; -- message forward/backward
    signal si_PE_req    :  STD_LOGIC := '0'; -- message request
   --siPEN_busy   : in std_logic; -- router is busy
    signal si_PE_ack    :  STD_LOGIC := '0'; -- message acknowledge  
         
    signal st_PE_pixel  :  STD_LOGIC_VECTOR(pix_depth-1 downto 0)   := (others => '0');
    signal st_PE_x_dest :  STD_LOGIC_VECTOR(img_width-1 downto 0)   := (others => '0');
    signal st_PE_y_dest :  STD_LOGIC_VECTOR(img_height-1 downto 0)  := (others => '0');
    signal st_PE_step   :  STD_LOGIC_VECTOR(n_steps-1 downto 0)     := (others => '0');
    signal st_PE_frame  :  STD_LOGIC_VECTOR(n_frames-1 downto 0)    := (others => '0');
    signal st_PE_x_orig :  STD_LOGIC_VECTOR(img_width-1 downto 0)   := (others => '0');
    signal st_PE_y_orig :  STD_LOGIC_VECTOR(img_height-1 downto 0)  := (others => '0');
    signal st_PE_fb     :  STD_LOGIC := '0'; -- message forward/backward
    signal st_PE_req    :  STD_LOGIC := '0'; -- message request
  --t_PE_busy   : out std_logic; -- router is busy
    signal st_PE_ack    :  STD_LOGIC := '0'; -- message acknowledge    
    

    signal st_PM_pixel  : std_logic_vector(pix_depth-1 downto 0) := (others => '0');
    signal st_PM_x_dest : std_logic_vector(img_width-1 downto 0) := (others => '0');
    signal st_PM_y_dest : std_logic_vector(img_height-1 downto 0) := (others => '0');
    signal st_PM_step   : std_logic_vector(n_steps-1 downto 0) := (others => '0');
    signal st_PM_frame  : std_logic_vector(n_frames-1 downto 0) := (others => '0');
    signal st_PM_x_orig : std_logic_vector(img_width-1 downto 0) := (others => '0');
    signal st_PM_y_orig : std_logic_vector(img_height-1 downto 0) := (others => '0');
    signal st_PM_fb     : std_logic := '0'; -- message forward/backward
    signal st_PM_req    : std_logic := '0'; -- message request
    signal st_PM_ack    : std_logic := '0'; -- message acknowledge       
     -- initiar output ports    
    signal si_PM_pixel  : std_logic_vector(pix_depth-1 downto 0) := (others => '0');
    signal si_PM_x_dest : std_logic_vector(img_width-1 downto 0) := (others => '0');
    signal si_PM_y_dest : std_logic_vector(img_height-1 downto 0) := (others => '0');
    signal si_PM_step   : std_logic_vector(n_steps-1 downto 0) := (others => '0');
    signal si_PM_frame  : std_logic_vector(n_frames-1 downto 0) := (others => '0');
    signal si_PM_x_orig : std_logic_vector(img_width-1 downto 0) := (others => '0');
    signal si_PM_y_orig : std_logic_vector(img_height-1 downto 0) := (others => '0');
    signal si_PM_fb     : std_logic := '0'; -- message forward/backward
    signal si_PM_req    : std_logic := '0'; -- message request
    signal si_PM_ack    : std_logic := '0'; -- message acknowledge 
    
    -- Benchmark hardware counter
    signal clk_count    : unsigned(31 downto 0);
    
    -- Step Register signal
    signal s_s_reg_out  : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    
    --reset out_pe_ctrl;
   -- signal s_reset_output_pe_ctrl : std_logic;
    
begin
    
    pe_wrapper_inst : pe_wrapper generic  map(
                                            x_init      => x_init,
                                            y_init      => y_init,
                                            bit_width           => bit_width         ,
                                            memory_length       => memory_length     ,
                                            instruction_length  => instruction_length,
                                            isf_opcode          => isf_opcode        ,
                                            regfile_size        => regfile_size      ,
                                            isf_x               => isf_x             ,
                                            isf_y               => isf_y             ,
                                            isf_s               => isf_s             ,
                                            isf_f               => isf_f             ,
                                            isf_px              => isf_px            ,
                                            NOP                 => NOP               ,
                                            GPX                 => GPX               ,
                                            SPX                 => SPX               ,
                                            ADD                 => ADD               ,
                                            SUB                 => SUB               ,
                                            MUL                 => MUL               ,
                                            DIV                 => DIV               ,
                                            AND1                => AND1              ,
                                            OR1                 => OR1               ,
                                            XOR1                => XOR1              ,
                                            NOT1                => NOT1              ,
                                            BGT                 => BGT               ,
                                            BST                 => BST               ,
                                            BEQ                 => BEQ               ,
                                            JMP                 => JMP               ,
                                            ENDPGR              => ENDPGR            ,
                                            addr_size           => addr_size         ,
                                            img_width           => img_width         ,
                                            img_height          => img_height        ,
                                            n_frames            => n_frames          ,
                                            n_steps             => n_steps           ,
                                            pix_depth           => pix_depth         
                                            )
                                port    map(
                                            clk             => clk,
                                            reset           => reset,
                                            o_endpgr_flag   => done,
                                            i_PE_pixel      => si_PE_pixel,
                                            i_PE_x_dest     => si_PE_x_dest,
                                            i_PE_y_dest     => si_PE_y_dest,
                                            i_PE_step       => si_PE_step,
                                            i_PE_frame      => si_PE_frame,
                                            i_PE_x_orig     => si_PE_x_orig,
                                            i_PE_y_orig     => si_PE_y_orig,
                                            i_PE_fb         => si_PE_fb,
                                            i_PE_req        => si_PE_req,
                                            i_PE_ack        => si_PE_ack,
                                            t_PE_pixel      => st_PE_pixel,
                                            t_PE_x_dest     => st_PE_x_dest,
                                            t_PE_y_dest     => st_PE_y_dest,
                                            t_PE_step       => st_PE_step,
                                            t_PE_frame      => st_PE_frame,
                                            t_PE_x_orig     => st_PE_x_orig,
                                            t_PE_y_orig     => st_PE_y_orig,
                                            t_PE_fb         => st_PE_fb,
                                            t_PE_req        => st_PE_req,
                                            t_PE_ack        => st_PE_ack,
                                            s_reg_out       => s_s_reg_out,
                                            i_axi_clk       => im_axi_clk,
                                            i_axi_we        => im_axi_we,
                                            i_axi_addr      => im_axi_addr,
                                            i_axi_data0     => im_axi_data0,
                                            i_axi_data1     => im_axi_data1,
                                            o_axi_imok      => o_axi_imok --,
--                                            o_x_out         => o_x_out ,
--                                            o_y_out         => o_y_out ,
--                                            o_f_out         => o_f_out ,
--                                            o_s_out         => o_s_out ,
--                                            o_px_out        => o_px_out,
--                                            o_idec_x        => o_idec_x ,
--                                            o_idec_y        => o_idec_y ,
--                                            o_idec_f        => o_idec_f ,
--                                            o_idec_s        => o_idec_s ,
--                                            o_idec_px       => o_idec_px,
--                                            o_instruction   => o_instruction,
--                                            o_opcode        => o_opcode,
--                                            o_rs            => o_rs,
--                                            o_rt            => o_rt,
--                                            o_ula_out       => o_ula_out
                                            );    

    pm_wrapper_inst : px_mem_wrapper generic  map(
                                            x_init      => x_init,            
                                            y_init      => y_init, 
                                            pix_depth   => pix_depth,           
                                            img_width   => img_width,
                                            img_height  => img_height,
                                            tile_width          => tile_width        ,
                                            tile_height         => tile_height       ,
                                            subimg_width        => subimg_width,
                                            subimg_height       => subimg_height,
                                            n_frames    => n_frames,
                                            n_steps     => n_steps,
                                            bit_width   => bit_width
                                            )
                                port    map(
                                            clk             => clk,
                                            reset           => reset,
                                            i_s_sync        => s_s_reg_out,
                                            i_PM_pixel      => si_PM_pixel,
                                            i_PM_x_dest     => si_PM_x_dest,
                                            i_PM_y_dest     => si_PM_y_dest,
                                            i_PM_step       => si_PM_step,
                                            i_PM_frame      => si_PM_frame,
                                            i_PM_x_orig     => si_PM_x_orig,
                                            i_PM_y_orig     => si_PM_y_orig,
                                            i_PM_fb         => si_PM_fb,
                                            i_PM_req        => si_PM_req,
                                            i_PM_ack        => si_PM_ack,
                                            t_PM_pixel      => st_PM_pixel,
                                            t_PM_x_dest     => st_PM_x_dest,
                                            t_PM_y_dest     => st_PM_y_dest,
                                            t_PM_step       => st_PM_step,
                                            t_PM_frame      => st_PM_frame,
                                            t_PM_x_orig     => st_PM_x_orig,
                                            t_PM_y_orig     => st_PM_y_orig,
                                            t_PM_fb         => st_PM_fb,
                                            t_PM_req        => st_PM_req,
                                            t_PM_ack        => st_PM_ack,
                                            i_axi_clk       => i_axi_clk,
                                            i_axi_en        => i_axi_en,
                                            i_axi_we        => i_axi_we,
                                            i_axi_x         => i_axi_x,
                                            i_axi_y         => i_axi_y,
                                            i_axi_s         => i_axi_s,
                                            i_axi_f         => i_axi_f,
                                            i_axi_px        => i_axi_px,
                                            o_rd_done       => rd_done,
                                            o_axi_px        => o_axi_px--,
--                                            o_router_addr   => o_router_addr,
--                                            o_router_x      => o_router_x   ,
--                                            o_router_y      => o_router_y   ,
--                                            o_router_s      => o_router_s   ,
--                                            o_router_f      => o_router_f   ,
--                                            o_router_px     => o_router_px
                                            );    

    router_inst : router_new  generic map(
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
                        port    map(
                                    clk             => clk,
                                    reset           => reset,
                                    i_PE_pixel      => st_PE_pixel,
                                    i_PE_x_dest     => st_PE_x_dest,
                                    i_PE_y_dest     => st_PE_y_dest,
                                    i_PE_step       => st_PE_step,
                                    i_PE_frame      => st_PE_frame,
                                    i_PE_x_orig     => st_PE_x_orig,
                                    i_PE_y_orig     => st_PE_y_orig,
                                    i_PE_fb         => st_PE_fb,
                                    i_PE_req        => st_PE_req,
                                    i_PE_ack        => st_PE_ack,
                                    t_PE_pixel      => si_PE_pixel,
                                    t_PE_x_dest     => si_PE_x_dest,
                                    t_PE_y_dest     => si_PE_y_dest,
                                    t_PE_step       => si_PE_step,
                                    t_PE_frame      => si_PE_frame,
                                    t_PE_x_orig     => si_PE_x_orig,
                                    t_PE_y_orig     => si_PE_y_orig,
                                    t_PE_fb         => si_PE_fb,
                                    t_PE_req        => si_PE_req,
                                    t_PE_ack        => si_PE_ack,
                                    i_PM_pixel      => st_PM_pixel,
                                    i_PM_x_dest     => st_PM_x_dest,
                                    i_PM_y_dest     => st_PM_y_dest,
                                    i_PM_step       => st_PM_step,
                                    i_PM_frame      => st_PM_frame,
                                    i_PM_x_orig     => st_PM_x_orig,
                                    i_PM_y_orig     => st_PM_y_orig,
                                    i_PM_fb         => st_PM_fb,
                                    i_PM_req        => st_PM_req,
                                    i_PM_ack        => st_PM_ack,
                                    t_PM_pixel      => si_PM_pixel,
                                    t_PM_x_dest     => si_PM_x_dest,
                                    t_PM_y_dest     => si_PM_y_dest,
                                    t_PM_step       => si_PM_step,
                                    t_PM_frame      => si_PM_frame,
                                    t_PM_x_orig     => si_PM_x_orig,
                                    t_PM_y_orig     => si_PM_y_orig,
                                    t_PM_fb         => si_PM_fb,
                                    t_PM_req        => si_PM_req,
                                    t_PM_ack        => si_PM_ack,
                                    i_N_pixel      => i_N_pixel,
                                    i_N_x_dest     => i_N_x_dest,
                                    i_N_y_dest     => i_N_y_dest,
                                    i_N_step       => i_N_step,
                                    i_N_frame      => i_N_frame,
                                    i_N_x_orig     => i_N_x_orig,
                                    i_N_y_orig     => i_N_y_orig,
                                    i_N_fb         => i_N_fb,
                                    i_N_req        => i_N_req,
                                    i_N_ack        => i_N_ack,
                                    t_N_pixel      => t_N_pixel,
                                    t_N_x_dest     => t_N_x_dest,
                                    t_N_y_dest     => t_N_y_dest,
                                    t_N_step       => t_N_step,
                                    t_N_frame      => t_N_frame,
                                    t_N_x_orig     => t_N_x_orig,
                                    t_N_y_orig     => t_N_y_orig,
                                    t_N_fb         => t_N_fb,
                                    t_N_req        => t_N_req,
                                    t_N_ack        => t_N_ack,
                                    i_S_pixel      => i_S_pixel,
                                    i_S_x_dest     => i_S_x_dest,
                                    i_S_y_dest     => i_S_y_dest,
                                    i_S_step       => i_S_step,
                                    i_S_frame      => i_S_frame,
                                    i_S_x_orig     => i_S_x_orig,
                                    i_S_y_orig     => i_S_y_orig,
                                    i_S_fb         => i_S_fb,
                                    i_S_req        => i_S_req,
                                    i_S_ack        => i_S_ack,
                                    t_S_pixel      => t_S_pixel,
                                    t_S_x_dest     => t_S_x_dest,
                                    t_S_y_dest     => t_S_y_dest,
                                    t_S_step       => t_S_step,
                                    t_S_frame      => t_S_frame,
                                    t_S_x_orig     => t_S_x_orig,
                                    t_S_y_orig     => t_S_y_orig,
                                    t_S_fb         => t_S_fb,
                                    t_S_req        => t_S_req,
                                    t_S_ack        => t_S_ack,
                                    i_E_pixel      => i_E_pixel,
                                    i_E_x_dest     => i_E_x_dest,
                                    i_E_y_dest     => i_E_y_dest,
                                    i_E_step       => i_E_step,
                                    i_E_frame      => i_E_frame,
                                    i_E_x_orig     => i_E_x_orig,
                                    i_E_y_orig     => i_E_y_orig,
                                    i_E_fb         => i_E_fb,
                                    i_E_req        => i_E_req,
                                    i_E_ack        => i_E_ack,
                                    t_E_pixel      => t_E_pixel,
                                    t_E_x_dest     => t_E_x_dest,
                                    t_E_y_dest     => t_E_y_dest,
                                    t_E_step       => t_E_step,
                                    t_E_frame      => t_E_frame,
                                    t_E_x_orig     => t_E_x_orig,
                                    t_E_y_orig     => t_E_y_orig,
                                    t_E_fb         => t_E_fb,
                                    t_E_req        => t_E_req,
                                    t_E_ack        => t_E_ack,
                                    i_W_pixel      => i_W_pixel,
                                    i_W_x_dest     => i_W_x_dest,
                                    i_W_y_dest     => i_W_y_dest,
                                    i_W_step       => i_W_step,
                                    i_W_frame      => i_W_frame,
                                    i_W_x_orig     => i_W_x_orig,
                                    i_W_y_orig     => i_W_y_orig,
                                    i_W_fb         => i_W_fb,
                                    i_W_req        => i_W_req,
                                    i_W_ack        => i_W_ack,
                                    t_W_pixel      => t_W_pixel,
                                    t_W_x_dest     => t_W_x_dest,
                                    t_W_y_dest     => t_W_y_dest,
                                    t_W_step       => t_W_step,
                                    t_W_frame      => t_W_frame,
                                    t_W_x_orig     => t_W_x_orig,
                                    t_W_y_orig     => t_W_y_orig,
                                    t_W_fb         => t_W_fb,
                                    t_W_req        => t_W_req,
                                    t_W_ack        => t_W_ack
                                );

--  o_PE_pixel   <= si_PE_pixel;  
--  o_PE_x_dest  <= si_PE_x_dest;
--  o_PE_y_dest  <= si_PE_y_dest;
--  o_PE_step    <= si_PE_step   ;
--  o_PE_frame   <= si_PE_frame  ;
--  o_PE_x_orig  <= si_PE_x_orig ;
--  o_PE_y_orig  <= si_PE_y_orig ;
    
    process(i_axi_en, i_axi_we)
    begin
        if(i_axi_en = '0') then
            reset   <= i_axi_we;
        else
            reset   <= '0';
        end if;
    end process;
      
    process(reset, clk, done)
    begin
        if reset = '1' then
            clk_count   <= to_unsigned(0, clk_count'length);
        else
            if RISING_EDGE(clk) then
                if done = '0' then
                    clk_count   <= clk_count + 1;
                end if;
            end if;
        end if;
    end process;
      
    process(gen_port_in, done, rd_done, o_axi_px, o_axi_imok)
        variable x_flag : STD_LOGIC_VECTOR(31 downto 0);
    begin
        x_flag := STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(gen_port_in(ix_f-1 downto iwe_f))), x_flag'length));
        
        if x_flag = x"FFFFFFFF" then
    
            --  Programming Mode
            i_axi_clk                           <= '0';
            i_axi_en                            <= '0';
            i_axi_we                            <= '0';
            i_axi_x                             <= (others => '0');
            i_axi_y                             <= (others => '0');
            i_axi_s                             <= (others => '0');
            i_axi_f                             <= (others => '0');
            i_axi_px                            <= (others => '0');
            
            im_axi_clk                          <= gen_port_in(iclk_f-1);
            im_axi_we                           <= gen_port_in(iwe_f-1);
            im_axi_addr                         <= gen_port_in(iy_f-1 downto ix_f);
            im_axi_data0                        <= gen_port_in(is_f-1 downto iy_f);
            im_axi_data1                        <= gen_port_in(if_f-1 downto is_f);
            
            gen_port_out(done_f-1)              <= o_axi_imok;
            gen_port_out(rd_done_f-1)           <= '0';
            gen_port_out(opx_f-1 downto rd_done_f) <= (others => '0');
        
        elsif x_flag = x"AAAAAAAA" then
        
            --  Clock Counter Mode
            i_axi_clk                           <= '0';
            i_axi_en                            <= '0';
            i_axi_we                            <= '0';
            i_axi_x                             <= (others => '0');
            i_axi_y                             <= (others => '0');
            i_axi_s                             <= (others => '0');
            i_axi_f                             <= (others => '0');
            i_axi_px                            <= (others => '0');
            
            im_axi_clk                          <= '0';            
            im_axi_we                           <= '0';            
            im_axi_addr                         <= (others => '0');
            im_axi_data0                        <= (others => '0');
            im_axi_data1                        <= (others => '0');
            
            gen_port_out(done_f-1)              <= o_axi_imok;
            gen_port_out(rd_done_f-1)           <= '0';
            gen_port_out(opx_f-1 downto rd_done_f) <= std_logic_vector(clk_count);
        
        else
        
            -- Standard mode 
            i_axi_clk                           <= gen_port_in(iclk_f-1);
            i_axi_en                            <= gen_port_in(ien_f-1);
            i_axi_we                            <= gen_port_in(iwe_f-1);
            i_axi_x                             <= unsigned(x_flag);
            i_axi_y                             <= unsigned(gen_port_in(iy_f-1 downto ix_f));
            i_axi_s                             <= unsigned(gen_port_in(is_f-1 downto iy_f));
            i_axi_f                             <= unsigned(gen_port_in(if_f-1 downto is_f));
            i_axi_px                            <= unsigned(gen_port_in(ipx_f-1 downto if_f));
            
            im_axi_clk                          <= '0';
            im_axi_we                           <= '0';
            im_axi_addr                         <= (others => '0');
            im_axi_data0                        <= (others => '0');
            im_axi_data1                        <= (others => '0');
            
            gen_port_out(done_f-1)              <= done;
            gen_port_out(rd_done_f-1)           <= rd_done;
            gen_port_out(opx_f-1 downto rd_done_f) <= std_logic_vector(o_axi_px);
        end if;
    end process;
    
end Behavioral;