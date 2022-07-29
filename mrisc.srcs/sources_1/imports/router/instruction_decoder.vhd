----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 28.08.2019 11:02:34
-- Design Name: 
-- Module Name: instruction_decoder - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instruction_decoder is
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
            NOP                 : std_logic_vector(4-1 downto 0):= "0000";
            GPX                 : std_logic_vector(4-1 downto 0):= "0001";
            SPX                 : std_logic_vector(4-1 downto 0):= "0010";
            ADD                 : std_logic_vector(4-1 downto 0):= "0011";
            SUB                 : std_logic_vector(4-1 downto 0):= "0100";
            MUL                 : std_logic_vector(4-1 downto 0):= "0101";
            DIV                 : std_logic_vector(4-1 downto 0):= "0110";
            AND1                : std_logic_vector(4-1 downto 0):= "0111";
            OR1                 : std_logic_vector(4-1 downto 0):= "1000";
            XOR1                : std_logic_vector(4-1 downto 0):= "1001";
            NOT1                : std_logic_vector(4-1 downto 0):= "1010";
            BGT                 : std_logic_vector(4-1 downto 0):= "1011";
            BST                 : std_logic_vector(4-1 downto 0):= "1100";
            BEQ                 : std_logic_vector(4-1 downto 0):= "1101";
            JMP                 : std_logic_vector(4-1 downto 0):= "1110";
            ENDPGR              : std_logic_vector(4-1 downto 0):= "1111";
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
        spx_en, gpx_en : out STD_LOGIC := 'Z'
        );
end instruction_decoder;

architecture Behavioral of instruction_decoder is
    constant range_x : natural := (isf_x+isf_y+isf_s+isf_f+isf_px+isf_opcode);
    constant range_y : natural := (isf_y+isf_s+isf_f+isf_px+isf_opcode);
    constant range_s : natural := (isf_s+isf_f+isf_px+isf_opcode);
    constant range_f : natural := (isf_f+isf_px+isf_opcode);
    constant range_px: natural := (isf_px+isf_opcode);
    constant range_rs : natural := (regfile_size+isf_opcode);
    constant range_rt : natural := (2*regfile_size+isf_opcode);
    constant range_rd : natural := (3*regfile_size+isf_opcode);
    -- range address := 31 downto 14
begin
    process(instruction)
        variable p_opcode : STD_LOGIC_VECTOR(isf_opcode-1 downto 0);
    begin
        p_opcode := instruction(isf_opcode-1 downto 0);
        case p_opcode is
            when SPX =>
            x <= instruction(range_x-1 downto range_y);
            y <= instruction(range_y-1 downto range_s);
            s <= instruction(range_s-1 downto range_f);
            f <= instruction(range_f-1 downto range_px);
            px <= instruction(range_px-1 downto isf_opcode);
            rd <= (others => '0');
            rt <= (others => '0');
            rs <= (others => '0');
            addr <= (others => '0');
            spx_en <= '1';
            gpx_en <= '0';
        when GPX =>
            x <= instruction(range_x-1 downto range_y);
            y <= instruction(range_y-1 downto range_s);
            s <= instruction(range_s-1 downto range_f);
            f <= instruction(range_f-1 downto range_px);
            px <= instruction(range_px-1 downto isf_opcode);
            rd <= (others => '0');
            rt <= (others => '0');
            rs <= (others => '0');
            addr <= (others => '0');
            spx_en <= '0';
            gpx_en <= '1';
        when JMP =>
            x <= (others => '0');
            y <= (others => '0');
            s <= (others => '0');
            f <= (others => '0');
            px <= (others => '0');
            rd <= (others => '0');
            rt <= (others => '0');
            rs <= (others => '0');  
            addr <= (2**bit_width-1 downto addr_size => '0') & instruction(instruction_length-1 downto instruction_length-addr_size);    
            spx_en <= '0';
            gpx_en <= '0';
        when BGT | BST | BEQ =>
            x <= (others => '0');
            y <= (others => '0');
            s <= (others => '0');
            f <= (others => '0');
            px <= (others => '0');
            rd <= (others => '0');
            rt <= instruction(range_rt-1 downto range_rs);
            rs <= instruction(range_rs-1 downto isf_opcode);
            addr <= (2**bit_width-1 downto addr_size => '0') & instruction(instruction_length-1 downto instruction_length-addr_size);
            spx_en <= '0';          
            gpx_en <= '0';        
        when ADD | SUB | MUL | DIV | AND1 | OR1 | XOR1 | NOT1 =>
            x <= (others => '0');
            y <= (others => '0');
            s <= (others => '0');
            f <= (others => '0');
            px <= (others => '0');
            rd <= instruction(range_rd-1 downto range_rt);
            rt <= instruction(range_rt-1 downto range_rs);
            rs <= instruction(range_rs-1 downto isf_opcode);
            addr <= (others => '0');
            spx_en <= '0';   
            gpx_en <= '0';        
        when others =>
            x <= (others => '0');
            y <= (others => '0');
            s <= (others => '0');
            f <= (others => '0');
            px <= (others => '0');
            rd <= (others => '0');
            rt <= (others => '0');
            rs <= (others => '0');  
            addr <= (others => '0');
            spx_en <= '0';   
            gpx_en <= '0';
        end case;
        opcode <= p_opcode;
    end process;
end Behavioral;
