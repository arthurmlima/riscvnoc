----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 01/21/2020 11:45:29 AM
-- Design Name: 
-- Module Name: pe_wrapper - Behavioral
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

entity pe_wrapper is
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
end pe_wrapper;

architecture Behavioral of pe_wrapper is

component processing_element is
    generic(
            bit_width           : natural;
            instruction_length  : natural;
            memory_length       : natural;
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
        clk : in STD_LOGIC := '0'; -- processor clock
        
        -- P-type instuctions interface
        i_mem_gpx_f, i_reset : in STD_LOGIC;
        mem_px : in UNSIGNED(2**bit_width-1 downto 0);
        x_out : out UNSIGNED(2**bit_width-1 downto 0);
        y_out : out UNSIGNED(2**bit_width-1 downto 0);
        f_out : out UNSIGNED(2**bit_width-1 downto 0);
        s_out : out UNSIGNED(2**bit_width-1 downto 0);
        px_out : out UNSIGNED(2**bit_width-1 downto 0);
        s_reg_out : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        o_mem_wr_en, o_mem_gpx_f, o_endpgr_flag : out STD_LOGIC;
        
        o_idec_x : out STD_LOGIC_VECTOR(isf_x-1 downto 0);
        o_idec_y : out STD_LOGIC_VECTOR(isf_y-1 downto 0);
        o_idec_f : out STD_LOGIC_VECTOR(isf_f-1 downto 0);
        o_idec_s : out STD_LOGIC_VECTOR(isf_s-1 downto 0);
        o_idec_px : out STD_LOGIC_VECTOR(isf_px-1 downto 0);
        o_instruction : out STD_LOGIC_VECTOR(instruction_length-1 downto 0);
        
        o_opcode    : out STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
        o_rs, o_rt, o_ula_out  : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        
        -- AXI/Instruction Memory interface
        i_axi_clk       : in STD_LOGIC;
        i_axi_we        : in STD_LOGIC;
        i_axi_addr      : in STD_LOGIC_VECTOR(31 downto 0);
        i_axi_data0     : in STD_LOGIC_VECTOR(31 downto 0);
        i_axi_data1     : in STD_LOGIC_VECTOR(31 downto 0);
        o_axi_imok      : out STD_LOGIC
        );
end component processing_element;

signal si_mem_gpx_f : STD_LOGIC;
signal mem_px       : UNSIGNED(2**bit_width-1 downto 0);
signal x_out        : UNSIGNED(2**bit_width-1 downto 0);
signal y_out        : UNSIGNED(2**bit_width-1 downto 0);
signal f_out        : UNSIGNED(2**bit_width-1 downto 0);
signal s_out        : UNSIGNED(2**bit_width-1 downto 0);
signal px_out       : UNSIGNED(2**bit_width-1 downto 0);
signal s_mem_wr_en, so_mem_gpx_f, s_endpgr_flag : STD_LOGIC;

-- define FSM types
type state_type is (SPX_INIT, SPX_WAIT, SPX_END,
                    GPX_INIT, GPX_WAIT, GPX_RECV, GPX_END, GPX_ERR,
                    GPX_RST, BUSY, IDLE, NONE);
signal s_state : state_type := BUSY;

-- i_mem_gpx_f = t_PE_req
-- o_mem_gpx_f = i_PE_req
-- ACK is used as guarantee
signal s_x_dest                         : STD_LOGIC_VECTOR(img_width-1 downto 0);
signal s_y_dest                         : STD_LOGIC_VECTOR(img_height-1 downto 0);
signal s_step                           : STD_LOGIC_VECTOR(n_steps-1 downto 0);
signal s_frame                          : STD_LOGIC_VECTOR(n_frames-1 downto 0);
signal s_x_orig                         : STD_LOGIC_VECTOR(img_width-1 downto 0);
signal s_y_orig                         : STD_LOGIC_VECTOR(img_height-1 downto 0);
signal pixel_coord_in, pixel_coord_out  : STD_LOGIC_VECTOR(2*img_width+2*img_height+n_steps+n_frames-1 downto 0);
signal mode                             : STD_LOGIC_VECTOR(2 downto 0);
signal clk_count_sync, clk_count_wait   : integer := 0;

function get_nstate(i_mode : STD_LOGIC_VECTOR(2 downto 0)) return state_type is
begin
    case i_mode is
        when "011" =>
            return SPX_INIT;
        when "001" =>
            return GPX_INIT;
        when "100" =>
            return IDLE;
        when others =>
            return BUSY;
    end case;
