----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 26.07.2019 15:44:03
-- Design Name: Register Bank
-- Module Name: breg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Register Bank with 32 registers of parametrizable size.
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

entity breg is
    generic(
            bit_width       : natural;
            isf_x           : natural;
            isf_y           : natural;
            isf_s           : natural;
            isf_f           : natural;
            isf_px          : natural;
            regfile_size    : natural;
            x_init          : natural;
            y_init          : natural;
            img_px_width    : natural;
            img_px_height   : natural;
            subimg_width    : natural;
            subimg_height   : natural
            );
    port(
        rs, rt, rd : in STD_LOGIC_VECTOR(regfile_size-1 downto 0);
        d_in : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        wren, clk, spx_en, i_mem_gpx_f : in STD_LOGIC;
        gpx_en : in STD_LOGIC := 'Z'; 
        x_in : in STD_LOGIC_VECTOR(isf_x-1 downto 0);
        y_in : in STD_LOGIC_VECTOR(isf_y-1 downto 0);
        f_in : in STD_LOGIC_VECTOR(isf_f-1 downto 0);
        s_in : in STD_LOGIC_VECTOR(isf_s-1 downto 0);
        idec_px : in STD_LOGIC_VECTOR(isf_px-1 downto 0);
        mem_px : in UNSIGNED(2**bit_width-1 downto 0);
        x_out : out UNSIGNED(2**bit_width-1 downto 0);
        y_out : out UNSIGNED(2**bit_width-1 downto 0);
        f_out : out UNSIGNED(2**bit_width-1 downto 0);
        s_out : out UNSIGNED(2**bit_width-1 downto 0);
        px_out : out UNSIGNED(2**bit_width-1 downto 0);
        s_reg_out : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        ra, rb : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        o_mem_wr_en, o_mem_gpx_f : out STD_LOGIC
        );
end breg;

architecture Behavioral of breg is
    constant N : natural        := 2**bit_width;
    constant pixel_mem_init     : natural := 2**regfile_size-6-1; -- -1 because of step register -6 because of tile coordinates
    constant c_zero             : STD_LOGIC_VECTOR(N-1 downto 0) := (N-1 downto 0 => '0');
    constant c_one              : STD_LOGIC_VECTOR(N-1 downto 0) := (N-1 downto 1 => '0') & '1';
    constant c_x_init           : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(x_init, N));
    constant c_y_init           : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(y_init, N));
    constant c_img_width        : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(img_px_width, N));
    constant c_img_height       : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(img_px_height, N));
    constant c_subimg_width     : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(subimg_width, N));
    constant c_subimg_height    : STD_LOGIC_VECTOR(N-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(subimg_height, N));
    type mem_array is array(pixel_mem_init-1 downto 0)
                   of STD_LOGIC_VECTOR(N-1 downto 0);
    type tile_array is array(5 downto 0)
                   of STD_LOGIC_VECTOR(N-1 downto 0);
    -- Register bank instantiation
    -- --   (more info: https://stackoverflow.com/a/30299963/10995501)
    signal mem : mem_array := (0 => c_zero,1 => c_one, others => (others => 'Z'));
    signal tile_mem : tile_array := (   0 => c_x_init,
                                        1 => c_y_init,
                                        2 => c_img_width,
                                        3 => c_img_height,
                                        4 => c_subimg_width,
                                        5 => c_subimg_height
                                    );
    signal rs_tmp, rt_tmp, rd_tmp : natural;
    signal index_x, index_y, index_s, index_f, index_px : natural;
    signal step_reg : STD_LOGIC_VECTOR(N-1 downto 0);
begin
    
    s_reg_out    <= step_reg;

    -- Read process and signals    
    rs_tmp      <= TO_INTEGER(UNSIGNED(rs));
    rt_tmp      <= TO_INTEGER(UNSIGNED(rt));
    
    process(rs_tmp, rt_tmp, step_reg, d_in)
    begin
        if (rs_tmp < pixel_mem_init) then
            ra <= mem(rs_tmp);
        elsif(rs_tmp < 2**regfile_size - 1) then
            ra <= tile_mem(rs_tmp - pixel_mem_init);
        else
            ra <= step_reg;
        end if;
        if (rt_tmp < pixel_mem_init) then
            rb <= mem(rt_tmp);
        elsif(rt_tmp < 2**regfile_size - 1) then
            rb <= tile_mem(rt_tmp - pixel_mem_init);
        else
            rb <= step_reg;
        end if;
    end process;
    
    -- Write process and signals
    rd_tmp      <= TO_INTEGER(UNSIGNED(rd));
    
    process(clk, wren, rd_tmp, d_in, step_reg, index_px, mem_px)
    begin
        if RISING_EDGE(clk) then
            if wren = '1' then
                -- 1st register always zero
                -- 2nd register always 0x1
                -- 4 last registers reserved to pixel operation
                if (rd_tmp > 1) and (rd_tmp < pixel_mem_init) then -- -6 because tile coordinates are read only
                    mem(rd_tmp)  <= d_in;
                elsif (rd_tmp = 2**regfile_size - 1) then
                    step_reg    <= d_in;
                end if;
            else
                if gpx_en = '1' then
                    mem(index_px) <= STD_LOGIC_VECTOR(mem_px);
                end if;
            end if;
        end if;
    end process;
    
    -- GPX and SPX process and signals
    -- send/receive data to/from Pixel memory
    index_x     <= TO_INTEGER(UNSIGNED(x_in));
    index_y     <= TO_INTEGER(UNSIGNED(y_in));
    index_s     <= TO_INTEGER(UNSIGNED(s_in));
    index_f     <= TO_INTEGER(UNSIGNED(f_in));
    index_px    <= TO_INTEGER(UNSIGNED(idec_px));
    
    process(i_mem_gpx_f, spx_en, gpx_en, index_x, index_y, index_s, index_f, index_px)
    begin
        if gpx_en = '1' then
            if (i_mem_gpx_f = '0') then
                o_mem_wr_en <= '0';
                o_mem_gpx_f <= '1';
            
                -- send P-type fields to Pixel memory
                x_out <= unsigned(mem(index_x));
                y_out <= unsigned(mem(index_y));
                s_out <= unsigned(mem(index_s));
                f_out <= unsigned(mem(index_f));
            end if;
        else
            if spx_en = '1' then
                -- enable to write pixel memory
                o_mem_wr_en <= '1';
                o_mem_gpx_f <= '1';
            
                -- send P-type fields to Pixel memory
                x_out <= unsigned(mem(index_x));
                y_out <= unsigned(mem(index_y));
                s_out <= unsigned(mem(index_s));
                f_out <= unsigned(mem(index_f));
                
                -- Keeps MSB equals 0 because of Rd/Wr bit
                px_out <= unsigned(mem(index_px));
            else
                -- reset control signals
                o_mem_wr_en <= '0';
                o_mem_gpx_f <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
