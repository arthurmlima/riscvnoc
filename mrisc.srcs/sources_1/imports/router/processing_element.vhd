----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 02.09.2019 15:40:19
-- Design Name: 
-- Module Name: processing_element - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: ASIP architecture for image processing
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
use WORK.parameters.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity processing_element is
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
end processing_element;

architecture Behavioral of processing_element is
    component program_counter
        generic(
                bit_width   : natural
                );
        port(
            pc_new : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
            spx_dis, gpx_dis, px_mem_dis, endpgr_flag, i_reset, clk : in STD_LOGIC := '0';
            pc : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0)
            );
    end component program_counter;
    
    component memory
        generic(
                bit_width           : natural;
                memory_length       : natural;
                instruction_length  : natural
                );
        port(
            -- Axi IO
            i_axi_clk       : in STD_LOGIC;
            i_axi_we        : in STD_LOGIC;
            i_axi_addr      : in STD_LOGIC_VECTOR(31 downto 0);
            i_axi_data0     : in STD_LOGIC_VECTOR(31 downto 0);
            i_axi_data1     : in STD_LOGIC_VECTOR(31 downto 0);
            o_axi_imok      : out STD_LOGIC;
            ----------------------------------------------------
            -- PE IO
            pc              : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0) := (others => '0');
            instruction     : out STD_LOGIC_VECTOR(instruction_length-1 downto 0) := (others => '0')
            );
    end component;
    
    component instruction_decoder
    generic(
            instruction_length  : natural;
            isf_opcode          : natural;
            regfile_size        : natural;
            isf_x               : natural;
            isf_y               : natural;
            isf_s               : natural;
            isf_f               : natural;
            isf_px              : natural;
            bit_width           : natural;
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
            instruction : in STD_LOGIC_VECTOR(instruction_length-1 downto 0);
            opcode : out STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
            rs, rt, rd : out STD_LOGIC_VECTOR(regfile_size-1 downto 0);
            x : out STD_LOGIC_VECTOR(isf_x-1 downto 0);
            y : out STD_LOGIC_VECTOR(isf_y-1 downto 0);
            f : out STD_LOGIC_VECTOR(isf_f-1 downto 0);
            s : out STD_LOGIC_VECTOR(isf_s-1 downto 0);
            px : out STD_LOGIC_VECTOR(isf_px-1 downto 0);
            addr : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
            spx_en, gpx_en : out STD_LOGIC
            );
    end component instruction_decoder;

    component breg
    generic(
            bit_width       : natural;
            isf_x           : natural;
            isf_y           : natural;
            isf_s           : natural;
            isf_f           : natural;
            isf_px          : natural;
            regfile_size    : natural
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
    end component breg;
    
    component ula
        generic(
                bit_width   : natural;
                isf_opcode  : natural;
                NOP         : std_logic_vector(4-1 downto 0);
                GPX         : std_logic_vector(4-1 downto 0);
                SPX         : std_logic_vector(4-1 downto 0);
                ADD         : std_logic_vector(4-1 downto 0);
                SUB         : std_logic_vector(4-1 downto 0);
                MUL         : std_logic_vector(4-1 downto 0);
                DIV         : std_logic_vector(4-1 downto 0);
                AND1        : std_logic_vector(4-1 downto 0);
                OR1         : std_logic_vector(4-1 downto 0);
                XOR1        : std_logic_vector(4-1 downto 0);
                NOT1        : std_logic_vector(4-1 downto 0);
                BGT         : std_logic_vector(4-1 downto 0);
                BST         : std_logic_vector(4-1 downto 0);
                BEQ         : std_logic_vector(4-1 downto 0);
                JMP         : std_logic_vector(4-1 downto 0);
                ENDPGR      : std_logic_vector(4-1 downto 0)
                );
        port(
            a, b : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
            opcode : in STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
            z : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
            zero : out STD_LOGIC
            );
    end component ula;
    
    component control_unit is
        generic(
                isf_opcode  : natural;
                NOP         : std_logic_vector(4-1 downto 0);
                GPX         : std_logic_vector(4-1 downto 0);
                SPX         : std_logic_vector(4-1 downto 0);
                ADD         : std_logic_vector(4-1 downto 0);
                SUB         : std_logic_vector(4-1 downto 0);
                MUL         : std_logic_vector(4-1 downto 0);
                DIV         : std_logic_vector(4-1 downto 0);
                AND1        : std_logic_vector(4-1 downto 0);
                OR1         : std_logic_vector(4-1 downto 0);
                XOR1        : std_logic_vector(4-1 downto 0);
                NOT1        : std_logic_vector(4-1 downto 0);
                BGT         : std_logic_vector(4-1 downto 0);
                BST         : std_logic_vector(4-1 downto 0);
                BEQ         : std_logic_vector(4-1 downto 0);
                JMP         : std_logic_vector(4-1 downto 0);
                ENDPGR      : std_logic_vector(4-1 downto 0)
                );    
        port(
            opcode : in STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
            reg_write, branch, jump, endpgr_flag : out STD_LOGIC
            );
    end component control_unit;
        
    component mux is
    generic(bit_width : natural);
    port(
        d0, d1 : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        s : in STD_LOGIC;
        y : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0)
        );
    end component mux;
    
    -- signals declaration
    -- instruction memory and program counter signals
    signal pc, pc_new : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal instruction : STD_LOGIC_VECTOR(instruction_length-1 downto 0);
    signal s_endpgr_flag : STD_LOGIC;
    
    -- instruction decoder signals
    signal addr : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal opcode : STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
    signal rs, rt, rd : STD_LOGIC_VECTOR(regfile_size-1 downto 0);
    signal x : STD_LOGIC_VECTOR(isf_x-1 downto 0);
    signal y : STD_LOGIC_VECTOR(isf_y-1 downto 0);
    signal f : STD_LOGIC_VECTOR(isf_f-1 downto 0);
    signal s : STD_LOGIC_VECTOR(isf_s-1 downto 0);
    signal px : STD_LOGIC_VECTOR(isf_px-1 downto 0);
    signal spx_en, gpx_en : STD_LOGIC;
    
    -- register file signals
    signal d_in : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal ra, rb : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal wren : STD_LOGIC;
    
    -- ula signals
