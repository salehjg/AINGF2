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
--         Filename:               tb_mc8051_tmrctr_sim.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.3 $
--
--         Date of Latest Version: $Date: 2002-01-07 12:16:57 $
--
--
--         Description: Module level testbench for the timer/counter unit.
--
--
--
--
-------------------------------------------------------------------------------
architecture sim of tb_mc8051_tmrctr is

  type mode is (MODE0_timer,
                MODE0_timer_interrupt,
                MODE0_counter,
                MODE0_counter_interrupt,
                MODE1_timer,
                MODE1_timer_interrupt,
                MODE1_counter,
                MODE1_counter_interrupt,
                MODE2_timer,
                MODE2_timer_interrupt,
                MODE2_counter,
                MODE2_counter_interrupt,
                MODE3_timer,
                MODE3_timer_interrupt,
                MODE3_counter,
                MODE3_counter_interrupt,
                SIMULATION_ERROR);
  
  signal s_tmod,
           s_th0_out,
           s_tl0_out,
           s_th1_out,
           s_tl1_out,
           s_reload: std_logic_vector(7 downto 0);
    
    signal clk,
           reset,
           s_int0,
           s_int1,
           s_t0,
           s_t1,
           s_tcon_tr0,
           s_tcon_tr1,
           s_tf0,
           s_tf1,
           s_wt_en: std_logic;
    
    signal tmr_ctr0, tmr_ctr1: mode;

    signal s_wt : std_logic_vector (1 downto 0);
    
    
begin

  i_mc8051_tmrctr : mc8051_tmrctr
    port map (clk        => clk,  	-- tmrctr inputs
              reset      => reset,
              int0_i     => s_int0,
              int1_i     => s_int1,
              t0_i       => s_t0,
              t1_i       => s_t1,
              tmod_i     => s_tmod,
              tcon_tr0_i => s_tcon_tr0,
              tcon_tr1_i => s_tcon_tr1,
              reload_i   => s_reload,
              wt_en_i    => s_wt_en,
              wt_i       => s_wt,

              th0_o => s_th0_out,  	-- tmrctr outputs
              tl0_o => s_tl0_out,
              th1_o => s_th1_out,
              tl1_o => s_tl1_out,
              tf0_o => s_tf0,
              tf1_o => s_tf1);


p_run: process

begin

-------------------------------------------------------------------------------
-- set start values and perform reset
-------------------------------------------------------------------------------
    s_tmod <= conv_std_logic_vector(0,8);
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    s_wt <= conv_std_logic_vector(0,2);
    s_wt_en <= '0';
    s_reload <= conv_std_logic_vector(0,8);       -- reload value
    reset <= '1';
    wait for one_period + one_period/2 + 5 ns ;
    reset <= '0';
    
-------------------------------------------------------------------------------
-- Testing MODE 0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 0 as timers
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt_en <= '0';
    

    s_tmod <= conv_std_logic_vector(0,8);       -- "00000000"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 80;
    