end function;

begin

proc_element : processing_element   generic map(
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
                                                addr_size           => addr_size
                                            ) 
                                    port map(
                                            clk             => clk,
                                            i_mem_gpx_f     => si_mem_gpx_f,
                                            mem_px          => mem_px,
                                            i_reset         => reset,
                                            x_out           => x_out,
                                            y_out           => y_out,
                                            f_out           => f_out,
                                            s_out           => s_out,
                                            px_out          => px_out,
                                            s_reg_out       => s_reg_out,
                                            o_mem_wr_en     => s_mem_wr_en,
                                            o_mem_gpx_f     => so_mem_gpx_f,
                                            o_endpgr_flag   => s_endpgr_flag,
                                            i_axi_clk       => i_axi_clk,
                                            i_axi_we        => i_axi_we,
                                            i_axi_addr      => i_axi_addr,
                                            i_axi_data0     => i_axi_data0,
                                            i_axi_data1     => i_axi_data1,
                                            o_axi_imok      => o_axi_imok,
                                            o_idec_x        => o_idec_x ,
                                            o_idec_y        => o_idec_y ,
                                            o_idec_f        => o_idec_f ,
                                            o_idec_s        => o_idec_s ,
                                            o_idec_px       => o_idec_px,
                                            o_instruction   => o_instruction,
                                            o_opcode        => o_opcode,
                                            o_rs            => o_rs,
                                            o_rt            => o_rt,
                                            o_ula_out       => o_ula_out
                                            );

o_x_out  <= x_out ;
o_y_out  <= y_out ;
o_f_out  <= f_out ;
o_s_out  <= s_out ;
o_px_out <= px_out;

