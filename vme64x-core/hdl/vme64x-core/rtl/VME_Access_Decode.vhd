--__________________________________________________________________________________                  
--                             VME TO WB INTERFACE
--
--                                CERN,BE/CO-HT 
--_________________________________________________________________________________
-- File:                      VME_Access_Decode.vhd
--_________________________________________________________________________________
-- Description: This component checks if the board is addressed and if it is, allows 
-- allows the access to WB bus by asserting the CardSel signal.
--
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Only A32 access is considered, all AM's
-- 2e transfers are not supported yet
-- 32 mByte window (lower 25 bits are not checked)
-- base addr = Addr_Hi(1:0) & GA(4:0)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--________________________________________________________________________________________
-- Authors:                                     
--               Svirlex
-- Date         03/2015                                                                           
-- Version      v0.04 
--________________________________________________________________________________________
--                               GNU LESSER GENERAL PUBLIC LICENSE                                
--                              ------------------------------------    
-- Copyright (c) 2009 - 2011 CERN                           
-- This source file is free software; you can redistribute it and/or modify it 
-- under the terms of the GNU Lesser General Public License as published by the 
-- Free Software Foundation; either version 2.1 of the License, or (at your option) 
-- any later version. This source is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for 
-- more details. You should have received a copy of the GNU Lesser General Public 
-- License along with this source; if not, download it from 
-- http://www.gnu.org/licenses/lgpl-2.1.html                     
-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use work.vme64x_pack.all;

--===========================================================================
-- Entity declaration
--===========================================================================

entity VME_Access_Decode is
    Port (clk_i           : in  STD_LOGIC;
          reset           : in  STD_LOGIC;
          mainFSMreset    : in  STD_LOGIC;
          decode          : in  STD_LOGIC;
          ModuleEnable    : in  STD_LOGIC;
          Addr            : in  STD_LOGIC_VECTOR (63 downto 0);
          Am              : in  STD_LOGIC_VECTOR (5 downto 0);
          XAm             : in  STD_LOGIC_VECTOR (7 downto 0);		-- not used so far
          BAR_i           : in  STD_LOGIC_VECTOR (4 downto 0);
			 Addr_HI_i       : in  STD_LOGIC_VECTOR (1 downto 0);   
			 AddrWidth       : in  STD_LOGIC_VECTOR (1 downto 0);		-- not used so far
          Base_Addr       : out  STD_LOGIC_VECTOR (63 downto 0);
          CardSel         : out  std_logic
       );

end VME_Access_Decode;
--===========================================================================
-- Architecture declaration
--===========================================================================
architecture Behavioral of VME_Access_Decode is

--===========================================================================
-- Architecture begin
--===========================================================================	
begin

-- !!! may be necessary to delay outputs one cycle

   p_Match : process(clk_i)
   begin
      if rising_edge(clk_i) then
         if mainFSMreset = '1' or reset = '1' then
            CardSel <= '0';
            Base_Addr <= (others => '0');
         elsif decode = '1' then
				if ModuleEnable = '1' and 
					((Am = c_A32) or					-- hex code 0x09
					 (Am = c_A32_sup) or 			-- hex code 0x0d
					 (Am = c_A32_BLT) or				-- hex code 0x0b  
					 (Am = c_A32_BLT_sup) or 		-- hex code 0x0f
					 (Am = c_A32_MBLT) or			-- hex code 0x08
					 (Am = c_A32_MBLT_sup)) and	-- hex code 0x0c
					Addr(31 downto 30) = Addr_HI_i and
					Addr(29 downto 25) = BAR_i then 
						CardSel <= '1';
                  Base_Addr(31 downto 25) <= Addr_HI_i & BAR_i;
                  Base_Addr(63 downto 32) <= (others => '0');
                  Base_Addr(24 downto 0)  <= (others => '0');                
				end if;
			end if;
		end if;
   end process;
	
end Behavioral;
--===========================================================================
-- Architecture end
--===========================================================================
