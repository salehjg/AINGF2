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
--         Filename:               tb_mc8051_siu_sim.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.6 $
--
--         Date of Latest Version: $Date: 2002-09-05 11:15:33 $
--
--
--         Description: Module level testbench for the serial interface 
--                      unit.
--
--
--
--
-------------------------------------------------------------------------------
architecture sim of tb_mc8051_siu is

  signal clk_a     : std_logic;                     --< system clock
  signal reset     : std_logic;                     --< system reset
  signal s_tf_a    : std_logic;                     --< timer1 overflow flag
  signal s_trans_a : std_logic;                     --< 1 activates transm.
  signal s_scon_a  : std_logic_vector(5 downto 0);  --< from SFR register
                                                    --< bits 7 to 3
  signal s_sbuf_a  : std_logic_vector(7 downto 0);  --< data for transm.
  signal s_smod_a  : std_logic;                     --< low(0)/high baudrate

  signal s_sbuf_out_a : std_logic_vector(7 downto 0);  --< received data 
  signal s_scon_out_a : std_logic_vector(2 downto 0);  --< to SFR register 
                                                       --< bits 0 to 2
  signal s_rxd_out_a  : std_logic;                     --< mode0 data output
  signal s_txd_out_a  : std_logic;                     --< serial data output

  signal clk_b     : std_logic;                     --< system clock
  signal s_tf_b    : std_logic;                     --< timer1 overflow flag
  signal s_trans_b : std_logic;                     --< 1 activates transm.
  signal s_scon_b  : std_logic_vector(5 downto 0);  --< from SFR register
                                                    --< bits 7 to 3
  signal s_sbuf_b  : std_logic_vector(7 downto 0);  --< data for transm.
  signal s_smod_b  : std_logic;                     --< low(0)/high baudrate

  signal s_sbuf_out_b : std_logic_vector(7 downto 0);  --< received data 
  signal s_scon_out_b : std_logic_vector(2 downto 0);  --< to SFR register 
                                                       --< bits 0 to 2
  signal s_rxdwr_a    : std_logic;                     --< rxd direction signal
  signal s_rxdwr_b    : std_logic;                     --< rxd direction signal
  signal s_rxd_out_b  : std_logic;                     --< mode0 data output
  signal s_txd_out_b  : std_logic;                     --< serial data output
    
  signal s_serialdata_a     : std_logic;
  signal s_serialdata_b     : std_logic;
  
begin

  s_serialdata_a <= s_txd_out_a when s_scon_a(4 downto 3) /= "00"
                    else s_rxd_out_a;
  s_serialdata_b <= s_txd_out_b when s_scon_b(4 downto 3) /= "00"
                    else s_rxd_out_b;
  
  i_mc8051_siu_a : mc8051_siu
    port map (clk     => clk_a,
              reset   => reset,
              tf_i    => s_tf_a,
              trans_i => s_trans_a,
              rxd_i   => s_serialdata_b,
              scon_i  => s_scon_a,
              sbuf_i  => s_sbuf_a,
              smod_i  => s_smod_a,
              sbuf_o  => s_sbuf_out_a,
              scon_o  => s_scon_out_a,
              rxdwr_o => s_rxdwr_a,
              rxd_o   => s_rxd_out_a,
              txd_o   => s_txd_out_a);
  
  i_mc8051_siu_b : mc8051_siu
    port map (clk     => clk_b,
              reset   => reset,
              tf_i    => s_tf_b,
              trans_i => s_trans_b,
              rxd_i   => s_serialdata_a,
              scon_i  => s_scon_b,
              sbuf_i  => s_sbuf_b,
              smod_i  => s_smod_b,
              sbuf_o  => s_sbuf_out_b,
              scon_o  => s_scon_out_b,
              rxdwr_o => s_rxdwr_b,
              rxd_o   => s_rxd_out_b,
              txd_o   => s_txd_out_b);

