----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:02:55 04/06/2007 
-- Design Name: 
-- Module Name:    mc8051_clockdiv - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mc8051_clockdiv is
    Port ( clk : in  STD_LOGIC;
           clkdiv : out  STD_LOGIC);
end mc8051_clockdiv;

architecture Behavioral of mc8051_clockdiv is
signal divcnt:std_logic_vector(3 downto 0);
begin
process(clk)
begin
   if rising_edge(clk) then
	   divcnt<=divcnt+1;
	end if;
end process;
clkdiv<=divcnt(3);
end Behavioral;

