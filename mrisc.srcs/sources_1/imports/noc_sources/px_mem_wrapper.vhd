----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 01/23/2020 02:56:50 PM
-- Design Name: 
-- Module Name: px_mem_wrapper - Behavioral
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

entity px_mem_wrapper is
    generic (
            noc_height      : natural;
            x_init          : natural;
            y_init          : natural;
            px_true_size    : natural;
            pix_depth       : natural;
            img_width       : natural;
            img_height      : natural;
            tile_width      : natural;
            tile_height     : natural;
            subimg_width    : natural;
            subimg_height   : natural;
            subimg_wmode    : natural;
            subimg_hmode    : natural;
            n_frames        : natural;
            n_steps         : natural;
            bit_width       : natural
            );
    port(
        clk, reset      : in STD_LOGIC;
        o_endpgr_flag   : out STD_LOGIC;
        i_mode          : in std_logic_vector(15 downto 0);
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
        i_PM_req    : in STD_LOGIC; -- message request
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
        
        ----------------------------------------------------
        -- port to write pixel values from the AXI
        i_axi_clk   : in std_logic;
        i_axi_en    : in std_logic;
        i_axi_we    : in std_logic;
    
        i_axi_x     : in unsigned(img_width-1 downto 0);
        i_axi_y     : in unsigned(img_height-1 downto 0);
        i_axi_s     : in unsigned(n_steps-1 downto 0);
        i_axi_f     : in unsigned(n_frames-1 downto 0);
        i_axi_px    : in unsigned(px_true_size-1 downto 0);
    
        o_rd_done   : out std_logic;
        o_axi_px    : out unsigned(px_true_size-1 downto 0);
        
        ----------------------------------------------------
        -- PE/PM interface
        i_pm_en         : in std_logic;
        i_pm_wen        : in std_logic;
        i_pm_x          : in unsigned(img_width-1 downto 0);
        i_pm_y          : in unsigned(img_height-1 downto 0);
        i_pm_s          : in unsigned(n_steps-1 downto 0);
        i_pm_f          : in unsigned(n_frames-1 downto 0);
        i_pm_px         : in unsigned(px_true_size-1 downto 0);
        
        o_pm_done       : out std_logic;
        o_pm_px         : out unsigned(px_true_size-1 downto 0)
    );
end px_mem_wrapper;

architecture Behavioral of px_mem_wrapper is

component bram_pixel_memory is
generic(
    x_init          : natural;
    y_init          : natural;
    px_true_size    : natural;
    pix_depth       : natural;
    img_width       : natural;
    img_height      : natural;
    tile_width      : natural;
    tile_height     : natural;
    subimg_width    : natural;
    subimg_height   : natural;
    n_frames        : natural;
    n_steps         : natural
);
port(
    ----------------------------------------------------
    -- port to write pixel values from the AXI
    i_axi_clk   : in std_logic;
    i_axi_en    : in std_logic;
    i_axi_we    : in std_logic;

    i_axi_x     : in unsigned(img_width-1 downto 0);
    i_axi_y     : in unsigned(img_height-1 downto 0);
    i_axi_s     : in unsigned(n_steps-1 downto 0);
    i_axi_f     : in unsigned(n_frames-1 downto 0);
    i_axi_px    : in unsigned(px_true_size-1 downto 0);

    o_rd_done   : out std_logic;
    o_axi_px    : out unsigned(px_true_size-1 downto 0);
    ----------------------------------------------------
    -- ports to access from the Tile Router
    i_reset         : in std_logic;
    i_clk           : in std_logic;
    i_enable        : in std_logic;
    i_wr_enable     : in std_logic;

    i_router_x      : in  unsigned(img_width-1 downto 0);
    i_router_y      : in  unsigned(img_height-1 downto 0);
    i_router_s      : in  unsigned(n_steps-1 downto 0);
    i_router_f      : in  unsigned(n_frames-1 downto 0);
    i_router_px     : in  unsigned(pix_depth-1 downto 0);
    
    o_router_opx    : out unsigned(pix_depth-1 downto 0);
    o_router_fpx    : out std_logic;
    o_out_ok        : out std_logic
);
end component bram_pixel_memory;

