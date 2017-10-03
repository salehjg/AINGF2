-------------------------------------------------------------------------------
--                                                                           --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--          XX     XX  X      X  X      X  X      X  X           XX          --
--          X X   X X  X         X      X  X      X  X          X X          --
--          X  X X  X  X         X      X  X      X  X         X  X          --
--          X   X   X  X          XXXXXX   X      X   XXXXXX      X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X      X  X      X  X      X         X     X          --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--                                                                           --
--                                                                           --
--                       O R E G A N O   S Y S T E M S                       --
--                                                                           --
--                            Design & Consulting                            --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--         Web:           http://www.oregano.at/                             --
--                                                                           --
--         Contact:       mc8051@oregano.at                                  --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--  MC8051 - VHDL 8051 Microcontroller IP Core                               --
--  Copyright (C) 2001 OREGANO SYSTEMS                                       --
--                                                                           --
--  This library is free software; you can redistribute it and/or            --
--  modify it under the terms of the GNU Lesser General Public               --
--  License as published by the Free Software Foundation; either             --
--  version 2.1 of the License, or (at your option) any later version.       --
--                                                                           --
--  This library is distributed in the hope that it will be useful,          --
--  but WITHOUT ANY WARRANTY; without even the implied warranty of           --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        --
--  Lesser General Public License for more details.                          --
--                                                                           --
--  Full details of the license can be found in the file LGPL.TXT.           --
--                                                                           --
--  You should have received a copy of the GNU Lesser General Public         --
--  License along with this library; if not, write to the Free Software      --
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA  --
--                                                                           --
-------------------------------------------------------------------------------
--
--
--         Author:                 Helmut Mayrhofer
--
--         Filename:               mc8051_ram_.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.3 $
--
--         Date of Latest Version: $Date: 2002-01-07 12:16:56 $
--
--
--         Description: The mc8051 internal RAM model.
--
--
--
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
------------------------ ENTITY DECLARATION -------------------------
entity mc8051_ram is

  port (clk        : in  std_logic;  			-- clock signal
        reset      : in  std_logic;  			-- reset signal
        ram_data_i : in  std_logic_vector(7 downto 0);  -- data input
        ram_data_o : out std_logic_vector(7 downto 0);  -- data output
        ram_adr_i  : in  std_logic_vector(6 downto 0);  -- adresses
        ram_wr_i   : in  std_logic;  			-- read=0, write=1 
        ram_en_i   : in  std_logic);  			-- inactive=0;active=1 

end mc8051_ram;

