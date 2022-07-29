----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 12/19/2019 12:42:33 PM
-- Design Name: 
-- Module Name: program_counter - Behavioral
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

entity program_counter is
    generic(
            bit_width   : natural
            );
    port(
        pc_new : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0) := (others => '0');
        spx_dis, gpx_dis, px_mem_dis, endpgr_flag, i_reset, clk : in STD_LOGIC := '0';
        pc : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0) := (others => '0')
        );
end program_counter;

architecture Behavioral of program_counter is
begin
    process(clk) begin
        if i_reset = '1' then
            pc <= STD_LOGIC_VECTOR(to_signed(-4, pc'length));
        else
            if RISING_EDGE(clk) then
                -- lock PC if endpgr flag is triggered
                if endpgr_flag = '0' then 
                    -- change pc only if gpx_dis, px_mem_dis = 0, 0 or 1, 1
                    -- also change if endprgr flag is not triggered
                    if  ((gpx_dis or spx_dis) xor px_mem_dis) = '0' then-- or
    --                    (spx_dis and not px_mem_dis) = '1' then
                        pc <= pc_new; -- PC new state output
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