-------------------------------------------------------------------------------
-- set the two timer/counters in mode 0 as counters
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(68,8);      -- "01000100"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 640;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 0 as counters using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(204,8);     -- "11001100"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- set the two timer/counters in mode 0 as timers using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(31,8);    -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(136,8);     -- "10001000"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 640;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- Testing MODE 1
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 1 as timers
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(17,8);      -- "00010001"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 640;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 1 as counters
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(254,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(254,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(85,8);      -- "01010101"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 1 as counters using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(221,8);     -- "11011101"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 1280;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- set the two timer/counters in mode 1 as timers using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(255,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(153,8);     -- "10011001"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 640;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- Testing MODE 2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 2 as timers
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(250,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(250,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(34,8);      -- "00100010"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 640;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 2 as counters
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(102,8);     -- "01100110"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 1280;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 2 as counters using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(238,8);     -- "11101110"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 1280;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- set the two timer/counters in mode 2 as timers using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(170,8);          -- "101010101"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 800;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- Testing MODE 3
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 3 as timers
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(51,8);           -- "00110011"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 3 as counters
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(119,8);           -- "01110111"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

-------------------------------------------------------------------------------
-- set the two timer/counters in mode 3 as counters using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(255,8);          -- "11111111"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;
    
-------------------------------------------------------------------------------
-- set the two timer/counters in mode 3 as timers using interrupt inputs
-------------------------------------------------------------------------------
    -- Perform reloads of tmr/ctr registers
    s_wt <= conv_std_logic_vector(0,2);         -- TL0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(1,2);         -- TL1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(252,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(2,2);         -- TH0
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt <= conv_std_logic_vector(3,2);         -- TH1
    s_wt_en <= '1';
    s_reload <= conv_std_logic_vector(253,8);   -- reload value
    wait for one_period;
    s_wt_en <= '0';
    
    s_tmod <= conv_std_logic_vector(187,8);          -- "10111011"
    s_tcon_tr0 <= '1';    
    s_tcon_tr1 <= '1';
    wait for one_period * 960;
    s_tcon_tr0 <= '0';    
    s_tcon_tr1 <= '0';
    wait for one_period * 4;

    wait for one_period * 10;
    assert FALSE report "END OF SIMULATION" severity failure;
    
-------------------------------------------------------------------------------
-- END of test after ~1000 * one_period
-------------------------------------------------------------------------------

end process p_run;


-- system clock definition

p_clock:   process
    
   variable  v_loop1 :   integer;
   
   begin
   clk <= '0';
   wait for one_period / 2;
   while true loop
      clk <= not clk;
      wait for one_period / 2;
   end loop;
   
end process p_clock;

p_tx:   process                       -- stimulate external inputs
    
   variable  v_loop1 :   integer;
   
   begin
   s_t0 <= '0';
   s_t1 <= '0';
   wait for one_period / 4;
   while true loop
      s_t0 <= not s_t0;
      s_t1 <= not s_t1;
      
      wait for one_period * 32;
   end loop;
   
end process p_tx;

p_intx:   process                       -- stimulate external inputs
    
   variable  v_loop1 :   integer;
   
   begin
   s_int0 <= '0';
   s_int1 <= '0';
   wait for one_period / 4;
   while true loop
      s_int0 <= not s_int0;
      s_int1 <= not s_int1;      
      wait for one_period * 64;
   end loop;
   
end process p_intx;

p_description: process(s_tmod)

begin

case s_tmod(3 downto 0) is
    when "0000" => tmr_ctr0 <= MODE0_timer;
    when "1000" => tmr_ctr0 <= MODE0_timer_interrupt;
    when "0100" => tmr_ctr0 <= MODE0_counter;
    when "1100" => tmr_ctr0 <= MODE0_counter_interrupt;
    when "0001" => tmr_ctr0 <= MODE1_timer;
    when "1001" => tmr_ctr0 <= MODE1_timer_interrupt;
    when "0101" => tmr_ctr0 <= MODE1_counter;
    when "1101" => tmr_ctr0 <= MODE1_counter_interrupt;
    when "0010" => tmr_ctr0 <= MODE2_timer;
    when "1010" => tmr_ctr0 <= MODE2_timer_interrupt;
    when "0110" => tmr_ctr0 <= MODE2_counter;
    when "1110" => tmr_ctr0 <= MODE2_counter_interrupt;
    when "0011" => tmr_ctr0 <= MODE3_timer;
    when "1011" => tmr_ctr0 <= MODE3_timer_interrupt;
    when "0111" => tmr_ctr0 <= MODE3_counter;
    when "1111" => tmr_ctr0 <= MODE3_counter_interrupt;
    when others => tmr_ctr0 <= SIMULATION_ERROR;
end case;

case s_tmod(7 downto 4) is
    when "0000" => tmr_ctr1 <= MODE0_timer;
    when "1000" => tmr_ctr1 <= MODE0_timer_interrupt;
    when "0100" => tmr_ctr1 <= MODE0_counter;
    when "1100" => tmr_ctr1 <= MODE0_counter_interrupt;
    when "0001" => tmr_ctr1 <= MODE1_timer;
    when "1001" => tmr_ctr1 <= MODE1_timer_interrupt;
    when "0101" => tmr_ctr1 <= MODE1_counter;
    when "1101" => tmr_ctr1 <= MODE1_counter_interrupt;
    when "0010" => tmr_ctr1 <= MODE2_timer;
    when "1010" => tmr_ctr1 <= MODE2_timer_interrupt;
    when "0110" => tmr_ctr1 <= MODE2_counter;
    when "1110" => tmr_ctr1 <= MODE2_counter_interrupt;
    when "0011" => tmr_ctr1 <= MODE3_timer;
    when "1011" => tmr_ctr1 <= MODE3_timer_interrupt;
    when "0111" => tmr_ctr1 <= MODE3_counter;
    when "1111" => tmr_ctr1 <= MODE3_counter_interrupt;
    when others => tmr_ctr1 <= SIMULATION_ERROR;
end case;

end process p_description;

end sim;

