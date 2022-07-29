----------------------------------------------------------------------------------
-- Company: Universidade de Brasília
-- Engineer: Bruno Almeida
-- 
-- Create Date: 15.08.2019 16:13:50
-- Design Name: 
-- Module Name: mux - Behavioral
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

entity mux is
    generic(bit_width : natural);
    port(
        d0, d1 : in STD_LOGIC_VECTOR(2**bit_width-1 downto 0);
        s : in STD_LOGIC;
        y : out STD_LOGIC_VECTOR(2**bit_width-1 downto 0)
        );
end mux;

architecture Behavioral of mux is
begin
    y <= d0 when s = '0' else
         d1;
end Behavioral;