--    signal z : STD_LOGIC_VECTOR(2**bit_width-1 downto 0) := (others => '0');
    signal zero : STD_LOGIC;
    
    -- jump mux signals
    signal jmp_mux_o : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal jmp_mux_ctrl : STD_LOGIC;

    -- branch mux signals
    signal branch_mux_o : STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
    signal branch_mux_ctrl, branch : STD_LOGIC;

begin
    pc_pe : program_counter generic map(
                                        bit_width => bit_width
                                        )
                            port map(   pc_new => branch_mux_o,
                                        gpx_dis => gpx_en,
                                        spx_dis => spx_en,
                                        px_mem_dis => i_mem_gpx_f,
                                        endpgr_flag => s_endpgr_flag,
                                        i_reset => i_reset,
                                        clk => clk,
                                        pc => pc
                                    );
                                    
    mem_pe : memory generic map(
                                bit_width           => bit_width,
                                memory_length       => memory_length,
                                instruction_length  => instruction_length
                                )
                    port map(   
                                pc => pc,
                                instruction => instruction,
                                i_axi_clk   => i_axi_clk,
                                i_axi_we    => i_axi_we,
                                i_axi_addr  => i_axi_addr,
                                i_axi_data0 => i_axi_data0,
                                i_axi_data1 => i_axi_data1,
                                o_axi_imok  => o_axi_imok
                            );
                            
    idec_pe : instruction_decoder generic   map(
                                                instruction_length => instruction_length,
                                                isf_opcode         => isf_opcode        ,
                                                regfile_size       => regfile_size      ,
                                                isf_x              => isf_x             ,
                                                isf_y              => isf_y             ,
                                                isf_s              => isf_s             ,
                                                isf_f              => isf_f             ,
                                                isf_px             => isf_px            ,
                                                bit_width          => bit_width         ,
                                                NOP                => NOP               ,
                                                GPX                => GPX               ,
                                                SPX                => SPX               ,
                                                ADD                => ADD               ,
                                                SUB                => SUB               ,
                                                MUL                => MUL               ,
                                                DIV                => DIV               ,
                                                AND1               => AND1              ,
                                                OR1                => OR1               ,
                                                XOR1               => XOR1              ,
                                                NOT1               => NOT1              ,
                                                BGT                => BGT               ,
                                                BST                => BST               ,
                                                BEQ                => BEQ               ,
                                                JMP                => JMP               ,
                                                ENDPGR             => ENDPGR            ,
                                                addr_size          => addr_size
                                                )
                                  port map( instruction => instruction,
                                            opcode => opcode,
                                            rs => rs,
                                            rt => rt,
                                            rd => rd,
                                            x => x,
                                            y => y,
                                            f => f,
                                            s => s,
                                            px => px,
                                            addr => addr,
                                            spx_en => spx_en,
                                            gpx_en => gpx_en
                                        );
                                        
    breg_pe : breg  generic map(
                                bit_width       => bit_width   ,
                                isf_x           => isf_x       ,
                                isf_y           => isf_y       ,
                                isf_s           => isf_s       ,
                                isf_f           => isf_f       ,
                                isf_px          => isf_px      ,
                                regfile_size    => regfile_size
                                )
                    port map(   rs => rs,
                                rt => rt,
                                rd => rd,
                                d_in => d_in,
                                wren => wren,
                                clk => clk,
                                spx_en => spx_en,
                                gpx_en => gpx_en,
                                x_in => x,
                                y_in => y,
                                s_in => s,
                                f_in => f,
                                idec_px => px,
                                mem_px => mem_px,
                                x_out => x_out,
                                y_out => y_out,
                                s_out => s_out,
                                f_out => f_out,
                                px_out => px_out,
                                s_reg_out => s_reg_out,
                                ra => ra,
                                rb => rb,
                                o_mem_wr_en => o_mem_wr_en,
                                i_mem_gpx_f => i_mem_gpx_f,
                                o_mem_gpx_f => o_mem_gpx_f 
                            );

    ula_pe : ula    generic map(
                                bit_width   => bit_width ,
                                isf_opcode  => isf_opcode,
                                NOP         => NOP       ,
                                GPX         => GPX       ,
                                SPX         => SPX       ,
                                ADD         => ADD       ,
                                SUB         => SUB       ,
                                MUL         => MUL       ,
                                DIV         => DIV       ,
                                AND1        => AND1      ,
                                OR1         => OR1       ,
                                XOR1        => XOR1      ,
                                NOT1        => NOT1      ,
                                BGT         => BGT       ,
                                BST         => BST       ,
                                BEQ         => BEQ       ,
                                JMP         => JMP       ,
                                ENDPGR      => ENDPGR    
                                )
                    port map(
                            a => ra,
                            b => rb,
                            z => d_in,
                            zero => zero,
                            opcode => opcode
                            );
                            
    ctrl_unit_pe : control_unit generic map(
                                            isf_opcode  => isf_opcode,
                                            NOP         => NOP       ,
                                            GPX         => GPX       ,
                                            SPX         => SPX       ,
                                            ADD         => ADD       ,
                                            SUB         => SUB       ,
                                            MUL         => MUL       ,
                                            DIV         => DIV       ,
                                            AND1        => AND1      ,
                                            OR1         => OR1       ,
                                            XOR1        => XOR1      ,
                                            NOT1        => NOT1      ,
                                            BGT         => BGT       ,
                                            BST         => BST       ,
                                            BEQ         => BEQ       ,
                                            JMP         => JMP       ,
                                            ENDPGR      => ENDPGR    
                                            )
                                port map(
                                        opcode => opcode,
                                        reg_write => wren,
                                        branch => branch,
                                        jump => jmp_mux_ctrl,
                                        endpgr_flag => s_endpgr_flag
                                        );
                            
    mux_jmp_pe : mux    generic map(bit_width => bit_width)
                        port map(
                                d0 => pc_new,
                                d1 => addr,
                                s => jmp_mux_ctrl,
                                y => jmp_mux_o
                                );

    mux_branch_pe : mux generic map(bit_width => bit_width)
                        port map(
                                d0 => jmp_mux_o,
                                d1 => addr,
                                s => branch_mux_ctrl,
                                y => branch_mux_o
                                );
    
    o_instruction <= instruction;
    o_idec_x    <= x ;
    o_idec_y    <= y ;
    o_idec_f    <= f ;
    o_idec_s    <= s ;
    o_idec_px   <= px;
    
    o_opcode    <= opcode;
    o_rs        <= ra;
    o_rt        <= rb;
    o_ula_out   <= d_in;
    
    process(i_reset, s_endpgr_flag) begin
        if i_reset = '1' then
            o_endpgr_flag <= '0';
        else
            o_endpgr_flag <= s_endpgr_flag;
        end if;
    end process;
    
    -- Program Counter handler process
    process(jmp_mux_ctrl, branch_mux_ctrl, pc) begin
        if (jmp_mux_ctrl = '1' or branch_mux_ctrl = '1') then
            pc_new <= branch_mux_o;
        else
            pc_new <= STD_LOGIC_VECTOR(SIGNED(pc) + 4);
        end if;
    end process;
        
    -- Branch operation mux - 'and' signal process
    process(branch, zero)
    begin
        branch_mux_ctrl <= branch and zero;
    end process;
end Behavioral;