signal s_axi_clk   : std_logic;
signal s_axi_en    : std_logic;
signal s_axi_we    : std_logic;

signal s_axi_x     : unsigned(img_width-1 downto 0);
signal s_axi_y     : unsigned(img_height-1 downto 0);
signal s_axi_s     : unsigned(n_steps-1 downto 0);
signal s_axi_f     : unsigned(n_frames-1 downto 0);
signal s_axi_px    : unsigned(px_true_size-1 downto 0);

signal s_rd_done   : std_logic;
signal s_axi_opx    : unsigned(px_true_size-1 downto 0);

----------------------------------------------------
signal si_reset             : std_logic;
signal si_clk               : std_logic;
signal si_router_x          : unsigned(img_width-1 downto 0); 
signal si_router_y          : unsigned(img_height-1 downto 0);
signal si_router_s          : unsigned(n_steps-1 downto 0);   
signal si_router_f          : unsigned(n_frames-1 downto 0);  
signal si_router_px         : unsigned(pix_depth-1 downto 0); 
signal so_router_opx        : unsigned(pix_depth-1 downto 0); 
signal so_router_fpx        : std_logic;
signal si_enable            : std_logic;
signal si_wr_enable         : std_logic;
signal so_out_ok            : std_logic;  

type state_type is (forward, backward, wait_pixel,
                    write_pixel, wait_backward, handshake);  -- Define the states
signal mode : state_type:= forward;    -- Create a signal that uses 
signal s_axi_valid : std_logic;
signal s_mode   : std_logic_vector(2 downto 0);
signal s_s_sync : natural;
signal tmp_step : natural := 0;

begin

px_mem : bram_pixel_memory       generic map(
                                            x_init => x_init,            
                                            y_init => y_init,      
                                            px_true_size => px_true_size,  
                                            pix_depth => pix_depth,     
                                            img_width => img_width,
                                            img_height=> img_height,
                                            tile_width          => tile_width        ,
                                            tile_height         => tile_height       ,
                                            subimg_width        => subimg_width,
                                            subimg_height       => subimg_height,
                                            n_frames  => n_frames,
                                            n_steps   => n_steps
                                            )
                                    port map(
                                            i_reset         => si_reset,
                                            i_clk           => si_clk,
                                            i_axi_clk       => s_axi_clk,
                                            i_axi_en        => s_axi_en,
                                            i_axi_we        => s_axi_we,
                                            i_axi_x         => s_axi_x,
                                            i_axi_y         => s_axi_y,
                                            i_axi_s         => s_axi_s,
                                            i_axi_f         => s_axi_f,
                                            i_axi_px        => s_axi_px,
                                            o_rd_done       => s_rd_done,
                                            o_axi_px        => s_axi_opx,
                                            i_router_x      => si_router_x,
                                            i_router_y      => si_router_y,
                                            i_router_s      => si_router_s,
                                            i_router_f      => si_router_f,
                                            i_router_px     => si_router_px,
                                            o_router_opx    => so_router_opx,
                                            i_enable        => si_enable,
                                            i_wr_enable     => si_wr_enable,
                                            o_out_ok        => so_out_ok,
                                            o_router_fpx    => so_router_fpx
                                            );

tmp_step    <= to_integer(UNSIGNED(t_PM_step));
s_s_sync    <= to_integer(unsigned(i_s_sync));

si_clk      <= clk;
s_axi_clk   <= clk;

-- AXI/PE process
process(clk, i_mode, s_rd_done)
    variable v_mode : natural;
begin
    if rising_edge(clk) then
        v_mode := to_integer(unsigned(i_mode));
        if  (v_mode = ((x_init / subimg_wmode) + (noc_height * y_init / subimg_hmode) + 1))  then
            s_axi_valid <= '1';
        elsif (s_rd_done /= '1') then
                s_axi_valid <= '0';
        end if;
    end if;
