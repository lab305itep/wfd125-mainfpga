--______________________________________________________________________
--                             VME TO WB INTERFACE
--
--                                CERN,BE/CO-HT 
--______________________________________________________________________
-- File:                       vme64x_pack.vhd                              
--______________________________________________________________________
-- Authors:                                     
--               Pablo Alvarez Sanchez (Pablo.Alvarez.Sanchez@cern.ch)                             
--               Davide Pedretti       (Davide.Pedretti@cern.ch)  
-- Date         11/2012                                                                           
-- Version      v0.03 
--_______________________________________________________________________
--                               GNU LESSER GENERAL PUBLIC LICENSE                                
--                              ------------------------------------    
-- Copyright (c) 2009 - 2011 CERN                           
-- This source file is free software; you can redistribute it and/or modify it under the terms of 
-- the GNU Lesser General Public License as published by the Free Software Foundation; either     
-- version 2.1 of the License, or (at your option) any later version.                             
-- This source is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;       
-- without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     
-- See the GNU Lesser General Public License for more details.                                    
-- You should have received a copy of the GNU Lesser General Public License along with this       
-- source; if not, download it from http://www.gnu.org/licenses/lgpl-2.1.html                     
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
package vme64x_pack is
--__________________________________________________________________________________
-- Records:
  type t_rom_cell is
  record
    add : integer;
    len : integer;
  end record;
  type t_cr_add_table is array (natural range <>) of t_rom_cell;

  type t_FSM is
  record
    s_memReq         : std_logic;
    s_decode         : std_logic;
    s_dtackOE        : std_logic;
    s_mainDTACK      : std_logic;
    s_dataDir        : std_logic;
    s_dataOE         : std_logic;
    s_addrDir        : std_logic;
    s_addrOE         : std_logic;
    s_DSlatch        : std_logic;
    s_incrementAddr  : std_logic;
    s_dataPhase      : std_logic;
    s_dataToOutput   : std_logic;
    s_dataToAddrBus  : std_logic;
    s_transferActive : std_logic;
    s_2eLatchAddr    : std_logic_vector(1 downto 0);
    s_retry          : std_logic;
    s_berr           : std_logic;
    s_BERR_out       : std_logic;
  end record;

  type t_FSM_IRQ is
  record
    s_IACKOUT   : std_logic;
    s_DataDir   : std_logic;
    s_DTACK     : std_logic;
    s_enableIRQ : std_logic;
    s_resetIRQ  : std_logic;
    s_DSlatch   : std_logic;
    s_DTACK_OE  : std_logic;
  end record;
  --_______________________________________________________________________________
  -- Constants:
  --WB data width:
  constant c_width             : integer                      := 64;  --must be 32 or 64!
  -- WB addr width:
  constant c_addr_width        : integer                      := 9;
  -- Tclk in ns used to calculate the data transfer rate
  constant c_clk_period        : integer                      := 10;  --c_CLK_PERIOD     : std_logic_vector(19 downto 0) := "00000000000000001010";
  -- AM table. 
  -- References:
  -- Table 2-3 "Address Modifier Codes" pages 21/22 VME64std ANSI/VITA 1-1994
  -- Table 2.4 "Extended Address Modifier Code" page 12 2eSST ANSI/VITA 1.5-2003(R2009)
  constant c_A24_S_sup         : std_logic_vector(5 downto 0) := "111101";  -- hex code 0x3d
  constant c_A24_S             : std_logic_vector(5 downto 0) := "111001";  -- hex code 0x39
  constant c_A24_BLT           : std_logic_vector(5 downto 0) := "111011";  -- hex code 0x3b
  constant c_A24_BLT_sup       : std_logic_vector(5 downto 0) := "111111";  -- hex code 0x3f
  constant c_A24_MBLT          : std_logic_vector(5 downto 0) := "111000";  -- hex code 0x38
  constant c_A24_MBLT_sup      : std_logic_vector(5 downto 0) := "111100";  -- hex code 0x3c
  constant c_A24_LCK           : std_logic_vector(5 downto 0) := "110010";  -- hex code 0x32
  constant c_CR_CSR            : std_logic_vector(5 downto 0) := "101111";  -- hex code 0x2f
  constant c_A16               : std_logic_vector(5 downto 0) := "101001";  -- hex code 0x29
  constant c_A16_sup           : std_logic_vector(5 downto 0) := "101101";  -- hex code 0x2d
  constant c_A16_LCK           : std_logic_vector(5 downto 0) := "101100";  -- hex code 0x2c
  constant c_A32               : std_logic_vector(5 downto 0) := "001001";  -- hex code 0x09
  constant c_A32_sup           : std_logic_vector(5 downto 0) := "001101";  -- hex code 0x0d
  constant c_A32_BLT           : std_logic_vector(5 downto 0) := "001011";  -- hex code 0x0b  
  constant c_A32_BLT_sup       : std_logic_vector(5 downto 0) := "001111";  -- hex code 0x0f
  constant c_A32_MBLT          : std_logic_vector(5 downto 0) := "001000";  -- hex code 0x08
  constant c_A32_MBLT_sup      : std_logic_vector(5 downto 0) := "001100";  -- hex code 0x0c
  constant c_A32_LCK           : std_logic_vector(5 downto 0) := "000101";  -- hex code 0x05
  constant c_A64               : std_logic_vector(5 downto 0) := "000001";  -- hex code 0x01
  constant c_A64_BLT           : std_logic_vector(5 downto 0) := "000011";  -- hex code 0x03
  constant c_A64_MBLT          : std_logic_vector(5 downto 0) := "000000";  -- hex code 0x00
  constant c_A64_LCK           : std_logic_vector(5 downto 0) := "000100";  -- hex code 0x04
  constant c_TWOedge           : std_logic_vector(5 downto 0) := "100000";  -- hex code 0x20
  constant c_A32_2eVME         : std_logic_vector(7 downto 0) := "00000001";  -- hex code 0x21
  constant c_A64_2eVME         : std_logic_vector(7 downto 0) := "00000010";  -- hex code 0x22
  constant c_A32_2eSST         : std_logic_vector(7 downto 0) := "00010001";  -- hex code 0x11
  constant c_A64_2eSST         : std_logic_vector(7 downto 0) := "00010010";  -- hex code 0x12

  -- Main Finite State machine signals default:
  -- When the S_FPGA detects the magic sequency, it erases the A_FPGA so 
  -- I don't need to drive the s_dtackOE, s_dataOE, s_addrOE, s_addrDir, s_dataDir 
  -- to 'Z' in the default configuration.
  -- If the S_FPGA will be provided to a core who drive these lines without erase the
  -- A_FPGA the above mentioned lines should be changed to 'Z' !!!
  constant c_FSM_default : t_FSM := (
    s_memReq         => '0',
    s_decode         => '0',
    s_dtackOE        => '0',
    s_mainDTACK      => '1',
    s_dataDir        => '0',
    s_dataOE         => '0',
    s_addrDir        => '0',  -- during IACK cycle the ADDR lines are input
    s_addrOE         => '0',
    s_DSlatch        => '0',
    s_incrementAddr  => '0',
    s_dataPhase      => '0',
    s_dataToOutput   => '0',
    s_dataToAddrBus  => '0',
    s_transferActive => '0',
    s_2eLatchAddr    => "00",
    s_retry          => '0',
    s_berr           => '0',
    s_BERR_out       => '0'
    );

  constant c_FSM_IRQ : t_FSM_IRQ := (
    s_IACKOUT   => '1',
    s_DataDir   => '0',
    s_DTACK     => '1',
    s_enableIRQ => '0',
    s_resetIRQ  => '1',
    s_DSlatch   => '0',
    s_DTACK_OE  => '0'
    );

