-- Author: Jones Yudi - University of Brasilia
-- Modified by: Bruno Almeida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bram_pixel_memory is

generic(
    x_init          : natural := 0;
    y_init          : natural := 0;
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
end entity bram_pixel_memory;

architecture behavioral of bram_pixel_memory is

    component rams_tdp_rf_rf
        generic(
                pixel_size  : natural;
                addr_size   : natural;
                mem_size    : natural
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
                dia     : in  std_logic_vector(pixel_size-1 downto 0);
                dib     : in  std_logic_vector(pixel_size-1 downto 0);
                doa     : out std_logic_vector(pixel_size-1 downto 0);
                dob     : out std_logic_vector(pixel_size-1 downto 0);
                doa_ok  : out std_logic;
                dob_ok  : out std_logic 
            );
    end component;

    constant c_addr_size    : natural := tile_width+tile_height+n_steps;
    constant c_mem_size     : natural := 2**(n_steps)*subimg_width*subimg_height;

    signal s_rd_done        : std_logic;
    signal s_router_x       : unsigned(31 downto 0);
    signal s_router_y       : unsigned(31 downto 0);
    signal s_router_s       : unsigned(31 downto 0);
    signal s_router_f       : unsigned(31 downto 0);
    signal s_router_px      : unsigned(31 downto 0);
    signal s_axi_x          : unsigned(31 downto 0);
    signal s_axi_y          : unsigned(31 downto 0);
    signal s_axi_s          : unsigned(31 downto 0);
    signal s_axi_f          : unsigned(31 downto 0);
    signal s_axi_px         : unsigned(31 downto 0);
        
    signal s_clka : std_logic;
    signal s_ena  : std_logic;
    signal s_wea  : std_logic;
    signal s_addra: std_logic_vector(c_addr_size-1 downto 0);
    signal s_dia  : std_logic_vector(8 downto 0);
    signal s_doa  : std_logic_vector(8 downto 0);
    signal s_clkb : std_logic;
    signal s_enb  : std_logic;
    signal s_web  : std_logic;
    signal s_addrb: std_logic_vector(c_addr_size-1 downto 0);
    signal s_dib  : std_logic_vector(8 downto 0);
    signal s_dob  : std_logic_vector(8 downto 0);
    signal s_doa_ok  : std_logic;   
                
    signal mem_size : unsigned(31 downto 0)                 := to_unsigned(c_mem_size, 32);
    signal img_size : unsigned(tile_height downto 0)        := to_unsigned(subimg_height, tile_height+1);
    signal steps    : unsigned(n_steps downto 0)            := to_unsigned(2**n_steps, n_steps+1);
    signal frames   : unsigned(n_frames downto 0)           := to_unsigned(n_frames, n_frames+1);

begin
    
    -- Clock sources
    s_clka          <= i_axi_clk;
    s_clkb          <= i_clk;

    bram_inst: rams_tdp_rf_rf 
    generic map(
                pixel_size  => px_true_size,
                addr_size   => c_addr_size,
                mem_size    => c_mem_size
                )
    port map(
        clka => s_clka,
        ena  => s_ena,
        wea  => s_wea,
        addra=> s_addra,
        dia  => s_dia,
        doa  => s_doa,
        doa_ok => s_doa_ok,
        
        clkb => s_clkb,
        enb  => s_enb,
        web  => s_web,
        
        addrb=> s_addrb,
        dib  => s_dib,
        dob  => s_dob,
        dob_ok => o_out_ok
    );

    s_router_x      <= to_unsigned(to_integer(i_router_x), s_router_x'length);
    s_router_y      <= to_unsigned(to_integer(i_router_y), s_router_y'length);
    s_router_s      <= to_unsigned(to_integer(i_router_s), s_router_s'length);
    s_router_f      <= to_unsigned(to_integer(i_router_f), s_router_f'length);
    s_router_px     <= to_unsigned(to_integer(i_router_px), s_router_px'length);
    s_axi_x         <= to_unsigned(to_integer(i_axi_x), s_axi_x'length);
    s_axi_y         <= to_unsigned(to_integer(i_axi_y), s_axi_y'length);
    s_axi_s         <= to_unsigned(to_integer(i_axi_s), s_axi_s'length);
    s_axi_f         <= to_unsigned(to_integer(i_axi_f), s_axi_f'length);
    s_axi_px        <= to_unsigned(to_integer(i_axi_px), s_axi_px'length);

    -- AXI/PE memory part
    o_rd_done   <= s_rd_done and s_doa_ok;
    o_axi_px    <= UNSIGNED(to_signed(to_integer(signed(s_doa(pix_depth-2 downto 0))),o_axi_px'length));
    
    process(i_axi_en, i_axi_we,s_axi_x,s_axi_y,s_axi_s,s_axi_f,s_axi_px)
        variable s_axi_addr : unsigned(31 downto 0);
    begin
        if(i_axi_en = '1') then
            s_axi_addr  :=  resize( img_size*(s_axi_x-x_init)*steps*frames+(s_axi_y-y_init)*steps*frames+
                                    s_axi_s*frames+s_axi_f, s_axi_addr'length);
            s_ena       <= '1';
            if(s_axi_addr < mem_size) then
                s_addra     <= std_logic_vector(s_axi_addr(s_addra'length-1 downto 0));
                s_rd_done   <= '1';
                if(i_axi_we = '1') then
                    s_wea   <= '1';
                    s_dia   <= std_logic_vector(to_signed(to_integer(s_axi_px), s_dia'length));
                else
                    s_wea   <= '0';
                end if;
            end if;
        else
            s_ena       <= '0';
            s_rd_done   <= '0';
        end if;
    end process;

    -- Router memory part
    o_router_opx    <= to_unsigned(to_integer(unsigned(s_dob(pix_depth-2 downto 0))),o_router_opx'length);
    
    process(i_reset,i_wr_enable,i_enable,s_router_x,s_router_y,s_router_s,s_router_f,s_router_px)
        variable s_router_addr : unsigned(31 downto 0);
    begin
        if(i_reset='0')then
            if(i_enable='1')then
                s_router_addr   := resize(  img_size*(s_router_x-x_init)*steps*frames+(s_router_y-y_init)*steps*frames+s_router_s*frames+s_router_f, s_router_addr'length);
                s_enb <= '1';
                if(s_router_addr < mem_size) then
                    s_addrb <= std_logic_vector(s_router_addr(s_addrb'length-1 downto 0));
                    o_router_fpx <= '1';
                    if(i_wr_enable='1')then
                        s_web <= '1';
                        s_dib <= std_logic_vector(s_router_px(s_dib'length-1 downto 0));
                    else
                        s_web <= '0';
                    end if;
                end if;
            else
                s_enb           <= '0';
                o_router_fpx    <= '0';
            end if;
        end if;
    end process;
       
end architecture behavioral;