-------------------------------------------------------------------------------
-- Perform simple selfchecking test for the four operating modes.
-------------------------------------------------------------------------------
    p_run : process

    begin

      -------------------------------------------------------------------------
      -- set start values and perform reset
      -------------------------------------------------------------------------
      s_smod_a  <= '0';
      s_trans_a <= '0';
      s_sbuf_a  <= conv_std_logic_vector(0, 8);
      s_scon_a  <= conv_std_logic_vector(0, 6);
      s_smod_b  <= '0';
      s_trans_b <= '0';
      s_sbuf_b  <= conv_std_logic_vector(0, 8);
      s_scon_b  <= conv_std_logic_vector(0, 6);
      reset   <= '1';
      wait for one_period + one_period/2 + 5 ns;
      reset   <= '0';
      wait for one_period * 4;
      -------------------------------------------------------------------------
      -- Testing MODE 0
      -------------------------------------------------------------------------
      s_scon_a  <= conv_std_logic_vector(0, 6);       -- 000000
      s_sbuf_a  <= conv_std_logic_vector(170, 8);     -- 10101010
      s_scon_b  <= conv_std_logic_vector(2, 6);       -- 000010
      s_sbuf_b  <= conv_std_logic_vector(170, 8);     -- 10101010
      s_trans_a <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1';
      s_scon_b  <= conv_std_logic_vector(0, 6);       -- 000000
      assert s_sbuf_out_b = "10101010"
        report "ERROR: FALSE DATA RECEIVED IN MODE 0! DATA SENT: AAh"
        severity failure;
      assert s_sbuf_out_b /= "10101010"
        report "CORRECT DATA RECEIVED IN MODE 0! DATA RECEIVED: AAh"
        severity note;
      wait for one_period * 600;
      s_scon_a  <= conv_std_logic_vector(0, 6);       -- 000000
      s_sbuf_a  <= conv_std_logic_vector(85, 8);      -- 01010101
      s_scon_b  <= conv_std_logic_vector(2, 6);       -- 000010
      s_sbuf_b  <= conv_std_logic_vector(16#55#, 8);  -- 01010101
      s_trans_a <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      s_scon_b  <= conv_std_logic_vector(0, 6);       -- 000000
      assert s_sbuf_out_b = "01010101"
        report "ERROR: FALSE DATA RECEIVED IN MODE 0! DATA SENT: 55h"
        severity failure;
      assert s_sbuf_out_b /= "01010101"
        report "CORRECT DATA RECEIVED IN MODE 0! DATA RECEIVED: 55h"
        severity note;
      wait for one_period * 600;
      s_scon_a  <= conv_std_logic_vector(2, 6);       -- 000010
      s_sbuf_a  <= conv_std_logic_vector(00, 8);      -- 00000000
      s_scon_b  <= conv_std_logic_vector(0, 6);       -- 000000
      s_sbuf_b  <= conv_std_logic_vector(16#FF#, 8);  -- 11111111
      s_trans_b <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_b <= '0';
      wait until s_scon_out_a(0) = '1' and s_scon_out_b(1) = '1';
      s_scon_a  <= conv_std_logic_vector(0, 6);       -- 000000
      assert s_sbuf_out_a = "11111111"
        report "ERROR: FALSE DATA RECEIVED IN MODE 0! DATA SENT: FFh"
        severity failure;
      assert s_sbuf_out_a /= "11111111"
        report "CORRECT DATA RECEIVED IN MODE 0! DATA RECEIVED: FFh"
        severity note;
      wait for one_period * 600;
      s_scon_a  <= conv_std_logic_vector(2, 6);       -- 000010
      s_sbuf_a  <= conv_std_logic_vector(00, 8);      -- 00000000
      s_scon_b  <= conv_std_logic_vector(0, 6);       -- 000000
      s_sbuf_b  <= conv_std_logic_vector(16#00#, 8);  -- 00000000
      s_trans_b <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_b <= '0';
      wait until s_scon_out_a(0) = '1' and s_scon_out_b(1) = '1';
      s_scon_a  <= conv_std_logic_vector(0, 6);       -- 000000
      assert s_sbuf_out_a = "00000000"
        report "ERROR: FALSE DATA RECEIVED IN MODE 0! DATA SENT: 00h"
        severity failure;
      assert s_sbuf_out_a /= "00000000"
        report "CORRECT DATA RECEIVED IN MODE 0! DATA RECEIVED: 00h"
        severity note;
      wait for one_period;
      -------------------------------------------------------------------------
      -- Testing MODE 1
      -------------------------------------------------------------------------
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(40, 6);   -- 101000  MODE 1 + RI=1
      s_sbuf_a  <= conv_std_logic_vector(170, 8);  -- 10101010
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(10, 6);   -- 001010  MODE 1 + RI=0
      s_sbuf_b  <= conv_std_logic_vector(170, 8);  -- 10101010
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1';
      assert s_sbuf_out_b = "10101010"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: AAh"
        severity failure;
      assert s_sbuf_out_b /= "10101010"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: AAh"
        severity note;
      wait for one_period * 600;
      s_sbuf_a  <= conv_std_logic_vector(85, 8);   -- 01010101
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      assert s_sbuf_out_b = "01010101"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: 55h"
        severity failure;
      assert s_sbuf_out_b /= "01010101"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: 55h"
        severity note;
      wait for one_period * 600;
      s_sbuf_a  <= conv_std_logic_vector(255, 8);   -- 11111111
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      assert s_sbuf_out_b = "11111111"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: FFh"
        severity failure;
      assert s_sbuf_out_b /= "11111111"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: FFh"
        severity note;
      wait for one_period * 600;
      s_sbuf_a  <= conv_std_logic_vector(0, 8);    -- 00000000
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      assert s_sbuf_out_b = "00000000"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: 00h"
        severity failure;
      assert s_sbuf_out_b /= "00000000"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: 00h"
        severity note;
      wait for one_period * 600;
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(10, 6);   -- 001010  MODE 1 + RI=0
      s_sbuf_a  <= conv_std_logic_vector(170, 8);  -- 10101010
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(8, 6);    -- 001000  MODE 1 + RI=0
      s_sbuf_b  <= conv_std_logic_vector(170, 8);  -- 10101010
      s_trans_b <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_b <= '0';
      wait until s_scon_out_a(0) = '1';
      assert s_sbuf_out_a = "10101010"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: AAh"
        severity failure;
      assert s_sbuf_out_a /= "10101010"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: AAh"
        severity note;
      wait for one_period * 600;
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(10, 6);   -- 001010  MODE 1 + RI=0
      s_sbuf_a  <= conv_std_logic_vector(171, 8);  -- 10101011
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(10, 6);   -- 001000  MODE 1 + RI=0
      s_sbuf_b  <= conv_std_logic_vector(170, 8);  -- 10101010
      s_trans_b <= '1';                            -- start transmission
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_b <= '0';
      s_trans_a <= '0';
      wait until s_scon_out_a(0) = '1' and s_scon_out_b(0) = '1';
      assert s_sbuf_out_a = "10101010"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: AAh"
        severity failure;
      assert s_sbuf_out_a /= "10101010"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: AAh"
        severity note;
      assert s_sbuf_out_b = "10101011"
        report "ERROR: FALSE DATA RECEIVED IN MODE 1! DATA SENT: ABh"
        severity failure;
      assert s_sbuf_out_b /= "10101011"
        report "CORRECT DATA RECEIVED IN MODE 1! DATA RECEIVED: ABh"
        severity note;
      wait for one_period * 600;
      -------------------------------------------------------------------------
      -- Testing MODE 2
      -------------------------------------------------------------------------
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(16, 6);   -- 010000  MODE 2
      s_sbuf_a  <= conv_std_logic_vector(171, 8);  -- 10101011
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(18, 6);   -- 010010  MODE 2 + REN=1
      s_sbuf_b  <= conv_std_logic_vector(171, 8);  -- 10101011
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1';
      assert s_sbuf_out_b = "10101011"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: ABh"
        severity failure;
      assert s_sbuf_out_b /= "10101011"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: ABh"
        severity note;
      wait for one_period * 400;
      s_sbuf_a  <= conv_std_logic_vector(86, 8);   -- 01010110
      s_trans_a <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      assert s_sbuf_out_b = "01010110"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: 56h"
        severity failure;
      assert s_sbuf_out_b /= "01010110"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: 56h"
        severity note;
      wait for one_period * 400;
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(18, 6);   -- 010000  MODE 2
      s_sbuf_a  <= conv_std_logic_vector(172, 8);  -- 10101100
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(18, 6);   -- 010010  MODE 2 + REN=1
      s_sbuf_b  <= conv_std_logic_vector(172, 8);  -- 10101100
      s_trans_a <= '1';                            -- start transmission
      s_trans_b <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      s_trans_b <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(0) = '1';
      assert s_sbuf_out_b = "10101100"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: ACh"
        severity failure;
      assert s_sbuf_out_b /= "10101100"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: ACh"
        severity note;
      assert s_sbuf_out_a = "10101100"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: ACh"
        severity failure;
      assert s_sbuf_out_a /= "10101100"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: ACh"
        severity note;
      wait for one_period * 400;
      s_smod_a  <= '1';
      s_scon_a  <= conv_std_logic_vector(18, 6);   -- 010000  MODE 2
      s_sbuf_a  <= conv_std_logic_vector(0, 8);    -- 00000000
      s_smod_b  <= '1';
      s_scon_b  <= conv_std_logic_vector(18, 6);   -- 010010  MODE 2 + REN=1
      s_sbuf_b  <= conv_std_logic_vector(255, 8);  -- 11111111
      s_trans_a <= '1';                            -- start transmission
      s_trans_b <= '1';                            -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      s_trans_b <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(0) = '1';
      assert s_sbuf_out_b = "00000000"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: 00h"
        severity failure;
      assert s_sbuf_out_b /= "00000000"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: 00h"
        severity note;
      assert s_sbuf_out_a = "11111111"
        report "ERROR: FALSE DATA RECEIVED IN MODE 2! DATA SENT: FFh"
        severity failure;
      assert s_sbuf_out_a /= "11111111"
        report "CORRECT DATA RECEIVED IN MODE 2! DATA RECEIVED: FFh"
        severity note;
      wait for one_period * 400;
      -------------------------------------------------------------------------
      -- Testing MODE 3
      -------------------------------------------------------------------------
      s_scon_a  <= conv_std_logic_vector(16#38#, 6);  -- 111000  MODE 3 + RI=1
      s_sbuf_a  <= conv_std_logic_vector(16#BE#, 8);  -- 10111110
      s_scon_b  <= conv_std_logic_vector(16#1A#, 6);  -- 011010  MODE 3 + REN=1
      s_trans_a <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1';
      assert s_sbuf_out_b = "10111110"
        report "ERROR: FALSE DATA RECEIVED IN MODE 3! DATA SENT: BEh"
        severity failure;
      assert s_sbuf_out_b /= "10111110"
        report "CORRECT DATA RECEIVED IN MODE 3! DATA RECEIVED: BEh"
        severity note;
      wait for one_period * 4000;
      s_sbuf_a  <= conv_std_logic_vector(16#55#, 8);  -- 01010101
      s_smod_a  <= '0';
      s_smod_b  <= '0';
      s_trans_a <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(1) = '1';
      assert s_sbuf_out_b = "01010101"
        report "ERROR: FALSE DATA RECEIVED IN MODE 3! DATA SENT: 55h"
        severity failure;
      assert s_sbuf_out_b /= "01010101"
        report "CORRECT DATA RECEIVED IN MODE 3! DATA RECEIVED: 55h"
        severity note;
      wait for one_period * 4000;
      s_scon_a  <= conv_std_logic_vector(16#1A#, 6);  -- 011010  MODE 3 + RI=0
      s_sbuf_b  <= conv_std_logic_vector(16#BE#, 8);  -- 10111110
      s_scon_b  <= conv_std_logic_vector(16#1A#, 6);  -- 011010  MODE 3 + REN=1
      s_sbuf_a  <= conv_std_logic_vector(16#B0#, 8);  -- 10110000
      s_trans_a <= '1';                               -- start transmission
      s_trans_b <= '1';                               -- start transmission
      wait for one_period * 1;
      s_trans_a <= '0';
      s_trans_b <= '0';
      wait until s_scon_out_b(0) = '1' and s_scon_out_a(0) = '1';
      assert s_sbuf_out_b = "10110000"
        report "ERROR: FALSE DATA RECEIVED IN MODE 3! DATA SENT: B0h"
        severity failure;
      assert s_sbuf_out_b /= "10110000"
        report "CORRECT DATA RECEIVED IN MODE 3! DATA RECEIVED: B0h"
        severity note;
      assert s_sbuf_out_a = "10111110"
        report "ERROR: FALSE DATA RECEIVED IN MODE 3! DATA SENT: BEh"
        severity failure;
      assert s_sbuf_out_a /= "10111110"
        report "CORRECT DATA RECEIVED IN MODE 3! DATA RECEIVED: BEh"
        severity note;
      wait for one_period * 4000;
      -------------------------------------------------------------------------
      -- END of test 
      -------------------------------------------------------------------------
      wait for one_period * 10;
      assert false report "--- SIMULATION ENDED WITHOUT ERROR!! ---"
        severity failure;
    end process p_run;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- System clock definition
-------------------------------------------------------------------------------
      clk_b <= clk_a;
      p_clock : process
        variable v_loop1 : integer;
      begin
        clk_a <= '0';
        wait for one_period / 2;
        while true loop
          clk_a <= not clk_a;
          wait for one_period / 2;
        end loop;
      end process p_clock;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Generate timer1 overflow flag
-------------------------------------------------------------------------------
    s_tf_b <= s_tf_a after one_period * 2;
    p_tf : process
      variable v_loop1 : integer;
    begin
      s_tf_a <= '0';
      wait for one_period + one_period / 2 + 5 ns;
      if s_scon_a(4) /= s_scon_a(3) then  -- Mode 1,3
        while true loop
          s_tf_a <= not s_tf_a;
          wait for one_period * 20;
        end loop;
      else
        s_tf_a <= '0';
      end if;
    end process p_tf;
-------------------------------------------------------------------------------
end sim;
