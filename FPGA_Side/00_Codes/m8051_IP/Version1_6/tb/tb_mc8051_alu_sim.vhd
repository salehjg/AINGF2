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
--         Author:                 Roland Höller
--
--         Filename:               tb_mc8051_alu_sim.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.4 $
--
--         Date of Latest Version: $Date: 2002-01-07 12:16:57 $
--
--
--         Description: Module level testbench for the mc8051 alu.
--
--
--
--
-------------------------------------------------------------------------------
architecture sim of tb_mc8051_alu is

  -----------------------------------------------------------------------------
  --                                                                         --
  --  IMAGE - Convert a special data type to string                          --
  --                                                                         --
  --  This function uses the STD.TEXTIO.WRITE procedure to convert different --
  --  VHDL data types to a string to be able to output the information via   --
  --  a report statement to the simulator.                                   --
  --  (VHDL'93 provides a dedicated predefinded attribute 'IMAGE)            --
  -----------------------------------------------------------------------------
  function IMAGE (constant tme : time) return string is
    variable v_line : line;
    variable v_tme  : string(1 to 20) := (others => ' ');
  begin
    write(v_line, tme);
    v_tme(v_line.all'range) := v_line.all;
    deallocate(v_line);
    return v_tme;
  end IMAGE;

  function IMAGE (constant nmbr : integer) return string is
    variable v_line : line;
    variable v_nmbr  : string(1 to 11) := (others => ' ');
  begin
    write(v_line, nmbr);
    v_nmbr(v_line.all'range) := v_line.all;
    deallocate(v_line);
    return v_nmbr;
  end IMAGE;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_DA - Test the combinational decimal adjustement command           --
  --                                                                         --
  --  Procedure to generate all the input data to test the combinational     --
  --  divider command. Furthermore the results are compared with the         --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_DA (
    constant DWIDTH     : in  integer;
    constant PROP_DELAY : in  time;
    signal   s_datao    : out std_logic_vector;
    signal   s_cy       : out std_logic_vector;
    signal   s_datai    : in  std_logic_vector;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_da_end   : out boolean) is

    type t_nibbles is array (0 to ((DWIDTH-1)/4)) of integer;

    variable v_flags     : std_logic_vector((DWIDTH-1)/4 downto 0);
    variable v_flags_int : std_logic_vector((DWIDTH-1)/4 downto 0);
    variable v_newdata   : std_logic_vector(DWIDTH-1 downto 0);
    variable v_tmp       : integer;
    variable v_cy        : std_logic;
    variable v_ext       : boolean;

  begin
    s_da_end <= false;
    s_datao <= conv_std_logic_vector(0,DWIDTH);
    s_cy <= conv_std_logic_vector(0,((DWIDTH-1)/4)+1);
    v_ext := false;
    for j in 0 to 2**DWIDTH-1 loop
      s_datao <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**(((DWIDTH-1)/4)+1)-1 loop
        -- MSB of v_flags is cy. The rest represents the auxiliary carry flags.
        v_flags := conv_std_logic_vector(i,((DWIDTH-1)/4)+1);
        v_cy := v_flags(v_flags'HIGH);
        s_cy <= conv_std_logic_vector(i,((DWIDTH-1)/4)+1);
        v_tmp := j;
        v_ext := false;
        -- Whenever a flag is set the corresponding data cannot be greater than
        -- 2 (The data is assumed to be the result of an addition of two BCD
        -- numbers). - Just to reduce simulation runtime.
        for r in 0 to (DWIDTH-1)/4 loop
          if j mod 2**((r+1)*4) > 2 and v_flags(r) = '1' then
            v_ext := true;
          end if;
        end loop;  -- r
        next when v_ext = true;
        for h in 0 to (DWIDTH-1)/4 loop
            -- Perform adjustement of the following nibbles
            if v_tmp mod 2**((h+1)*4) > 9*(2**(h*4))+2**(h*4)-1 or
              v_flags(h) = '1' then
              v_flags_int := conv_std_logic_vector(0,((DWIDTH-1)/4)+1);
              for k in h to ((DWIDTH-1)/4) loop
                if k=h then
                  -- Determine carry flag of the nibble which will be
                  -- incremented by 6.
                  if DWIDTH >= (k+1)*4 then
                    if v_tmp mod 2**((k+1)*4) > 9*(2**(k*4))+2**(k*4)-1 then
                      -- The correction of the nibble needs a carry
                      v_flags_int(k) := '1';
                    end if;
                  elsif DWIDTH = (k+1)*4-1 or DWIDTH = (k+1)*4-2 then
                    if v_tmp mod 2**((k+1)*4) > 1*(2**(k*4))+2**(k*4)-1 then
                      -- The correction of the nibble needs a carry
                      v_flags_int(k) := '1';
                    end if;
                  end if;
                else
                  -- Determine carry flag of the nibbles subsequent to the one
                  -- which will be incremented by 6.
                  if DWIDTH >= (k+1)*4 then
                    if v_tmp mod 2**((k+1)*4) >= 15*(2**(k*4))
                      and v_flags_int(k-1) = '1' then
                      -- The correction of the nibble needs a carry
                      v_flags_int(k) := '1';
                    end if;
                  else
                    if v_tmp mod 2**DWIDTH >= (2**(DWIDTH-k*4)-1)*2**(k*4)
                      and v_flags_int(k-1) = '1' then
                      -- The correction of the nibble needs a carry
                      v_flags_int(k) := '1';
                    end if;
                  end if;
                end if;
              end loop;  -- k
              for k in h to ((DWIDTH-1)/4) loop
                -- Perform correction for the lowest nibble in scope
                if DWIDTH >= (k+1)*4-1 then
                  if k=h then
                    v_tmp := v_tmp + 6*(2**(h*4));
                  end if;
                elsif DWIDTH = (k+1)*4-2 then
                  if k=h then
                    v_tmp := v_tmp + 2*(2**(h*4));
                  end if;
                end if;
              end loop;  -- k
              v_flags := v_flags_int or v_flags;
            end if;
        end loop;  -- h
        -- Set expected values.
        v_newdata := conv_std_logic_vector(v_tmp, DWIDTH);
        if v_tmp > 2**DWIDTH-1 then
          v_cy := '1';
        end if;
        -- After waiting for the result, perform checks.
        wait for PROP_DELAY;
        assert (s_datai = v_newdata) and (s_cyi((DWIDTH-1)/4) = v_cy)
          report "ERROR in decimal adjustement of the "
          & IMAGE(DWIDTH) & " bit data!" &
          " v_tmp= " & IMAGE(v_tmp) &
          " j= "  & IMAGE(j) &
          " i= "  & IMAGE(i)
          severity failure;
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT DECIMAL ADJUST FUNCTION FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_da_end <= true;
    wait;
  end PROC_DA;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_DIV_ACC_RAM - Test the combinational divider                      --
  --                                                                         --
  --  Procedure to generate all the input data to test the combinational     --
  --  divider command. Furthermore the results are compared with the         --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_DIV_ACC_RAM (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_qutnt    : in  std_logic_vector;
    signal   s_rmndr    : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_dvdnd    : out std_logic_vector;
    signal   s_dvsor    : out std_logic_vector;
    signal   s_dvdr_end : out boolean) is
    
    variable v_quot : integer;
    variable v_remd : integer;
    variable v_flags     : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    
  begin
    s_dvdr_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_dvdnd <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_dvsor <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          s_cyo <= v_flags(((DWIDTH-1)/4) downto 0);
          s_ovo <= v_flags(v_flags'HIGH);        
          wait for PROP_DELAY;
          if i /= 0 then
            v_quot := j/i;
            v_remd := j rem i;
            assert (s_cyi((DWIDTH-1)/4) = '0')
              and (s_ovi = '0')
              and (s_qutnt = conv_std_logic_vector(v_quot,DWIDTH))
              and (s_rmndr = conv_std_logic_vector(v_remd,DWIDTH))
              report "ERROR in division!"
              severity failure;
          else   
            assert (s_cyi((DWIDTH-1)/4) = '0')
              and (s_ovi = '1')
              report "ERROR in division by zero - flags not correct!"
              severity failure;          
          end if;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH) & "BIT DIVIDER SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_dvdr_end <= true;
    wait;
  end PROC_DIV_ACC_RAM;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_MUL_ACC_RAM - Test the combinational multiplier                   --
  --                                                                         --
  --  Procedure to generate all the input data to test the combinational     --
  --  multiply command. Furthermore the results are compared with the        --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_MUL_ACC_RAM (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_product  : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_mltplcnd : out std_logic_vector;
    signal   s_mltplctr : out std_logic_vector;
    signal   s_mul_end  : out boolean) is
    
    variable v_product : integer;
    variable v_flags     : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    
  begin
    s_mul_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_mltplcnd <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_mltplctr <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          s_cyo <= v_flags(((DWIDTH-1)/4) downto 0);
          s_ovo <= v_flags(v_flags'HIGH);        
          v_product := j*i;
          wait for PROP_DELAY;
          if v_product > 2**DWIDTH-1 then
            assert (s_cyi((DWIDTH-1)/4) = '0')
              and (s_ovi = '1')
              and (s_product = conv_std_logic_vector(v_product,DWIDTH*2))
              report "ERROR in " & IMAGE(DWIDTH) & "bit multiplication!"
              severity failure;
          else  
            assert (s_cyi((DWIDTH-1)/4) = '0')
              and (s_product = conv_std_logic_vector(v_product,DWIDTH*2))
              and (s_ovi = '0')
              report "ERROR in " & IMAGE(DWIDTH) & "bit multiplication!"
              severity failure;
          end if;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT MULTIPLIER SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_mul_end <= true;
    wait;
  end PROC_MUL_ACC_RAM;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_AND - Test the logical AND command                                --
  --                                                                         --
  --  Procedure to generate all the input data to test the logical           --
  --  AND command. Furthermore the results are compared with the             --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_AND (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_result   : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_operanda : out std_logic_vector;
    signal   s_operandb : out std_logic_vector;
    signal   s_and_end  : out boolean) is

    variable v_result : std_logic_vector(DWIDTH-1 downto 0);
    variable v_flags  : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    variable v_cyo    : std_logic_vector(((DWIDTH-1)/4) downto 0);
    variable v_ovo    : std_logic;

  begin
    s_and_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_operanda <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_operandb <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          v_cyo := v_flags(((DWIDTH-1)/4) downto 0);
          v_ovo := v_flags(v_flags'HIGH);
          s_cyo <= v_cyo;
          s_ovo <= v_ovo;
          v_result := conv_std_logic_vector(j,DWIDTH)
                      and conv_std_logic_vector(i,DWIDTH);
          wait for PROP_DELAY;
          assert (s_cyi = v_cyo)
            and (s_ovi = v_ovo)
            and (s_result = v_result)
            report "ERROR in " & IMAGE(DWIDTH) & "bit logical AND operation!"
            severity failure;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT AND SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_and_end <= true;
    wait;
  end PROC_AND;
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_OR - Test the logical OR command                                  --
  --                                                                         --
  --  Procedure to generate all the input data to test the logical           --
  --  OR command. Furthermore the results are compared with the              --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_OR (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_result   : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_operanda : out std_logic_vector;
    signal   s_operandb : out std_logic_vector;
    signal   s_or_end  : out boolean) is

    variable v_result : std_logic_vector(DWIDTH-1 downto 0);
    variable v_flags  : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    variable v_cyo    : std_logic_vector(((DWIDTH-1)/4) downto 0);
    variable v_ovo    : std_logic;

  begin
    s_or_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_operanda <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_operandb <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          v_cyo := v_flags(((DWIDTH-1)/4) downto 0);
          v_ovo := v_flags(v_flags'HIGH);
          s_cyo <= v_cyo;
          s_ovo <= v_ovo;
          v_result := conv_std_logic_vector(j,DWIDTH)
                      or conv_std_logic_vector(i,DWIDTH);
          wait for PROP_DELAY;
          assert (s_cyi = v_cyo)
            and (s_ovi = v_ovo)
            and (s_result = v_result)
            report "ERROR in " & IMAGE(DWIDTH) & "bit logical OR operation!"
            severity failure;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT OR SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_or_end <= true;
    wait;
  end PROC_OR;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_XOR - Test the logical XOR command                                --
  --                                                                         --
  --  Procedure to generate all the input data to test the logical           --
  --  XOR command. Furthermore the results are compared with the             --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_XOR (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_result   : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_operanda : out std_logic_vector;
    signal   s_operandb : out std_logic_vector;
    signal   s_xor_end  : out boolean) is

    variable v_result : std_logic_vector(DWIDTH-1 downto 0);
    variable v_flags  : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    variable v_cyo    : std_logic_vector(((DWIDTH-1)/4) downto 0);
    variable v_ovo    : std_logic;

  begin
    s_xor_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_operanda <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_operandb <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          v_cyo := v_flags(((DWIDTH-1)/4) downto 0);
          v_ovo := v_flags(v_flags'HIGH);
          s_cyo <= v_cyo;
          s_ovo <= v_ovo;
          v_result := conv_std_logic_vector(j,DWIDTH)
                      xor conv_std_logic_vector(i,DWIDTH);
          wait for PROP_DELAY;
          assert (s_cyi = v_cyo)
            and (s_ovi = v_ovo)
            and (s_result = v_result)
            report "ERROR in " & IMAGE(DWIDTH) & "bit logical XOR operation!"
            severity failure;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT XOR SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_xor_end <= true;
    wait;
  end PROC_XOR;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_ADD - Test the logical ADD command                                --
  --                                                                         --
  --  Procedure to generate all the input data to test the logical           --
  --  ADD command. Furthermore the results are compared with the             --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_ADD (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    constant ADD_CARRY  : in  boolean;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_result   : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_operanda : out std_logic_vector;
    signal   s_operandb : out std_logic_vector;
    signal   s_add_end  : out boolean) is

    variable v_result : std_logic_vector(DWIDTH-1 downto 0);
    variable v_flags  : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    variable v_cyo    : std_logic_vector(((DWIDTH-1)/4) downto 0);
    variable v_ovo    : std_logic;
    variable v_carry  : integer;

  begin
    s_add_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_operanda <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_operandb <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          s_cyo <= v_flags(((DWIDTH-1)/4) downto 0);
          s_ovo <= v_flags(v_flags'HIGH);
          v_carry := conv_integer(v_flags((DWIDTH-1)/4));
          if ADD_CARRY = true then
            for h in 0 to (DWIDTH-1)/4 loop
              if DWIDTH > (h+1)*4 then
                if (j mod 2**((h+1)*4) + i mod 2**((h+1)*4) + v_carry)
                  > 2**((h+1)*4)-1 then  
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              else
                if (j mod 2**(DWIDTH) + i mod 2**(DWIDTH) + v_carry
                  > 2**(DWIDTH)-1) then  
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              end if;
            end loop;  -- h
 --           if DWIDTH = 1 then
 --             v_ovo := '0';
 --           else
              if (j+i > 2**DWIDTH-1
                  and (j mod 2**(DWIDTH-1) + i mod 2**(DWIDTH-1) + v_carry)
                  <= 2**(DWIDTH-1)-1) or
                (j+i < 2**DWIDTH-1
                 and (j mod 2**(DWIDTH-1) + i mod 2**(DWIDTH-1) + v_carry)
                 > 2**(DWIDTH-1)-1) then
                v_ovo := '1';                             
              else                                          
                v_ovo := '0';                               
              end if;                                       
 --           end if;
            v_result := conv_std_logic_vector(j + i + v_carry,DWIDTH);
            wait for PROP_DELAY;
            assert (s_cyi = v_cyo)
              and (s_ovi = v_ovo)
              and (s_result = v_result)
              report "ERROR in " & IMAGE(DWIDTH) & "bit ADDC operation!"
              severity failure;
          else
            for h in 0 to (DWIDTH-1)/4 loop
              if DWIDTH > (h+1)*4 then
                if (j mod 2**((h+1)*4) + i mod 2**((h+1)*4))
                  > 2**((h+1)*4)-1 then  
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              else
                if (j mod 2**(DWIDTH) + i mod 2**(DWIDTH)
                  > 2**(DWIDTH)-1) then  
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              end if;
            end loop;  -- h
 --           if DWIDTH = 1 then
 --             v_ovo := '0';
 --           else
              if (j+i > 2**DWIDTH-1
                  and (j mod 2**(DWIDTH-1) + i mod 2**(DWIDTH-1))
                  <= 2**(DWIDTH-1)-1) or
                (j+i <= 2**DWIDTH-1
                 and (j mod 2**(DWIDTH-1) + i mod 2**(DWIDTH-1))
                 > 2**(DWIDTH-1)-1) then
                v_ovo := '1';                               
              else                                          
                v_ovo := '0';                               
              end if;                                       
 --           end if;
            v_result := conv_std_logic_vector(j+i,DWIDTH);
            wait for PROP_DELAY;
            assert (s_cyi = v_cyo)
              and (s_ovi = v_ovo)
              and (s_result = v_result)
              report "ERROR in " & IMAGE(DWIDTH) & "bit ADD operation!"
              severity failure;
          end if;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT ADD SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_add_end <= true;
    wait;
  end PROC_ADD;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  --                                                                         --
  --  PROC_SUB - Test the logical SUB command                                --
  --                                                                         --
  --  Procedure to generate all the input data to test the                   --
  --  SUB command. Furthermore the results are compared with the             --
  --  expected values and the simulation is stopped with an error message    --
  --  if the test failes.                                                    --
  -----------------------------------------------------------------------------
  procedure PROC_SUB (
    constant DWIDTH     : in  positive;
    constant PROP_DELAY : in  time;
    signal   s_cyi      : in  std_logic_vector;
    signal   s_ovi      : in  std_logic;
    signal   s_result   : in  std_logic_vector;
    signal   s_cyo      : out std_logic_vector;
    signal   s_ovo      : out std_logic;
    signal   s_operanda : out std_logic_vector;
    signal   s_operandb : out std_logic_vector;
    signal   s_sub_end  : out boolean) is

    variable v_result : std_logic_vector(DWIDTH-1 downto 0);
    variable v_flags  : std_logic_vector((DWIDTH-1)/4+1 downto 0);
    variable v_cyo    : std_logic_vector(((DWIDTH-1)/4) downto 0);
    variable v_ovo    : std_logic;
    variable v_carry  : integer;

  begin
    s_sub_end <= false;
    for j in 0 to 2**DWIDTH-1 loop
      s_operanda <= conv_std_logic_vector(j,DWIDTH);
      for i in 0 to 2**DWIDTH-1 loop
        s_operandb <= conv_std_logic_vector(i,DWIDTH);
        for f in 0 to 2**(((DWIDTH-1)/4)+2)-1 loop
          v_flags := conv_std_logic_vector(f,((DWIDTH-1)/4)+2);
          s_cyo <= v_flags(((DWIDTH-1)/4) downto 0);
          s_ovo <= v_flags(v_flags'HIGH);
          v_carry := conv_integer(v_flags((DWIDTH-1)/4));
            for h in 0 to (DWIDTH-1)/4 loop
              if DWIDTH > (h+1)*4 then
                if (j mod 2**((h+1)*4) - i mod 2**((h+1)*4) - v_carry)
                  < 0 then 
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              else
                if (j mod 2**(DWIDTH) - i mod 2**(DWIDTH) - v_carry)
                  < 0 then
                  v_cyo(h) := '1';                          
                else                                        
                  v_cyo(h) := '0';                          
                end if;
              end if;
            end loop;  -- h
 --           if DWIDTH = 1 then
 --             v_ovo := '0';
 --           else
              if (j - i - v_carry < 0
                  and (j mod 2**(DWIDTH-1) - i mod 2**(DWIDTH-1) - v_carry)
                  >= 0) or 
                (j - i - v_carry >= 0
                 and (j mod 2**(DWIDTH-1) - i mod 2**(DWIDTH-1) - v_carry)
                 < 0) then
                v_ovo := '1';                               
              else                                          
                v_ovo := '0';                               
              end if;                                       
 --           end if;
            v_result := conv_std_logic_vector(j - i - v_carry,DWIDTH);
            wait for PROP_DELAY;
            assert (s_cyi = v_cyo)
              and (s_ovi = v_ovo)
              and (s_result = v_result)
              report "ERROR in " & IMAGE(DWIDTH) & "bit SUB operation!"
              severity failure;
        end loop;  -- f
      end loop;  -- i
    end loop;  -- j  
    assert false
      report "********* " & IMAGE(DWIDTH)
      & "BIT SUB SEQUENCE FINISHED AT "
      & IMAGE(now) & " !" & " *********" 
      severity note;
    s_sub_end <= true;
    wait;
  end PROC_SUB;
  -----------------------------------------------------------------------------

  constant PROP_DELAY : time := 100 ns;
  constant MAX_DWIDTH : integer := 11;

  type t_data_DA is array (1 to MAX_DWIDTH) of
    std_logic_vector(MAX_DWIDTH-1 downto 0);
  type t_cmd_DA is array (1 to MAX_DWIDTH) of std_logic_vector(5 downto 0);
  type t_cy_DA is array (1 to MAX_DWIDTH) of
    std_logic_vector((MAX_DWIDTH-1)/4 downto 0);
  type t_ov_DA is array (1 to MAX_DWIDTH) of std_logic;
  type t_end_DA is array (1 to MAX_DWIDTH) of boolean;
  
  type t_data_DIV_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector(MAX_DWIDTH-1 downto 0);
  type t_cmd_DIV_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector(5 downto 0);
  type t_ov_DIV_ACC_RAM is array (1 to MAX_DWIDTH) of std_logic;
  type t_end_DIV_ACC_RAM is array (1 to MAX_DWIDTH) of boolean;
  type t_cy_DIV_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector((MAX_DWIDTH-1)/4 downto 0);

  type t_product_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector(MAX_DWIDTH*2-1 downto 0);
  type t_data_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector(MAX_DWIDTH-1 downto 0);
  type t_cmd_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector(5 downto 0);
  type t_ov_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of std_logic;
  type t_end_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of boolean;
  type t_cy_MUL_ACC_RAM is array (1 to MAX_DWIDTH) of
    std_logic_vector((MAX_DWIDTH-1)/4 downto 0);
  
  type t_data_STIM is array (1 to MAX_DWIDTH) of
    std_logic_vector(MAX_DWIDTH-1 downto 0);
  type t_cmd_STIM is array (1 to MAX_DWIDTH) of std_logic_vector(5 downto 0);
  type t_cy_STIM is array (1 to MAX_DWIDTH) of
    std_logic_vector((MAX_DWIDTH-1)/4 downto 0);
  type t_ov_STIM is array (1 to MAX_DWIDTH) of std_logic;
  type t_end_STIM is array (1 to MAX_DWIDTH) of boolean;

  type t_pass is array (1 to MAX_DWIDTH+1) of boolean;

  signal rom_data_DA : t_data_DA;
  signal ram_data_DA : t_data_DA;
  signal acc_DA : t_data_DA;
  signal hlp_DA : t_data_DA;
  signal cmd_DA : t_cmd_DA;
  signal cy_DA : t_cy_DA;
  signal ov_DA : t_ov_DA;
  signal new_cy_DA : t_cy_DA;
  signal new_ov_DA : t_ov_DA;
  signal result_a_DA : t_data_DA;
  signal result_b_DA : t_data_DA;
  signal end_DA : t_end_DA;

  signal rom_data_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal ram_data_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal acc_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal hlp_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal cmd_DIV_ACC_RAM : t_cmd_DIV_ACC_RAM;
  signal cy_DIV_ACC_RAM : t_cy_DIV_ACC_RAM;
  signal ov_DIV_ACC_RAM : t_ov_DIV_ACC_RAM;
  signal new_cy_DIV_ACC_RAM : t_cy_DIV_ACC_RAM;
  signal new_ov_DIV_ACC_RAM : t_ov_DIV_ACC_RAM;
  signal result_a_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal result_b_DIV_ACC_RAM : t_data_DIV_ACC_RAM;
  signal end_DIV_ACC_RAM : t_end_DIV_ACC_RAM;

  signal rom_data_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal ram_data_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal acc_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal hlp_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal cmd_MUL_ACC_RAM : t_cmd_MUL_ACC_RAM;
  signal cy_MUL_ACC_RAM : t_cy_MUL_ACC_RAM;
  signal ov_MUL_ACC_RAM : t_ov_MUL_ACC_RAM;
  signal new_cy_MUL_ACC_RAM : t_cy_MUL_ACC_RAM;
  signal new_ov_MUL_ACC_RAM : t_ov_MUL_ACC_RAM;
  signal result_a_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal result_b_MUL_ACC_RAM : t_data_MUL_ACC_RAM;
  signal product_MUL_ACC_RAM : t_product_MUL_ACC_RAM;
  signal end_MUL_ACC_RAM : t_end_MUL_ACC_RAM;

  signal rom_data_AND_ACC_RAM : t_data_STIM;
  signal ram_data_AND_ACC_RAM : t_data_STIM;
  signal acc_AND_ACC_RAM : t_data_STIM;
  signal hlp_AND_ACC_RAM : t_data_STIM;
  signal cmd_AND_ACC_RAM : t_cmd_STIM;
  signal cy_AND_ACC_RAM : t_cy_STIM;
  signal ov_AND_ACC_RAM : t_ov_STIM;
  signal new_cy_AND_ACC_RAM : t_cy_STIM;
  signal new_ov_AND_ACC_RAM : t_ov_STIM;
  signal result_a_AND_ACC_RAM : t_data_STIM;
  signal result_b_AND_ACC_RAM : t_data_STIM;
  signal end_AND_ACC_RAM : t_end_STIM;

  signal rom_data_OR_ACC_RAM : t_data_STIM;
  signal ram_data_OR_ACC_RAM : t_data_STIM;
  signal acc_OR_ACC_RAM : t_data_STIM;
  signal hlp_OR_ACC_RAM : t_data_STIM;
  signal cmd_OR_ACC_RAM : t_cmd_STIM;
  signal cy_OR_ACC_RAM : t_cy_STIM;
  signal ov_OR_ACC_RAM : t_ov_STIM;
  signal new_cy_OR_ACC_RAM : t_cy_STIM;
  signal new_ov_OR_ACC_RAM : t_ov_STIM;
  signal result_a_OR_ACC_RAM : t_data_STIM;
  signal result_b_OR_ACC_RAM : t_data_STIM;
  signal end_OR_ACC_RAM : t_end_STIM;

  signal rom_data_XOR_ACC_RAM : t_data_STIM;
  signal ram_data_XOR_ACC_RAM : t_data_STIM;
  signal acc_XOR_ACC_RAM : t_data_STIM;
  signal hlp_XOR_ACC_RAM : t_data_STIM;
  signal cmd_XOR_ACC_RAM : t_cmd_STIM;
  signal cy_XOR_ACC_RAM : t_cy_STIM;
  signal ov_XOR_ACC_RAM : t_ov_STIM;
  signal new_cy_XOR_ACC_RAM : t_cy_STIM;
  signal new_ov_XOR_ACC_RAM : t_ov_STIM;
  signal result_a_XOR_ACC_RAM : t_data_STIM;
  signal result_b_XOR_ACC_RAM : t_data_STIM;
  signal end_XOR_ACC_RAM : t_end_STIM;

  signal rom_data_ADD_ACC_RAM : t_data_STIM;
  signal ram_data_ADD_ACC_RAM : t_data_STIM;
  signal acc_ADD_ACC_RAM : t_data_STIM;
  signal hlp_ADD_ACC_RAM : t_data_STIM;
  signal cmd_ADD_ACC_RAM : t_cmd_STIM;
  signal cy_ADD_ACC_RAM : t_cy_STIM;
  signal ov_ADD_ACC_RAM : t_ov_STIM;
  signal new_cy_ADD_ACC_RAM : t_cy_STIM;
  signal new_ov_ADD_ACC_RAM : t_ov_STIM;
  signal result_a_ADD_ACC_RAM : t_data_STIM;
  signal result_b_ADD_ACC_RAM : t_data_STIM;
  signal end_ADD_ACC_RAM : t_end_STIM;
  
  signal rom_data_ADDC_ACC_RAM : t_data_STIM;
  signal ram_data_ADDC_ACC_RAM : t_data_STIM;
  signal acc_ADDC_ACC_RAM : t_data_STIM;
  signal hlp_ADDC_ACC_RAM : t_data_STIM;
  signal cmd_ADDC_ACC_RAM : t_cmd_STIM;
  signal cy_ADDC_ACC_RAM : t_cy_STIM;
  signal ov_ADDC_ACC_RAM : t_ov_STIM;
  signal new_cy_ADDC_ACC_RAM : t_cy_STIM;
  signal new_ov_ADDC_ACC_RAM : t_ov_STIM;
  signal result_a_ADDC_ACC_RAM : t_data_STIM;
  signal result_b_ADDC_ACC_RAM : t_data_STIM;
  signal end_ADDC_ACC_RAM : t_end_STIM;
  
  signal rom_data_SUB_ACC_RAM : t_data_STIM;
  signal ram_data_SUB_ACC_RAM : t_data_STIM;
  signal acc_SUB_ACC_RAM : t_data_STIM;
  signal hlp_SUB_ACC_RAM : t_data_STIM;
  signal cmd_SUB_ACC_RAM : t_cmd_STIM;
  signal cy_SUB_ACC_RAM : t_cy_STIM;
  signal ov_SUB_ACC_RAM : t_ov_STIM;
  signal new_cy_SUB_ACC_RAM : t_cy_STIM;
  signal new_ov_SUB_ACC_RAM : t_ov_STIM;
  signal result_a_SUB_ACC_RAM : t_data_STIM;
  signal result_b_SUB_ACC_RAM : t_data_STIM;
  signal end_SUB_ACC_RAM : t_end_STIM;

  signal pass : t_pass := (others => true);

begin

  -----------------------------------------------------------------------------
  -- Test the DA command for data widths from 1 up to MAX_DWIDTH             --
  -----------------------------------------------------------------------------
  gen_da: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during DA test
    rom_data_DA(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    ram_data_DA(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    hlp_DA(i)      <= conv_std_logic_vector(0,MAX_DWIDTH);
    cmd_DA(i)      <= conv_std_logic_vector(32,6);
    ov_DA(i)       <= '0';
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_DA : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_DA(i)(i-1 downto 0), 
        ram_data_i => ram_data_DA(i)(i-1 downto 0), 
        acc_i      => acc_DA(i)(i-1 downto 0),      
--        hlp_i      => hlp_DA(i)(i-1 downto 0),      
        cmd_i      => cmd_DA(i),      
        cy_i       => cy_DA(i)((i-1)/4 downto 0),       
        ov_i       => ov_DA(i),       
        new_cy_o   => new_cy_DA(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_DA(i),   
        result_a_o => result_a_DA(i)(i-1 downto 0), 
        result_b_o => result_b_DA(i)(i-1 downto 0));
    -- Call the test procedure for the DA command
    PROC_DA (DWIDTH     => i,
             PROP_DELAY => PROP_DELAY,
             s_datao    => acc_DA(i)(i-1 downto 0),
             s_cy       => cy_DA(i)((i-1)/4 downto 0),
             s_datai    => result_a_DA(i)(i-1 downto 0),
             s_cyi      => new_cy_DA(i)((i-1)/4 downto 0),
             s_da_end   => end_DA(i));
  end generate GEN_DA;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- Test the DIV_ACC_RAM command for data widths from 1 up to MAX_DWIDTH    --
  -----------------------------------------------------------------------------
  gen_div_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during DIV_ACC_RAM test
    rom_data_DIV_ACC_RAM(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    hlp_DIV_ACC_RAM(i)      <= conv_std_logic_vector(0,MAX_DWIDTH);
    cmd_DIV_ACC_RAM(i)      <= conv_std_logic_vector(43,6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_DIV_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_DIV_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_DIV_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_DIV_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_DIV_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_DIV_ACC_RAM(i),      
        cy_i       => cy_DIV_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_DIV_ACC_RAM(i),       
        new_cy_o   => new_cy_DIV_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_DIV_ACC_RAM(i),   
        result_a_o => result_a_DIV_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_DIV_ACC_RAM(i)(i-1 downto 0));
    PROC_DIV_ACC_RAM (DWIDTH => i,
             PROP_DELAY      => PROP_DELAY,
             s_cyi           => new_cy_DIV_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi           => new_ov_DIV_ACC_RAM(i),
             s_qutnt         => result_a_DIV_ACC_RAM(i)(i-1 downto 0),
             s_rmndr         => result_b_DIV_ACC_RAM(i)(i-1 downto 0),
             s_cyo           => cy_DIV_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo           => ov_DIV_ACC_RAM(i),
             s_dvdnd         => acc_DIV_ACC_RAM(i)(i-1 downto 0),
             s_dvsor         => ram_data_DIV_ACC_RAM(i)(i-1 downto 0),
             s_dvdr_end      => end_DIV_ACC_RAM(i));
  end generate gen_div_acc_ram;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Test the MUL_ACC_RAM command for data widths from 1 up to MAX_DWIDTH  --
  -----------------------------------------------------------------------------
  gen_mul_acc_ram            : for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during MUL_ACC_RAM test
    product_MUL_ACC_RAM(i)(i-1 downto 0)   <=
      result_a_MUL_ACC_RAM(i)(i-1 downto 0);
    product_MUL_ACC_RAM(i)(i*2-1 downto i) <=
      result_b_MUL_ACC_RAM(i)(i-1 downto 0);
    rom_data_MUL_ACC_RAM(i)            <= conv_std_logic_vector(0, MAX_DWIDTH);
    hlp_MUL_ACC_RAM(i)                 <= conv_std_logic_vector(0, MAX_DWIDTH);
    cmd_MUL_ACC_RAM(i)                 <= conv_std_logic_vector(42, 6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_MUL_ACC_RAM : mc8051_alu
      generic map (
        DWIDTH               => i)
      port map (
        rom_data_i           => rom_data_MUL_ACC_RAM(i)(i-1 downto 0),
        ram_data_i           => ram_data_MUL_ACC_RAM(i)(i-1 downto 0),
        acc_i                => acc_MUL_ACC_RAM(i)(i-1 downto 0),
--        hlp_i                => hlp_MUL_ACC_RAM(i)(i-1 downto 0),
        cmd_i                => cmd_MUL_ACC_RAM(i),
        cy_i                 => cy_MUL_ACC_RAM(i)((i-1)/4 downto 0),
        ov_i                 => ov_MUL_ACC_RAM(i),
        new_cy_o             => new_cy_MUL_ACC_RAM(i)((i-1)/4 downto 0),
        new_ov_o             => new_ov_MUL_ACC_RAM(i),
        result_a_o           => result_a_MUL_ACC_RAM(i)(i-1 downto 0),
        result_b_o           => result_b_MUL_ACC_RAM(i)(i-1 downto 0));
    PROC_MUL_ACC_RAM (DWIDTH => i,
             PROP_DELAY      => PROP_DELAY,
             s_cyi           => new_cy_MUL_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi           => new_ov_MUL_ACC_RAM(i),
             s_product       => product_MUL_ACC_RAM(i)(i*2-1 downto 0),
             s_cyo           => cy_MUL_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo           => ov_MUL_ACC_RAM(i),
             s_mltplcnd      => acc_MUL_ACC_RAM(i)(i-1 downto 0),
             s_mltplctr      => ram_data_MUL_ACC_RAM(i)(i-1 downto 0),
             s_mul_end       => end_MUL_ACC_RAM(i));
  end generate gen_mul_acc_ram;
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Test the AND_ACC_RAM command for data widths from 1 up to MAX_DWIDTH    --
  -----------------------------------------------------------------------------
  gen_and_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during AND_ACC_RAM test
    rom_data_AND_ACC_RAM(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    hlp_AND_ACC_RAM(i)      <= conv_std_logic_vector(0,MAX_DWIDTH);
    cmd_AND_ACC_RAM(i)      <= conv_std_logic_vector(37,6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_AND_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_AND_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_AND_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_AND_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_AND_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_AND_ACC_RAM(i),      
        cy_i       => cy_AND_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_AND_ACC_RAM(i),       
        new_cy_o   => new_cy_AND_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_AND_ACC_RAM(i),   
        result_a_o => result_a_AND_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_AND_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the AND_ACC_RAM command
    PROC_AND (DWIDTH    => i,
             PROP_DELAY => PROP_DELAY,
             s_cyi      => new_cy_AND_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_AND_ACC_RAM(i),
             s_result   => result_a_AND_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_AND_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_AND_ACC_RAM(i),
             s_operanda => acc_AND_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_AND_ACC_RAM(i)(i-1 downto 0),
             s_and_end  => end_AND_ACC_RAM(i));
  end generate gen_and_acc_ram;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- Test the OR_ACC_RAM command for data widths from 1 up to MAX_DWIDTH    --
  -----------------------------------------------------------------------------
  gen_or_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during OR_ACC_RAM test
    rom_data_OR_ACC_RAM(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    hlp_OR_ACC_RAM(i)      <= conv_std_logic_vector(0,MAX_DWIDTH);
    cmd_OR_ACC_RAM(i)      <= conv_std_logic_vector(44,6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_OR_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_OR_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_OR_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_OR_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_OR_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_OR_ACC_RAM(i),      
        cy_i       => cy_OR_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_OR_ACC_RAM(i),       
        new_cy_o   => new_cy_OR_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_OR_ACC_RAM(i),   
        result_a_o => result_a_OR_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_OR_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the OR_ACC_RAM command
    PROC_OR (DWIDTH     => i,
             PROP_DELAY => PROP_DELAY,
             s_cyi      => new_cy_OR_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_OR_ACC_RAM(i),
             s_result   => result_a_OR_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_OR_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_OR_ACC_RAM(i),
             s_operanda => acc_OR_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_OR_ACC_RAM(i)(i-1 downto 0),
             s_or_end  => end_OR_ACC_RAM(i));
  end generate gen_or_acc_ram;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- Test the XOR_ACC_RAM command for data widths from 1 up to MAX_DWIDTH    --
  -----------------------------------------------------------------------------
  gen_xor_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during XOR_ACC_RAM test
    rom_data_XOR_ACC_RAM(i) <= conv_std_logic_vector(0,MAX_DWIDTH);
    hlp_XOR_ACC_RAM(i)      <= conv_std_logic_vector(0,MAX_DWIDTH);
    cmd_XOR_ACC_RAM(i)      <= conv_std_logic_vector(47,6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_XOR_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_XOR_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_XOR_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_XOR_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_XOR_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_XOR_ACC_RAM(i),      
        cy_i       => cy_XOR_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_XOR_ACC_RAM(i),       
        new_cy_o   => new_cy_XOR_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_XOR_ACC_RAM(i),   
        result_a_o => result_a_XOR_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_XOR_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the XOR_ACC_RAM command
    PROC_XOR (DWIDTH    => i,
             PROP_DELAY => PROP_DELAY,
             s_cyi      => new_cy_XOR_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_XOR_ACC_RAM(i),
             s_result   => result_a_XOR_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_XOR_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_XOR_ACC_RAM(i),
             s_operanda => acc_XOR_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_XOR_ACC_RAM(i)(i-1 downto 0),
             s_xor_end  => end_XOR_ACC_RAM(i));
  end generate gen_xor_acc_ram;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- Test the ADD_ACC_RAM command for data widths from 1 up to MAX_DWIDTH    --
  -----------------------------------------------------------------------------
  gen_add_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during ADD_ACC_RAM test
    rom_data_ADD_ACC_RAM(i)  <= conv_std_logic_vector(0, MAX_DWIDTH);
    hlp_ADD_ACC_RAM(i)       <= conv_std_logic_vector(0, MAX_DWIDTH);
    cmd_ADD_ACC_RAM(i)       <= conv_std_logic_vector(33, 6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_ADD_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_ADD_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_ADD_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_ADD_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_ADD_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_ADD_ACC_RAM(i),      
        cy_i       => cy_ADD_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_ADD_ACC_RAM(i),       
        new_cy_o   => new_cy_ADD_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_ADD_ACC_RAM(i),   
        result_a_o => result_a_ADD_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_ADD_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the ADD_ACC_RAM command
    PROC_ADD (DWIDTH    => i,
             PROP_DELAY => PROP_DELAY,
             ADD_CARRY  => false, 
             s_cyi      => new_cy_ADD_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_ADD_ACC_RAM(i),
             s_result   => result_a_ADD_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_ADD_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_ADD_ACC_RAM(i),
             s_operanda => acc_ADD_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_ADD_ACC_RAM(i)(i-1 downto 0),
             s_add_end  => end_ADD_ACC_RAM(i));
  end generate gen_add_acc_ram;
  -----------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------
  -- Test the ADDC_ACC_RAM command for data widths from 1 up to MAX_DWIDTH   --
  -----------------------------------------------------------------------------
  gen_addc_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during ADDC_ACC_RAM test
    rom_data_ADDC_ACC_RAM(i)  <= conv_std_logic_vector(0, MAX_DWIDTH);
    hlp_ADDC_ACC_RAM(i)       <= conv_std_logic_vector(0, MAX_DWIDTH);
    cmd_ADDC_ACC_RAM(i)       <= conv_std_logic_vector(35, 6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_ADDC_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_ADDC_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_ADDC_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_ADDC_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_ADDC_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_ADDC_ACC_RAM(i),      
        cy_i       => cy_ADDC_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_ADDC_ACC_RAM(i),       
        new_cy_o   => new_cy_ADDC_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_ADDC_ACC_RAM(i),   
        result_a_o => result_a_ADDC_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_ADDC_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the ADDC_ACC_RAM command
    PROC_ADD (DWIDTH    => i,
             PROP_DELAY => PROP_DELAY,
             ADD_CARRY  => true, 
             s_cyi      => new_cy_ADDC_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_ADDC_ACC_RAM(i),
             s_result   => result_a_ADDC_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_ADDC_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_ADDC_ACC_RAM(i),
             s_operanda => acc_ADDC_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_ADDC_ACC_RAM(i)(i-1 downto 0),
             s_add_end  => end_ADDC_ACC_RAM(i));
  end generate gen_addc_acc_ram;
  -----------------------------------------------------------------------------
    
  -----------------------------------------------------------------------------
  -- Test the SUB_ACC_RAM command for data widths from 1 up to MAX_DWIDTH   --
  -----------------------------------------------------------------------------
  gen_sub_acc_ram: for i in 1 to MAX_DWIDTH generate
    -- Values which do not change during SUB_ACC_RAM test
    rom_data_SUB_ACC_RAM(i)  <= conv_std_logic_vector(0, MAX_DWIDTH);
    hlp_SUB_ACC_RAM(i)       <= conv_std_logic_vector(0, MAX_DWIDTH);
    cmd_SUB_ACC_RAM(i)       <= conv_std_logic_vector(40, 6);
    -- Instantiate the ALU unit with the data width set to i
    i_mc8051_alu_SUB_ACC_RAM : mc8051_alu    
      generic map (                 
        DWIDTH => i)                
      port map (                    
        rom_data_i => rom_data_SUB_ACC_RAM(i)(i-1 downto 0), 
        ram_data_i => ram_data_SUB_ACC_RAM(i)(i-1 downto 0), 
        acc_i      => acc_SUB_ACC_RAM(i)(i-1 downto 0),      
--        hlp_i      => hlp_SUB_ACC_RAM(i)(i-1 downto 0),      
        cmd_i      => cmd_SUB_ACC_RAM(i),      
        cy_i       => cy_SUB_ACC_RAM(i)((i-1)/4 downto 0),       
        ov_i       => ov_SUB_ACC_RAM(i),       
        new_cy_o   => new_cy_SUB_ACC_RAM(i)((i-1)/4 downto 0),   
        new_ov_o   => new_ov_SUB_ACC_RAM(i),   
        result_a_o => result_a_SUB_ACC_RAM(i)(i-1 downto 0), 
        result_b_o => result_b_SUB_ACC_RAM(i)(i-1 downto 0));
    -- Call the test procedure for the SUB_ACC_RAM command
    PROC_SUB (DWIDTH    => i,
             PROP_DELAY => PROP_DELAY,
             s_cyi      => new_cy_SUB_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovi      => new_ov_SUB_ACC_RAM(i),
             s_result   => result_a_SUB_ACC_RAM(i)(i-1 downto 0),
             s_cyo      => cy_SUB_ACC_RAM(i)((i-1)/4 downto 0),
             s_ovo      => ov_SUB_ACC_RAM(i),
             s_operanda => acc_SUB_ACC_RAM(i)(i-1 downto 0),
             s_operandb => ram_data_SUB_ACC_RAM(i)(i-1 downto 0),
             s_sub_end  => end_SUB_ACC_RAM(i));
  end generate gen_sub_acc_ram;
  -----------------------------------------------------------------------------
    
  gen_pass: for i in 1 to MAX_DWIDTH generate
    pass(i+1) <= end_DA(i)
                 and pass(i)
                 and end_DIV_ACC_RAM(i)
                 and end_AND_ACC_RAM(i)
                 and end_OR_ACC_RAM(i)
                 and end_XOR_ACC_RAM(i)
                 and end_ADD_ACC_RAM(i)
                 and end_ADDC_ACC_RAM(i)
                 and end_SUB_ACC_RAM(i)
                 and end_MUL_ACC_RAM(i);
  end generate gen_pass;
  -- The following process guarantees that the simulation is not stopped
  -- (despite the ocurrence of an error situation) till all the instantiated
  -- designs under test have finished their whole test.
  p_endsim: process
  begin  -- process p_endsim
    wait until pass(MAX_DWIDTH+1) = true;
    assert false report "SIMULATION ENDED SUCCESSFULLY !!!" severity failure;
  end process p_endsim;
  
end sim;
