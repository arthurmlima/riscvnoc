----------------------------------------------------------------------------------
-- from https://www.xilinx.com/support/documentation/sw_manuals/xilinx2016_4/ug901-vivado-synthesis.pdf
-- example page 115. Dual-Port block RAM with Two Write Ports in Read-First Mode (VHDL)
-- 
----------------------------------------------------------------------------------
-- For more information about data and address widths, please consult:
-- https://www.xilinx.com/support/documentation/user_guides/ug573-ultrascale-memory-resources.pdf
-- table 1-11: TDP Memory for RAMB36E2 in UltraScale+ (page 33).
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity rams_tdp_rf_rf_rf is
generic(
        pix_depth  : natural;
        addr_size   : natural;
        mem_size    : natural
        );
port(  
        clka    : in  std_logic;
        clkb    : in  std_logic;
        ena     : in  std_logic;
        enb     : in  std_logic;
        wea     : in  std_logic;
        web     : in  std_logic;
        addra   : in  std_logic_vector(addr_size-1 downto 0);
        addrb   : in  std_logic_vector(addr_size-1 downto 0);
        dia     : in  std_logic_vector(pix_depth-1 downto 0);
        dib     : in  std_logic_vector(pix_depth-1 downto 0);
        doa     : out std_logic_vector(pix_depth-1 downto 0);        
        dob     : out std_logic_vector(pix_depth-1 downto 0);
        doa_ok  : out std_logic;
        dob_ok  : out std_logic 
  
        
    );
end rams_tdp_rf_rf_rf;

architecture syn of rams_tdp_rf_rf_rf is type ram_type is array (mem_size-1 downto 0) of std_logic_vector(pix_depth-1 downto 0);

    shared variable RAM : ram_type:=  ( 0=> x"0000", 1=> x"0001", 2=> x"0002",3=> x"0003",4=> x"0004",5=> x"0005", 6=> x"0006",7=> x"0007",8=> x"0008",9=> x"0009", 10=> x"000A",11=> x"000B", others=> (others=> '0') );

    begin process(CLKA, ENA, WEA) begin

        if CLKA'event and CLKA = '1' then
            if ENA = '1' then
                DOA <= RAM(conv_integer(ADDRA));
                DOA_OK <= '1';
                if WEA = '1' then
                    RAM(conv_integer(ADDRA)) := DIA;
                end if;
            else
                DOA_OK <= '0';
            end if;
        end if;
    end process;
    
    process(CLKB, ENB, WEB) begin
        if CLKB'event and CLKB = '1' then
            if ENB = '1' then
                DOB <= RAM(conv_integer(ADDRB));
                DOB_OK <= '1';
                if WEB = '1' then
                    RAM(conv_integer(ADDRB)) := DIB;
                end if;
            else
                DOB_OK <= '0';
            end if;
        end if; 
    end process;

end syn;