end process;

process(s_axi_valid, i_axi_en, i_axi_we, i_axi_x, i_axi_y, i_axi_s, i_axi_f, i_axi_px,
        si_clk, i_pm_en, i_pm_wen, i_pm_x, i_pm_y, i_pm_s, i_pm_f, i_pm_px, s_rd_done, s_axi_opx)
begin
    if(s_axi_valid = '1') then
        -- AXI-PM Interface
        s_axi_en    <= i_axi_en;
        s_axi_we    <= i_axi_we; 
        s_axi_x     <= i_axi_x; 
        s_axi_y     <= i_axi_y;  
        s_axi_s     <= i_axi_s;  
        s_axi_f     <= i_axi_f;  
        s_axi_px    <= i_axi_px; 
        
        o_rd_done   <= s_rd_done;
        o_axi_px    <= s_axi_opx;
        
        o_pm_done   <= '0';
        o_pm_px     <= (others => '0');
    else
        -- PE-PM Interface
        s_axi_en    <= i_pm_en;
        s_axi_we    <= i_pm_wen; 
        s_axi_x     <= i_pm_x; 
        s_axi_y     <= i_pm_y;  
        s_axi_s     <= i_pm_s;  
        s_axi_f     <= i_pm_f;  
        s_axi_px    <= i_pm_px;
        
        o_rd_done   <= '0';
        o_axi_px    <= (others => '0');

        o_pm_done   <= s_rd_done;
        o_pm_px     <= s_axi_opx;
    end if;
end process;

-- Router read request
process(clk, reset, so_router_opx, t_PM_x_dest, t_PM_y_dest, t_PM_step, t_PM_frame,
        t_PM_pixel, so_router_fpx, so_out_ok, t_PM_req, i_PM_ack) is
