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
--         Filename:               tb_mc8051_top_sim.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.4 $
--
--         Date of Latest Version: $Date: 2006-09-07 06:37:03 $
--
--
--         Description: Top level testbench for the mc8051 IP-core.

--
--
--
--
-------------------------------------------------------------------------------
architecture sim of tb_mc8051_top is

  -----------------------------------------------------------------------------
  --
  -- FUNCTION: FUNC_PULLUP - model behaviour of a pullup resistor
  --
  -----------------------------------------------------------------------------
  function FUNC_PULLUP (signal s_bidir_line : in std_logic) return std_logic is

    variable v_result : std_logic;
    
  begin
    if s_bidir_line = 'Z' then
      v_result:= '1';
    else
      v_result := s_bidir_line;
    end if;
    return v_result;
  end FUNC_PULLUP;
  
  signal s_p0_i   : std_logic_vector(7 downto 0);
  signal s_p1_i   : std_logic_vector(7 downto 0);
  signal s_p2_i   : std_logic_vector(7 downto 0);
  signal s_p3_i   : std_logic_vector(7 downto 0);
  signal s_p0     : std_logic_vector(7 downto 0);
  signal s_p1     : std_logic_vector(7 downto 0);
  signal s_p2     : std_logic_vector(7 downto 0);
  signal s_p3     : std_logic_vector(7 downto 0);
  signal s_p0_ext : std_logic_vector(7 downto 0);
  signal s_p1_ext : std_logic_vector(7 downto 0);
  signal s_p2_ext : std_logic_vector(7 downto 0);
  signal s_p3_ext : std_logic_vector(7 downto 0);
  signal s_p0_o   : std_logic_vector(7 downto 0);
  signal s_p1_o   : std_logic_vector(7 downto 0);
  signal s_p2_o   : std_logic_vector(7 downto 0);
  signal s_p3_o   : std_logic_vector(7 downto 0);

  signal clk   : std_logic;
  signal reset : std_logic;

  signal s_int0 : std_logic_vector(C_IMPL_N_EXT-1 downto 0);
  signal s_int1 : std_logic_vector(C_IMPL_N_EXT-1 downto 0);


  signal s_all_t0 : std_logic_vector(C_IMPL_N_TMR-1 downto 0);
  signal s_all_t1 : std_logic_vector(C_IMPL_N_TMR-1 downto 0);

  signal s_all_rxd   : std_logic_vector(C_IMPL_N_SIU-1 downto 0);
  signal s_all_rxd_o : std_logic_vector(C_IMPL_N_SIU-1 downto 0);
  signal s_all_txd   : std_logic_vector(C_IMPL_N_SIU-1 downto 0);
  
  
begin

  i_mc8051_top : mc8051_top
    port map (reset     => reset,
              int0_i    => s_int0,
              int1_i    => s_int1,
              all_t0_i  => s_all_t0,
              all_t1_i  => s_all_t1,
              all_rxd_i => s_all_rxd,
              all_rxd_o => s_all_rxd_o,
              all_txd_o => s_all_txd,
              clk       => clk,
              p0_i      => s_p0_i,
              p1_i      => s_p1_i,
              p2_i      => s_p2_i,
              p3_i      => s_p3_i,
              p0_o      => s_p0_o,
              p1_o      => s_p1_o,
              p2_o      => s_p2_o,
              p3_o      => s_p3_o);

  -- Model the 8 bit I/O ports as described in the "MC8051 IP Core User Guide".
  -- NOTE: The two stage synchronization flip flops, which are depicted in the
  --       "MC8051 IP Core User Guide" have not been modeled here.
  gen_portmodel : for i in 0 to 7 generate
    s_p0_i(i) <= s_p0(i);
    s_p1_i(i) <= s_p1(i);
    s_p2_i(i) <= s_p2(i);
    s_p3_i(i) <= s_p3(i);

    s_p0(i) <= '0' when s_p0_o(i) = '0' else FUNC_PULLUP(s_p0_ext(i));
    s_p1(i) <= '0' when s_p1_o(i) = '0' else FUNC_PULLUP(s_p1_ext(i));
    s_p2(i) <= '0' when s_p2_o(i) = '0' else FUNC_PULLUP(s_p2_ext(i));
    s_p3(i) <= '0' when s_p3_o(i) = '0' else FUNC_PULLUP(s_p3_ext(i));
  end generate;
  
  -----------------------------------------------------------------------------
  p_run : process

  begin
    ---------------------------------------------------------------------------
    -- set start values and perform reset
    ---------------------------------------------------------------------------
    s_p0_ext <= ( others => 'Z' );
    s_p1_ext <= ( others => 'Z' );
    s_p2_ext <= ( others => 'Z' );
    s_p3_ext <= ( others => 'Z' );
    
    s_all_t0  <= ( others => '0' );
    s_all_t1  <= ( others => '0' );
    s_all_rxd <= ( others => '0' );

    reset <= '1';
    wait for one_period + one_period/2 + 5 ns;
    reset <= '0';

    wait for one_period * 5000;

    wait for one_period / 2;
    assert false report "END OF SIMULATION" severity failure;

  end process p_run;
  -----------------------------------------------------------------------------

  gen_int0: process
  begin
    s_int0 <= ( others => '0' );
    wait for 3000 ns;
    s_int0 <= ( others => '1' );
    wait for 7000 ns;
    s_int0 <= ( others => '0' );
    wait for 8000 ns;
    s_int0 <= ( others => '1' );
    wait for 7000 ns;
    s_int0 <= ( others => '0' );
    wait for 5000 ns;
    s_int0 <= ( others => '0' );
    wait for 3000 ns;
    s_int0 <= ( others => '0' );
    wait;
  end process gen_int0;


  -----------------------------------------------------------------------------
  gen_int1: process
  begin
    s_int1 <= ( others => '0' );
    wait for 4000 ns;
    s_int1 <= ( others => '1' );
    wait for 6000 ns;
    s_int1 <= ( others => '0' );
    wait;
  end process gen_int1;


  -----------------------------------------------------------------------------
  -- system clock definition
  p_clock : process
    
    variable v_loop1 : integer;
    
  begin
    clk <= '0';
    wait for one_period/2;
    while true loop
      clk <= not clk;
      wait for one_period/2;
    end loop;
    
  end process p_clock;
  -----------------------------------------------------------------------------
end sim;