--___________________________________________________________________________________________
-- TYPE:
  type t_typeOfDataTransfer is (D08_0,
                                  D08_1,
                                  D08_2,
                                  D08_3,
                                  D16_01,
                                  D16_23,
                                  D32,
                                  D64,
                                  TypeError
                                  );

  type t_addressingType is (A24,
                                 A24_BLT,
                                 A24_MBLT,
                                 CR_CSR,
                                 A16,
                                 A32,
                                 A32_BLT,
                                 A32_MBLT,
                                 A64,
                                 A64_BLT,
                                 A64_MBLT,
                                 TWOedge,
                                 AM_Error
                                 );

  type t_transferType is (SINGLE,
                                 BLT,
                                 MBLT,
                                 TWOe,
                                 error
                                 );

  type t_XAMtype is (A32_2eVME,
                                 A64_2eVME,
                                 A32_2eSST,
                                 A64_2eSST,
                                 A32_2eSSTb,
                                 A64_2eSSTb,
                                 XAM_error
                                 );     

  type t_2eType is (TWOe_VME,
                                 TWOe_SST
                                 );                                                     

  type t_mainFSMstates is (IDLE,
                                 DECODE_ACCESS,
                                 WAIT_FOR_DS,
                                 LATCH_DS1,
                                 LATCH_DS2,
                                 LATCH_DS3,
                                 LATCH_DS4,
                                 CHECK_TRANSFER_TYPE,
                                 MEMORY_REQ,
                                 DATA_TO_BUS,
                                 DTACK_LOW,
                                 DECIDE_NEXT_CYCLE,
                                 INCREMENT_ADDR,
                                 SET_DATA_PHASE
--                           UGLY_WAIT_TO_MAKE_DECODING_WORK
                                        -- uncomment for using 2e modes:
--                                  WAIT_FOR_DS_2e,
--                                  ADDR_PHASE_1,
--                                  ADDR_PHASE_2,
--                                  ADDR_PHASE_3,
--                                  DECODE_ACCESS_2e,
--                                  DTACK_PHASE_1,
--                                  DTACK_PHASE_2,
--                                  DTACK_PHASE_3,
--                                  TWOeVME_WRITE,
--                                  TWOeVME_READ,
--                                  TWOeVME_MREQ_RD,
--                                  WAIT_WR_1,
--                                  WAIT_WR_2,
--                                  WAIT_WB_ACK_WR,
--                                  WAIT_WB_ACK_RD,
--                                  TWOeVME_TOGGLE_WR,
--                                  TWOeVME_TOGGLE_RD,
--                                  TWOe_FIFO_WRITE,
--                                  TWOe_TOGGLE_DTACK,
--                                  TWOeVME_INCR_ADDR,
--                                  TWOe_WAIT_FOR_DS1,
--                                  TWOe_FIFO_WAIT_READ,
--                                  TWOe_FIFO_READ,
--                                  TWOe_CHECK_BEAT,
--                                  TWOe_RELEASE_DTACK,
--                                  TWOe_END_1,
--                                  TWOe_END_2
                                 );