begin
    if(reset='1')then
        si_reset    <= '1';
        si_enable   <= '0';
        i_PM_pixel  <= (others => '0');
        i_PM_x_dest <= (others => '0');
        i_PM_y_dest <= (others => '0');
        i_PM_step   <= (others => '0');
        i_PM_frame  <= (others => '0');
        i_PM_x_orig <= (others => '0');
        i_PM_y_orig <= (others => '0');
        i_PM_fb     <= '0'; -- 0 is forward; 1 is backward
        i_PM_req    <= '0';  
        t_PM_ack    <= '0';
        mode        <= forward;     
    elsif(rising_edge(clk))then
        si_reset    <= '0';
        si_enable   <= '1';
        case mode is
            when forward =>        
                if(t_PM_req='1') then -- there is a request from the pe to access the pixel memory.
                    -- read input pixels
                    si_router_x     <= UNSIGNED(t_PM_x_dest);
                    si_router_y     <= UNSIGNED(t_PM_y_dest);
                    si_router_s     <= UNSIGNED(t_PM_step);
                    si_router_f     <= UNSIGNED(t_PM_frame);
                    si_router_px    <= UNSIGNED(t_PM_pixel);
                    
                    -- signal to complete handshake
                    i_PM_pixel      <= (others => '0');
                    i_PM_x_dest     <= (others => '0');
                    i_PM_y_dest     <= (others => '0');
                    i_PM_step       <= (others => '0');
                    i_PM_frame      <= (others => '0');
                    i_PM_x_orig     <= (others => '0');
                    i_PM_y_orig     <= (others => '0');
                    i_PM_fb         <= '0';
                    i_PM_req        <= '0';
                    t_PM_ack        <= '1';
                    mode            <= handshake;
                end if;
            when wait_pixel =>
                if (so_router_fpx = '1') and (so_out_ok = '1') and (t_PM_req = '0') and (i_PM_ack = '0') then
                    i_PM_pixel      <= STD_LOGIC_VECTOR(so_router_opx);
                    i_PM_x_dest     <= t_PM_x_dest;
                    i_PM_y_dest     <= t_PM_y_dest;
                    i_PM_step       <= t_PM_step;
                    i_PM_frame      <= t_PM_frame;
                    i_PM_x_orig     <= t_PM_x_orig;
                    i_PM_y_orig     <= t_PM_y_orig;
                    i_PM_fb         <= '1'; -- 0 is read; 1 write
                    i_PM_req        <= '1';
                    t_PM_ack        <= '1';
                    si_wr_enable    <= '0';
                    mode            <= backward;
                end if;
            when write_pixel =>
                if(so_out_ok = '1') then
                    i_PM_pixel      <= (others => '0');
                    i_PM_x_dest     <= (others => '0');
                    i_PM_y_dest     <= (others => '0');
                    i_PM_step       <= (others => '0');
                    i_PM_frame      <= (others => '0');
                    i_PM_x_orig     <= (others => '0');
                    i_PM_y_orig     <= (others => '0');
                    i_PM_fb         <= '0';
                    i_PM_req        <= '0';
                    t_PM_ack        <= '0';
                    si_wr_enable    <= '0';
                    mode            <= forward;
                end if;
            when backward =>
                if(i_PM_ack = '1') then --means that the router 'ack-ed' the request to backward the message to the original PE
                    i_PM_pixel      <= (others => '0');
                    i_PM_x_dest     <= (others => '0');
                    i_PM_y_dest     <= (others => '0');
                    i_PM_step       <= (others => '0');
                    i_PM_frame      <= (others => '0');
                    i_PM_x_orig     <= (others => '0');
                    i_PM_y_orig     <= (others => '0');
                    i_PM_fb         <= '0';
                    i_PM_req        <= '0';
                    t_PM_ack        <= '0';
                    si_wr_enable    <= '0';
                    mode            <= forward;
                end if;
            when handshake =>
                if(si_router_px = '1' & (pix_depth - 2 downto 0 => '0')) then  -- read
                    if (tmp_step > s_s_sync) then   -- not exist
                        if (t_PM_req = '0') and (i_PM_ack = '0') then
                            i_PM_pixel      <= (others => '1');
                            i_PM_x_dest     <= t_PM_x_dest;
                            i_PM_y_dest     <= t_PM_y_dest;
                            i_PM_step       <= t_PM_step;
                            i_PM_frame      <= t_PM_frame;
                            i_PM_x_orig     <= t_PM_x_orig;
                            i_PM_y_orig     <= t_PM_y_orig;
                            i_PM_fb         <= '1'; -- 0 is read; 1 write
                            i_PM_req        <= '1';
                            t_PM_ack        <= '1';
                            si_wr_enable    <= '0';
                            mode            <= backward;
                        end if;
                    else    -- read
                        i_PM_pixel      <= (others => '0');
                        i_PM_x_dest     <= (others => '0');
                        i_PM_y_dest     <= (others => '0');
                        i_PM_step       <= (others => '0');
                        i_PM_frame      <= (others => '0');
                        i_PM_x_orig     <= (others => '0');
                        i_PM_y_orig     <= (others => '0');
                        i_PM_fb         <= '0';
                        i_PM_req        <= '0';
                        t_PM_ack        <= '1';
                        si_wr_enable    <= '0';
                        mode            <= wait_pixel;
                    end if;
                else    -- write
                    i_PM_pixel      <= (others => '0');
                    i_PM_x_dest     <= (others => '0');
                    i_PM_y_dest     <= (others => '0');
                    i_PM_step       <= (others => '0');
                    i_PM_frame      <= (others => '0');
                    i_PM_x_orig     <= (others => '0');
                    i_PM_y_orig     <= (others => '0');
                    i_PM_fb         <= '0';
                    i_PM_req        <= '0';
                    t_PM_ack        <= '1';
                    si_wr_enable    <= '1';
                    mode            <= write_pixel;
                end if;                
            when others =>
                mode    <= forward;
        end case;
    end if;
end process;


end Behavioral;
