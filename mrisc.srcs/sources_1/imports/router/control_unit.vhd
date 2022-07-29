----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 28.08.2019 15:53:32
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode)
    begin
        case opcode is
            when ADD | SUB | MUL | DIV | AND1 | OR1 | XOR1 | NOT1 =>
                reg_write <= '1';
                branch <= '0';
                jump <= '0';
                endpgr_flag <= '0';
            when BGT | BST | BEQ =>
                reg_write <= '0';
                branch <= '1';
                jump <= '0';
                endpgr_flag <= '0';
            when JMP =>
                reg_write <= '0';
                branch <= '0';
                jump <= '1';
                endpgr_flag <= '0';
            when ENDPGR =>
                reg_write <= '0';
                branch <= '0';
                jump <= '0';
                endpgr_flag <= '1';                              
            when others =>
                reg_write <= '0';
                branch <= '0';
                jump <= '0';
                endpgr_flag <= '0';
        end case;
    end process;
end Behavioral;
