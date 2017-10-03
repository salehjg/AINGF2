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
--         Filename:               mc8051_rom_sim.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.2 $
--
--         Date of Latest Version: $Date: 2002-01-07 12:16:57 $
--
--
--         Description: The mc8051 ROM model.
--
--
--
--
-------------------------------------------------------------------------------
architecture sim of mc8051_rom is

   type   rom_type is array (65535 downto 0) of bit_vector(7 downto 0); 
   signal s_init : boolean := false;

begin

------------------------------------------------------------------------------ 
-- rom_read 
------------------------------------------------------------------------------ 
 
  p_read : process (clk, reset, rom_adr_i)
      variable v_loop : integer;    
      variable v_line : line;
      variable v_rom_data : rom_type;
      file f_initfile : text is in c_init_file;
  begin
    if (not s_init) then
      v_loop := 0;
      while ((not endfile(f_initfile) and (v_loop < 65535))) loop
        readline(f_initfile,v_line);
        read(v_line,v_rom_data(v_loop));
        v_loop := v_loop + 1;        
      end loop;
      s_init <= true;
    end if;
    if (clk'event and (clk = '1')) then  -- rising clock edge
      rom_data_o <= to_stdlogicvector(v_rom_data(conv_integer(unsigned(rom_adr_i))));
    end if;
  end process p_read; 

end sim;

