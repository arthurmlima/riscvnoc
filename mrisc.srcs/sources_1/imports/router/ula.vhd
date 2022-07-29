----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 30.07.2019 09:35:58
-- Design Name: 
-- Module Name: ula - Behavioral
-- Project Name: Arithmetic Logic Unit
-- Target Devices: 
-- Tool Versions: 
-- Description: RISC-V ALU modified to Branch Instructions
-- Based on: https://forums.xilinx.com/t5/Synthesis/4-Bit-Alu-Written-in-VHDL-Advice-Needed/td-p/896499
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ula is
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
end ula;

architecture Behavioral of ula is

begin
    process(a, b, opcode)
    begin
        zero <= '0';
        case opcode is
            when ADD => z <= STD_LOGIC_VECTOR(SIGNED(a) + SIGNED(b));
            when SUB => z <= STD_LOGIC_VECTOR(SIGNED(a) - SIGNED(b));
            when MUL => z <= STD_LOGIC_VECTOR(resize(SIGNED(a) * SIGNED(b), z'length));
            when DIV =>
                if b = STD_LOGIC_VECTOR(to_unsigned(0, b'length)) then
                    z <= STD_LOGIC_VECTOR(resize(UNSIGNED(b), z'length));
                else
                    z <= STD_LOGIC_VECTOR(shift_right(SIGNED(a), to_integer(UNSIGNED(b))));
                end if;
            when AND1 => z <= a and b;
            when OR1 => z <= a or b;
            when XOR1 => z <= a xor b;
            when NOT1 => z <= not a;
            when BGT =>
                if SIGNED(a) > SIGNED(b) then
                    -- z <= (N-1 downto 1 => '0', others => '1');
                    zero <= '1';
                end if;
            when BST =>
                if SIGNED(a) < SIGNED(b) then
                    -- z <= (N-1 downto 1 => '0', others => '1');
                    zero <= '1';
                end if;
            when BEQ =>
                if SIGNED(a) = SIGNED(b) then
                    zero <= '1';
                end if;
             when others =>
                z <= (others => '0'); 
            end case;     
    end process;
end Behavioral;