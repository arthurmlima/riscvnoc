----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 09.08.2019 16:31:53
-- Design Name: 
-- Module Name: memory - Behavioral
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
use STD.TEXTIO.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory is 
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
end memory;

architecture Behavioral of memory is

    -- AXI/IM signals
    signal s_axi_we     : std_logic;
    signal s_axi_imok   : std_logic;
    signal s_axi_addr   : std_logic_vector(10 downto 0);
    signal s_axi_data   : std_logic_vector(31 downto 0);
    
    constant mem_size : integer := 2**(memory_length)-1;  -- 2048; -- temporary size (bugs if .text and .data is larger)
    type mem_array is array(0 to mem_size)
                   of STD_LOGIC_VECTOR(instruction_length-1 downto 0);
    signal mem : mem_array := (others => (others => '0'));
    
    type state_type is (WAIT_DATA, WRT_2ND, WRT_END);
    signal state        : state_type := WAIT_DATA;
    
begin   

    -- AXI Instruction Write process
    process(i_axi_clk, i_axi_we, s_axi_imok, i_axi_addr, i_axi_data0, i_axi_data1)
        variable addr_index : integer;
        variable tmp_data0  : std_logic_vector(31 downto 0);
    begin
        if i_axi_we = '0' then
            o_axi_imok  <= '0';
        else
            if RISING_EDGE(i_axi_clk) then
                case state is
                    -- Write first part
                    when WAIT_DATA =>
                        tmp_data0   := i_axi_data0;
                    
                        -- Trigger second part only if I. Length is greater then 32
                        if instruction_length > 32 then
                            state <= WRT_2ND;
                        else
                            addr_index  := integer(to_integer(UNSIGNED(i_axi_addr)/4));
                            mem(addr_index) <= tmp_data0(instruction_length-1 downto 0);
                            o_axi_imok  <= '1';
                            state <= WRT_END;
                        end if;
                    
                    -- Write second part if necessary
                    when WRT_2ND =>
                        addr_index  := integer(to_integer(UNSIGNED(i_axi_addr)/4)); 
                        mem(addr_index)  <= i_axi_data1((instruction_length-32) - 1 downto 0) &
                                            tmp_data0;
                        o_axi_imok  <= '1';
                        state       <= WRT_END;
                    when WRT_END =>
                        o_axi_imok  <= '0';
                        state       <= WAIT_DATA;
                end case;
            end if;
        end if;
    end process;
    
    -- Instruction Memory and PC Register process
    process(pc)
        variable addr_index : integer;
    begin
        addr_index := integer(to_integer(SIGNED(pc))/4);
        if(addr_index <= mem_size) and (addr_index >= 0) then
            -- TODO: generalize last index assignment for different bit_width
            instruction <= mem(addr_index);
        else
            instruction <= STD_LOGIC_VECTOR(to_unsigned(0, instruction'length));
        end if;
    end process;
end Behavioral;