-- functions
  function f_div8 (width  : integer) return integer;
  function f_log2_size (A : natural) return natural;
  function f_latchDS (clk_period : integer) return integer;
--_____________________________________________________________________________________________________
--COMPONENTS:
  component VME_bus is
    generic(g_clock           : integer := c_clk_period;
              g_wb_data_width : integer := c_width;
              g_wb_addr_width : integer := c_addr_width;
				  g_addr_hi		   : integer := 0		-- two most significant address bits
              );
    port(
      clk_i           : in  std_logic;
      rst_n_i : in std_logic;
      VME_RST_n_i     : in  std_logic;
      VME_AS_n_i      : in  std_logic;
      VME_LWORD_n_i   : in  std_logic;
      VME_WRITE_n_i   : in  std_logic;
      VME_DS_n_i      : in  std_logic_vector(1 downto 0);
      VME_DS_ant_n_i  : in  std_logic_vector(1 downto 0);
      VME_ADDR_i      : in  std_logic_vector(31 downto 1);
      VME_DATA_i      : in  std_logic_vector(31 downto 0);
      VME_AM_i        : in  std_logic_vector(5 downto 0);
      VME_IACK_n_i    : in  std_logic;
      memAckWB_i      : in  std_logic;
      wbData_i        : in  std_logic_vector(g_wb_data_width - 1 downto 0);
      err_i           : in  std_logic;
      rty_i           : in  std_logic;
      stall_i         : in  std_logic;
      ModuleEnable    : in  std_logic;
      Endian_i        : in  std_logic_vector(2 downto 0);
      Sw_Reset        : in  std_logic;
      BAR_i           : in  std_logic_vector(4 downto 0);
      reset_o         : out std_logic;
      VME_LWORD_n_o   : out std_logic;
      VME_RETRY_n_o   : out std_logic;
      VME_RETRY_OE_o  : out std_logic;
      VME_DTACK_n_o   : out std_logic;
      VME_DTACK_OE_o  : out std_logic;
      VME_BERR_o      : out std_logic;
      VME_ADDR_o      : out std_logic_vector(31 downto 1);
      VME_ADDR_DIR_o  : out std_logic;
      VME_ADDR_OE_N_o : out std_logic;
      VME_DATA_o      : out std_logic_vector(31 downto 0);
      VME_DATA_DIR_o  : out std_logic;
      VME_DATA_OE_N_o : out std_logic;
      memReq_o        : out std_logic;
      wbData_o        : out std_logic_vector(g_wb_data_width - 1 downto 0);
      locAddr_o       : out std_logic_vector(g_wb_addr_width - 1 downto 0);
      wbSel_o         : out std_logic_vector(f_div8(g_wb_data_width) - 1 downto 0);
      RW_o            : out std_logic;
      cyc_o           : out std_logic;
      err_flag_o      : out std_logic;
      numBytes        : out std_logic_vector(12 downto 0);
      transfTime      : out std_logic_vector(39 downto 0);
      leds            : out std_logic_vector(7 downto 0)
      );
  end component VME_bus;

  component VME_Access_Decode is
    port (
      clk_i          : in  std_logic;
      reset          : in  std_logic;
      mainFSMreset   : in  std_logic;
      decode         : in  std_logic;
      ModuleEnable   : in  std_logic;
      Addr           : in  std_logic_vector(63 downto 0);
      Am             : in  std_logic_vector(5 downto 0);
      XAm            : in  std_logic_vector(7 downto 0);
      BAR_i          : in  std_logic_vector(4 downto 0);
		Addr_HI_i      : in  STD_LOGIC_VECTOR (1 downto 0);   
      AddrWidth      : in  std_logic_vector(1 downto 0);
      Base_Addr      : out std_logic_vector(63 downto 0);
      CardSel        : out std_logic
      );
  end component VME_Access_Decode;


  component VME_Wb_master is
    generic(
      g_wb_data_width : integer := c_width;
      g_wb_addr_width : integer := c_addr_width
      );
    port(
      memReq_i        : in  std_logic;
      clk_i           : in  std_logic;
      cardSel_i       : in  std_logic;
      reset_i         : in  std_logic;
      BERRcondition_i : in  std_logic;
      sel_i           : in  std_logic_vector(7 downto 0);
      locDataInSwap_i : in  std_logic_vector(63 downto 0);
      rel_locAddr_i   : in  std_logic_vector(63 downto 0);
      RW_i            : in  std_logic;
      stall_i         : in  std_logic;
      rty_i           : in  std_logic;
      err_i           : in  std_logic;
      wbData_i        : in  std_logic_vector(g_wb_data_width - 1 downto 0);
      memAckWB_i      : in  std_logic;
      locDataOut_o    : out std_logic_vector(63 downto 0);
      memAckWb_o      : out std_logic;
      err_o           : out std_logic;
      rty_o           : out std_logic;
      cyc_o           : out std_logic;
      memReq_o        : out std_logic;
      WBdata_o        : out std_logic_vector(g_wb_data_width - 1 downto 0);
      locAddr_o       : out std_logic_vector(g_wb_addr_width - 1 downto 0);
      WbSel_o         : out std_logic_vector(f_div8(g_wb_data_width) - 1 downto 0);
      RW_o            : out std_logic
      );
  end component VME_Wb_master;

  component VME_swapper is
    port(
      d_i : in  std_logic_vector(63 downto 0);
      sel : in  std_logic_vector(2 downto 0);
      d_o : out std_logic_vector(63 downto 0)
      );
  end component VME_swapper;
  component Reg32bit is
                         port (
                               reset, clk_i, enable : in  std_logic;
                               di                   : in  std_logic_vector(31 downto 0); 
                               do                   : out std_logic_vector(31 downto 0)
                               );
  end component Reg32bit;
  component FlipFlopD is
    port (
      reset, enable, sig_i, clk_i : in  std_logic;
      sig_o                       : out std_logic := '0'
      );
  end component FlipFlopD;
  component EdgeDetection is
    port (
      sig_i, clk_i : in  std_logic;
      sigEdge_o    : out std_logic := '0'
      );
  end component EdgeDetection;

  component FallingEdgeDetection is
    port (
      sig_i, clk_i : in  std_logic;
      FallEdge_o   : out std_logic);
  end component FallingEdgeDetection;

  component RisEdgeDetection is
    port (
      sig_i, clk_i : in  std_logic;
      RisEdge_o    : out std_logic);
  end component RisEdgeDetection;

  component DoubleSigInputSample is
    port (
      sig_i, clk_i : in  std_logic;
      sig_o        : out std_logic);
  end component DoubleSigInputSample;

  component SigInputSample is
    port (
      sig_i, clk_i : in  std_logic;
      sig_o        : out std_logic);
  end component SigInputSample;

  component DoubleRegInputSample is
    generic(
      width : natural := 8
      );
    port (
      reg_i : in  std_logic_vector(width-1 downto 0);
      reg_o : out std_logic_vector(width-1 downto 0) := (others => '0');
      clk_i : in  std_logic
      );
  end component DoubleRegInputSample;

  component RegInputSample is
    generic(
      width : natural := 8
      );
    port (
      reg_i : in  std_logic_vector(width-1 downto 0);
      reg_o : out std_logic_vector(width-1 downto 0) := (others => '0');
      clk_i : in  std_logic
      );
  end component RegInputSample;

  component SingleRegInputSample is
    generic(
      width : natural := 8
      );
    port (
      reg_i : in  std_logic_vector(width-1 downto 0);
      reg_o : out std_logic_vector(width-1 downto 0) := (others => '0');
      clk_i : in  std_logic
      );
  end component SingleRegInputSample;

  component VME_IRQ_Controller
    generic (
      g_retry_timeout : integer range 1024 to 16777215);
    port (
      clk_i           : in  std_logic;
      reset_n_i       : in  std_logic;
      VME_IACKIN_n_i  : in  std_logic;
      VME_AS_n_i      : in  std_logic;
      VME_DS_n_i      : in  std_logic_vector (1 downto 0);
      VME_ADDR_123_i  : in  std_logic_vector (2 downto 0);
      INT_Level_i     : in  std_logic_vector (7 downto 0);
      INT_Vector_i    : in  std_logic_vector (7 downto 0);
      INT_Req_i       : in  std_logic;
      VME_IRQ_n_o     : out std_logic_vector (6 downto 0);
      VME_IACKOUT_n_o : out std_logic;
      VME_DTACK_n_o   : out std_logic;
      VME_DTACK_OE_o  : out std_logic;
      VME_DATA_o      : out std_logic_vector (31 downto 0);
      VME_DATA_DIR_o  : out std_logic);
  end component;

end vme64x_pack;
package body vme64x_pack is

  function f_div8 (width : integer) return integer is
  begin
    for I in 1 to 8 loop
      if (8*I >= width) then
        return(I);
      end if;
    end loop;
  end function f_div8;

  function f_log2_size (A : natural) return natural is
  begin
    for I in 1 to 64 loop               -- Works for up to 64 bits
      if (2**I >= A) then
        return(I);
      end if;
    end loop;
    return(63);
  end function f_log2_size;
  
  function f_latchDS(clk_period : integer) return integer is
  begin
    for I in 1 to 4 loop
      if (clk_period * I >= 20) then  -- 20 is the max time between the assertion
                                      -- of the DS lines.
        return(I);
      end if;
    end loop;
    return(4);                          -- works for up to 200 MHz
  end function f_latchDS;
  
end vme64x_pack;
