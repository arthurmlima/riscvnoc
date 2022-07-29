----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 27.08.2019 21:17:35
-- Design Name: 
-- Module Name: parameters - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: modified from Jones Yudi version.
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

package parameters is

    -- general parameters
    -- TODO: change x, y, s, f and px based on noc topology
    constant noc_width : natural := 3; -- noc size
    constant noc_height : natural := 3; -- noc size
    constant px_true_size : natural := 8;   -- true pixel depth
    constant pix_depth : natural := px_true_size + 1; -- must include +1 because of foward/backward 
    constant img_width : natural := 6; -- resolution
    constant img_height: natural := 6; -- resolution
    constant tile_width  : natural := 2; -- tile resolution 
    constant tile_height : natural := 2; -- tile resolution
    constant n_steps     : natural := 6; -- steps in the image processing chain
    constant n_frames    : natural := 5; -- frames needed by an algorithm
    
    -- router parameters
    constant subimg_width 	: natural := 2; --2**2; --4;
	constant subimg_height	: natural := 2; --2**2; --4;
    constant buffer_length  : natural := 6;
    
    -- secondary parameters
    constant memory_length : natural := 11; -- size of memory (2^program_length-1 downto to 0)
    constant regfile_word : natural := 3;   -- word length in each register (2^regfile_word-1 downto 0)
                                            -- (word length)*(number of words) = bit width
                                            -- (2**regfile_word)*(2**(bit_width-regfile_word)) = 2**bit_width 
    constant regfile_size : natural := 5;   -- size of register file (2^regfile_size-1 downto 0)
    constant regfile_num : natural := 2**regfile_size;    -- total of registers inside regfile - 1
                                                            -- (for index purposes)
    constant bit_width : natural := 5;  -- processor bit width (2^bit_width-1 downto 0)
                                        -- considering each register with the same width as bit_width
    
    constant addr_size : natural := 17; -- address field size in bits
    
    constant p_bit_width : natural := 6; -- P-type instruction field size
    
    -- instruction set parameters (isf = instruction set field)
    constant isf_opcode : natural := 4;
    constant isf_x : natural := img_width; -- temporary 
    constant isf_y : natural := img_height; -- temporary
    constant isf_s : natural := n_steps; -- temporary
    constant isf_f : natural := n_frames; -- temporary
    constant isf_px: natural := pix_depth; -- px value range = 0 to 255
    constant isf_rs : natural := regfile_size;
    constant isf_rt : natural := regfile_size;
    constant isf_rd : natural := regfile_size;
    constant isf_dest : natural := regfile_size;
    
    -- TODO: use if statement to choose instruction length based on P-type instru. size and 2**bit_width
    constant instruction_length : natural := isf_opcode+isf_x+isf_y+isf_s+isf_f+isf_px; -- bits per instruction
    
    -- opcodes
    constant NOP :   std_logic_vector(isf_opcode-1 downto 0):= "0000";
    constant GPX :   std_logic_vector(isf_opcode-1 downto 0):= "0001";
    constant SPX :   std_logic_vector(isf_opcode-1 downto 0):= "0010";
    constant ADD :   std_logic_vector(isf_opcode-1 downto 0):= "0011";
    constant SUB :   std_logic_vector(isf_opcode-1 downto 0):= "0100";
    constant MUL :   std_logic_vector(isf_opcode-1 downto 0):= "0101";
    constant DIV :   std_logic_vector(isf_opcode-1 downto 0):= "0110";
    constant AND1 :  std_logic_vector(isf_opcode-1 downto 0):= "0111";
    constant OR1 :   std_logic_vector(isf_opcode-1 downto 0):= "1000";
    constant XOR1 :  std_logic_vector(isf_opcode-1 downto 0):= "1001";
    constant NOT1 :  std_logic_vector(isf_opcode-1 downto 0):= "1010";
    constant BGT :   std_logic_vector(isf_opcode-1 downto 0):= "1011";
    constant BST :   std_logic_vector(isf_opcode-1 downto 0):= "1100";
    constant BEQ :   std_logic_vector(isf_opcode-1 downto 0):= "1101";
    constant JMP :   std_logic_vector(isf_opcode-1 downto 0):= "1110";
    constant ENDPGR :std_logic_vector(isf_opcode-1 downto 0):= "1111";

    -- memory parameters
        -- .text file path -> change if necessary
    constant code_file : string := "/home/bsilva/Documents/UnB/Projeto_Final/parts/binary-generator-pe/code.bin";
    constant code_tfile : string := "/home/bsilva/Documents/UnB/Projeto_Final/parts/binary-generator-pe/code_old.bin";
    constant code_0_0 : string := "/home/bsilva/Documents/UnB/Projeto_Final/parts/sample_code/code_0_0.bin";
    constant code_2_2 : string := "/home/bsilva/Documents/UnB/Projeto_Final/parts/sample_code/code_2_2.bin";
    constant code_endpgr : string := "/home/bsilva/Documents/UnB/Projeto_Final/parts/sample_code/code_endpgr.bin";

end package parameters;