s_x_dest    <=  STD_LOGIC_VECTOR(to_unsigned(to_integer(x_out), i_PE_x_dest'length));
s_y_dest    <=  STD_LOGIC_VECTOR(to_unsigned(to_integer(y_out), i_PE_y_dest'length));
s_step      <=  STD_LOGIC_VECTOR(to_unsigned(to_integer(s_out), i_PE_step'length));  
s_frame     <=  STD_LOGIC_VECTOR(to_unsigned(to_integer(f_out), i_PE_frame'length)); 
s_x_orig    <=  STD_LOGIC_VECTOR(to_unsigned(x_init, i_PE_x_orig'length));           
s_y_orig    <=  STD_LOGIC_VECTOR(to_unsigned(y_init, i_PE_y_orig'length));           

mode <= s_endpgr_flag & s_mem_wr_en & so_mem_gpx_f;

pixel_coord_in  <= t_PE_x_dest & t_PE_y_dest & t_PE_step & t_PE_frame & t_PE_x_orig & t_PE_y_orig;
pixel_coord_out <= s_x_dest & s_y_dest & s_step & s_frame & s_x_orig & s_y_orig;

process(clk, reset, mode, s_x_dest, s_y_dest, s_step, s_frame, s_x_orig,
        s_y_orig, pixel_coord_in, pixel_coord_out, t_PE_req, i_PE_ack)
begin
    if reset = '1' then
        mem_px          <= (others => '0');
        i_PE_pixel      <= (others => '0');
        i_PE_x_dest     <= (others => '0');
        i_PE_y_dest     <= (others => '0');
        i_PE_step       <= (others => '0');
        i_PE_frame      <= (others => '0');
        i_PE_x_orig     <= (others => '0');
        i_PE_y_orig     <= (others => '0');
        i_PE_fb         <= '0'; -- Foward (not wait for pixel)
        i_PE_req        <= '0'; -- Pe wants to give px to Router    
        t_PE_ack        <= '0';
        si_mem_gpx_f    <= '0';
        o_endpgr_flag   <= '0';
        s_state         <= BUSY;
    else
        if RISING_EDGE(clk) then
            case s_state is
                when SPX_INIT =>
                    if t_PE_req = '0' and i_PE_ack = '0' then
                        mem_px          <= (others => '0');
                        i_PE_pixel      <= "0" & STD_LOGIC_VECTOR(to_unsigned(to_integer(px_out), i_PE_pixel'length-1));
                        i_PE_x_dest     <= s_x_dest;
                        i_PE_y_dest     <= s_y_dest;
                        i_PE_step       <= s_step;  
                        i_PE_frame      <= s_frame; 
                        i_PE_x_orig     <= s_x_orig;
                        i_PE_y_orig     <= s_y_orig;
                        i_PE_fb         <= '0'; -- Foward -> send to PM
                        i_PE_req        <= '1'; -- Pe wants to give px to Router
                        t_PE_ack        <= '1';
                        si_mem_gpx_f    <= '0'; -- Lock Program Counter to wait handshake
                        o_endpgr_flag   <= '0';
                        s_state         <= SPX_WAIT;
                    end if;
                when SPX_WAIT =>
                    if i_PE_ack = '1' then
                        mem_px          <= (others => '0');
                        i_PE_pixel      <= (others => '0');
                        i_PE_x_dest     <= (others => '0');
                        i_PE_y_dest     <= (others => '0');
                        i_PE_step       <= (others => '0');
                        i_PE_frame      <= (others => '0');
                        i_PE_x_orig     <= (others => '0');
                        i_PE_y_orig     <= (others => '0');
                        i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                        i_PE_req        <= '0';   
                        t_PE_ack        <= '0';
                        si_mem_gpx_f    <= '1';
                        o_endpgr_flag   <= '0';
                        s_state         <= SPX_END;
                    end if;
                when SPX_END =>
                    i_PE_pixel      <= (others => '0');
                    i_PE_x_dest     <= (others => '0');
                    i_PE_y_dest     <= (others => '0');
                    i_PE_step       <= (others => '0');
                    i_PE_frame      <= (others => '0');
                    i_PE_x_orig     <= (others => '0');
                    i_PE_y_orig     <= (others => '0');
                    i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                    i_PE_req        <= '0'; -- Pe wants to give px to Router    
                    t_PE_ack        <= '0';
                    si_mem_gpx_f    <= '0';
                    o_endpgr_flag   <= '0';
                    s_state         <= BUSY;
                when GPX_INIT =>
                    if t_PE_req = '0' and i_PE_ack = '0' then
                        mem_px          <= (others => '0');
                        i_PE_pixel      <= '1' & (pix_depth - 2 downto 0 => '0');
                        i_PE_x_dest     <= s_x_dest;
                        i_PE_y_dest     <= s_y_dest;
                        i_PE_step       <= s_step;  
                        i_PE_frame      <= s_frame; 
                        i_PE_x_orig     <= s_x_orig;
                        i_PE_y_orig     <= s_y_orig;
                        i_PE_fb         <= '0'; -- Foward -> send to PM
                        i_PE_req        <= '1'; -- Pe wants to give px to Router
                        t_PE_ack        <= '1';
                        si_mem_gpx_f    <= '0';
                        o_endpgr_flag   <= '0';
                        clk_count_wait  <= 0;
                        s_state         <= GPX_WAIT;
                    end if;
                when GPX_WAIT => -- wait for response from router
                    if i_PE_ack = '1' then
                        mem_px          <= (others => '0');
                        i_PE_pixel      <= (others => '0');
                        i_PE_x_dest     <= (others => '0');
                        i_PE_y_dest     <= (others => '0');
                        i_PE_step       <= (others => '0');
                        i_PE_frame      <= (others => '0');
                        i_PE_x_orig     <= (others => '0');
                        i_PE_y_orig     <= (others => '0');
                        i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                        i_PE_req        <= '0';   
                        t_PE_ack        <= '0';
                        si_mem_gpx_f    <= '0';
                        o_endpgr_flag   <= '0';
                        s_state         <= GPX_RECV;
                    end if;
                when GPX_RECV => -- save pixel data and answer router with ack
                    if t_PE_req = '1' then --means that the router wants to give a pixel to the processor
                        i_PE_pixel      <= (others => '0');
                        i_PE_x_dest     <= (others => '0');
                        i_PE_y_dest     <= (others => '0');
                        i_PE_step       <= (others => '0');
                        i_PE_frame      <= (others => '0');
                        i_PE_x_orig     <= (others => '0');
                        i_PE_y_orig     <= (others => '0');
                        i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                        i_PE_req        <= '0';   
                        t_PE_ack        <= '1';
                        o_endpgr_flag   <= '0';
                        
                        if pixel_coord_in = pixel_coord_out then -- valid pixel
                            if (t_PE_pixel = (pix_depth-1 downto 0 => '1')) then -- PM is locked
                                mem_px          <= (others => '0');
                                si_mem_gpx_f    <= '0';
                                clk_count_sync  <= 0;
                                s_state         <= GPX_RST;
                            else
                                mem_px          <=  (2**bit_width-1 downto pix_depth-1 => t_PE_pixel(pix_depth-2)) 
                                                    & UNSIGNED(t_PE_pixel(pix_depth-2 downto 0));
                                si_mem_gpx_f    <= '1'; -- Send flag to unlock PC as gpx is enabled
                                s_state         <= GPX_END;
                            end if;
                        else
                            mem_px          <= (others => '0');
                            si_mem_gpx_f    <= '0';
                            s_state         <= GPX_ERR;
                        end if;
                    else
                        mem_px          <= (others => '0');
                        si_mem_gpx_f    <= '0';
                        clk_count_wait  <= clk_count_wait + 1;
                        
                        if clk_count_wait > 1000 then
                            s_state     <= GPX_ERR;
                        else
                            s_state     <= GPX_RECV;
                        end if;
                    end if;
                when GPX_RST =>
                    mem_px          <= (others => '0');
                    i_PE_pixel      <= (others => '0');
                    i_PE_x_dest     <= (others => '0');
                    i_PE_y_dest     <= (others => '0');
                    i_PE_step       <= (others => '0');
                    i_PE_frame      <= (others => '0');
                    i_PE_x_orig     <= (others => '0');
                    i_PE_y_orig     <= (others => '0');
                    i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                    i_PE_req        <= '0';   
                    t_PE_ack        <= '0';
                    si_mem_gpx_f    <= '0';
                    o_endpgr_flag   <= '0';
                    clk_count_sync  <= clk_count_sync + 1;

                    if clk_count_sync > 10000 then
                        s_state     <= GPX_INIT;
                    else
                        s_state     <= GPX_RST;
                    end if;
                when GPX_ERR =>
                    i_PE_pixel      <= (others => '0');
                    i_PE_x_dest     <= (others => '0');
                    i_PE_y_dest     <= (others => '0');
                    i_PE_step       <= (others => '0');
                    i_PE_frame      <= (others => '0');
                    i_PE_x_orig     <= (others => '0');
                    i_PE_y_orig     <= (others => '0');
                    i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                    i_PE_req        <= '0'; -- Pe wants to give px to Router    
                    t_PE_ack        <= '0';
                    si_mem_gpx_f    <= '0';
                    o_endpgr_flag   <= '0';
                    s_state         <= GPX_INIT;
                when GPX_END =>
                    i_PE_pixel      <= (others => '0');
                    i_PE_x_dest     <= (others => '0');
                    i_PE_y_dest     <= (others => '0');
                    i_PE_step       <= (others => '0');
                    i_PE_frame      <= (others => '0');
                    i_PE_x_orig     <= (others => '0');
                    i_PE_y_orig     <= (others => '0');
                    i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                    i_PE_req        <= '0'; -- Pe wants to give px to Router    
                    t_PE_ack        <= '0';
                    si_mem_gpx_f    <= '0';
                    o_endpgr_flag   <= '0';
                    s_state         <= BUSY;
                when IDLE =>
                    i_PE_pixel      <= (others => '0');
                    i_PE_x_dest     <= (others => '0');
                    i_PE_y_dest     <= (others => '0');
                    i_PE_step       <= (others => '0');
                    i_PE_frame      <= (others => '0');
                    i_PE_x_orig     <= (others => '0');
                    i_PE_y_orig     <= (others => '0');
                    i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                    i_PE_req        <= '0'; -- Pe wants to give px to Router    
                    t_PE_ack        <= '0';
                    si_mem_gpx_f    <= '0';
                    o_endpgr_flag   <= '1';
                    s_state         <= get_nstate(mode);
                when BUSY =>
                        i_PE_pixel      <= (others => '0');
                        i_PE_x_dest     <= (others => '0');
                        i_PE_y_dest     <= (others => '0');
                        i_PE_step       <= (others => '0');
                        i_PE_frame      <= (others => '0');
                        i_PE_x_orig     <= (others => '0');
                        i_PE_y_orig     <= (others => '0');
                        i_PE_fb         <= '0'; -- Foward (not wait for pixel)
                        i_PE_req        <= '0'; -- Pe wants to give px to Router    
                        si_mem_gpx_f    <= '0';
                        o_endpgr_flag   <= '0';
                        s_state         <= get_nstate(mode);
                    if t_PE_req = '0' then
                        t_PE_ack        <= '0';
                    else
                        t_PE_ack        <= '1';
                    end if;
                when NONE =>
            end case;
        end if;
    end if;
end process;

end Behavioral;
